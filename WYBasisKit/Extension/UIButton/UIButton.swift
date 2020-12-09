//
//  UIButton.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public extension UIButton {
    
    /// 返回一个计算好的字符串的宽度
    private func titleWidth(title: String, controlHeight: CGFloat = 0, controlFont: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        
        let sharedControlHeight = (controlHeight == 0) ? controlFont.lineHeight : controlHeight
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font: controlFont, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let stringSize: CGSize! = title.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: sharedControlHeight), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: attributes, context: nil).size
        
        return stringSize.width
    }
    
    /**
    *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
    *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
    *  什么都不设置默认为图片在左，文字在右，居中且挨着排列的
    *  @param spacing 图片和文字的间隔
    */
    func wy_layouEdgeInsets(position: WYButtonPosition, spacing: CGFloat) {
        
        if imageView?.image == nil || currentImage == nil || currentTitle?.isEmpty == true || titleLabel?.text?.isEmpty == true {
            
            wy_print("wy_layouEdgeInsets方法 需要在设置图片、文字与约束或者frame之后才可以调用，且button的size要大于 图片大小+文字大小+spacing")
            return
        }
        
        superview?.layoutIfNeeded()

        let imageWidth: CGFloat = (imageView?.image?.size.width)!
        let imageHeight: CGFloat = (imageView?.image?.size.height)!
        let textWidth: CGFloat = (titleWidth(title: currentTitle!,controlFont: titleLabel!.font))
        let textHeight: CGFloat = (titleLabel?.font.lineHeight)!

        //image中心移动的x距离
        let imageOffsetX: CGFloat = (imageWidth + textWidth) / 2 - imageWidth / 2
        //image中心移动的y距离
        let imageOffsetY: CGFloat = imageHeight / 2 + spacing / 2
        //文字中心移动的x距离
        let textOffsetX: CGFloat = (imageWidth + textWidth / 2) - (imageWidth + textWidth) / 2
        //文字中心移动的y距离
        let textOffsetY: CGFloat = textHeight / 2 + spacing / 2

        switch position {

        case .imageRight_titleLeft:

            imageEdgeInsets = UIEdgeInsets(top: 0, left: textWidth+spacing/2, bottom: 0, right: -(textWidth+spacing/2))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageHeight+spacing/2), bottom: 0, right: imageHeight+spacing/2)

            break

        case .imageLeft_titleRight:

            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)

            break

        case .imageTop_titleBottom:

            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: textOffsetY, left: -textOffsetX, bottom: -textOffsetY, right: textOffsetX)

            break

        case .imageBottom_titleTop:

            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -textOffsetY, left: -textOffsetX, bottom: textOffsetY, right: textOffsetX)

            break
        }
    }
    
    /** 按钮默认状态文字 */
    var wy_nTitle: String {
        
        set {
            setTitle(newValue, for: .normal)
        }
        
        get {
            return title(for: .normal) ?? ""
        }
    }

    /** 按钮高亮状态文字 */
    var wy_hTitle: String {
        
        set {
            setTitle(newValue, for: .highlighted)
        }
        
        get {
            return title(for: .highlighted) ?? ""
        }
    }

    /** 按钮选中状态文字 */
    var wy_sTitle: String {
        
        set {
            setTitle(newValue, for: .selected)
        }
        
        get {
            return title(for: .selected) ?? ""
        }
    }


    /** 按钮默认状态文字颜色 */
    var wy_title_nColor: UIColor {
        
        set {
            setTitleColor(newValue, for: .normal)
        }
        
        get {
            return titleColor(for: .normal) ?? .clear
        }
    }

    /** 按钮高亮状态文字颜色 */
    var wy_title_hColor: UIColor {
        
        set {
            setTitleColor(newValue, for: .highlighted)
        }
        
        get {
            return titleColor(for: .highlighted) ?? .clear
        }
    }

    /** 按钮选中状态文字颜色 */
    var wy_title_sColor: UIColor {
        
        set {
            setTitleColor(newValue, for: .selected)
        }
        
        get {
            return titleColor(for: .selected) ?? .clear
        }
    }


    /** 按钮默认状态图片 */
    var wy_nImage: UIImage {
        
        set {
            setImage(newValue, for: .normal)
        }
        
        get {
            
            return image(for: .normal) ?? UIKit.UIImage.wy_imageFromColor(color: .clear)
        }
    }

    /** 按钮高亮状态图片 */
    var wy_hImage: UIImage {
        
        set {
            setImage(newValue, for: .highlighted)
        }
        
        get {
            
            return image(for: .highlighted) ?? UIKit.UIImage.wy_imageFromColor(color: .clear)
        }
    }

    /** 按钮选中状态图片 */
    var wy_sImage: UIImage {
        
        set {
            setImage(newValue, for: .selected)
        }
        
        get {
            
            return image(for: .selected) ?? UIKit.UIImage.wy_imageFromColor(color: .clear)
        }
    }
    
    /** 设置按钮背景色 */
    func wy_setBackgroundColor(_ color: UIColor, forState: UIControl.State) {

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(colorImage, for: forState)
    }

    /** 设置按钮字号 */
    var wy_titleFont: UIFont {

        set {
            titleLabel?.font = newValue
        }

        get {

            return (titleLabel?.font)!
        }
    }

    /** 设置按钮左对齐 */
    func wy_leftAlignment() {
        
        contentHorizontalAlignment = .left
    }

    /** 设置按钮中心对齐 */
    func wy_centerAlignment() {
        
        contentHorizontalAlignment = .center
    }

    /** 设置按钮右对齐 */
    func wy_rightAlignment() {
        
        contentHorizontalAlignment = .right
    }

    /** 设置按钮上对齐 */
    func wy_topAlignment() {
        
        contentVerticalAlignment = .top
    }

    /** 设置按钮下对齐 */
    func wy_bottomAlignment() {
        
        contentVerticalAlignment = .bottom
    }
}
