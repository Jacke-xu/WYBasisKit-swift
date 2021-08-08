//
//  WYLocalizableManager.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

/// 国际化语言版本(目前只国际化了中文及英文，其他的可以调用WYBasisKitConfig.localizableTable属性来设置需要加载的自定义本地化语言读取表)
public enum WYLanguage: RawRepresentable {

    /// 简体中文
    case chinese
    
    /// 英文
    case english
    
    /// 其他语言(具体查看other.rawValue)
    case other
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        switch rawValue {
        case "zh-Hans":
            self = .chinese
        case "en":
            self = .english
        default:
            self = .other
        }
    }
    
    public var rawValue: String {
            switch self {
            case .chinese:
                return "zh-Hans"
            case .english:
                return "en"
            case .other:
                let userLanguage: String = (UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String) ?? (Bundle.main.preferredLocalizations.first ?? "")
                return userLanguage
            }
        }
}

private let WYBasisKitLanguage = "WYBasisKitLanguage"

public func WYLocalizedString(_ key: String) -> String {
    return WYLocalizableManager.localizedString(key: key)
}

public func WYLocalizedString(_ chinese: String = "", _ english: String = "") -> String {
    return (WYLocalizableManager.currentLanguage() == .chinese) ? chinese : english
}

public struct WYLocalizableManager {
    
    /// 设置本地化语言读取表(如果有Bundle，则要求Bundle名与表名一致，否则会读取失败)，不设置默认则使用默认WYLocalizable
    public static var localizableTable: String = "WYLocalizable"
    
    private static var showLanguage: WYLanguage = WYLocalizableManager.currentLanguage()
    
    private static var bundle: Bundle? = localizableBundle()
    
    /// 当前语言
    public static func currentLanguage() -> WYLanguage {
        
        let userLanguage: String = (UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String) ?? (Bundle.main.preferredLocalizations.first!)
        switch userLanguage {
        case "zh-Hans":
            return WYLanguage(rawValue: WYLanguage.chinese.rawValue)!
        case "en":
            return WYLanguage(rawValue: WYLanguage.english.rawValue)!
        default:
            return WYLanguage(rawValue: WYLanguage.other.rawValue)!
        }
    }
    
    /// 获取各个国家语言标识符列表(如简体中文 = zh-Hans)
    public static func isoLanguageCodes() -> [String] {
        return Locale.isoLanguageCodes
    }

    /// 切换语言(如果reload为True，需要给 Storyboard 设置 Name 和 Identifier，默认从 Main.Storyboard 重启)
    public static func switchLanguage(language: WYLanguage, reload: Bool = true, name: String = "Main", identifier: String = "rootViewController", handler:(() -> Void)? = nil) {

        guard language.rawValue != currentLanguage().rawValue else {
            return
        }
        
        guard localizableBundle(from: language) != nil else {
            return
        }
        
        bundle = localizableBundle(from: language)
        
        UserDefaults.standard.setValue(language.rawValue, forKey: WYBasisKitLanguage)
        UserDefaults.standard.synchronize()
        
        showLanguage = currentLanguage()
        
        guard reload == true else {
            if handler != nil {
                handler!()
            }
            return
        }
        reloadStoryboard(name: name, identifier: identifier, handler: handler)
    }

    public static func localizedString(key: String) -> String {
        
        guard bundle != nil else {
            return WYLocalizedString(key)
        }
        return bundle!.localizedString(forKey: key, value: nil, table: localizableTable)
    }
    
    /// 点击切换语言后调用该方法切换本地语言
    private static func reloadStoryboard(name: String, identifier: String, handler:(() -> Void)? = nil) {
        
        if let appdelegate = UIApplication.shared.delegate {
            
            let storyBoard = UIStoryboard(name: name, bundle: nil)
            
            let mainController = storyBoard.instantiateViewController(withIdentifier: identifier)
            
            appdelegate.window??.rootViewController = mainController
        }
        
        if handler != nil {
            
            handler!()
        }
    }
    
    /// 获取存放国际化资源的Bundle
    private static func localizableBundle(from language: WYLanguage = currentLanguage()) -> Bundle? {

        let bundlePath = (Bundle(for: WYBundleClass.self).path(forResource: localizableTable, ofType: "bundle")) ?? (Bundle.main.path(forResource: localizableTable, ofType: "bundle"))

        guard let resourcePath = bundlePath else {

            return Bundle(path: (Bundle(for: WYBundleClass.self).path(forResource: language.rawValue, ofType: "lproj") ?? Bundle.main.path(forResource: language.rawValue, ofType: "lproj")) ?? "")
        }
        return Bundle(path: Bundle(path: resourcePath)?.path(forResource: language.rawValue, ofType: "lproj") ?? "")
    }
}

private class WYBundleClass {}
