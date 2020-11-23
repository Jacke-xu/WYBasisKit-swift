//
//  UINavigationController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// 导航栏背景色
    var wy_backgroundColor: UIColor {
        
        set(newValue) {
            
            if newValue == UIColor.clear {
                
                wy_backgroundImage = UIImage()
                wy_hiddenBottomLine()
                
            }else {
                
                UINavigationBar.appearance().barTintColor = newValue
            }
        }
        get {
            return UINavigationBar.appearance().barTintColor ?? .white
        }
    }
    
    /// 导航栏背景图
    var wy_backgroundImage: UIImage {
        
        set(newValue) {
            
            UINavigationBar.appearance().setBackgroundImage(newValue, for: .default)
        }
        get {
            return UINavigationBar.appearance().backgroundImage(for: .default) ?? UIImage.wy_imageFromColor(color: .white)
        }
    }
    
    /// 导航栏标题字体
    var wy_titleFont: UIFont {
        
        set(newValue) {
            
            guard UINavigationBar.appearance().titleTextAttributes != nil else {
                
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: newValue, NSAttributedString.Key.foregroundColor: wy_titleColor]
                
                return
            }
            
            var titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
            
            titleTextAttributes![NSAttributedString.Key.font] = newValue
            
            UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        }
        get {
            
            let titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
            if titleTextAttributes?.keys.contains(NSAttributedString.Key.font) == true {
                
                return titleTextAttributes![NSAttributedString.Key.font] as! UIFont
                
            }else {
                
                return .systemFont(ofSize: wy_screenWidthRatioValue(value: 16))
            }
        }
    }
    
    /// 导航栏标题颜色
    var wy_titleColor: UIColor {
        
        set(newValue) {
            
            guard UINavigationBar.appearance().titleTextAttributes != nil else {
                
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: wy_titleFont, NSAttributedString.Key.foregroundColor: newValue]
                
                return
            }
            
            var titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
            
            titleTextAttributes![NSAttributedString.Key.foregroundColor] = newValue
            
            UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        }
        get {
            
            let titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
            if titleTextAttributes?.keys.contains(NSAttributedString.Key.foregroundColor) == true {
                
                return titleTextAttributes![NSAttributedString.Key.foregroundColor] as! UIColor
                
            }else {
                
                return .black
            }
        }
    }
    
    /// 返回按钮图片
    var wy_returnButtonImage: UIImage {
        
        set(newValue) {
            
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = newValue
            UINavigationBar.appearance().backIndicatorImage = newValue
        }
        get {
            
            return UINavigationBar.appearance().backIndicatorImage ?? UIImage.wy_imageFromColor(color: .white)
        }
    }
    
    /// 返回按钮背景颜色
    var wy_returnButtonColor: UIColor {
        
        set(newValue) {
            
            UINavigationBar.appearance().tintColor = newValue
        }
        get {
            
            return UINavigationBar.appearance().tintColor
        }
    }
    
    /// 返回按钮文本
    var wy_returnButtonTitle: String {

        /// 直接在导航栏的代理方法中全局设置
        set {}

        get {

            return topViewController?.navigationItem.backBarButtonItem?.title ?? ""
        }
    }
    
    /// 获取一个纯文本UIBarButtonItem
    func wy_navTitleItem(title: String, color: UIColor = .black, target: Any? = nil, selector: Selector? = nil) -> UIBarButtonItem {
        
        let titleItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        titleItem.tintColor = color
        
        return titleItem
    }
    
    /// 获取一个纯图片UIBarButtonItem
    func wy_navImageItem(image: UIImage, color: UIColor = .black, target: Any? = nil, selector: Selector? = nil) -> UIBarButtonItem {
        
        let imageItem = UIBarButtonItem(image: image, style: .plain, target: target, action: selector)
        imageItem.tintColor = color
            
        return imageItem
    }
    
    /// 获取一个自定义UIBarButtonItem
    func wy_navCustomItem(itemView: UIView) -> UIBarButtonItem {
        
        return UIBarButtonItem(customView: itemView)
    }
    
    /// 隐藏导航栏底部黑线
    func wy_hiddenBottomLine() {
        
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    /// 显示导航栏底部分割线
    func wy_showBottomLine(color: UIColor?) {
        
        UINavigationBar.appearance().shadowImage = nil
        
        if let imageView = wy_sharedBottomLine() {
            
            var frame: CGRect = imageView.frame
            frame.size.height = 1
            imageView.frame = frame
            
            let lineView = imageView.viewWithTag(100) ?? UIView(frame: imageView.bounds)
            lineView.backgroundColor = color
            lineView.tag = 100
            imageView.addSubview(lineView)
        }
    }
    
    /// 获取导航栏底部分隔线View
    func wy_sharedBottomLine(findView: UIView? = UIApplication.shared.keyWindow?.wy_currentController()?.navigationController?.navigationBar) -> UIImageView? {
        
        if let view = findView {
            
            if view.isKind(of: UIImageView.self) && view.bounds.size.height <= 1.0 {
                return view as? UIImageView
            }
             
            for subView in view.subviews {
                let imageView = wy_sharedBottomLine(findView: subView)
                if imageView != nil {
                    return imageView
                }
            }
        }
         
        return nil
    }
}

extension UINavigationController: UINavigationBarDelegate, UIGestureRecognizerDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        
        objc_setAssociatedObject(self, NavigationControllerRuntimeKey.barReturnButtonDelegate, self.interactivePopGestureRecognizer?.delegate, .OBJC_ASSOCIATION_ASSIGN)
        self.interactivePopGestureRecognizer?.delegate = self
        
        /// 全局设置返回按钮文本
        topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: wy_returnButtonTitle, style: .plain, target: nil, action: nil)
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {

        if self.viewControllers.count < (navigationBar.items?.count)! {

            return true
        }

        var shouldPop = true
        let vc: UIViewController = topViewController!

        if vc.responds(to: #selector(wy_navigationBarWillReturn)) {
            shouldPop = vc.wy_navigationBarWillReturn()
        }

        if shouldPop == true {

            DispatchQueue.main.async {

                self.popViewController(animated: true)
            }

        }else {

            // 取消 pop 后，复原返回按钮的状态
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer == self.interactivePopGestureRecognizer) {
            
            let vc: UIViewController = topViewController!
            
            if vc.responds(to: #selector(wy_navigationBarWillReturn)) {
                
                return vc.wy_navigationBarWillReturn()
            }
            
            let originDelegate: UIGestureRecognizerDelegate = objc_getAssociatedObject(self, NavigationControllerRuntimeKey.barReturnButtonDelegate)! as! UIGestureRecognizerDelegate
            
            return originDelegate.gestureRecognizerShouldBegin!(gestureRecognizer)
        }
        
        return true
    }
}
