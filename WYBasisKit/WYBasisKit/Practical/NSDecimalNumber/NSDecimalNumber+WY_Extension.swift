//
//  NSDecimalNumber+WY_Extension.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/4/27.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

/// 返回保持精度后的float值
public func floatWithDecimalNumber(number : CGFloat) -> CGFloat {

    return CGFloat(decimalNumber(number: Double(number)).floatValue);
}

/// 返回保持精度后的Double值
public func doubleWithDecimalNumber(number : CGFloat) -> Double {
    
    return decimalNumber(number: Double(number)).doubleValue;
}

/// 返回保持精度后的NSString值
public func stringWithDecimalNumber(number : CGFloat) -> String {
    
    return decimalNumber(number: Double(number)).stringValue;
}

func decimalNumber(number : Double) -> NSDecimalNumber {
    
    return NSDecimalNumber.init(decimal: Decimal(number));
}
