//
//  String.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

public extension String {
    
    /// 返回一个计算好的字符串的宽度
    func wy_calculateStringWidth(controlHeight: CGFloat = 0, controlFont: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        
        let sharedControlHeight = (controlHeight == 0) ? controlFont.lineHeight : controlHeight
        return wy_calculateStringSize(controlSize: CGSize(width: .greatestFiniteMagnitude, height: sharedControlHeight), controlFont: controlFont, lineSpacing: lineSpacing).width
    }
    
    /// 返回一个计算好的字符串的高度
    func wy_calculateStringHeight(controlWidth: CGFloat, controlFont: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        
        return wy_calculateStringSize(controlSize: CGSize(width: controlWidth, height: .greatestFiniteMagnitude), controlFont: controlFont, lineSpacing: lineSpacing).height
    }
    
    /// 返回一个计算好的字符串的size
    func wy_calculateStringSize(controlSize: CGSize, controlFont: UIFont, lineSpacing: CGFloat = 0) -> CGSize {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font: controlFont, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let string = self as NSString
        let stringSize: CGSize! = string.boundingRect(with: controlSize, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: attributes, context: nil).size
        
        return stringSize
    }
    
    /// 判断字符串包含某个字符串
    func wy_stringContains(find: String) -> Bool{
        return self.range(of: find) != nil
    }

    /// 判断字符串包含某个字符串(忽略大小写)
    func wy_stringContainsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    /// 使用正则表达式替换自定字符
    func wy_replace(appointSymbol: String ,replacement: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[\(appointSymbol)]", options: [])
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: replacement)
    }
    
    /// 获取设备时间戳
    static func wy_sharedDeviceTimestamp(mode: WYTimestampMode = .second) -> String {
        
        let timeInterval: TimeInterval = NSDate().timeIntervalSince1970
        switch mode {
        case .second:
            return "\(Int(timeInterval))"
        case .millisecond:
            return "\(CLongLong(round(timeInterval*1000)))"
        }
    }
    
    /// 时间戳转字符串
    func  wy_timestampConvertDate(dateFormat: WYTimeFormat) -> String {
        
        if self.isEmpty {return ""}
        
        let date: NSDate = NSDate.init(timeIntervalSince1970: Double(self)!)
        
        let formatter = DateFormatter.init()
        
        formatter.dateFormat = sharedTimeFormat(dateFormat: dateFormat)
        
        return formatter.string(from: date as Date)
    }
    
    /// 字符串转时间戳
    func wy_dateStrConvertTimestamp(dateFormat: WYTimeFormat) -> String {
        
        if self.isEmpty {return ""}
        
        let format = DateFormatter.init()
        
        format.dateStyle = .medium
        format.timeStyle = .short
        format.dateFormat = sharedTimeFormat(dateFormat: dateFormat)
        
        let date = format.date(from: self)
        
        return String(date!.timeIntervalSince1970)
    }
    
    /// 从字符串中提取数字
    var wy_extractNumbers: String {
        
        let scanner = Scanner(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        
        scanner.scanInt(&number)

        return String(number)
    }
    
    /// 检测手机号合法性
    func wy_isValidPhoneNumber(countryCode: String) -> Bool {
        
        if self.isEmpty || countryCode.isEmpty {
            
            return false
        }
        
        let phoneCode: String = self
        
        let phoneUtil = NBPhoneNumberUtil()
        let new_countryCode: NSNumber = NSNumber(value: Int((countryCode.wy_replace(appointSymbol: "+", replacement: "")))!)
        
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneCode, defaultRegion: phoneUtil.getRegionCode(forCountryCode: new_countryCode))
            
            if phoneUtil.isValidNumber(forRegion: phoneNumber, regionCode: phoneUtil.getRegionCode(forCountryCode: new_countryCode)) == false {
                
                return false
            }
        }
        catch _ as NSError {
            return false
        }
        return true
    }
    
    /// 获取非空字符串
    var wy_emptyStr: String {
        
        return (self.isEmpty) ? "" : self
    }
    
    private func sharedTimeFormat(dateFormat: WYTimeFormat) -> String {
        
        switch dateFormat {
        case .HM:
            return "HH:mm"
        case .YMD:
            return "yyyy-MM-dd"
        case .HMS:
            return "HH:mm:ss"
        case .MDHM:
            return "MM-dd HH:mm"
        case .YMDHM:
            return "yyyy-MM-dd HH:mm"
        case .YMDHMS:
            return "yyyy-MM-dd HH:mm:ss"
        case .custom(format: let format):
            return format
        }
    }
}
