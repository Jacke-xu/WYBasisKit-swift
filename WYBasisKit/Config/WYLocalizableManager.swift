//
//  WYLocalizableManager.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

import UIKit

/// 国际化语言版本
public enum WYLanguage: String {
    
    /// 中文
    case chinese = "zh-Hans"
    
    /// 英文
    case english = "en"
}

private let WYBasisKitLanguage = "WYBasisKitLanguage"

public func WYLocalizedString(_ key: String) -> String {
    
    return WYLocalizableManager.shared.stringFromKey(key: key)
}

public func WYLocalizedString(_ chinese: String = "", _ english: String = "") -> String {
    
    return (WYLocalizableManager.shared.currentLanguage() == .chinese) ? chinese : english
}

public class WYLocalizableManager {

    public static var shared = WYLocalizableManager()
    
    private var showLanguage: WYLanguage!
    
    private var bundle: Bundle?
    
    init() {
        
        showLanguage = currentLanguage()

        bundle = Bundle.init(path: Bundle.main.path(forResource: currentLanguage().rawValue, ofType: "lproj") ?? "")
    }
    
    /// 当前语言
    public func currentLanguage() -> WYLanguage {
        
        var userLanguage: String = (UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String) ?? (Bundle.main.preferredLocalizations.first!)
        
        userLanguage = (userLanguage.hasPrefix("zh") == true) ? WYLanguage.chinese.rawValue : WYLanguage.english.rawValue
        
        return WYLanguage(rawValue: userLanguage)!
    }

    /// 切换语言
    public func switchLanguage(language: WYLanguage, reload: Bool = true, handler:(() -> Void)? = nil) {
        
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") else {
            return
        }

        guard let bundleTem = Bundle.init(path: path) else {
            return
        }
        bundle = bundleTem
        UserDefaults.standard.setValue(language.rawValue, forKey: WYBasisKitLanguage)
        UserDefaults.standard.synchronize()
        
        guard reload == true else {
        
            if handler != nil {
                
                handler!()
            }
            return
        }
        
        reloadMainStoryboardController(handler: handler)
    }

    public func stringFromKey(key: String) -> String {
        
        if (Bundle.main.path(forResource: currentLanguage().rawValue, ofType: "lproj") ?? "").isEmpty {
            return key
        }else {
            guard let bundleTem = bundle else {
                return WYLocalizedString(key)
            }
            return bundleTem.localizedString(forKey: key, value: nil, table: "WYLocalizable")
        }
    }
    
    /// 点击切换语言后调用该方法切换本地语言(需要给 Main.Storyboard 设置 Storyboard ID 为rootViewController)
    private func reloadMainStoryboardController(handler:(() -> Void)? = nil) {
        
        guard showLanguage != currentLanguage() else { return }
        
        if let appdelegate = UIApplication.shared.delegate {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let mainController = storyBoard.instantiateViewController(withIdentifier: "rootViewController")
            
            appdelegate.window??.rootViewController = mainController
        }
        
        showLanguage = currentLanguage()
        
        if handler != nil {
            
            handler!()
        }
    }
}
