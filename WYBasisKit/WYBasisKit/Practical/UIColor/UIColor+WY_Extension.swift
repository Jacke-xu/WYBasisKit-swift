//
//  UIColor+WY_Extension.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/3/14.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import UIKit


/// RGB convert UIColor
func WY_RGB(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor {
    
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0);
}

/// RGB convert UIColor
func WY_RGB(red : CGFloat, green : CGFloat, blue : CGFloat, aplha : CGFloat) -> UIColor {
    
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: aplha);
}

/// hexColor convert UIColor
func wy_hexColor(hexColor : String) -> UIColor {
    
    var colorStr = hexColor.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
    
    if(colorStr.length < 6) {

        return UIColor.clear;
    }
    
    if(colorStr.hasPrefix("0X") || colorStr.hasPrefix("0x")) {
        
        colorStr = colorStr.substring(from: 2) as NSString;
    }
    
    if(colorStr.hasPrefix("#")) {
        
        colorStr = colorStr.substring(from: 1) as NSString;
    }
    
    if(colorStr.length != 6) {
        
        return UIColor.clear;
    }
    
    var range = NSRange.init()
    
    range.location = 0;
    
    range.length = 2;
    
    // red
    let redStr = colorStr.substring(with: range);
    
    // green
    range.location = 2;
    
    let greenStr = colorStr.substring(with: range);
    
    // blue
    range.location = 4;
    
    let blueStr = colorStr.substring(with: range);
    
    var R : UInt32 = 0x0;
    
    var G : UInt32 = 0x0;
    
    var B : UInt32 = 0x0;
    
    Scanner.init(string: redStr).scanHexInt32(&R);
    
    Scanner.init(string: greenStr).scanHexInt32(&G);
    
    Scanner.init(string: blueStr).scanHexInt32(&B);
    
    return UIColor(red:CGFloat(R)/255.0, green:CGFloat(G)/255.0, blue:CGFloat(B)/255.0, alpha:CGFloat(1.0));
}

/// hexColor convert UIColor
func wy_hexColor(hexColor : String, alpha : CGFloat) -> UIColor {
    
    var colorStr = hexColor.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
    
    if(colorStr.length < 6) {
        
        return UIColor.clear;
    }
    
    if(colorStr.hasPrefix("0X") || colorStr.hasPrefix("0x")) {
        
        colorStr = colorStr.substring(from: 2) as NSString;
    }
    
    if(colorStr.hasPrefix("#")) {
        
        colorStr = colorStr.substring(from: 1) as NSString;
    }
    
    if(colorStr.length != 6) {
        
        return UIColor.clear;
    }
    
    var range = NSRange.init()
    
    range.location = 0;
    
    range.length = 2;
    
    // red
    let redStr = colorStr.substring(with: range);
    
    // green
    range.location = 2;
    
    let greenStr = colorStr.substring(with: range);
    
    // blue
    range.location = 4;
    
    let blueStr = colorStr.substring(with: range);
    
    var R : UInt32 = 0x0;
    
    var G : UInt32 = 0x0;
    
    var B : UInt32 = 0x0;
    
    Scanner.init(string: redStr).scanHexInt32(&R);
    
    Scanner.init(string: greenStr).scanHexInt32(&G);
    
    Scanner.init(string: blueStr).scanHexInt32(&B);
    
    return UIColor(red:CGFloat(R)/255.0, green:CGFloat(G)/255.0, blue:CGFloat(B)/255.0, alpha:CGFloat(alpha));
}

/// randomColor
var wy_randomColor : UIColor {
    
    return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0);
}
