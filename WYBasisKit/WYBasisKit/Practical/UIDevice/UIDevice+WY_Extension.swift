//
//  UIDevice+WY_Extension.swift
//  WYBasisKit
//
//  Created by jacke-xu on 2019/5/3.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

/**
 * 可编译通过的小数点写法 ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗
 * 参考文库 http://www.xueui.cn/design/142395.html
 */

import UIKit


extension UIDevice {
    
    /// 判断设备型号
    public class var wy_deviceModel : String {
        
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
}


extension UIDevice {
    
    /// 是否是iPhone
    public class var wy_iPhoneSeries: Bool {
        return current.userInterfaceIdiom == .phone
    }
    
    /// 是否是iPad
    public class var wy_iPadSeries: Bool {
        return current.userInterfaceIdiom == .pad
    }
    
    /// 是否是模拟器
    public class var wy_simulatorSeries : Bool {
        
        #if targetEnvironment(simulator)
        return true;
        #else
        return false;
        #endif
    }
    
    /// 是否该使用3x图片
    public class var wy_useAssetRatio3x : Bool {
        
        return UIScreen.main.currentMode!.size.width/UIScreen.main.bounds.size.width == 3 ? true : false;
    }
    
    /// 是否是4.0英寸系列iPhone  竖屏分辨率640 x 1136  竖屏点320 x 568
    public class  var wy_iPhone_⒋0inch: Bool {
        return self.wy_resolutionRatio(horizontal: 640, vertical: 1136);
    }
    
    /// 是否是4.7英寸系列iPhone  竖屏分辨率750 x 1334  竖屏点375 x 667
    public class  var wy_iPhone_⒋7inch: Bool {
        return self.wy_resolutionRatio(horizontal: 750, vertical: 1334);
    }
    
    /// 是否是5.5英寸系列iPhone  竖屏分辨率1242 x 2208  竖屏点414 x 736
    public class var wy_iPhone_⒌5inch: Bool {
        return self.wy_resolutionRatio(horizontal: 1242, vertical: 2208);
    }
    
    /// 是否是5.8英寸系列iPhone  竖屏分辨率1125 x 2436  竖屏点375 x 812
    public class var wy_iPhone_⒌8inch: Bool {
        return self.wy_resolutionRatio(horizontal: 1125, vertical: 2436);
    }
    
    /// 是否是6.1英寸系列iPhone  竖屏分辨率828 x 1792  竖屏点414 x 896
    public class var wy_iPhone_⒍1inch: Bool {
        return self.wy_resolutionRatio(horizontal: 828, vertical: 1792);
    }
    
    /// 是否是6.5英寸系列iPhone  竖屏分辨率1242 x 2688  竖屏点414 x 896
    public class var wy_iPhone_⒍5inch: Bool {
        return self.wy_resolutionRatio(horizontal: 1242, vertical: 2688);
    }
    
    /// 通过状态栏高度判定是否是齐刘海手机
    public class var wy_isNeatBang : Bool {
        return UIApplication.shared.statusBarFrame.height == 44.0;
    }
    
    /// 是否是传入的分辨率
    class func wy_resolutionRatio(horizontal : CGFloat, vertical : CGFloat) -> Bool {
        
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: horizontal, height: vertical).equalTo((UIScreen.main.currentMode?.size)!) && !wy_iPadSeries : false);
    }
}


extension UIDevice {
    
    /// 是否是竖屏模式
    public class var wy_verticalScreen : Bool {
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown {
            
            return true;
        }else {
            
            return false;
        }
    }
    
    /// 是否是横屏模式
    public class var wy_horizontalScreen : Bool {
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
            
            return true;
        }else {
            
            return false;
        }
    }
}


extension UIDevice {
    
    /// uuid 注意其实uuid并不是唯一不变的
    public class var wy_uuid: String! {
        return current.identifierForVendor!.uuidString
    }
    
    /// 系统名称
    public class var wy_systemName: String {
        return current.systemName
    }
    
    /// 设备名称
    public class var wy_deviceName: String {
        return current.name
    }
    
    /// 设备版本号
    public class var wy_deviceVersion: String {
        return current.systemVersion
    }
    
    /// 当前版本是否是传入的版本
    public class func wy_isVersion(version : CGFloat) -> Bool {
        
        let floatVersion : CGFloat = CGFloat(Double(wy_deviceVersion)!);
        
        return floatVersion == version;
    }
    
    /// 当前版本是否等于或高于传入的版本
    public class func wy_isVersionOrLater(version : CGFloat) -> Bool {
        
        let floatVersion : CGFloat = CGFloat(Double(wy_deviceVersion)!);
        
        return floatVersion >= version;
    }
    
    /// 当前版本是否等于或低于传入的版本
    public class func wy_isVersionOrEarlier(version : CGFloat) -> Bool {
        
        let floatVersion : CGFloat = CGFloat(Double(wy_deviceVersion)!);
        
        return floatVersion <= version;
    }
}
