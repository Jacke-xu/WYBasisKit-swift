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

/// 获取自定义控件所需要的换行数
public func wy_numberOfLines(total: NSInteger, perLine: NSInteger) -> NSInteger {
    if CGFloat(total).truncatingRemainder(dividingBy: CGFloat(perLine)) == 0 {
        return total / perLine
    }else {
        return (total / perLine) + 1
    }
}
