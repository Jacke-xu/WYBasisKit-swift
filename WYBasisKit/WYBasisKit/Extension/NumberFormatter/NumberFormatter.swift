//
//  NumberFormatter.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    /// 千位符之四舍五入的整数(1234.5678 -> 1235)
    class func wy_roundToInteger(string: String?) -> String {
        
        return NumberFormatter.localizedString(from: NSNumber(value: Double(string ?? "0.0") ?? 0.0), number: .none)
    }
    
    /// 千位符之小数转百分数(1234.5678 -> 123,457%)
    class func wy_decimalToPercent(string: String?) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 4 //设置小数点后最多4位
        
        return numberFormatter.string(from: NSNumber(value: Double(string ?? "0") ?? 0)) ?? "0%"
    }
    
    /// 千位符之国际化格式小数(1234.5678 -> 1,234.5678)
    class func wy_internationalizedFormat(string: String?) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 4 //设置小数点后最多4位
        
        return numberFormatter.string(from: NSNumber(value: Double(string ?? "0") ?? 0)) ?? "0"
    }
}
