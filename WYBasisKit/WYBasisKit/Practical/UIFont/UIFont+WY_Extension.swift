//
//  UIFont+WY_Extension.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/3/17.
//  Copyright © 2019 jacke-xu. All rights reserved.
//
//自定义字体网址：http://iosfonts.com

import Foundation
import UIKit


extension UIFont {
    
    /// 根据屏幕比率自定调整字号大小
    var wy_adjustFont : UIFont {
        
        return UIFont.init(name: self.fontName, size: self.pointSize*wy_screenWidthRatio)!
    }
}
