//
//  UIFont+WY_Extension.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/3/17.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {
    
    var wy_adjustFont : UIFont? {
        
        return UIFont.init(name: self.fontName, size: self.pointSize*screenWidthRatio)!;
    }
}
