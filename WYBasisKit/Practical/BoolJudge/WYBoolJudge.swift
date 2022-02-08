//
//  WYBoolJudge.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Foundation
import libPhoneNumber_iOS

public struct WYBoolJudge {
    
    /// 判断是否是指定位字母与数字的组合(默认6-16位)
    public static func wy_isLettersAndNumbers(string: String, min: Int = 6, max: Int = 16) -> Bool {
        let pwd =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{\(min),\(max)}$"
        let regextestpwd = NSPredicate(format: "SELF MATCHES %@",pwd)
        
        return regextestpwd.evaluate(with: string)
    }
    
    /// 检测手机号合法性
    public static func wy_isValidPhoneNumber(_ phoneNumber: String, _ countryCode: String = "86") -> Bool {
        
        if phoneNumber.isEmpty || countryCode.isEmpty {
            return false
        }
        
        /**
         *  使用正则表达式替换自定字符
         *  @param appointSymbol: 要替换的字符
         *  @param replacement: 替换成什么字符
         *  @param object: 需要处理的字符
         */
        func wy_replace(appointSymbol: String ,replacement: String, object: String) -> String {
            let regex = try! NSRegularExpression(pattern: "[\(appointSymbol)]", options: [])
            return regex.stringByReplacingMatches(in: object, options: [],
                                                  range: NSMakeRange(0, object.count),
                                                  withTemplate: replacement)
        }
        
        let phoneCode: String = phoneNumber
        let phoneUtil = NBPhoneNumberUtil()
        let new_countryCode: NSNumber = NSNumber(value: Int((wy_replace(appointSymbol: "+", replacement: "", object: countryCode)))!)
        
        do {
            let nb_phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneCode, defaultRegion: phoneUtil.getRegionCode(forCountryCode: new_countryCode))
            
            if phoneUtil.isValidNumber(forRegion: nb_phoneNumber, regionCode: phoneUtil.getRegionCode(forCountryCode: new_countryCode)) == false {
                
                return false
            }
        }
        catch _ as NSError {
            return false
        }
        return true
    }
}
