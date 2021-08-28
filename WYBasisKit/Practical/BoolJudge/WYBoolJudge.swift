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
    public static func wy_isValidPhoneNumber(_ phoneNumber: String, _ countryCode: String = WYBasisKitConfig.countryCode) -> Bool {
        
        if phoneNumber.isEmpty || countryCode.isEmpty {
            return false
        }
        
        let phoneCode: String = phoneNumber
        let phoneUtil = NBPhoneNumberUtil()
        let new_countryCode: NSNumber = NSNumber(value: Int((countryCode.wy_replace(appointSymbol: "+", replacement: "")))!)
        
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
