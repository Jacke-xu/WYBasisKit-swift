//
//  UIDevice.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

/**
 * 可编译通过的小数点写法 ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗
 * 参考文库 http://www.xueui.cn/design/142395.html
 */

/**
 * 设备型号identifier
 * 参考文库 https://www.theiphonewiki.com/wiki/Models
*/


import UIKit

public extension UIDevice {
    
    /// 判断设备型号
    class var wy_deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone Xs"
        case "iPhone11,4", "iPhone11,6":                return "iPhone Xs Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iphone12.1":                              return "iPhone 11"
        case "iphone12.3":                              return "iPhone 11 Pro"
        case "iphone12.5":                              return "iPhone 11 Pro Max"
        case "iPhone13.1":                              return "iPhone 12 mini"
        case "iPhone13.2":                              return "iPhone 12"
        case "iPhone13.3":                              return "iPhone 12 Pro"
        case "iPhone13.4":                              return "iPhone 12 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3", "AppleTV6,2":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    /// 是否是iPhone
    class var wy_iPhoneSeries: Bool {
        return current.userInterfaceIdiom == .phone
    }
    
    /// 是否是iPad
    class var wy_iPadSeries: Bool {
        return current.userInterfaceIdiom == .pad
    }
    
    /// 是否是模拟器
    class var wy_simulatorSeries: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// 是否该使用3x图片
    class var wy_useAssetRatio3x: Bool {
        return UIScreen.main.currentMode!.size.width/UIScreen.main.bounds.size.width == 3 ? true : false
    }
    
    /// 通过状态栏高度判定是否是齐刘海手机
    class var wy_isNeatBang: Bool {
        
        return UIApplication.shared.statusBarFrame.height != 20.0
    }
    
    /// 是否是传入的分辨率
    class func wy_resolutionRatio(horizontal: CGFloat, vertical: CGFloat) -> Bool {
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: horizontal, height: vertical).equalTo((UIScreen.main.currentMode?.size)!) && !wy_iPadSeries : false)
    }
    
    /// 是否是竖屏模式
    class var wy_verticalScreen: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown {
            return true
        } else {
            return false
        }
    }
    
    /// 是否是横屏模式
    class var wy_horizontalScreen: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
            return true
        } else {
            return false
        }
    }
    
    /// uuid 注意其实uuid并不是唯一不变的
    class var wy_uuid: String! {
        return current.identifierForVendor!.uuidString
    }
    
    /// 系统名称
    class var wy_systemName: String {
        return current.systemName
    }
    
    /// 设备名称
    class var wy_deviceName: String {
        return current.name
    }
    
    /// 设备版本号
    class var wy_deviceVersion: String {
        return current.systemVersion
    }
}
