//
//  UIView+WYExtension.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

enum WYGradientDirection {
    
    /// 从上到小
    case gradientDirectionTopToBottom
    /// 从左到右
    case gradientDirectionLeftToRight
    /// 左上到右下
    case gradientDirectionLeftToLowRight
    /// 右上到左下
    case gradientDirectionRightToLowlLeft
}

extension UIView {
 
    /// 设置渐变色
    func wy_gradualColors(colors: [UIColor], cradientDirection: WYGradientDirection)  {
        
        DispatchQueue.main.async {
            
            var CGColors: [CGColor] = NSMutableArray.init() as! [CGColor]
            for color: UIColor in colors {
                
                CGColors.append(color.cgColor)
            }
            
            var startPoint: CGPoint!
            var endPoint: CGPoint!
            switch cradientDirection {
            case .gradientDirectionTopToBottom:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: 1.0)
                break
            case .gradientDirectionLeftToRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 1.0, y: 0.0)
                break
            case .gradientDirectionLeftToLowRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 1.0, y: 1.0)
                break
            default:
                startPoint = CGPoint(x: 1.0, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: 1.0)
            }
            
            let layer = CAGradientLayer()
            layer.frame = self.bounds
            layer.colors = CGColors
            layer.startPoint = startPoint
            layer.endPoint = endPoint
            self.layer.insertSublayer(layer, at: 0)
        }
    }
}
