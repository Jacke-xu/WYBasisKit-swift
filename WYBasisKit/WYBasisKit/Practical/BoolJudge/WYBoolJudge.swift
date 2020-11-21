//
//  WYBoolJudge.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation

class WYBoolJudge: NSObject {
    
    /// 判断是否是6-16位字母与数字的组合
    class func wy_isLettersAndNumbers(string: String) -> Bool {
        
        let pwd =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let regextestpwd = NSPredicate(format: "SELF MATCHES %@",pwd)
        
        return regextestpwd.evaluate(with: string)
    }
}
