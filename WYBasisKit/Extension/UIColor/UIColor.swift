//
//  UIColor.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

public extension UIColor {
    
    /// RGB(A) convert UIColor
    class func wy_rgb(red: CGFloat, green: CGFloat, blue: CGFloat, aplha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: aplha)
    }

    /// hexColor convert UIColor
    class func wy_hexColor(hexColor: String, alpha: CGFloat = 1.0) -> UIColor {
        var colorStr = hexColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if colorStr.length < 6 {
            return UIColor.clear
        }
        if colorStr.hasPrefix("0X") || colorStr.hasPrefix("0x") {
            colorStr = colorStr.substring(from: 2) as NSString
        }
        if colorStr.hasPrefix("#") {
            colorStr = colorStr.substring(from: 1) as NSString
        }
        if colorStr.length != 6 {
            return UIColor.clear
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        // red
        let redStr = colorStr.substring(with: range)
        // green
        range.location = 2
        let greenStr = colorStr.substring(with: range)
        // blue
        range.location = 4
        let blueStr = colorStr.substring(with: range)
        var R: UInt32 = 0x0
        var G: UInt32 = 0x0
        var B: UInt32 = 0x0
        Scanner.init(string: redStr).scanHexInt32(&R)
        Scanner.init(string: greenStr).scanHexInt32(&G)
        Scanner.init(string: blueStr).scanHexInt32(&B)
        return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha: CGFloat(alpha))
    }
    
    /// hexColor convert UIColor
    class func wy_hexColor(hexColor: UInt, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor(
            
            red: CGFloat((hexColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexColor & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexColor & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    /// randomColor
    class var wy_randomColor: UIColor {
        return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
    }
}
