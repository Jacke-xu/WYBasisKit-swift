//
//  WYLocalizableManager.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
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
            let userLanguage: String = (UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String) ?? WYLocalizableManager.currentSystemLanguage()
            return userLanguage
        }
    }
}

private let WYBasisKitLanguage = "WYBasisKitLanguage"
private let WYBasisKit_preferred_language = "preferredLocalizations"

public func WYLocalizedString(_ key: String) -> String {
    return WYLocalizableManager.localizedString(key: key)
}

public func WYLocalizedString(_ chinese: String = "", _ english: String = "") -> String {
    return (WYLocalizableManager.currentLanguage() == .chinese) ? chinese : english
}

public struct WYLocalizableManager {
    
    /// 设置本地化语言读取表(如果有Bundle，则要求Bundle名与表名一致，否则会读取失败)，不设置默认则使用默认WYLocalizable
    public static var localizableTable: String = WYBasisKitConfig.localizableTable ?? "WYLocalizable"
    
    private static var bundle: Bundle? = localizableBundle()
    
    /// 当前正在使用的语言
    public static func currentLanguage() -> WYLanguage {
        
        var preferredLanguage: String = UserDefaults.standard.value(forKey: WYBasisKit_preferred_language) as? String ?? ""
        let currentSystemLanguage: String = currentSystemLanguage()
        if currentSystemLanguage != preferredLanguage {
            
            UserDefaults.standard.set(currentSystemLanguage, forKey: WYBasisKit_preferred_language)
            
            UserDefaults.standard.set(currentSystemLanguage, forKey: WYBasisKitLanguage)
            
            UserDefaults.standard.synchronize()
            
            preferredLanguage = currentSystemLanguage
            
        }else {
            preferredLanguage = (UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String) ?? currentSystemLanguage
        }
        switch preferredLanguage {
        case "zh-Hans":
            return WYLanguage(rawValue: WYLanguage.chinese.rawValue)!
        case "en":
            return WYLanguage(rawValue: WYLanguage.english.rawValue)!
        default:
            return WYLanguage(rawValue: WYLanguage.other.rawValue)!
        }
    }
    
    /// 获取当前系统语言
    public static func currentSystemLanguage() -> String {
        
        let appleLanguages: [String] = (UserDefaults.standard.object(forKey: "AppleLanguages") as! [String])
        let countryCode: String = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? ""
        var appleLanguage: String = appleLanguages.first!.replacingOccurrences(of: "-" + countryCode, with: "")
        if appleLanguage.hasPrefix("en") {
            appleLanguage = "en"
        }
        return appleLanguage
    }
    
    /**
     *  切换本地语言
     *
     *  @param language  准备切换的目标语言
     *
     *  @param reload  是否重新加载App
     *
     *  @param name  Storyboard文件的名字，默认Main(一般不需要修改，使用默认的就好)
     *
     *  @param identifier  Storyboard文件的Identifier
     *
     */
    public static func switchLanguage(language: WYLanguage, reload: Bool = true, name: String = "Main", identifier: String = "rootViewController", handler:(() -> Void)? = nil) {
        
        guard language.rawValue != currentLanguage().rawValue else {
            return
        }
        
        guard let languageBundle = localizableBundle(from: language) else {
            return
        }
        bundle = languageBundle
        
        UserDefaults.standard.setValue(language.rawValue, forKey: WYBasisKitLanguage)
        UserDefaults.standard.synchronize()
        
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
        
        let bundlePath = (Bundle(for: WYLocalizableClass.self).path(forResource: localizableTable, ofType: "bundle")) ?? (Bundle.main.path(forResource: localizableTable, ofType: "bundle"))
        
        guard let resourcePath = bundlePath else {
            
            /// 如果没有找到存放国际化资源的Bundle文件，就直接从本地加载国际化文件
            return Bundle(path: (Bundle(for: WYLocalizableClass.self).path(forResource: language.rawValue, ofType: "lproj") ?? Bundle.main.path(forResource: language.rawValue, ofType: "lproj")) ?? "")
        }
        /// 从找到的存放国际化资源的Bundle文件中加载国际化资源
        return Bundle(path: Bundle(path: resourcePath)?.path(forResource: language.rawValue, ofType: "lproj") ?? "")
    }
}

private class WYLocalizableClass {}
