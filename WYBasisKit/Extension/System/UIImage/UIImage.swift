//
//  UIImage.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 截取指定View快照
    class func wy_screenshot(_ view: UIView) -> UIImage! {
        
        // 设置屏幕倍率可以保证截图的质量
        let scale: CGFloat = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, scale)

        view.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 根据颜色创建图片
    class func wy_image(from color: UIColor) -> UIImage! {
        
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
    class func wy_image(from gradientColors: [UIColor], gradientDirection: WYGradientDirection, imageSize: CGSize) -> UIImage {
        
        var array: [CGColor] = []
        for color in gradientColors {
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
    
    /**
     *  加载本地图片
     *
     *  @param imageName             要加载的图片名
     *
     *  @param bundleName            从哪个bundle文件内查找，如果为空，则直接在本地路径下查找
     *
     *  @param subdirectory         bundleName.bundle下面的子文件夹目录(如果图片是放在bundle文件下面的子文件夹中，则需要传入该路径，例如ImageSource.bundle下面有个叫apple的子文件夹，则subdirectory应该传入 apple )
     *
     */
    class func wy_named(_ imageName: String, inBundle bundleName: String = WYBasisKitConfig.bundleName, subdirectory: String = "") -> UIImage {
        
        if imageName.isEmpty {
            
            wy_print("没有找到相关图片，因为传入的 imageName 为空， 已默认创建一张随机颜色图片供您使用")
            return wy_image(from: UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0))
        }
        
        if bundleName.isEmpty {
            
            guard let image = UIImage(named: imageName) else {

                let resourcePath = ((Bundle(for: WYLocalizableClass.self).path(forResource: imageName, ofType: nil)) ?? (Bundle.main.path(forResource: imageName, ofType: nil))) ?? ""
                
                guard let contentImage = UIImage(named: imageName, in: Bundle(path: resourcePath), compatibleWith: nil) else {
                    
                    wy_print("在项目路径或Assets下面，没有找到 \(imageName) 这张图片，已默认创建一张随机颜色图片供您使用")
                    
                    return wy_image(from: UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0))
                }
                return contentImage
            }
            return image
            
        }else {
            
            var subdirectoryPath = subdirectory
            if  (subdirectory.isEmpty == false) && (subdirectory.hasPrefix("/") == false) {
                subdirectoryPath = "/" + subdirectory
            }
            
            let resourcePath = (((Bundle(for: WYLocalizableClass.self).path(forResource: bundleName, ofType: "bundle")) ?? (Bundle.main.path(forResource: bundleName, ofType: "bundle"))) ?? "").appending(subdirectoryPath)
            
            guard let contentImage = UIImage(named: imageName, in: Bundle(path: resourcePath), compatibleWith: nil) else {
                
                wy_print("在 \(bundleName).bundle\(subdirectory) 中没有找到 \(imageName) 这张图片，已默认创建一张随机颜色图片供您使用")
                return wy_image(from: UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0))
            }
            return contentImage
        }
    }
}

private class WYLocalizableClass {}
