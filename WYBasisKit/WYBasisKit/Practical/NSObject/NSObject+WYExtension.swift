//
//  NSObject+WYExtension.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

extension String {
    
    /// CGFloat Convert String
    init(float: CGFloat) {

        self = String(Float(float))
    }
}

extension NSString {
    
    /// String Convert NSString
    class func wy_init(string: String) -> NSString {
        
        return string as NSString
    }
    
    /// Int Convert NSString
    class func wy_init(int: Int) -> NSString {
        
        return String(int) as NSString
    }

    /// NSInteger Convert NSString
    class func wy_init(integer: NSInteger) -> NSString {
        
        return String(integer) as NSString
    }
    
    /// Double Convert NSString
    class func wy_init(double: Double) -> NSString {
        
        return String(double) as NSString
    }

    /// Float Convert NSString
    class func wy_init(float: Float) -> NSString {
        
        return String(float) as NSString
    }

    /// CGFloat Convert NSString
    class func wy_init(float: CGFloat) -> NSString {
        
        return String(float: float) as NSString
    }
}

extension Double {
    
    /// NSString Convert Double
    init(string: NSString) {

        self = NumberFormatter().number(from: string as String)?.doubleValue ?? 0.0
    }
}

extension Float {
    
    /// NSString Convert Float
    init(string: NSString) {

        self = Float(string as String) ?? 0.0
    }
}

extension CGFloat {

    /// String Convert CGFloat
    init(string: String) {

        self = CGFloat(Float(string) ?? 0.0)
    }

    /// NSString Convert CGFloat
    init(string: NSString) {

        self = CGFloat(Float(string: string))
    }
}

extension Int {
    
    /// NSString Convert Int
    init(string: NSString) {

        self = Int(string as String) ?? 0
    }
}

extension NSInteger {
    
    /// NSString Convert NSInteger
    init(stringValue: NSString) {

        self = NSInteger(stringValue as String) ?? 0
    }
}
