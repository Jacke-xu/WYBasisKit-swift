//
//  WYBasisKitConfig.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/11/21.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

/**
 * 可编译通过的特殊字符 𝟬 𝟭 𝟮 𝟯 𝟰 𝟱 𝟲 𝟳 𝟴 𝟵 ․﹒𝙭ｘ𝙓
 * 设备数据参考文库 https://blog.csdn.net/Scorpio_27/article/details/52297643
 */

import UIKit

/// 屏幕分辨率
public enum WYScreenPixels {
    case 𝟯𝟮𝟬ｘ𝟱𝟲𝟴
    case 𝟯𝟳𝟱ｘ𝟲𝟲𝟳
    case 𝟰𝟭𝟰ｘ𝟳𝟯𝟲
    case 𝟯𝟳𝟱ｘ𝟴𝟭𝟮
    case 𝟰𝟭𝟰ｘ𝟴𝟵𝟲
    case 𝟯𝟵𝟬ｘ𝟴𝟰𝟰
    case 𝟰𝟮𝟴ｘ𝟵𝟮𝟲
    case 𝟯𝟵𝟯ｘ𝟴𝟱𝟮
    case 𝟰𝟯𝟬ｘ𝟵𝟯𝟮
    case customize
}

public struct WYBasisKitConfig {
    
    /// 设置默认屏幕分辨率
    public static var defaultScreenPixels: WYScreenPixels = .𝟯𝟵𝟬ｘ𝟴𝟰𝟰
    
    /// 设置自定义屏幕宽度比基数
    public static var screenWidthRatioBase: CGFloat = wy_screenRatioBase(fromWidth: true, pixels: defaultScreenPixels)
    
    /// 设置自定义屏幕高度比基数
    public static var screenHeightRatioBase: CGFloat = wy_screenRatioBase(fromWidth: false, pixels: defaultScreenPixels)
    
    /// 设置字号适配的最大比率数
    public static var maxFontRatio: CGFloat = 1.25
    
    /// 设置国际化时需要加载的自定义本地化语言读取表
    public static var localizableTable: String?
    
    /// Debug模式下是否打印日志
    public static var debugModeLog: Bool = true
}

/// 电池条高度
public var wy_statusBarHeight: CGFloat {
    get {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

/// NavBar高度 self.navigationController.navigationBar.frame.size.height
public let wy_navBarHeight: CGFloat = 44.0

/// 导航栏安全区域
public var wy_navBarSafetyZone: CGFloat {
    get {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            return window?.safeAreaInsets.top ?? 0.0
        } else {
            let window = UIApplication.shared.windows.first
            return window?.safeAreaInsets.top ?? 0.0
        }
    }
}

/// 导航栏高度
public let wy_navViewHeight: CGFloat = (wy_statusBarHeight+wy_navBarHeight)

/// tabBar安全区域
public var wy_tabbarSafetyZone: CGFloat {
    get {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            return window?.safeAreaInsets.bottom ?? 0.0
        } else {
            let window = UIApplication.shared.windows.first
            return window?.safeAreaInsets.bottom ?? 0.0
        }
    }
}

/// tabBar高度
public let wy_tabBarHeight: CGFloat = (wy_tabbarSafetyZone + 49.0)

/// 屏幕宽
public let wy_screenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高
public let wy_screenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 屏幕宽度或者高度比率基数
public func wy_screenRatioBase(fromWidth: Bool, pixels: WYScreenPixels = WYBasisKitConfig.defaultScreenPixels) -> CGFloat {
    switch pixels {
    case .𝟯𝟮𝟬ｘ𝟱𝟲𝟴:
        return (fromWidth ? 320.0 : 568.0)
    case .𝟯𝟳𝟱ｘ𝟲𝟲𝟳:
        return (fromWidth ? 375.0 : 667.0)
    case .𝟰𝟭𝟰ｘ𝟳𝟯𝟲:
        return (fromWidth ? 414.0 : 736.0)
    case .𝟯𝟳𝟱ｘ𝟴𝟭𝟮:
        return (fromWidth ? 375.0 : 812.0)
    case .𝟰𝟭𝟰ｘ𝟴𝟵𝟲:
        return (fromWidth ? 414.0 : 896.0)
    case .𝟯𝟵𝟬ｘ𝟴𝟰𝟰:
        return (fromWidth ? 390.0 : 844.0)
    case .𝟰𝟮𝟴ｘ𝟵𝟮𝟲:
        return (fromWidth ? 428.0 : 926.0)
    case .𝟯𝟵𝟯ｘ𝟴𝟱𝟮:
        return (fromWidth ? 393.0 : 852.0)
    case .𝟰𝟯𝟬ｘ𝟵𝟯𝟮:
        return (fromWidth ? 430.0 : 932.0)
    case .customize:
        return (fromWidth ? WYBasisKitConfig.screenWidthRatioBase : WYBasisKitConfig.screenHeightRatioBase)
    }
}

/// 屏幕宽度比率
public func wy_screenWidthRatio(_ pixels: WYScreenPixels = WYBasisKitConfig.defaultScreenPixels) -> CGFloat {
    return (wy_screenWidth / wy_screenRatioBase(fromWidth: true, pixels: pixels))
}

/// 屏幕高度比率
public func wy_screenHeightRatio(_ pixels: WYScreenPixels = WYBasisKitConfig.defaultScreenPixels) -> CGFloat {
    return (wy_screenHeight / wy_screenRatioBase(fromWidth: false, pixels: pixels))
}

