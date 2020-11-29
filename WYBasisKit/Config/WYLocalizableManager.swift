//
//  WYLocalizableManager.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import Foundation

public enum WYLanguage {
    
    /// 中文
    case chinese
    
    /// 英文
    case english
}

private let WYBasisKitLanguage = "WYBasisKitLanguage"

public func WYLocalizedString(_ key: String, value: String? = "", comment: String? = "") -> String {
    return WYLocalizableManager.shared.stringFromKey(key: key)
}

public class WYLocalizableManager: NSObject {

    public static let shared = WYLocalizableManager()
    
    private var bundle: Bundle?
    
    override init() {
        
        var userLanguage = UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String
        if userLanguage == nil {
            userLanguage = Bundle.main.preferredLocalizations.first
        }

        switch userLanguage {
        case "zh-Hans-US", "zh-Hans-CN", "zh-Hant-CN", "zh-TW", "zh-HK", "zh-Hans":
            userLanguage = "zh-Hans"
        default:
            userLanguage = "en"
        }

        bundle = Bundle.init(path: Bundle.main.path(forResource: userLanguage, ofType: "lproj")!)
    }
    
    public func currentLanguage() -> String {
        
        var userLanguage = UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String
        if userLanguage == nil {
            userLanguage = Bundle.main.preferredLocalizations.first
        }

        switch userLanguage {
        case "zh-Hans-US", "zh-Hans-CN", "zh-Hant-CN", "zh-TW", "zh-HK", "zh-Hans":
            userLanguage = "zh-Hans"
        default:
            userLanguage = "en"
        }

        return userLanguage ?? "en"
    }

    public func setUserLanguage(language: WYLanguage) {
        
        var languageStr = "en"
        switch language {
        case .chinese:
            languageStr = "zh-Hans"
        case .english:
            languageStr = "en"
        }
        
        guard let path = Bundle.main.path(forResource: languageStr, ofType: "lproj") else {
            return
        }

        guard let bundleTem = Bundle.init(path: path) else {
            return
        }
        bundle = bundleTem
        UserDefaults.standard.setValue(languageStr, forKey: WYBasisKitLanguage)
        UserDefaults.standard.synchronize()
    }

    public func stringFromKey(key: String) -> String {
        
        guard let bundleTem = bundle else {
            return WYLocalizedString(key, comment: "")
        }

        return bundleTem.localizedString(forKey: key, value: nil, table: "WYLocalizable")
    }
}
