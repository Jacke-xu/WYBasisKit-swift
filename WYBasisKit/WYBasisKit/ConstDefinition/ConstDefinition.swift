//
//  ConstDefinition.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/4/9.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

/// NavBar高度 self.navigationController.navigationBar.frame.size.height
let wy_navBarHeight : CGFloat = 44.0

/// 电池条高度
let wy_statusBarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高度
let wy_navViewHeight : CGFloat = (wy_statusBarHeight+wy_navBarHeight)

/// tabBar高度
//#define wy_tabBarHeight         ((wy_isNeatBang == YES) ? (49.0f+34.0f) : 49.0f)

/// tabBar安全区域
//#define wy_tabbarSafetyZone         ((wy_isNeatBang == YES) ? 34.0f : 0.0f)

/// 导航栏安全区域
//#define wy_navBarSafetyZone         ((wy_isNeatBang == YES) ? 44.0f : 0.0f)

/// 屏幕宽
let wy_screenWidth : CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高(已减去tabbar安全区域高度)
//let wy_screenHeight : CGFloat = UIScreen.main.bounds.size.height-

/// 全屏高
let wy_fullScreenHeight : CGFloat = UIScreen.main.bounds.size.height

/// 屏幕宽度比率
let wy_screenWidthRatio : CGFloat = (wy_screenWidth / 375.0)

/// 屏幕高度比率
let wy_screenHeightRatio : CGFloat = (wy_fullScreenHeight / 667.0)

/// DEBUG打印日志
public func wy_print(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let message = messages.compactMap{ "\($0)" }.joined(separator: " ")
    print("\n【\((file as NSString).lastPathComponent) ——> \(function) ——> line:\(line)】\n\n \(message)\n\n\n")
    #endif
}

/// 角度转弧度
public func wy_degreesToRadian(degrees : CGFloat) -> CGFloat {
    
    return floatWithDecimalNumber(number: (CGFloat.pi * (degrees) / 180.0));
}

/// 弧度转角度
public func wy_radianToDegrees(radian : CGFloat) -> CGFloat {
    
    return floatWithDecimalNumber(number: (radian*180.0)/(CGFloat.pi));
}

/// 获取app包路径
let wy_bundlePath : String = Bundle.main.bundlePath

/// 获取app资源目录路径
let wy_appResourcePath : String = Bundle.main.resourcePath!

/// 获取app包的readme.txt文件
let wy_readmePath : String = Bundle.main.path(forResource: "readme", ofType: "txt")!

/// app名字
let wy_appName : String = Bundle.main.infoDictionary!["CFBundleName"] as! String

let wy_appStoreName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String

/// 应用标识
let wy_appIdentifier : String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String

/// 应用商店版本号
let wy_appStoreVersion : String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

/// 应用构建版本号
let wy_appBuildVersion : String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

/// 获取当前语言
let wy_currentLanguage : String = NSLocale.preferredLanguages.first!

/// 判断是否是传入的iOS系统版本
//#define WY_iOSVersion(number)                [[[UIDevice currentDevice] systemVersion] floatValue] == number
//
/////判断是否是传入的iOS系统版本及以上
//#define WY_iOSVersionAbove(number)                [[[UIDevice currentDevice] systemVersion] floatValue] >= number
//
/////判断是否是传入的iOS系统版本及以下
//#define WY_iOSVersionBelow(number)                [[[UIDevice currentDevice] systemVersion] floatValue] <= number
//
/////判断是否在传入的iOS系统版本之间
//#define WY_iOSVersionAmong(smallVersion,bigVersion)                (([[[UIDevice currentDevice] systemVersion] floatValue] >= smallVersion) && ([[[UIDevice currentDevice] systemVersion] floatValue] <= bigVersion))
//
//
/////判断是竖屏还是横屏
//#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)//竖屏
//
//#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)//横屏
//
////http://www.xueui.cn/design/142395.html
/////判断是设备型号
//#define wy_isIPhoneSE     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)
//
//#define wy_isIPhone8     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)
//
//#define wy_isIPhone8Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)
//
//#define wy_isIPhoneXR    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size)) && !wy_isIPad : NO)
//
//#define wy_isIPhoneXS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)
//
//#define wy_isIPhoneXSMax    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)
//
/////判断当前机型是使用2x还是3x图
//#define wy_is3x      ([[UIScreen mainScreen] currentMode].size.width/[UIScreen mainScreen].bounds.size.width == 3) ? YES : NO
//
/////是否是齐刘海机型
//#define wy_isNeatBang      (wy_isIPhoneXS || wy_isIPhoneXSMax || wy_isIPhoneXR) ? YES : NO
//
/////是否是ipad
//#define wy_isIPad      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//
/////是否是iphone
//#define wy_isIPhone    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//
//#define wy_isSimulator   (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) ? YES : NO


