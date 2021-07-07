//
//  WYBoolJudge.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Foundation

public struct WYBoolJudge {
    
    /// 判断是否是指定位字母与数字的组合(默认6-16位)
    public static func wy_isLettersAndNumbers(string: String, min: Int = 6, max: Int = 16) -> Bool {
        let pwd =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{\(min),\(max)}$"
        let regextestpwd = NSPredicate(format: "SELF MATCHES %@",pwd)
        
        return regextestpwd.evaluate(with: string)
    }
}
