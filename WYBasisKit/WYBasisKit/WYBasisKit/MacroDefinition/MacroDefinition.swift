//
//  MacroDefinition.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/3/14.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

import Foundation
import UIKit

///NavBar高度 self.navigationController.navigationBar.frame.size.height
let navBarHeight : CGFloat = 44.0

///电池条高度
let statusBarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height

///导航栏高度
let navViewHeight : CGFloat = (statusBarHeight+navBarHeight)

///tabBar高度
//let tabBarHeight : CGFloat = ((isNeatBang == true) ? (49.0+34.0) : 49.0)
//
/////tabBar安全区域
//let tabbarSafetyZone : CGFloat = ((isNeatBang == true) ? 34.0 : 0.0)
//
/////导航栏安全区域
//let navBarSafetyZone : CGFloat = ((isNeatBang == true) ? 44.0 : 0.0)

///屏幕宽
let screenWidth : CGFloat = UIScreen.main.bounds.size.width

///屏幕高
let screenHeight : CGFloat = UIScreen.main.bounds.size.height

///屏幕宽度比率
let screenWidthRatio : CGFloat = (screenWidth / 375.0)

///屏幕高度比率
let screenHeightRatio : CGFloat = (screenHeight / 667.0)

//颜色方法简写
///颜色随机
let randomColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)

/// 获取RGBA颜色
func RGBA(R : CGFloat ,G : CGFloat ,B : CGFloat ,A: CGFloat) -> UIColor {
    
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A);
}

/// 获取RGB颜色
func RGB(R : CGFloat ,G : CGFloat ,B : CGFloat) -> UIColor {
    
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0);
}

///字体方法简写  自定义字体网址：http://iosfonts.com
func pxFont(fontSize : Int) -> UIFont {
    
    return UIFont.systemFont(ofSize: CGFloat(fontSize/2));
}

////G－C－D
/////在子线程上运行的GCD
//let GCD_SubThread(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
//
/////在主线程上运行的GCD
//let GCD_MainThread(block) dispatch_async(dispatch_get_main_queue(),block)
//
/////只运行一次的GCD
//let GCD_OnceThread(block) static dispatch_once_t onceToken; dispatch_once(&onceToken, block);
//
/////DEBUG打印日志
//
/////由角度、弧度值转换
//let degreesToRadian(x) (M_PI * (x) / 180.0)        //角度获取弧度
//let radianToDegrees(radian) (radian*180.0)/(M_PI)  //弧度获取角度
//
/////获取app包路径
//let bundlePath     [[NSBundle mainBundle] bundlePath];
//
/////获取app资源目录路径
//let appResourcePath         [[NSBundle mainBundle] resourcePath];
//
/////获取app包的readme.txt文件
//let readmePath         [[NSBundle mainBundle] pathForResource:@"readme" ofType:@"txt"];
//
/////app名字
//let AppName          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
//
//let appStoreName     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
//
/////应用标识
//let AppIdentifier    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//
/////应用商店版本号
//let AppStoreVersion   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//
/////应用构建版本号
//let AppVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//
//
/////获取当前语言
//let currentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//
/////判断是否是传入的iOS系统版本
//let iOSVersion(number)                [[[UIDevice currentDevice] systemVersion] floatValue] == number
//
/////判断是否是传入的iOS系统版本及以上
//let iOSVersionAbove(number)                [[[UIDevice currentDevice] systemVersion] floatValue] >= number
//
/////判断是否是传入的iOS系统版本及以下
//let iOSVersionBelow(number)                [[[UIDevice currentDevice] systemVersion] floatValue] <= number
//
/////判断是否在传入的iOS系统版本之间
//let iOSVersionAmong(smallVersion,bigVersion)                (([[[UIDevice currentDevice] systemVersion] floatValue] >= smallVersion) && ([[[UIDevice currentDevice] systemVersion] floatValue] <= bigVersion))
//
//
/////判断是竖屏还是横屏
//let UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)//竖屏
//
//let UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)//横屏
//
/////判断是否 Retina屏、设备是否iphone几、是否是iPad
//let retina      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//
//let iPhoneSE     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//
//let iPhone8     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//
//let iPhone8Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//
//let iPhoneXR    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//
//let iPhoneXS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//
//let iPhoneXSMax    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
//
/////判断当前机型是使用2x还是3x图
//let is3x      ([[UIScreen mainScreen] currentMode].size.width/[UIScreen mainScreen].bounds.size.width == 3) ? YES : NO
//
/////是否是齐刘海机型
//let isNeatBang      (iPhoneXS || iPhoneXSMax || iPhoneXR) ? YES : NO
//
/////是否是ipad
//let iPad      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//
/////是否是iphone
//let iPhone    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