/// 屏幕宽度比率转换
public func wy_screenWidth(_ ratioValue: CGFloat, _ pixels: WYScreenPixels = WYBasisKitConfig.defaultScreenPixels) -> CGFloat {
    return round(ratioValue*wy_screenWidthRatio(pixels))
}

/// 屏幕高度比率转换
public func wy_screenHeight(_ ratioValue: CGFloat, _ pixels: WYScreenPixels = WYBasisKitConfig.defaultScreenPixels) -> CGFloat {
    return round(ratioValue*wy_screenHeightRatio(pixels))
}

/// 字号比率转换
public func wy_fontSize(_ ratioValue: CGFloat, _ pixels: WYScreenPixels = WYBasisKitConfig.defaultScreenPixels) -> CGFloat {
    if wy_screenWidthRatio(pixels) > WYBasisKitConfig.maxFontRatio {
        return ratioValue * WYBasisKitConfig.maxFontRatio
    }else {
        return ratioValue * wy_screenWidthRatio(pixels)
    }
}

/// 获取非空字符串
public func wy_safe(_ string: String?) -> String {
    return string ?? ""
}

/// 角度转弧度
public func wy_degreesToRadian(degrees: CGFloat) -> CGFloat {
    return CGFloat(NSDecimalNumber(decimal: Decimal(Double((CGFloat.pi * (degrees) / 180.0)))).floatValue)
}

/// 弧度转角度
public func wy_radianToDegrees(radian: CGFloat) -> CGFloat {
    return CGFloat(NSDecimalNumber(decimal: Decimal(Double((radian*180.0)/(CGFloat.pi)))).floatValue)
}

/**
 *  获取自定义控件所需要的换行数
 *
 *  @param total     总共有多少个自定义控件
 *
 *  @param perLine   每行显示多少个控件
 *
 */
public func wy_numberOfLines(total: NSInteger, perLine: NSInteger) -> NSInteger {
    if CGFloat(total).truncatingRemainder(dividingBy: CGFloat(perLine)) == 0 {
        return total / perLine
    }else {
        return (total / perLine) + 1
    }
}

/**
 *  获取一个随机整数
 *
 *  @param minimux   最小可以是多少
 *
 *  @param maximum   最大可以是多少
 *
 */
public func wy_randomInteger(minimux: NSInteger = 1, maximum: NSInteger = 99999) -> NSInteger {
    
    guard minimux < maximum else {
        return maximum
    }
    return minimux + (NSInteger(arc4random()) % (maximum - minimux))
}

/**
 *  获取一个随机浮点数
 *
 *  @param minimux   最小可以是多少
 *
 *  @param maximum   最大可以是多少
 *
 *  @param precision 精度，即保留几位小数
 *
 */
public func wy_randomFloat(minimux: CGFloat = 0.01, maximum: CGFloat = 99999.99, precision: NSInteger = 2) -> CGFloat {
    
    guard minimux < maximum else {
        return maximum
    }
    return CGFloat(Double(String(format:"%.\(precision)f",CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(minimux - maximum) + min(minimux, maximum))) ?? 0)
}

/**
 *  获取一个随机字符串
 *
 *  @param min   最少需要多少个字符
 *
 *  @param max   最多需要多少个字符
 *
 */
public func wy_randomString(minimux: NSInteger = 1, maximum: NSInteger = 100) -> String {
    
    let contentString: String = "关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。参差荇菜，左右采之。窈窕淑女，琴瑟友之。参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。"
    
    guard maximum <= contentString.count else {
        return contentString
    }
    
    guard minimux <= maximum else {
        return contentString
    }
    
    let startIndex = contentString.index(contentString.startIndex, offsetBy: 0)
    let endIndex = contentString.index(contentString.startIndex, offsetBy: wy_randomInteger(minimux: minimux, maximum: maximum) - (minimux > 0 ? 1 : 0))
    
    return String(contentString[startIndex...endIndex])
}

/// 获取对象或者类的所有属性和对应的类型
public func wy_sharedPropertys(object: Any? = nil, className: String = "") -> [String: Any] {
    
    var propertys: [String: Any] = [:]
    
    if (object != nil) {

        Mirror(reflecting: object!).children.forEach { (child) in
            propertys[child.label ?? ""] = type(of: child.value)
        }
    }
    guard let objClass = NSClassFromString(className) else {
        return propertys
    }
    
    var count: UInt32 = 0
    let ivars = class_copyIvarList(objClass, &count)
    for i in 0..<count {
        let ivar = ivars?[Int(i)]
        let ivarName = NSString(cString: ivar_getName(ivar!)!, encoding: String.Encoding.utf8.rawValue)
        let ivarType = NSString(cString: ivar_getTypeEncoding(ivar!)!, encoding: String.Encoding.utf8.rawValue)
        
        propertys[((ivarName ?? "") as String)] = (ivarType as String?) ?? ""
    }
    return propertys
}

/// 项目名字
public let wy_projectName: String = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""

/// 商店应用名
public let wy_appStoreName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""

/// 应用标识
public let wy_appIdentifier: String = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""

/// 应用商店版本号
public let wy_appStoreVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

/// 应用构建版本号
public let wy_appBuildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

/// DEBUG打印日志
public func wy_print(_ messages: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    if WYBasisKitConfig.debugModeLog == true {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let time = timeFormatter.string(from: Date())
        let message = messages.compactMap { "\($0)" }.joined(separator: " ")
        print("\n【\((file as NSString).lastPathComponent) ——> \(function) ——> line:\(line) ——> time:\(time)】\n\n \(message)\n\n\n")
    }
    #endif
}
