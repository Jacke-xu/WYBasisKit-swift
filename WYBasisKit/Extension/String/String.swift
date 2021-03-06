//
//  String.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

/// 获取时间戳的模式
public enum WYTimestampMode {
    
    /// 秒
    case second
    
    /// 毫秒
    case millisecond
}

/// 时间格式化模式
public enum WYTimeFormat {
    
    /// 时:分
    case HM
    /// 年-月-日
    case YMD
    /// 时:分:秒
    case HMS
    /// 月-日 时:分
    case MDHM
    /// 年-月-日 时:分
    case YMDHM
    /// 年-月-日 时:分:秒
    case YMDHMS
    /// 传入自定义格式
    case custom(format: String)
}

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
        
        return CGSize(width: ceil(stringSize.width), height: ceil(stringSize.height))
    }
    
    /// 获取每行显示的字符串
    func wy_stringPerLine(font: UIFont, controlWidth: CGFloat) -> [String] {
        
        if self.isEmpty {
            return []
        }
        
        let myFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        
        let attStr = NSMutableAttributedString(string: self)
        
        attStr.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: myFont, range: NSMakeRange(0, attStr.length))
        
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attStr)
        
        let path: CGMutablePath = CGMutablePath()
        
        path.addRect(CGRect(x: 0, y: 0, width: controlWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        let lines = CTFrameGetLines(frame) as Array
        
        var linesArray = [String]()
        
        for line in lines {
            let lineRef: CTLine = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range: NSRange = NSMakeRange(lineRange.location, lineRange.length)
            
            let prefixIndex = self.index(self.startIndex, offsetBy: range.location)
            let suffixIndex = self.index(self.startIndex, offsetBy: range.location + range.length - 1)
            let subStr = String(self[prefixIndex...suffixIndex])
            
            linesArray.append(subStr)
        }
        
        return linesArray
    }
    
    /// 判断字符串显示完毕需要几行
    func wy_numberOfRows(font: UIFont, controlWidth: CGFloat) -> NSInteger {
        return wy_stringPerLine(font: font, controlWidth: controlWidth).count
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
        
        let date: NSDate = NSDate(timeIntervalSince1970: Double(self)!)
        
        let formatter = DateFormatter()
        
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
    
    /// 时间戳距离现在的时间
    func wy_dateDifferenceWithNowTimer(dateFormat: WYTimeFormat) -> String {
        
        // 当前时时间戳
        let currentTime = Date().timeIntervalSince1970
        // 传入的时间
        let computingTime = (self.count == 13) ? (NSInteger(stringValue: self) / 1000) : NSInteger(stringValue: self)
        // 距离当前的时间差
        let timeDifference = NSInteger(currentTime) - computingTime
        // 秒转分钟
        let second = timeDifference / 60
        if (second == 0) {
            return WYLocalizedString("刚刚")
        }
        if second < 60 {
            return "\(second)" + WYLocalizedString("分钟前")
        }
        
        // 秒转小时
        let hours = timeDifference / 3600
        if hours < 24 {
            return "\(hours)" + WYLocalizedString("小时前")
        }
        
        // 秒转天数
        let days = timeDifference / 3600 / 24
        if days < 30 {
            return "\(days)" + WYLocalizedString("天前")
        }
        
        // 秒转月
        let months = timeDifference / 3600 / 24 / 30
        if months < 12 {
            return "\(months)" + WYLocalizedString("月前")
        }
        
        // 秒转年
        let years = timeDifference / 3600 / 24 / 30 / 12
        if years < 3 {
            return "\(years)" + WYLocalizedString("年前")
        }
        return wy_timestampConvertDate(dateFormat: dateFormat)
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
        return (self.isEmpty == true) ? "" : self
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
