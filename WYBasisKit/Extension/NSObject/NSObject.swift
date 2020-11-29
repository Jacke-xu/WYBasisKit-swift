//
//  NSObject.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public extension String {
    
    /// CGFloat Convert String
    init(float: CGFloat) {

        self = String(Float(float))
    }
}

public extension NSString {
    
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

public extension Double {
    
    /// NSString Convert Double
    init(string: NSString) {

        self = NumberFormatter().number(from: string as String)?.doubleValue ?? 0.0
    }
    
    /// String Convert Double
    init(string: String) {

        self = NumberFormatter().number(from: string)?.doubleValue ?? 0.0
    }
}

public extension Float {
    
    /// NSString Convert Float
    init(string: NSString) {

        self = Float(string as String) ?? 0.0
    }
}

public extension CGFloat {

    /// String Convert CGFloat
    init(string: String) {

        self = CGFloat(Float(string) ?? 0.0)
    }

    /// NSString Convert CGFloat
    init(string: NSString) {

        self = CGFloat(Float(string: string))
    }
}

public extension Int {
    
    /// NSString Convert Int
    init(string: NSString) {

        self = Int(string as String) ?? 0
    }
}

public extension NSInteger {
    
    /// NSString Convert NSInteger
    init(stringValue: NSString) {

        self = NSInteger(stringValue as String) ?? 0
    }
    
    /// String Convert NSInteger
    init(stringValue: String) {

        self = NSInteger(stringValue) ?? 0
    }
}

public extension NSObject {
    
    class func wy_maintainAccuracy(value: CGFloat) -> String {
        
        return wy_maintainAccuracy(value: Double(value)).stringValue
    }
    
    class func wy_maintainAccuracy(value: CGFloat) -> Double {
        
        return wy_maintainAccuracy(value: Double(value)).doubleValue
    }
    
    class func wy_maintainAccuracy(value: CGFloat) -> CGFloat {
        
        return CGFloat(wy_maintainAccuracy(value: Double(value)).floatValue)
    }
    
    class private func wy_maintainAccuracy(value: Double) -> NSDecimalNumber {
        
        return NSDecimalNumber(decimal: Decimal(value))
    }
}

