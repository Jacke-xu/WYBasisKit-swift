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
    func wy_addGesture(target: Any?, action: Selector?) {
        
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
    * 设置圆角、边框、阴影
    * @param rectCorner        要圆角的位置，默认没有圆角
    * @param cornerRadius      圆角半径
    * @param borderColor       边框颜色
    * @param borderWidth       边框宽度
    * @param shadowColor       阴影颜色
    * @param shadowRadius      阴影半径
    * @param shadowOpacity     阴影透明度，默认值是0.0，取值范围0~1
    * @param shadowOffset      阴影偏移度(width : 为正数时，向右偏移，为负数时，向左偏移，height : 为正数时，向下偏移，为负数时，向上偏移)
    * @param gradualColors     渐变色数组
    * @param gradientDirection 渐变色方向，默认从左到右
    */
    func wy_add(rectCorner: UIRectCorner = .init(), cornerRadius: CGFloat = 0, borderColor: UIColor = .clear, borderWidth: CGFloat = 0, shadowColor: UIColor = .clear, shadowRadius: CGFloat = 0, shadowOpacity: CGFloat = 0.5, shadowOffset: CGSize = CGSize.zero, gradualColors: [UIColor] = [], gradientDirection: WYGradientDirection = .leftToRight) {
        
        DispatchQueue.main.async {
            
            self.wy_rectCorner(rectCorner)
                .wy_cornerRadius(cornerRadius)
                .wy_borderColor(borderColor)
                .wy_borderWidth(borderWidth)
                .wy_shadowColor(shadowColor)
                .wy_shadowRadius(shadowRadius)
                .wy_shadowOpacity(shadowOpacity)
                .wy_shadowOffset(shadowOffset)
                .wy_gradualColors(gradualColors)
                .wy_gradientDirection(gradientDirection)
                .wy_showVisual()
        }
    }
    
    @discardableResult
    /// 使用链式编程设置圆角、边框、阴影(调用方式类似SnapKit， 也可直接.语法)
    func wy_makeVisual(visualView: (UIView) -> Void) -> UIView {

        visualView(self)
        return wy_showVisual()
    }
    
    @discardableResult
    /// 圆角的位置， 默认4角圆角
    func wy_rectCorner(_ corner: UIRectCorner) -> UIView {
        privateRectCorner = corner
        return self
    }
    
    @discardableResult
    /// 圆角的半径 默认0.0
    func wy_cornerRadius(_ radius: CGFloat) -> UIView {
        privateConrnerRadius = radius
        return self
    }
    
    @discardableResult
    /// 边框颜色 默认透明
    func wy_borderColor(_ color: UIColor) -> UIView {
        privateBorderColor = color
        return self
    }
    
    @discardableResult
    /// 边框宽度 默认0.0
    func wy_borderWidth(_ width: CGFloat) -> UIView {
        privateBorderWidth = width
        return self
    }
    
    @discardableResult
    /// 阴影颜色 默认透明
    func wy_shadowColor(_ color: UIColor) -> UIView {
        privateShadowColor = color
        return self
    }
    
    @discardableResult
    /// 阴影偏移度 默认CGSize.zero (width : 为正数时，向右偏移，为负数时，向左偏移，height : 为正数时，向下偏移，为负数时，向上偏移)
    func wy_shadowOffset(_ offset: CGSize) -> UIView {
        privateShadowOffset = offset
        return self
    }
    
    @discardableResult
    /// 阴影半径 默认0.0
    func wy_shadowRadius(_ redius: CGFloat) -> UIView {
        privateShadowRadius = redius
        return self
    }
    
    @discardableResult
    /// 阴影模糊度，默认0.5，取值范围0~1
    func wy_shadowOpacity(_ opacity: CGFloat) -> UIView {
        privateShadowOpacity = opacity
        return self
    }
    
    @discardableResult
    /// 渐变色数组
    func wy_gradualColors(_ colors: [UIColor]) -> UIView {

        privateGradualColors = colors
        return self
    }

    @discardableResult
    /// 渐变色方向 默认从左到右
    func wy_gradientDirection(_ direction: WYGradientDirection) -> UIView {

        privateGradientDirection = direction
        return self
    }
    
    @discardableResult
    /// 贝塞尔路径 默认nil (有值时，radius属性将失效)
    func wy_bezierPath(_ path: UIBezierPath) -> UIView {
        privateBezierPath = path
        return self
    }
    
    @discardableResult
    /// 设置圆角时，会去获取视图的bounds属性，如果此时获取不到，则需要传入该参数，默认为 nil，如果传入该参数，则不会去回去视图的bounds属性了
    func wy_viewBounds(_ bounds: CGRect) -> UIView {
        privateViewBounds = bounds
        if frame.equalTo(.zero) {
            
            wy_origin = bounds.origin
            wy_size = bounds.size
        }
        return self
    }
    
    @discardableResult
    /// 显示边框、阴影、圆角
    func wy_showVisual() -> UIView {
        
        // 抗锯齿边缘
        layer.rasterizationScale = UIScreen.main.scale
        
        // 添加阴影
        wy_addShadow()
        // 添加边框、圆角
        wy_addBorderAndRadius()
        // 添加阴影
        wy_addGradual()
        
        return self
    }
    
    @discardableResult
    /// 清除边框、阴影、圆角、渐变
    func wy_clearVisual() -> UIView {
        
        // 阴影
        if shadowBackgroundView != nil {
            
            shadowBackgroundView?.removeFromSuperview()
            shadowBackgroundView = nil
        }

        // 圆角、边框、渐变
        if layer.sublayers?.isEmpty == false {
            
            for sublayer in layer.sublayers! {
                
                if ((sublayer.name == WYAssociatedKeys.wy_boardLayer) || (sublayer.name == WYAssociatedKeys.wy_gradientLayer)) {
                    
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        
        // 恢复默认设置
        privateRectCorner    = .allCorners
        privateConrnerRadius = 0.0
        privateBorderColor   = .clear
        privateBorderWidth   = 0.0
        privateShadowOpacity = 0.0
        privateShadowRadius  = 0.0
        privateShadowOffset  = .zero
        privateViewBounds    = .zero
        privateShadowColor   = .clear
        privateGradualColors = nil
        privateGradientDirection = .leftToRight
        shadowBackgroundView = nil

        layer.cornerRadius   = 0.0
        layer.borderWidth    = 0.0
        layer.borderColor    = UIColor.clear.cgColor
        layer.shadowOpacity  = 0.0
        layer.shadowPath     = nil
        layer.shadowRadius   = 0.0
        layer.shadowColor    = UIColor.clear.cgColor
        layer.shadowOffset   = .zero
        layer.mask           = nil
        
        return self
    }
    
    private func wy_addShadow() {
        
        var shadowView = self
        
        // 同时存在阴影和圆角
        if (((privateShadowOpacity > 0) && (privateConrnerRadius > 0)) || (privateBezierPath != nil)) {
            
            if shadowBackgroundView != nil {
                
                shadowBackgroundView?.removeFromSuperview()
                shadowBackgroundView = nil
            }
            
            if superview == nil { wy_print("添加阴影和圆角时，请先将view加到父视图上") }
            
            shadowView = UIView(frame: self.frame)
            shadowView.translatesAutoresizingMaskIntoConstraints = false
            superview?.insertSubview(shadowView, belowSubview: self)
            superview?.addConstraints([
                                            NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
                                            NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0),
                                            NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
                                            NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)])

            shadowBackgroundView = shadowView
            
        }
        
        // 圆角
        if ((privateConrnerRadius > 0) || (privateBezierPath != nil)) {
            
            let shadowPath: UIBezierPath = wy_sharedBezierPath()
            shadowView.layer.shadowPath = shadowPath.cgPath
        }

        // 阴影
        shadowView.layer.shadowOpacity = Float(privateShadowOpacity)
        shadowView.layer.shadowRadius  = privateShadowRadius
        shadowView.layer.shadowOffset  = privateShadowOffset
        shadowView.layer.shadowColor   = privateShadowColor.cgColor
    }
    
    /// 添加圆角和边框
    private func wy_addBorderAndRadius() {
        
        // 圆角或阴影或自定义曲线
        if ((privateConrnerRadius > 0) || (privateShadowOpacity > 0) || (privateBezierPath != nil)) {
            
            // 圆角
            if ((privateConrnerRadius > 0) || (privateBezierPath != nil)) {
                
                let path: UIBezierPath = wy_sharedBezierPath()
                let maskLayer: CAShapeLayer = CAShapeLayer()
                maskLayer.frame = bounds
                maskLayer.path = path.cgPath
                layer.mask = maskLayer
            }
  
            // 边框
            if ((privateBorderWidth > 0) || (privateBezierPath != nil)) {
                
                if layer.sublayers?.isEmpty == false {
                    
                    for sublayer in layer.sublayers! {
                        
                        if sublayer.name == WYAssociatedKeys.wy_boardLayer {
                            
                            sublayer.removeFromSuperlayer()
                        }
                    }
                }
                
                let path: UIBezierPath = wy_sharedBezierPath()
                let shapeLayer = CAShapeLayer()
                shapeLayer.name = WYAssociatedKeys.wy_boardLayer
                shapeLayer.frame = bounds
                shapeLayer.path = path.cgPath
                shapeLayer.lineWidth   = privateBorderWidth
                shapeLayer.strokeColor = privateBorderColor.cgColor
                shapeLayer.fillColor   = UIColor.clear.cgColor
                shapeLayer.lineCap = .square
                shapeLayer.lineJoin = .miter
                layer.addSublayer(shapeLayer)
            }

        }else {
            
            // 只有边框
            let borderLayer = CAShapeLayer()
            borderLayer.path = wy_sharedBezierPath().cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = privateBorderColor.cgColor
            borderLayer.lineWidth = privateBorderWidth
            borderLayer.frame = bounds
            borderLayer.lineCap = .square
            borderLayer.lineJoin = .miter
            layer.addSublayer(borderLayer)
        }
    }
    
    /// 添加阴影
    private func wy_addGradual() {
        
        guard privateGradualColors?.isEmpty == false else {
            return
        }
        
        var CGColors: [CGColor] = NSMutableArray.init() as! [CGColor]
        for color: UIColor in privateGradualColors! {
            
            CGColors.append(color.cgColor)
        }
        
        var startPoint: CGPoint!
        var endPoint: CGPoint!
        switch privateGradientDirection {
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
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = WYAssociatedKeys.wy_gradientLayer
        gradientLayer.frame = bounds
        gradientLayer.colors = CGColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func wy_sharedBounds() -> CGRect {
        
        // 如果传入了大小，则使用传入的大小
        if (privateViewBounds.equalTo(.zero) == false) {
            
            return privateViewBounds
        }
        
        // 获取在自动布局前的视图大小
        if (superview != nil) {
            
            superview?.layoutIfNeeded()
        }
        
        return self.bounds
    }
    
    private func wy_sharedBezierPath() -> UIBezierPath {
        
        if privateBezierPath != nil {
            
            return privateBezierPath!
            
        }else {
            return UIBezierPath(roundedRect: wy_sharedBounds(), byRoundingCorners: privateRectCorner, cornerRadii: CGSize(width: privateConrnerRadius, height: privateConrnerRadius))
        }
    }
    
    private var privateRectCorner: UIRectCorner {
        
        set(newValue) {

            objc_setAssociatedObject(self, WYAssociatedKeys.privateRectCorner, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            
            return UIRectCorner.init(rawValue: objc_getAssociatedObject(self, WYAssociatedKeys.privateRectCorner) as? UInt ?? UInt(UIRectCorner.allCorners.rawValue))
        }
    }
    
    private var privateConrnerRadius: CGFloat {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateConrnerRadius, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateConrnerRadius) as? CGFloat ?? 0.0
        }
    }
    
    private var privateBorderColor: UIColor {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateBorderColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateBorderColor) as? UIColor ?? .black
        }
    }
    
    private var privateBorderWidth: CGFloat {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateBorderWidth, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateBorderWidth) as? CGFloat ?? 0.0
        }
    }
    
    private var privateShadowColor: UIColor {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowColor) as? UIColor ?? .black
        }
    }
    
    private var privateShadowOffset: CGSize {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowOffset, NSCoder.string(for: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return NSCoder.cgSize(for: objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowOffset) as? String ?? (NSCoder.string(for: CGSize.zero)))
        }
    }
    
    private var privateShadowRadius: CGFloat {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowRadius, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowRadius) as? CGFloat ?? 0.0
        }
    }
    
    private var privateShadowOpacity: CGFloat {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowOpacity, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowOpacity) as? CGFloat ?? 0.5
        }
    }
    
    private var privateGradientDirection: WYGradientDirection {
        
        set(newValue) {

            objc_setAssociatedObject(self, WYAssociatedKeys.privateGradientDirection, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            
            return WYGradientDirection.init(rawValue: objc_getAssociatedObject(self, WYAssociatedKeys.privateGradientDirection) as? UInt ?? WYGradientDirection.leftToRight.rawValue) ?? .leftToRight
        }
    }
    
    private var privateGradualColors: [UIColor]? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateGradualColors, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateGradualColors) as? [UIColor]
        }
    }
    
    private var privateBezierPath: UIBezierPath? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateBezierPath, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateBezierPath) as? UIBezierPath
        }
    }
    
    private var privateViewBounds: CGRect {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.privateViewBounds, NSCoder.string(for: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return NSCoder.cgRect(for: objc_getAssociatedObject(self, WYAssociatedKeys.privateViewBounds) as? String ?? (NSCoder.string(for: CGRect.zero)))
        }
    }
    
    private var shadowBackgroundView: UIView? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.shadowBackgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.shadowBackgroundView) as? UIView
        }
    }
    
    private struct WYAssociatedKeys {
        
        static let privateRectCorner = UnsafeRawPointer.init(bitPattern: "privateRectCorner".hashValue)!
        static let privateConrnerRadius = UnsafeRawPointer.init(bitPattern: "privateConrnerRadius".hashValue)!
        static let privateBorderColor = UnsafeRawPointer.init(bitPattern: "privateBorderColor".hashValue)!
        static let privateBorderWidth = UnsafeRawPointer.init(bitPattern: "privateBorderWidth".hashValue)!
        static let privateShadowColor = UnsafeRawPointer.init(bitPattern: "privateShadowColor".hashValue)!
        static let privateShadowOffset = UnsafeRawPointer.init(bitPattern: "privateShadowOffset".hashValue)!
        static let privateShadowRadius = UnsafeRawPointer.init(bitPattern: "privateShadowRadius".hashValue)!
        static let privateShadowOpacity = UnsafeRawPointer.init(bitPattern: "privateShadowOpacity".hashValue)!
        static let privateGradualColors = UnsafeRawPointer.init(bitPattern: "privateGradualColors".hashValue)!
        static let privateGradientDirection = UnsafeRawPointer.init(bitPattern: "privateGradientDirection".hashValue)!
        static let privateBezierPath = UnsafeRawPointer.init(bitPattern: "privateBezierPath".hashValue)!
        static let privateViewBounds = UnsafeRawPointer.init(bitPattern: "privateViewBounds".hashValue)!
        static let shadowBackgroundView = UnsafeRawPointer.init(bitPattern: "shadowBackgroundView".hashValue)!
        static let wy_boardLayer = "wy_boardLayer"
        static let wy_gradientLayer = "wy_gradientLayer"
    }
}
