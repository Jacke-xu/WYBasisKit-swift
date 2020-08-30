//
//  UIImage+WYExtension.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
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
}
