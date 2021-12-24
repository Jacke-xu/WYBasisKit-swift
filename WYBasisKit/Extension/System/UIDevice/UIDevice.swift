//
//  UIDevice.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

/**
 * 可编译通过的小数点写法 ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗
 * 参考文库 http://www,xueui,cn/design/142395,html
 */

/**
 * 设备型号identifier
 * 参考文库 https://www,theiphonewiki,com/wiki/Models
*/


import UIKit

public extension UIDevice {
    
    /// 设备型号
    class var wy_deviceName: String {
        return current.name
    }
    
    /// 系统名称
    class var wy_systemName: String {
        return current.systemName
    }
    
    /// 系统版本号
    class var wy_systemVersion: String {
        return current.systemVersion
    }
    
    /// 是否是iPhone系列
    class var wy_iPhoneSeries: Bool {
        return current.userInterfaceIdiom == .phone
    }
    
    /// 是否是iPad系列
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
    
    /// uuid 注意其实uuid并不是唯一不变的
    class var wy_uuid: String {
        return current.identifierForVendor!.uuidString
    }
    
    /// 是否使用3x图片
    class var wy_use3xAsset: Bool {
        return UIScreen.main.currentMode!.size.width / UIScreen.main.bounds.size.width >= 3 ? true : false
    }
    
    /// 是否是齐刘海手机
    class var wy_isBangsScreen: Bool {
        
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows.first?.safeAreaInsets != UIEdgeInsets.zero
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
}
