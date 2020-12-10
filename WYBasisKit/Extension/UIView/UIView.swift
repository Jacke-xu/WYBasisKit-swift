//
//  UIView.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public extension UIView {
    
    /** view.width */
    var wy_width: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.width
        }
    }
    
    /** view.height */
    var wy_height: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.height
        }
    }
    
    /** view.origin.x */
    var wy_left: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin.x
        }
    }
    
    /** view.origin.x + view.width */
    var wy_right: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    /** view.origin.y */
    var wy_top: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin.y
        }
    }
    
    /** view.origin.y + view.height */
    var wy_bottom: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    /** view.center.x */
    var wy_centerx: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue - (self.frame.size.width / 2.0)
            self.frame = frame
        }
        
        get {
            return self.frame.origin.x + (self.frame.size.width / 2.0)
        }
    }
    
    /** view.center.y */
    var wy_centery: CGFloat {
        
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue - (self.frame.size.height / 2.0)
            self.frame = frame
        }
        
        get {
            return self.frame.origin.y + (self.frame.size.height / 2.0)
        }
    }
    
    /** view.origin */
    var wy_origin: CGPoint {
        
        set {
            var frame: CGRect = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin
        }
    }
    
    /** view.size */
    var wy_size: CGSize {
        
        set {
            var frame: CGRect = self.frame
            frame.size = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size
        }
    }
    
    /// 移除所有子控件
    func wy_removeAllSubviews() {
        
        while !subviews.isEmpty {
            
            let view = subviews[0]
            view.removeFromSuperview()
        }
    }
    
    /// 获取当前正在显示的Controller
    func wy_currentController(windowController: UIViewController? = (UIApplication.shared.delegate?.window)??.rootViewController) -> UIViewController? {
        
        if let navigationController = windowController as? UINavigationController {
            
            return wy_currentController(windowController: navigationController.visibleViewController)
            
        }else if let tabBarController = windowController as? UITabBarController {
            
            return wy_currentController(windowController: tabBarController.selectedViewController)
            
        }else if let presentedController = windowController?.presentedViewController {
            
            return wy_currentController(windowController: presentedController)
            
        }else {
            
            return windowController
        }
    }
    
    /// 添加手势点击事件
    func wy_addGestureAction(target: Any?, action: Selector?) {
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gestureRecognizer)
    }
    
    /// 添加收起键盘的手势
    func wy_gestureHidingkeyboard() {
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wy_keyboardHide))
        gestureRecognizer.numberOfTapsRequired = 1
        //设置成false表示当前控件响应后会传播到其他控件上，默认为true
        gestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func wy_keyboardHide() {
        
        endEditing(true)
    }
}

public extension UIView {
    
    /**
    * 设置圆角、边框
    * @param rectCorner        要圆角的位置，默认4角圆角
    * @param cornerRadius      圆角半径
    * @param borderColor       边框颜色
    * @param borderWidth       边框宽度
    */
    func wy_add(rectCorner: UIRectCorner = .allCorners, cornerRadius: CGFloat = 0, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        
        DispatchQueue.main.async {
            
            self.layoutIfNeeded()
            
            // 抗锯齿边缘
            self.layer.rasterizationScale = UIScreen.main.scale
            
            // 设置圆角
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            
            // 设置边框
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskLayer.path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = borderWidth
            borderLayer.frame = self.bounds
            self.layer.addSublayer(borderLayer)
        }
    }
    
    /**
    * 设置阴影
    * @param rectCorner        要圆角的位置，默认不圆角
    * @param shadowColor       阴影颜色
    * @param shadowRadius      阴影半径
    * @param shadowOpacity     阴影透明度，默认值是0.0，取值范围0~1
    * @param shadowOffset      阴影偏移度(width : 为正数时，向右偏移，为负数时，向左偏移，height : 为正数时，向下偏移，为负数时，向上偏移)
    */
    func wy_add(rectCorner: UIRectCorner = .init(), shadowColor: UIColor = .clear, shadowRadius: CGFloat = 0, shadowOpacity: CGFloat = 0.5, shadowOffset: CGSize = CGSize.zero) {
        
        DispatchQueue.main.async {
            
            self.layoutIfNeeded()
            
            // 抗锯齿边缘
            self.layer.rasterizationScale = UIScreen.main.scale
            
            // 设置阴影
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowOpacity = Float(shadowOpacity)
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: shadowRadius, height: shadowRadius)).cgPath
        }
    }
    
    /// 设置渐变色
    func wy_add(gradualColors: [UIColor], gradientDirection: WYGradientDirection)  {
        
        DispatchQueue.main.async {
            
            self.layoutIfNeeded()
            
            // 抗锯齿边缘
            self.layer.rasterizationScale = UIScreen.main.scale
            
            var CGColors: [CGColor] = NSMutableArray.init() as! [CGColor]
            for color: UIColor in gradualColors {
                
                CGColors.append(color.cgColor)
            }
            
            var startPoint: CGPoint!
            var endPoint: CGPoint!
            switch gradientDirection {
            case .topToBottom:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: 1.0)
                break
            case .leftToRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 1.0, y: 0.0)
                break
            case .leftToLowRight:
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
