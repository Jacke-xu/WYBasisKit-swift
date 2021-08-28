//
//  WYConstDefinition.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation

/// NavBar高度 self.navigationController.navigationBar.frame.size.height
public let wy_navBarHeight: CGFloat = 44.0

/// 电池条高度
public let wy_statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高度
public let wy_navViewHeight: CGFloat = (wy_statusBarHeight+wy_navBarHeight)

/// tabBar高度
public let wy_tabBarHeight: CGFloat = ((UIApplication.shared.statusBarFrame.height != 20.0) ? (49.0+34.0) : 49.0)

/// tabBar安全区域
public let wy_tabbarSafetyZone: CGFloat = ((UIApplication.shared.statusBarFrame.height != 20.0) ? 34.0 : 0.0)

/// 导航栏安全区域
public let wy_navBarSafetyZone: CGFloat = ((UIApplication.shared.statusBarFrame.height != 20.0) ? 44.0 : 0.0)

/// 屏幕宽
public let wy_screenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高
public let wy_screenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 屏幕宽度比率
public let wy_screenWidthRatio: CGFloat = (wy_screenWidth / WYBasisKitConfig.screenWidthRatioBase)

/// 屏幕高度比率
public let wy_screenHeightRatio: CGFloat = (wy_screenHeight / WYBasisKitConfig.screenHeightRatioBase)

/// 屏幕宽度比率转换
public func wy_screenWidth(_ ratioValue: CGFloat) -> CGFloat {
    return round(ratioValue*wy_screenWidthRatio)
}

/// 屏幕高度比率转换
public func wy_screenHeight(_ ratioValue: CGFloat) -> CGFloat {
    return round(ratioValue*wy_screenHeightRatio)
}

/// 字号比率转换
public func wy_fontSize(_ ratioValue: CGFloat) -> CGFloat {
    return ratioValue * ((wy_screenWidthRatio > WYBasisKitConfig.maxFontRatio) ? WYBasisKitConfig.maxFontRatio : wy_screenWidthRatio)
}

/// DEBUG打印日志
public func wy_print(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let message = messages.compactMap { "\($0)" }.joined(separator: " ")
    print("\n【\((file as NSString).lastPathComponent) ——> \(function) ——> line:\(line)】\n\n \(message)\n\n\n")
    #endif
}

/// 获取app包路径
public let wy_bundlePath: String = Bundle.main.bundlePath

/// 获取app资源目录路径
public let wy_appResourcePath: String = Bundle.main.resourcePath!

/// 获取app包的readme.txt文件
public let wy_readmePath: String = Bundle.main.path(forResource: "readme", ofType: "txt")!

/// 项目名字
public let wy_projectName: String = Bundle.main.infoDictionary!["CFBundleName"] as! String

public let wy_appStoreName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String

/// 应用标识
public let wy_appIdentifier: String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String

/// 应用商店版本号
public let wy_appStoreVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

/// 应用构建版本号
public let wy_appBuildVersion: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

/// 获取当前语言
public let wy_currentLanguage: String = NSLocale.preferredLanguages.first!
