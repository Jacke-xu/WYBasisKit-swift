//
//  UIViewController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit
import MBProgressHUD

/// viewController显示模式
public enum WYDisplaMode {
    
    case push
    case present
}

/// 拦截返回按钮的点击和侧滑返回事件
@objc protocol ViewControllerHandlerProtocol {
    
    @objc optional func wy_navigationBarWillReturn() -> Bool
}

extension UIViewController: ViewControllerHandlerProtocol {

    open func wy_navigationBarWillReturn() -> Bool {

        return true
    }
}

public extension UIViewController {
    
    func wy_displayMessage(title: String? = .none, message: String, duration: TimeInterval = wy_messageDuration) {
        
        UIAlertController.wy_show(title: title ?? "", message: message, duration: duration)
    }
    
    func wy_displayMessage(title: String? = .none, message: String? = .none, actions: [String] = [WYLocalizedString("知道了")]) {
        
        UIAlertController.wy_show(title: title ?? "", message: message ?? "", actions: actions)
    }
    
    func wy_displayLoading(string: String = "", animated: Bool = true) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: animated)
        hud.label.text = string
    }
    
    func wy_dismissLoading() {
        
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    /** 从导航控制器栈中查找ViewController，没有时返回nil */
    func wy_findViewController(className: String) -> UIViewController? {
        
        guard let controller = wy_controller(from: className) else { return nil }
        
        guard self.navigationController?.viewControllers.isEmpty == true else { return nil }
        
        return self.navigationController?.viewControllers.first(where: { $0 == controller })
    }
    
    /** 删除指定的视图控制器 */
    func wy_deleteViewController(className: String, complete:(() -> Void)? = nil) {
        
        guard let controller = wy_controller(from: className) else { return }
        
        guard self.navigationController?.viewControllers.isEmpty == true else { return }
        
        var controllers: [UIViewController] = self.navigationController!.viewControllers
        
        controllers.removeAll(where: { $0 == controller })
        
        self.navigationController?.viewControllers = controllers
        
        if complete != nil {
            
            complete!()
        }
    }
    
    /** 跳转到指定的视图控制器 */
    func wy_showViewController(className: String, parameters: AnyObject? = nil, displaMode: WYDisplaMode = .push, animated: Bool = true) {

        guard let controller = wy_controller(from: className)  else { return }
        
        wy_showViewController(controller: controller, parameters: parameters, displaMode: displaMode, animated: animated)
    }
    
    /** 跳转到指定的视图控制器，此方法可防止循环跳转 */
    func wy_showOnlyViewController(className: String, parameters: AnyObject? = nil, displaMode: WYDisplaMode = .push, animated: Bool = true) {
        
        weak var weakSelf = self
        wy_deleteViewController(className: className) {
            
            weakSelf?.wy_showViewController(className: className, parameters: parameters, displaMode: displaMode, animated: animated)
        }
    }
    
    /** 返回到指定的视图控制器 */
    func wy_backToViewController(className: String, animated: Bool = true) {
        
        let controller = wy_projectName + "." + className
        guard let controllerClass = NSClassFromString(controller) as? UIViewController.Type else {
            
            return
        }
        
        if wy_viewControllerDisplaMode() == .push {
            
            guard self.navigationController?.viewControllers.isEmpty == true else { return }
            
            let showController: UIViewController? = self.navigationController!.viewControllers.first(where: { $0.isKind(of: controllerClass.self) })
            
            guard showController != nil else { return }
            
            self.navigationController?.popToViewController(showController!, animated: animated)
            
        }else {
            
            var presentingController = self.presentingViewController
            
            guard presentingController != nil else { return }
            
            while !(presentingController!.isKind(of: controllerClass.self)) {
                
                presentingController = presentingController?.presentingViewController
            }
            presentingController?.dismiss(animated: animated)
        }
    }
    
    /** 跳转到指定的视图控制器(通用) */
    func wy_showViewController(controller: UIViewController, parameters: AnyObject? = nil, displaMode: WYDisplaMode = .push, animated: Bool = true) {
        
        controller.hidesBottomBarWhenPushed = true
        controller.wy_parameters = parameters
        switch displaMode {
        case .push:
            self.navigationController?.pushViewController(controller, animated: animated)
        case .present:
            self.present(controller, animated: animated)
        }
    }
    
    /** 根据字符串获得对应控制器 */
    func wy_controller(from className: String) -> UIViewController? {
        
        let controller = wy_projectName + "." + className
        
        guard let controllerClass = NSClassFromString(controller) as? UIViewController.Type else {
            
            return nil
        }
        return controllerClass.init()
    }
    
    /** 获取viewController跳转模式 */
    func wy_viewControllerDisplaMode() -> WYDisplaMode {
        
        let viewcontrollers = self.navigationController?.viewControllers
        var displaMode: WYDisplaMode = .push
        
        if viewcontrollers?.isEmpty == false {
            
            displaMode = (viewcontrollers?.last == self) ? .push : .present
            
        }else {
            
            displaMode = .present
        }
        
        return displaMode;
    }
    
    private struct ControllerRuntimeKey {
        
        static let wy_parameters = UnsafeRawPointer.init(bitPattern: "wy_parameters".hashValue)!
    }
    
    /// 控制器附加参数
    var wy_parameters: AnyObject? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, WYAssociatedKeys.wy_parameters, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.wy_parameters) as AnyObject
        }
    }
    
    private struct WYAssociatedKeys {
        
        static let wy_parameters = UnsafeRawPointer.init(bitPattern: "wy_parameters".hashValue)!
    }
}


