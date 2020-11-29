//
//  UIImage.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 截取指定View快照
    class func wy_screenshot(view: UIView) -> UIImage! {
        
        // 设置屏幕倍率可以保证截图的质量
        let scale: CGFloat = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, scale)

        view.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 根据颜色创建图片
    class func wy_imageFromColor(color: UIColor) -> UIImage! {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 生成渐变图片
    class func wy_imageFromGradientColors(colors: [UIColor], gradientDirection: WYGradientDirection, imageSize: CGSize) -> UIImage {
        
        var array: [CGColor] = []
        for color in colors {
            array.append(color.cgColor)
        }
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: array as CFArray, locations: nil)
        
        var start: CGPoint
        var end: CGPoint
        switch gradientDirection {
        case .topToBottom:
            start = CGPoint.zero
            end = CGPoint(x: 0, y: imageSize.height)
            break
        case .leftToRight:
            start = CGPoint.zero
            end = CGPoint(x: imageSize.width, y: 0)
            break
        case .leftToLowRight:
            start = CGPoint.zero
            end = CGPoint(x: imageSize.width, y: imageSize.height)
            break
        case .rightToLowlLeft:
            start = CGPoint(x: imageSize.width, y: 0)
            end = CGPoint(x: 0, y: imageSize.height)
            break
        }
        
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0, y: -imageSize.height)
        context?.drawLinearGradient(gradient!, start: start, end: end, options: .init())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     *  将图片切割成圆形
     *
     *  @param iconImage     要切割的图片
     *  @param borderWidth   边框的宽度
     *  @param borderColor   边框的颜色
     *
     *  @return 切割好的头像
     */
    class func wy_captureCircle(iconImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        
        var imageW = iconImage.size.width + borderWidth * 2
        var imageH = iconImage.size.height + borderWidth * 2;
        imageW = min(imageH, imageW)
        imageH = imageW
        let imageSize = CGSize(width: imageW, height: imageH)
        //新建一个图形上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0);
        let ctx = UIGraphicsGetCurrentContext()
        borderColor.set()
        //画大圆
        let bigRadius = imageW * 0.5
        let centerX = imageW * 0.5
        let centerY = imageH * 0.5
        
        ctx?.addArc(center: CGPoint(x: centerX, y: centerY), radius: bigRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        ctx?.fillPath()
        //画小圆
        let smallRadius = bigRadius - borderWidth
        ctx?.addArc(center: CGPoint(x: centerX, y: centerY), radius: smallRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        //切割
        ctx?.clip()
        //画图片
        iconImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: iconImage.size.width, height: iconImage.size.height))
        //从上下文中取出图片
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
