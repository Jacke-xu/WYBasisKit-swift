//
//  UITextField+WYExtension.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// 占位文字颜色
    var wy_placeholderColor: UIColor? {
        
        set(newValue) {
            
            objc_setAssociatedObject(self, #function, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            let ivar: Ivar = class_getInstanceVariable(UITextField.classForCoder(), "_placeholderLabel")!

            let placeholderLabel: UILabel = object_getIvar(self, ivar) as? UILabel ?? UILabel()
            placeholderLabel.textColor = self.wy_placeholderColor
        }
        get {
            return objc_getAssociatedObject(self, #function) as? UIColor
        }
    }
}
