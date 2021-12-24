//
//  AppDelegate.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 屏蔽控制台约束输出
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        return true
    }
    
    /// 切换为深色或浅色模式
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if #available(iOS 13.0, *) {
            application.wy_switchAppDisplayBrightness(style: (WYLocalizableManager.currentLanguage() == .english) ? .dark : .light)
        }
    }
    
    /// 屏幕旋转需要支持的方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIDevice.current.wy_interfaceOrientation
    }
}

extension AppDelegate {
    
    class func shared() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
}

