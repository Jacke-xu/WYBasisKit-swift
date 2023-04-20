//
//  UIButton.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
//

import UIKit

/// UIButton图片控件和文本控件显示位置
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
    
    /// 返回一个计算好的字符串的宽度
    private func wy_stringWidth(string: String, controlHeight: CGFloat = 0, controlFont: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        
        let sharedControlHeight = (controlHeight == 0) ? controlFont.lineHeight : controlHeight
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font: controlFont, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let stringSize: CGSize! = string.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: sharedControlHeight), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: attributes, context: nil).size
        
        return stringSize.width
    }
    
    /**
     *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
     *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
     *  什么都不设置默认为图片在左，文字在右，居中且挨着排列的
     *  @param spacing 图片和文字的间隔
     */
    func wy_layouEdgeInsets(position: WYButtonPosition, spacing: CGFloat = 0) {
        
        DispatchQueue.main.async {
            
            if self.imageView?.image == nil || self.currentImage == nil || self.currentTitle?.isEmpty == true || self.titleLabel?.text?.isEmpty == true {
                
                //wy_print("wy_layouEdgeInsets方法 需要在设置图片、文字与约束或者frame之后才可以调用，且button的size最好大于 图片大小+文字大小+spacing")
                return
            }
            self.superview?.layoutIfNeeded()
            
            let imageWidth: CGFloat = (self.currentImage?.size.width) ?? 0
            let imageHeight: CGFloat = (self.currentImage?.size.height) ?? 0
            let textWidth: CGFloat = (self.wy_stringWidth(string: self.currentTitle ?? "",controlFont: self.titleLabel?.font ?? .systemFont(ofSize: 15)))
            let textHeight: CGFloat = (self.titleLabel?.font.lineHeight) ?? 0
            
            // image中心移动的x距离
            let imageOffsetX: CGFloat = (imageWidth + textWidth) / 2 - imageWidth / 2
            // image中心移动的y距离
            let imageOffsetY: CGFloat = imageHeight / 2 + spacing / 2
            // 文字中心移动的x距离
            let textOffsetX: CGFloat = (imageWidth + textWidth / 2) - (imageWidth + textWidth) / 2
            // 文字中心移动的y距离
            let textOffsetY: CGFloat = textHeight / 2 + spacing / 2
            
            switch position {
                
            case .imageRight_titleLeft:
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: textWidth+spacing/2, bottom: 0, right: -(textWidth+spacing/2))
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth+spacing/2), bottom: 0, right: imageWidth+spacing/2)
                
                if (textWidth + imageWidth + spacing) > self.frame.size.width {
                    
                    // 内容偏移x距离
                    let contentOffsetx: CGFloat = spacing / 2
                    self.contentEdgeInsets = UIEdgeInsets(top: 0, left: contentOffsetx, bottom: 0, right: contentOffsetx)
                }
                break
                
            case .imageLeft_titleRight:
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
                
                if (textWidth + imageWidth + spacing) > self.frame.size.width {
                    
                    // 内容偏移x距离
                    let contentOffsetx: CGFloat = spacing / 2
                    self.contentEdgeInsets = UIEdgeInsets(top: 0, left: contentOffsetx, bottom: 0, right: contentOffsetx)
                }
                break
                
            case .imageTop_titleBottom:
                
                self.imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
                self.titleEdgeInsets = UIEdgeInsets(top: textOffsetY, left: -textOffsetX, bottom: -textOffsetY, right: textOffsetX)
                
                if (((textWidth + imageWidth + spacing) > self.frame.size.width) || ((textHeight + imageHeight + spacing) > self.frame.size.height)) {
                    
                    // 内容偏移x距离
                    let contentOffsetx: CGFloat = ([imageWidth, textWidth].min()!) / 2
                    // 内容偏移y距离
                    let contentOffsety: CGFloat = (([imageHeight, textHeight].min()!) / 2) + (spacing / 2)
                    self.contentEdgeInsets = UIEdgeInsets(top: contentOffsety, left: -contentOffsetx, bottom: contentOffsety, right: -contentOffsetx)
                }
                break
                
            case .imageBottom_titleTop:
                
                self.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
                self.titleEdgeInsets = UIEdgeInsets(top: -textOffsetY, left: -textOffsetX, bottom: textOffsetY, right: textOffsetX)
                self.contentEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth / 2), bottom: 0, right: -(imageWidth / 2))
                
                if (((textWidth + imageWidth + spacing) > self.frame.size.width) || ((textHeight + imageHeight + spacing) > self.frame.size.height)) {
                    
                    // 内容偏移x距离
                    let contentOffsetx: CGFloat = ([imageWidth, textWidth].min()!) / 2
                    // 内容偏移y距离
                    let contentOffsety: CGFloat = (([imageHeight, textHeight].min()!) / 2) + (spacing / 2)
                    self.contentEdgeInsets = UIEdgeInsets(top: contentOffsety, left: -contentOffsetx, bottom: contentOffsety, right: -contentOffsetx)
                }
                break
            }
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
            return image(for: .normal) ?? UIKit.UIImage.wy_createImage(from: .clear)
        }
    }
    
    /** 按钮高亮状态图片 */
    var wy_hImage: UIImage {
        set {
            setImage(newValue, for: .highlighted)
        }
        get {
            return image(for: .highlighted) ?? UIKit.UIImage.wy_createImage(from: .clear)
        }
    }
    
    /** 按钮选中状态图片 */
    var wy_sImage: UIImage {
        set {
            setImage(newValue, for: .selected)
        }
        get {
            return image(for: .selected) ?? UIKit.UIImage.wy_createImage(from: .clear)
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
    
    /**
     *  添加点击事件(interval > 0 时，可以在 interval 间隔时间内防止重复点击)
     *  interval 下次可点击的间隔时间
     */
    func wy_addHandler(interval: TimeInterval = 1, selector: @escaping IntervalSelector) {
        addTarget(self, action: #selector(buttonDelayHandler(_:)) , for: .touchUpInside)
        selectorInterval = interval
        intervalSelector = selector
    }
    
    /**
     *  添加点击事件(interval > 0 时，可以在 interval 间隔时间内防止重复点击, 建议不要大于2秒，会影响内存释放)
     *  interval 下次可点击的间隔时间
     */
    func wy_addHandler(interval: TimeInterval = 1, target: Any, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
        wy_addHandler(interval: interval) { _ in }
    }
}

public typealias IntervalSelector = ((UIButton)->Void)
private extension UIButton {
    
    private var intervalSelector: IntervalSelector? {
        
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.intervalSelector, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.intervalSelector) as? IntervalSelector
        }
    }
    
    private var selectorInterval: TimeInterval {
        set {
            objc_setAssociatedObject(self, WYAssociatedKeys.selectorInterval, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.selectorInterval) as? TimeInterval ?? 0
        }
    }
    
    @objc private func buttonDelayHandler(_ button: UIButton) {
        intervalSelector?(button)
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + selectorInterval) { [weak self] in
            DispatchQueue.main.async {
                self?.isUserInteractionEnabled = true
            }
        }
    }
    
    struct WYAssociatedKeys {
        static let intervalSelector = UnsafeRawPointer(bitPattern: "IntervalSelector".hashValue)!
        static let selectorInterval = UnsafeRawPointer(bitPattern: "selectorInterval".hashValue)!
    }
}
