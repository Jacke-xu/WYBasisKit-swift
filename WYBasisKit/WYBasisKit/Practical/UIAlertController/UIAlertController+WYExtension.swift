//
//  UIAlertController+WYExtension.swift
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
                
                wy_print("弹窗内容为空")
                return
            }
            
            let alertController: UIAlertController! = UIAlertController(title: (title.isEmpty ? nil : title), message: (message.isEmpty ? nil : message), preferredStyle: style)
            
            for placeholder: String in textFieldPlaceholders {
                
                alertController.addTextField { (textField) in
                    
                    textField.placeholder = placeholder
                    textField.isSecureTextEntry = alertController.sharedSecureTextEntry(placeholder: placeholder)
                }
            }
            
            for actionStr: String in actions {
                
                let action: UIAlertAction = UIAlertAction(title: actionStr, style: alertController.sharedActionStyle(actionStr: actionStr, alertStyle: style)) { (alertAction) in
                    
                    if (handler != nil) {

                        let texts: NSMutableArray = []
                        if !textFieldPlaceholders.isEmpty {
                            
                            for textField: UITextField in alertController.textFields! {
                                
                                texts.add(textField.text ?? "")
                            }
                        }
                        handler!(alertAction.title!, texts.copy() as! Array<String>)
                    }
                    alertController.sharedAppDelegate().window?.makeKeyAndVisible()
                }
                alertController.addAction(action)
            }
            alertController.modalPresentationStyle = .fullScreen
            alertController.alertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            if duration > 0.0 {
                
                DispatchQueue.main.asyncAfter(deadline: .now()+duration) {
                    
                    if (handler != nil) {

                        handler!("", [])
                    }
                    alertController.alertWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                    alertController.sharedAppDelegate().window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    private func sharedActionStyle(actionStr: String!, alertStyle: UIAlertController.Style!) -> UIAlertAction.Style {
        
        var actionStyle: UIAlertAction.Style! = UIAlertAction.Style.default
        switch actionStr {
        case "删除":
            actionStyle = UIAlertAction.Style.destructive
        case "取消":
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
    
    private func sharedSecureTextEntry(placeholder: String!) -> Bool {
        
        return placeholder.wy_stringContainsIgnoringCase(find: "密码")
    }
    
    /// 仅用于外部调用处记录，可用以判断是否正在显示弹窗
    class var isBecomeActive: Bool {
        
        get {
            
            return objc_getAssociatedObject(self, #function) as? Bool ?? false
        }
        
        set {
            
            objc_setAssociatedObject(self, #function, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private var alertWindow: UIWindow? {
        
        get {
            
            var showWindow: UIWindow? = objc_getAssociatedObject(self, #function) as? UIWindow
            
            if showWindow == nil {
                
                showWindow = UIWindow(frame: UIScreen.main.bounds)
                showWindow!.rootViewController = UIViewController()
                objc_setAssociatedObject(self, #function, showWindow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            showWindow?.makeKeyAndVisible()
            
            return showWindow
        }
    }
    
    private func sharedAppDelegate() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
}
