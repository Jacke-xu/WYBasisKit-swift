//
//  UIButton+WYExtension.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

enum WYButtonPosition {
    
    /** 图片在左，文字在右，默认 */
    case imageLeft_titleRight
    /** 图片在右，文字在左 */
    case imageRight_titleLeft
    /** 图片在上，文字在下 */
    case imageTop_titleBottom
    /** 图片在下，文字在上 */
    case imageBottom_titleTop
}

extension UIButton {
    
    /**
    *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
    *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
    *
    *  @param spacing 图片和文字的间隔
    */
    func wy_layouEdgeInsets(position: WYButtonPosition, spacing: CGFloat) {
        
        if self.imageView?.image == nil || self.currentImage == nil || self.currentTitle?.isEmpty == true || self.titleLabel?.text?.isEmpty == true {
            
            wy_print("wy_layouEdgeInsets方法 需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing")
            return
        }
        
        let imageWidth: CGFloat = (self.imageView?.image?.size.width)!
        let imageHeight: CGFloat = (self.imageView?.image?.size.height)!
        let textWidth: CGFloat = (self.currentTitle?.wy_calculateStringWidth(controlFont: self.titleLabel!.font))!
        let textHeight: CGFloat = (self.titleLabel?.font.lineHeight)!
        
        //image中心移动的x距离
        let imageOffsetX: CGFloat = (imageWidth + textWidth) / 2 - imageWidth / 2
        //image中心移动的y距离
        let imageOffsetY: CGFloat = imageHeight / 2 + spacing / 2
        //文字中心移动的x距离
        let textOffsetX: CGFloat = (imageWidth + textHeight / 2) - (imageWidth + textWidth) / 2
        //文字中心移动的y距离
        let textOffsetY: CGFloat = textHeight / 2 + spacing / 2
        
        switch position {
        case .imageRight_titleLeft:
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: textWidth+spacing/2, bottom: 0, right: -(textWidth+spacing/2))
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageHeight+spacing/2), bottom: 0, right: imageHeight+spacing/2)
            break
        case .imageTop_titleBottom:
            self.imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets(top: textOffsetY, left: -textOffsetX, bottom: -textOffsetY, right: textOffsetX)
            break
        case .imageBottom_titleTop:
            self.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets(top: -textOffsetY, left: -textOffsetX, bottom: textOffsetY, right: textOffsetX)
            break
        default:
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break
        }
    }
    
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
}
