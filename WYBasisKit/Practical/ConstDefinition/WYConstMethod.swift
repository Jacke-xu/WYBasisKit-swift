//
//  WYConstMethod.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/12/9.
//  Copyright © 2020 jacke·xu. All rights reserved.
//

import UIKit

/// 获取当前正在显示的控制器
public func wy_currentController(controller: UIViewController = UIApplication.shared.keyWindow!.rootViewController!) -> UIViewController? {
    
    if controller is UITabBarController {
        
        let tabBarController = controller as! UITabBarController
        
        return wy_currentController(controller: tabBarController.selectedViewController!)
    }
    
    if controller is UINavigationController {
        
        let navController = controller as! UINavigationController
        
        return wy_currentController(controller: navController.viewControllers.last!)
    }
    
    return controller
}

/// 角度转弧度
public func wy_degreesToRadian(degrees: CGFloat) -> CGFloat {
    return NSObject.wy_maintainAccuracy(value: (CGFloat.pi * (degrees) / 180.0))
}

/// 弧度转角度
public func wy_radianToDegrees(radian: CGFloat) -> CGFloat {
    return NSObject.wy_maintainAccuracy(value: (radian*180.0)/(CGFloat.pi))
}
