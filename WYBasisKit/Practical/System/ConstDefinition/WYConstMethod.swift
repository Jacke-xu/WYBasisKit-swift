//
//  WYConstMethod.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/12/9.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

/// 获取当前正在显示的控制器
public func wy_currentController(windowController: UIViewController? = (UIApplication.shared.delegate?.window)??.rootViewController) -> UIViewController? {
    
    if let navigationController = windowController as? UINavigationController {
        
        return wy_currentController(windowController: navigationController.visibleViewController)
        
    }else if let tabBarController = windowController as? UITabBarController {
        
        return wy_currentController(windowController: tabBarController.selectedViewController)
        
    }else if let presentedController = windowController?.presentedViewController {
        
        return wy_currentController(windowController: presentedController)
        
    }else {
        
        return windowController
    }
}

/// 角度转弧度
public func wy_degreesToRadian(degrees: CGFloat) -> CGFloat {
    return NSObject.wy_maintainAccuracy(value: (CGFloat.pi * (degrees) / 180.0))
}

/// 弧度转角度
public func wy_radianToDegrees(radian: CGFloat) -> CGFloat {
    return NSObject.wy_maintainAccuracy(value: (radian*180.0)/(CGFloat.pi))
}

/**
 *  获取自定义控件所需要的换行数
 *
 *  @param total     总共有多少个自定义控件
 *
 *  @param perLine   每行显示多少个控件
 *
 */
public func wy_numberOfLines(total: NSInteger, perLine: NSInteger) -> NSInteger {
    if CGFloat(total).truncatingRemainder(dividingBy: CGFloat(perLine)) == 0 {
        return total / perLine
    }else {
        return (total / perLine) + 1
    }
}

/**
 *  获取一个随机整数
 *
 *  @param minimux   最小可以是多少
 *
 *  @param maximum   最大可以是多少
 *
 */
public func wy_randomInteger(minimux: NSInteger = 1, maximum: NSInteger = 99999) -> NSInteger {
    
    guard minimux < maximum else {
        return maximum
    }
    return minimux + (NSInteger(arc4random()) % (maximum - minimux))
}

/**
 *  获取一个随机浮点数
 *
 *  @param minimux   最小可以是多少
 *
 *  @param maximum   最大可以是多少
 *
 *  @param precision 精度，即保留几位小数
 *
 */
public func wy_randomFloat(minimux: CGFloat = 0.01, maximum: CGFloat = 99999.99, precision: NSInteger = 2) -> CGFloat {
    
    guard minimux < maximum else {
        return maximum
    }
    return CGFloat(Double(String(format:"%.\(precision)f",CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(minimux - maximum) + min(minimux, maximum))) ?? 0)
}

/**
 *  获取一个随机字符串
 *
 *  @param min   最少需要多少个字符
 *
 *  @param max   最多需要多少个字符
 *
 */
public func wy_randomString(minimux: NSInteger = 1, maximum: NSInteger = 100) -> String {
    
    let contentString: String = "关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。参差荇菜，左右采之。窈窕淑女，琴瑟友之。参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。"
    
    guard maximum < contentString.count else {
        return contentString
    }
    
    guard minimux <= maximum else {
        return contentString
    }
    
    let startIndex = contentString.index(contentString.startIndex, offsetBy: 0)
    let endIndex = contentString.index(contentString.startIndex, offsetBy: wy_randomInteger(minimux: minimux, maximum: maximum) - (minimux > 0 ? 1 : 0))
    
    return String(contentString[startIndex...endIndex])
}

/// 获取对象或者类的所有属性和对应的类型
public func wy_objectPropertys(object: AnyObject? = nil, className: String = "") -> [String: Any] {
    
    var propertys: [String: Any] = [:]
    
    if (object != nil) {

        Mirror(reflecting: object!).children.forEach { (child) in
            propertys[child.label ?? "未知"] = type(of: child.value)
        }
    }
    
    guard let objClass = NSClassFromString(className) else {
        return propertys
    }
    
    var count: UInt32 = 0
    let ivars = class_copyIvarList(objClass, &count)
    for i in 0..<count {
        let ivar = ivars?[Int(i)]
        let ivarName = NSString(cString: ivar_getName(ivar!)!, encoding: String.Encoding.utf8.rawValue)
        let ivarType = NSString(cString: ivar_getTypeEncoding(ivar!)!, encoding: String.Encoding.utf8.rawValue)
        
        propertys[((ivarName ?? "") as String)] = (ivarType as String?) ?? "未知"
    }
    
    return propertys
}
