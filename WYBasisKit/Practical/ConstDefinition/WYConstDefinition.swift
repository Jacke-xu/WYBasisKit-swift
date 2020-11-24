//
//  WYConstDefinition.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation

/// NavBar高度 self.navigationController.navigationBar.frame.size.height
let wy_navBarHeight: CGFloat = 44.0

/// 电池条高度
let wy_statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高度
let wy_navViewHeight: CGFloat = (wy_statusBarHeight+wy_navBarHeight)

/// tabBar高度
let wy_tabBarHeight: CGFloat = ((UIDevice.wy_isNeatBang == true) ? (49.0+34.0) : 49.0)

/// tabBar安全区域
let wy_tabbarSafetyZone: CGFloat = ((UIDevice.wy_isNeatBang == true) ? 34.0 : 0.0)

/// 导航栏安全区域
let wy_navBarSafetyZone: CGFloat = ((UIDevice.wy_isNeatBang == true) ? 44.0 : 0.0)

/// 屏幕宽
let wy_screenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高
let wy_screenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 屏幕宽度比率
let wy_screenWidthRatio: CGFloat = (wy_screenWidth / 375.0)

/// 屏幕高度比率
let wy_screenHeightRatio: CGFloat = (wy_screenHeight / 812.0)

/// 屏幕宽度比率转换
public func wy_screenWidthRatioValue(value: CGFloat) -> CGFloat {
    return (value*wy_screenWidthRatio)
}

/// 屏幕高度比率转换
public func wy_screenHeightRatioValue(value: CGFloat) -> CGFloat {
    return (value*wy_screenHeightRatio)
}

/// 获取当前正在显示的控制器
public func wy_showController(controller: UIViewController = UIApplication.shared.keyWindow!.rootViewController!) -> UIViewController? {
    
    if controller is UITabBarController {
        
        let tabBarController = controller as! UITabBarController
        
        return wy_showController(controller: tabBarController.selectedViewController!)
    }
    
    if controller is UINavigationController {
        
        let navController = controller as! UINavigationController
        
        return wy_showController(controller: navController.viewControllers.last!)
    }
    
    return controller
}

/// DEBUG打印日志
public func wy_print(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let message = messages.compactMap { "\($0)" }.joined(separator: " ")
    print("\n【\((file as NSString).lastPathComponent) ——> \(function) ——> line:\(line)】\n\n \(message)\n\n\n")
    #endif
}

/// 角度转弧度
public func wy_degreesToRadian(degrees: CGFloat) -> CGFloat {
    return NSObject.wy_maintainAccuracy(value: (CGFloat.pi * (degrees) / 180.0))
}

/// 弧度转角度
public func wy_radianToDegrees(radian: CGFloat) -> CGFloat {
    return NSObject.wy_maintainAccuracy(value: (radian*180.0)/(CGFloat.pi))
}

/// 获取app包路径
let wy_bundlePath: String = Bundle.main.bundlePath

/// 获取app资源目录路径
let wy_appResourcePath: String = Bundle.main.resourcePath!

/// 获取app包的readme.txt文件
let wy_readmePath: String = Bundle.main.path(forResource: "readme", ofType: "txt")!

/// 项目名字
let wy_projectName: String = Bundle.main.infoDictionary!["CFBundleName"] as! String

let wy_appStoreName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String

/// 应用标识
let wy_appIdentifier: String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String

/// 应用商店版本号
let wy_appStoreVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

/// 应用构建版本号
let wy_appBuildVersion: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

/// 获取当前语言
let wy_currentLanguage: String = NSLocale.preferredLanguages.first!
