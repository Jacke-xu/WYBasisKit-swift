//
//  UIFont.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//  自定义字体网址：http://iosfonts.com

import UIKit

extension UIFont {
    
    /// 根据屏幕比率自动调整字号大小
    var wy_adjust : UIFont {
        
        return UIFont.init(name: self.fontName, size: self.pointSize*wy_screenWidthRatio)!
    }
}
