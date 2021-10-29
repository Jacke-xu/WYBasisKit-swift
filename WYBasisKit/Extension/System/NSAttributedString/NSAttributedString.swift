//
//  NSAttributedString.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    
    /**

    *  需要修改的字符颜色数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
    *  例：NSArray *colorsOfRanges = @[@{color:@[@"0",@"1"]},@{color:@[@"1",@"2"]}]
    *  或：NSArray *colorsOfRanges = @[@{color:str},@{color:str}]
    */
    @discardableResult
    func wy_colorsOfRanges(colorsOfRanges: Array<Dictionary<UIColor, Any>>) -> NSMutableAttributedString {
        
        for dic: Dictionary in colorsOfRanges {
            
            let color: UIColor = dic.keys.first!
            let rangeValue = dic.values.first
            if rangeValue is String || rangeValue is NSString {
                
                let rangeStr: String = rangeValue as! String
                let selfStr = self.string as NSString
                
                addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: selfStr.range(of: rangeStr))
                
            }else {
                
                let rangeAry: Array = rangeValue as! Array<Any>
                let firstRangeStr: String = rangeAry.first as! String
                let lastRangeStr: String = rangeAry.last as! String
                addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(Int(firstRangeStr) ?? 0, Int(lastRangeStr) ?? 0))
            }
        }
        
        return self
    }
    
    /**

    *  需要修改的字符字体数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
    *  例：NSArray *fontsOfRanges = @[@{font:@[@"0",@"1"]},@{font:@[@"1",@"2"]}]
    *  或：NSArray *fontsOfRanges = @[@{font:str},@{font:str}]
    */
    @discardableResult
    func wy_fontsOfRanges(fontsOfRanges: Array<Dictionary<UIFont, Any>>) -> NSMutableAttributedString {
        for dic: Dictionary in fontsOfRanges {
            
            let font: UIFont = dic.keys.first!
            let rangeValue = dic.values.first
            if rangeValue is String || rangeValue is NSString {
                
                let rangeStr: String = rangeValue as! String
                let selfStr = self.string as NSString
                
                addAttribute(NSAttributedString.Key.font, value: font, range: selfStr.range(of: rangeStr))
                
            }else {
                
                let rangeAry = rangeValue as! Array<Any>
                let firstRangeStr: String = rangeAry.first as! String
                let lastRangeStr: String = rangeAry.last as! String
                addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(Int(firstRangeStr) ?? 0, Int(lastRangeStr) ?? 0))
            }
        }
        return self
    }
    
    /// 设置行间距
    @discardableResult
    func wy_lineSpacing(lineSpacing: CGFloat, string: String? = nil, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let selfStr: NSString = self.string as NSString
        addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: selfStr.range(of: (string == nil ? self.string : string!)))
        
        return self
    }
    
    /// 设置字间距
    @discardableResult
    func wy_wordsSpacing(wordsSpacing: CGFloat, string: String? = nil) -> NSMutableAttributedString {
        
        let selfStr: NSString = self.string as NSString
        addAttributes([NSAttributedString.Key.kern: NSNumber(value: Double(wordsSpacing))], range: selfStr.range(of: string == nil ? self.string : string!))
        
        return self
    }
    
    /// 文本添加下滑线
    @discardableResult
    func wy_underline(color: UIColor, string: String? = nil) -> NSMutableAttributedString {
         
        let selfStr: NSString = self.string as NSString
        addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: selfStr.range(of: string == nil ? self.string : string!))
        addAttribute(NSAttributedString.Key.underlineColor, value: color, range: selfStr.range(of: string == nil ? self.string : string!))
        
        return self
    }
    
    /// 文本添加删除线
    @discardableResult
    func wy_strikethrough(color: UIColor, string: String? = nil) -> NSMutableAttributedString {
         
        let selfStr: NSString = self.string as NSString
        addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: selfStr.range(of: string == nil ? self.string : string!))
        addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: selfStr.range(of: string == nil ? self.string : string!))
        
        return self
    }
    
    /**
    *  文本添加内边距
    *  @param firstLineHeadIndent  首行左边距
    *  @param headIndent  第二行及以后的左边距(换行符\n除外)
    *  @param tailIndent  尾部右边距
    */
    @discardableResult
    func wy_innerMargin(firstLineHeadIndent: CGFloat = 0, headIndent: CGFloat = 0, tailIndent: CGFloat = 0, alignment: NSTextAlignment = .justified) -> NSMutableAttributedString {
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        
        let selfStr: NSString = self.string as NSString
        addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: selfStr.range(of: self.string))
        
        return self
    }
}

extension NSAttributedString {
    
    /// 计算富文本宽度
    func wy_calculateWidth(controlHeight: CGFloat) -> CGFloat {
        
        return wy_calculateSize(controlSize: CGSize(width: .greatestFiniteMagnitude, height: controlHeight)).width
    }
    
    /// 计算富文本高度
    func wy_calculateHeight(controlWidth: CGFloat) -> CGFloat {
        
        return wy_calculateSize(controlSize: CGSize(width: controlWidth, height: .greatestFiniteMagnitude)).height
    }
    
    /// 计算富文本宽高
    func wy_calculateSize(controlSize: CGSize) -> CGSize {
        
        let attributedSize = boundingRect(with: controlSize, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return CGSize(width: ceil(attributedSize.width), height: ceil(attributedSize.height))
    }
}
