//
//  NSMutableAttributedString.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    
    /**

    *  需要修改的字符颜色数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
    *  例：NSArray *colorsOfRanges = @[@{color:@[@"0",@"1"]},@{color:@[@"1",@"2"]}]
    *  或：NSArray *colorsOfRanges = @[@{color:str},@{color:str}]
    */
    func wy_colorsOfRanges(colorsOfRanges: Array<Dictionary<NSObject, Any>>) {
        
        for dic: Dictionary in colorsOfRanges {
            
            let color: UIColor = dic.keys.first as! UIColor
            let rangeValue = dic.values.first
            if rangeValue is String || rangeValue is NSString {
                
                let rangeStr: String = rangeValue as! String
                let selfStr = self.string as NSString
                
                self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: selfStr.range(of: rangeStr))
                
            }else {
                
                let rangeAry: Array = rangeValue as! Array<Any>
                let firstRangeStr: String = rangeAry.first as! String
                let lastRangeStr: String = rangeAry.last as! String
                self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(Int(firstRangeStr) ?? 0, Int(lastRangeStr) ?? 0))
            }
        }
    }
    
    /**

    *  需要修改的字符字体数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
    *  例：NSArray *fontsOfRanges = @[@{font:@[@"0",@"1"]},@{font:@[@"1",@"2"]}]
    *  或：NSArray *fontsOfRanges = @[@{font:str},@{font:str}]
    */
    func wy_fontsOfRanges(fontsOfRanges: Array<Dictionary<NSObject, Any>>) {
        for dic: Dictionary in fontsOfRanges {
            
            let font: UIFont = dic.keys.first as! UIFont
            let rangeValue = dic.values.first
            if rangeValue is String || rangeValue is NSString {
                
                let rangeStr: String = rangeValue as! String
                let selfStr = self.string as NSString
                
                self.addAttribute(NSAttributedString.Key.font, value: font, range: selfStr.range(of: rangeStr))
                
            }else {
                
                let rangeAry = rangeValue as! Array<Any>
                let firstRangeStr: String = rangeAry.first as! String
                let lastRangeStr: String = rangeAry.last as! String
                self.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(Int(firstRangeStr) ?? 0, Int(lastRangeStr) ?? 0))
            }
        }
    }
    
    /// 设置行间距
    func wy_lineSpacing(lineSpacing: CGFloat, string: String, alignment: NSTextAlignment = .left) {
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let selfStr: NSString = self.string as NSString
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: selfStr.range(of: string))
    }
    
    /// 文本添加下划线
    func wy_underline(color: UIColor) {
         
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: self.string.count))
    }
}
