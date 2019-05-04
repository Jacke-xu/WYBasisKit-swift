//
//  DataConvert+WY_Extension.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/5/4.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import UIKit

extension String {
    
    var wy_floatValue : CGFloat {
        
        return CGFloat(Double(self)!);
    }
    
    var wy_doubleValue : Double {
        
        return Double(self)!;
    }
    
    var wy_integerValue : NSInteger {
        
        return NSInteger(self)!;
    }
}

extension CGFloat {
    
    var wy_stringValue : String {
        
        return String(Double(self));
    }
    
    var wy_doubleValue : Double {
        
        return Double(self);
    }
    
    var wy_integerValue : NSInteger {
        
        return NSInteger(self);
    }
}

extension Double {
    
    var wy_stringValue : String {
        
        return String(self);
    }
    
    var wy_floatValue : CGFloat {
        
        return CGFloat(self);
    }
    
    var wy_integerValue : NSInteger {
        
        return NSInteger(self);
    }
}

extension NSInteger {
    
    var wy_stringValue : String {
        
        return String(self);
    }
    
    var wy_floatValue : CGFloat {
        
        return CGFloat(self);
    }
    
    var wy_doubleValue : Double {
        
        return Double(self);
    }
}
