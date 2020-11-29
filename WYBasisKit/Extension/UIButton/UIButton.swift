//
//  UIButton.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public enum WYButtonPosition {
    
    /** 图片在左，文字在右，默认 */
    case imageLeft_titleRight
    /** 图片在右，文字在左 */
    case imageRight_titleLeft
    /** 图片在上，文字在下 */
    case imageTop_titleBottom
    /** 图片在下，文字在上 */
    case imageBottom_titleTop
}

public extension UIButton {
    
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
    
    /** 按钮默认状态文字 */
    var wy_nTitle: String {
        
        set {
            self.setTitle(newValue, for: .normal)
        }
        
        get {
            return self.title(for: .normal) ?? ""
        }
    }

    /** 按钮高亮状态文字 */
    var wy_hTitle: String {
        
        set {
            self.setTitle(newValue, for: .highlighted)
        }
        
        get {
            return self.title(for: .highlighted) ?? ""
        }
    }

    /** 按钮选中状态文字 */
    var wy_sTitle: String {
        
        set {
            self.setTitle(newValue, for: .selected)
        }
        
        get {
            return self.title(for: .selected) ?? ""
        }
    }


    /** 按钮默认状态文字颜色 */
    var wy_title_nColor: UIColor {
        
        set {
            self.setTitleColor(newValue, for: .normal)
        }
        
        get {
            return self.titleColor(for: .normal) ?? .clear
        }
    }

    /** 按钮高亮状态文字颜色 */
    var wy_title_hColor: UIColor {
        
        set {
            self.setTitleColor(newValue, for: .highlighted)
        }
        
        get {
            return self.titleColor(for: .highlighted) ?? .clear
        }
    }

    /** 按钮选中状态文字颜色 */
    var wy_title_sColor: UIColor {
        
        set {
            self.setTitleColor(newValue, for: .selected)
        }
        
        get {
            return self.titleColor(for: .selected) ?? .clear
        }
    }


    /** 按钮默认状态图片 */
    var wy_nImage: UIImage {
        
        set {
            self.setImage(newValue, for: .normal)
        }
        
        get {
            
            return self.image(for: .normal) ?? UIKit.UIImage.wy_imageFromColor(color: .clear)
        }
    }

    /** 按钮高亮状态图片 */
    var wy_hImage: UIImage {
        
        set {
            self.setImage(newValue, for: .highlighted)
        }
        
        get {
            
            return self.image(for: .highlighted) ?? UIKit.UIImage.wy_imageFromColor(color: .clear)
        }
    }

    /** 按钮选中状态图片 */
    var wy_sImage: UIImage {
        
        set {
            self.setImage(newValue, for: .selected)
        }
        
        get {
            
            return self.image(for: .selected) ?? UIKit.UIImage.wy_imageFromColor(color: .clear)
        }
    }
    
    /** 设置按钮背景色 */
    func wy_setBackgroundColor(_ color: UIColor, forState: UIControl.State) {

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }

    /** 设置按钮字号 */
    var wy_titleFont: UIFont {

        set {
            self.titleLabel?.font = newValue
        }

        get {

            return (self.titleLabel?.font)!
        }
    }

    /** 设置按钮左对齐 */
    func wy_leftAlignment() {
        
        self.contentHorizontalAlignment = .left
    }

    /** 设置按钮中心对齐 */
    func wy_centerAlignment() {
        
        self.contentHorizontalAlignment = .center
    }

    /** 设置按钮右对齐 */
    func wy_rightAlignment() {
        
        self.contentHorizontalAlignment = .right
    }

    /** 设置按钮上对齐 */
    func wy_topAlignment() {
        
        self.contentVerticalAlignment = .top
    }

    /** 设置按钮下对齐 */
    func wy_bottomAlignment() {
        
        self.contentVerticalAlignment = .bottom
    }
}
