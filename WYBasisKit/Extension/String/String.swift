//
//  String.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

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
    func wy_calculateWidth(controlHeight: CGFloat = 0, controlFont: UIFont, lineSpacing: CGFloat = 0, wordsSpacing: CGFloat = 0) -> CGFloat {
        
        let sharedControlHeight = (controlHeight == 0) ? controlFont.lineHeight : controlHeight
        return wy_calculategSize(controlSize: CGSize(width: .greatestFiniteMagnitude, height: sharedControlHeight), controlFont: controlFont, lineSpacing: lineSpacing, wordsSpacing: wordsSpacing).width
    }
    
    /// 返回一个计算好的字符串的高度
    func wy_calculateHeight(controlWidth: CGFloat, controlFont: UIFont, lineSpacing: CGFloat = 0, wordsSpacing: CGFloat = 0) -> CGFloat {
        
        return wy_calculategSize(controlSize: CGSize(width: controlWidth, height: .greatestFiniteMagnitude), controlFont: controlFont, lineSpacing: lineSpacing, wordsSpacing: wordsSpacing).height
    }
    
    /// 返回一个计算好的字符串的size
    func wy_calculategSize(controlSize: CGSize, controlFont: UIFont, lineSpacing: CGFloat = 0, wordsSpacing: CGFloat = 0) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font: controlFont, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.kern: NSNumber(value: Double(wordsSpacing))]
        
        
        let string = self as NSString
        let stringSize: CGSize! = string.boundingRect(with: controlSize, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: attributes, context: nil).size
        
        return CGSize(width: ceil(stringSize.width), height: ceil(stringSize.height))
    }
    
    /// 判断字符串包含某个字符串
    func wy_stringContains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    /// 判断字符串包含某个字符串(忽略大小写)
    func wy_stringContainsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    /// 字符串截取(从第几位截取到第几位)
    func wy_substring(from: NSInteger, to: NSInteger) -> String {
        
        guard from < self.count else {
            return self
        }
        
        guard to < self.count else {
            return self
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        
        return String(self[startIndex...endIndex])
    }
    
    /// 字符串截取(从第几位往后截取几位)
    func wy_substring(from: NSInteger, after: NSInteger) -> String {
        
        guard from < self.count else {
            return self
        }
        
        guard (from + after) < self.count else {
            return self
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: from + after)
        
        return String(self[startIndex...endIndex])
    }
    
    /**
     *  替换指定字符(useRegex为true时，会过滤掉 appointSymbol 字符中所包含的每一个字符, useRegex为false时，会过滤掉字符串中所包含的整个 appointSymbol 字符)
     *  @param appointSymbol: 要替换的字符
     *  @param replacement: 替换成什么字符
     *  @param useRegex: 过滤方式，true正则表达式过滤, false为系统方式过滤
     */
    func wy_replace(appointSymbol: String ,replacement: String, useRegex: Bool = false) -> String {
        
        if (useRegex == true) {
            let regex = try! NSRegularExpression(pattern: "[\(appointSymbol)]", options: [])
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: NSMakeRange(0, self.count),
                                                  withTemplate: replacement)
        }else {
            return self.replacingOccurrences(of: appointSymbol, with: replacement)
        }
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
    
    /// 时间戳转年月日格式
    func  wy_timestampConvertDate(dateFormat: WYTimeFormat) -> String {
        
        if self.isEmpty {return ""}
        
        let dateString: String = self.count <= 10 ? self : "\(((NumberFormatter().number(from: self)?.doubleValue ?? 0.0) / 1000))"
        
        let date: Date = Date(timeIntervalSince1970: Double(dateString)!)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = sharedTimeFormat(dateFormat: dateFormat)
        
        return formatter.string(from: date as Date)
    }
    
    /// 年月日格式转时间戳
    func wy_dateStrConvertTimestamp(dateFormat: WYTimeFormat) -> String {
        
        if self.isEmpty {return ""}
        
        let format = DateFormatter()
        
        format.dateStyle = .medium
        format.timeStyle = .short
        format.dateFormat = sharedTimeFormat(dateFormat: dateFormat)
        
        let date = format.date(from: self)
        
        return String(date!.timeIntervalSince1970)
    }
    
    /// 时间戳距离现在的间隔时间
    func wy_dateDifferenceWithNowTimer(dateFormat: WYTimeFormat) -> String {
        
        // 当前时时间戳
        let currentTime = Date().timeIntervalSince1970
        // 传入的时间
        let computingTime = (self.count <= 10) ? (NSInteger(self) ?? 0) : ((NSInteger(self) ?? 0) / 1000)
        // 距离当前的时间差
        let timeDifference = NSInteger(currentTime) - computingTime
        // 秒转分钟
        let second = timeDifference / 60
        if (second <= 0) {
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
    
    /**
     *  汉字转拼音
     *  @param tone: 是否需要保留音调
     *  @param interval: 拼音之间是否需要用空格间隔开
     */
    func wy_phoneticTransform(tone: Bool = false, interval: Bool = false) -> String {
        
        // 转化为可变字符串
        let mString = NSMutableString(string: self)
        
        // 转化为带声调的拼音
        CFStringTransform(mString, nil, kCFStringTransformToLatin, false)
        
        if !tone {
            // 转化为不带声调
            CFStringTransform(mString, nil, kCFStringTransformStripDiacritics, false)
        }
        
        let phonetic = (NSString(string: mString) as String)
        
        if !interval {
            // 去除字符串之间的空格
            return phonetic.replacingOccurrences(of: " ", with: "")
        }
        return phonetic
    }
    
    /// 根据时间戳获取星座
    static func wy_constellation(from timestamp: String) -> String {
        
        let timeInterval: TimeInterval = timestamp.count <= 10 ? (NumberFormatter().number(from: timestamp)?.doubleValue ?? 0.0) : ((NumberFormatter().number(from: timestamp)?.doubleValue ?? 0.0) / 1000)
        
        let oneDay:Double = 86400
        let constellationDics = [WYLocalizedString("摩羯座"): "12.22-1.19",
                                 WYLocalizedString("水瓶座"): "1.20-2.18",
                                 WYLocalizedString("双鱼座"): "2.19-3.20",
                                 WYLocalizedString("白羊座"): "3.21-4.19",
                                 WYLocalizedString("金牛座"): "4.20-5.20",
                                 WYLocalizedString("双子座"): "5.21-6.21",
                                 WYLocalizedString("巨蟹座"): "6.22-7.22",
                                 WYLocalizedString("狮子座"): "7.23-8.22",
                                 WYLocalizedString("处女座"): "8.23-9.22",
                                 WYLocalizedString("天秤座"): "9.23-10.23",
                                 WYLocalizedString("天蝎座"): "10.24-11.22",
                                 WYLocalizedString("射手座"): "11.23-12.21"]
        
        let currConstellation = constellationDics.filter {
            
            let timeRange = constellationDivision(timestamp: timestamp, range: $1)
            let startTime = timeRange.0
            let endTime = timeRange.1 + oneDay
            
            return timeInterval > startTime && timeInterval < endTime
        }
        return currConstellation.first?.key ?? WYLocalizedString("摩羯座")
    }
    
    /// Encode
    func wy_encoded(escape: String = "?!@#$^&%*+,:;='\"`<>()[]{}/\\| ") -> String {
        
        let characterSet = NSCharacterSet(charactersIn: escape).inverted
        return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? self
    }
    
    /// Decode
    func wy_decoded() -> String {
        
        let targetString: NSMutableString = NSMutableString(string: self)
        targetString.replaceOccurrences(of: "+", with: "", options: .literal, range: NSMakeRange(0, targetString.length))
        return targetString.removingPercentEncoding ?? self
    }
    
    /**
     *  根据传入的表情字符串生成富文本，例如字符串 "哈哈[哈哈]" 会生成 "哈哈😄"
     *  @param textColor     富文本的字体颜色
     *  @param textFont      富文本的字体
     *  @param emojiTable    表情解析对照表，如 ["哈哈]": "哈哈表情对应的图片名", [嘿嘿]: "嘿嘿表情对应的图片名"]
     *  @param bundle        从哪个bundle文件内查找图片资源，如果为空，则直接在本地路径下查找
     *  @param pattern       正则匹配规则, 默认匹配1到3位, 如 [哈] [哈哈] [哈哈哈] 这种
     */
    func wy_convertEmojiAttributed(textColor: UIColor, textFont: UIFont, emojiTable: [String: String], sourceBundle: WYSourceBundle? = nil, pattern: String = "\\[.{1,3}\\]") -> NSMutableAttributedString {
        
        let emojiString: String = self
        
        // 字体、颜色
        let textAttributes = [NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor]
        
        // 获取字体的行高，作为表情的高度
        let attachmentHeight = textFont.lineHeight
        
        // 通过 emojiString 获得 NSMutableAttributedString
        let attributedString = NSMutableAttributedString(string: emojiString, attributes: textAttributes)
        
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch let error {
            wy_print(error.localizedDescription)
        }
        
        // 获取到匹配正则的数据
        if let matches = regex?.matches(in: emojiString, options: .withoutAnchoringBounds, range: NSMakeRange(0, attributedString.string.count)) {
            if matches.count > 0 {
                // 遍历符合的数据进行解析
                for i in 0..<matches.count {
                    let result = matches[matches.count-i-1]
                    let range = result.range
                    let emojiStr = (emojiString as NSString).substring(with: range)
                    // 符合的数据是否为表情
                    if emojiTable.keys.contains(emojiStr) {
                        
                        // 获取表情对应的图片名
                        if let imageName: String = emojiTable[emojiStr] {
                            let image: UIImage = UIImage.wy_named(imageName, inBundle: sourceBundle)
                            
                            // 创建一个NSTextAttachment
                            let attachment = NSTextAttachment()
                            attachment.image  = image
                            
                            let attachmentWidth = attachmentHeight * (image.size.width / image.size.height)
                            
                            attachment.bounds = CGRect(x: 0, y: (textFont.capHeight - textFont.lineHeight)/2, width: attachmentWidth, height: attachmentHeight)
                            
                            // 通过NSTextAttachment生成一个NSAttributedString
                            let replace = NSAttributedString(attachment: attachment)
                            
                            // 替换表情字符串
                            attributedString.replaceCharacters(in: range, with: replace)
                        }
                    }
                }
            }
        }
        return attributedString
    }
}

private extension String {
    
    func sharedTimeFormat(dateFormat: WYTimeFormat) -> String {
        
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
    
    /// 获取星座开始、结束时间
    static func constellationDivision(timestamp: String, range: String) -> (TimeInterval, TimeInterval) {
        
        /// 获取当前年份
        func getCurrYear(date:Date) -> String {
            
            let dm = DateFormatter()
            dm.dateFormat = "yyyy."
            let currYear = dm.string(from: date)
            return currYear
        }
        
        /// 日期转换当前时间戳
        func toTimeInterval(dateStr: String) -> TimeInterval? {
            
            let dm = DateFormatter()
            dm.dateFormat = "yyyy.MM.dd"
            
            let date = dm.date(from: dateStr)
            let interval = date?.timeIntervalSince1970
            
            return interval
        }
        
        let timeStrArr = range.components(separatedBy: "-")
        
        let timeInterval: TimeInterval = timestamp.count <= 10 ? (NumberFormatter().number(from: timestamp)?.doubleValue ?? 0.0) : ((NumberFormatter().number(from: timestamp)?.doubleValue ?? 0.0) / 1000)
        
        let dateYear = getCurrYear(date: Date(timeIntervalSince1970: timeInterval))
        let startTimeStr = dateYear + timeStrArr.first!
        let endTimeStr = dateYear + timeStrArr.last!
        
        let startTime = toTimeInterval(dateStr: startTimeStr)!
        let endTime = toTimeInterval(dateStr: endTimeStr)!
        
        return (startTime, endTime)
    }
}
