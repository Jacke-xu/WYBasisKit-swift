//
//  UIFont.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//  自定义字体网址：http://iosfonts.com

import UIKit

public extension UIFont {
    
    /// 根据屏幕比率自动调整字号大小
    var wy_adjust : UIFont {
        return UIFont.init(name: self.fontName, size: wy_fontSize(self.pointSize))!
    }
    
    /// 根据屏幕比率自动调整字号大小
    class func wy_systemFont(ofSize fontSize: CGFloat) -> UIFont {
        return .systemFont(ofSize: wy_fontSize(fontSize))
    }
    
    /// 根据屏幕比率自动调整字号大小
    class func wy_boldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: wy_fontSize(fontSize))
    }
    
    /// 根据屏幕比率自动调整字号大小
    class func wy_italicSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return .italicSystemFont(ofSize: wy_fontSize(fontSize))
    }
}
