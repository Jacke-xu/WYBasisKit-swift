//
//  UIAlertController.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func wy_show(style: UIAlertController.Style = .alert, title: String = "", message: String = "", duration: TimeInterval = 0.0, textFieldPlaceholders: Array<String> = [], actions: Array<String> = [], handler:((_ actionStr: String, _ textFieldTexts: Array<String>) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            
            if title.isEmpty && message.isEmpty && textFieldPlaceholders.isEmpty && actions.isEmpty {
                return
            }
            
            let alertController: UIAlertController! = UIAlertController(title: (title.isEmpty ? nil : title), message: (message.isEmpty ? nil : message), preferredStyle: style)
            
            for placeholder: String in textFieldPlaceholders {
                
                alertController.addTextField { (textField) in
                    
                    textField.placeholder = placeholder
                    textField.isSecureTextEntry = alertController.wy_sharedSecureTextEntry(placeholder: placeholder)
                }
            }
            
            for actionStr: String in actions {
                
                let action: UIAlertAction = UIAlertAction(title: actionStr, style: alertController.wy_sharedActionStyle(actionStr: actionStr, alertStyle: style)) { (alertAction) in
                    
                    if (handler != nil) {

                        let texts: NSMutableArray = []
                        if !textFieldPlaceholders.isEmpty {
                            
                            for textField: UITextField in alertController.textFields! {
                                
                                texts.add(textField.text ?? "")
                            }
                        }
                        handler!(alertAction.title!, texts.copy() as! Array<String>)
                    }
                    alertController.wy_sharedAppDelegate().window?.makeKeyAndVisible()
                }
                alertController.addAction(action)
            }
            alertController.modalPresentationStyle = .fullScreen
            alertController.wy_alertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            if duration > 0.0 {
                
                DispatchQueue.main.asyncAfter(deadline: .now()+duration) {
                    
                    if (handler != nil) {

                        handler!("", [])
                    }
                    alertController.wy_alertWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                    alertController.wy_sharedAppDelegate().window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    private func wy_sharedActionStyle(actionStr: String!, alertStyle: UIAlertController.Style!) -> UIAlertAction.Style {
        
        var actionStyle: UIAlertAction.Style! = UIAlertAction.Style.default
        switch actionStr {
        case WYLocalizedString("删除"):
            actionStyle = UIAlertAction.Style.destructive
        case WYLocalizedString("取消"):
            if alertStyle == UIAlertController.Style.actionSheet {
                actionStyle = UIAlertAction.Style.cancel
            }else {
                actionStyle = UIAlertAction.Style.default
            }
        default:
            actionStyle = UIAlertAction.Style.default
        }
        return actionStyle
    }
    
    private func wy_sharedSecureTextEntry(placeholder: String!) -> Bool {
        
        return placeholder.wy_stringContainsIgnoringCase(find: WYLocalizedString("密码"))
    }
    
    /// 仅用于外部调用处记录，可用以判断是否正在显示弹窗
    class var wy_isBecomeActive: Bool {
        
        get {
            
            return objc_getAssociatedObject(self, #function) as? Bool ?? false
        }
        
        set {
            
            objc_setAssociatedObject(self, #function, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private struct UIAlertControllerRuntimeKey {
        
        static let wy_alertWindow = UnsafeRawPointer.init(bitPattern: "wy_alertWindow".hashValue)!
    }
    
    private var wy_alertWindow: UIWindow? {
        
        get {
            
            var showWindow: UIWindow? = objc_getAssociatedObject(self, UIAlertControllerRuntimeKey.wy_alertWindow) as? UIWindow
            
            if showWindow == nil {
                
                showWindow = UIWindow(frame: UIScreen.main.bounds)
                showWindow!.rootViewController = UIViewController()
                objc_setAssociatedObject(self, UIAlertControllerRuntimeKey.wy_alertWindow, showWindow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            showWindow?.makeKeyAndVisible()
            
            return showWindow
        }
    }
    
    private func wy_sharedAppDelegate() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
}
