//
//  NSDecimalNumber+WYExtension.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

/// 返回保持精度后的float值
public func wy_floatWithDecimalNumber(number: CGFloat) -> CGFloat {
    return CGFloat(wy_decimalNumber(number: Double(number)).floatValue)
}

/// 返回保持精度后的Double值
public func wy_doubleWithDecimalNumber(number: CGFloat) -> Double {
    return wy_decimalNumber(number: Double(number)).doubleValue
}

/// 返回保持精度后的String值
public func wy_stringWithDecimalNumber(number: CGFloat) -> String {
    return wy_decimalNumber(number: Double(number)).stringValue
}

private func wy_decimalNumber(number: Double) -> NSDecimalNumber {
    return NSDecimalNumber.init(decimal: Decimal(number))
}
