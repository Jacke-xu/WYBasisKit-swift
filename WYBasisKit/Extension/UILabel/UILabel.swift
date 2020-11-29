//
//  UILabel.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /** 获取UILable的行高(根据UILable的字号获取的) */
    func wy_lineHeight() -> CGFloat {
        
        return self.font.lineHeight
    }
}
