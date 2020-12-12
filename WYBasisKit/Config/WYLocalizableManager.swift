//
//  WYLocalizableManager.swift
//  WYBasisKit
//
//  Created by jacke·xu on 2020/8/29.
//  Copyright © 2020 jacke-xu. All rights reserved.
//

import UIKit

private let WYBasisKitLanguage = "WYBasisKitLanguage"

public func WYLocalizedString(_ key: String) -> String {
    
    return WYLocalizableManager.shared.stringFromKey(key: key)
}

public func WYLocalizedString(_ chinese: String = "", _ english: String = "") -> String {
    
    return (WYLocalizableManager.shared.currentLanguage() == .chinese) ? chinese : english
}

public class WYLocalizableManager: NSObject {

    public static let shared = WYLocalizableManager()
    
    private var showLanguage: WYLanguage!
    
    private var bundle: Bundle?
    
    override init() {
        
        super.init()
        
        showLanguage = currentLanguage()

        bundle = Bundle.init(path: Bundle.main.path(forResource: currentLanguage().rawValue, ofType: "lproj")!)
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
        
        guard let bundleTem = bundle else {
            return WYLocalizedString(key)
        }

        return bundleTem.localizedString(forKey: key, value: nil, table: "WYLocalizable")
    }
    
    /// 点击切换语言后调用该方法切换本地语言(需要给 Main.Storyboard 设置 Storyboard ID 为rootViewController)
    private func reloadMainStoryboardController(handler:(() -> Void)? = nil) {
        
        guard showLanguage != currentLanguage() else { return }
        
        if let appdelegate = UIApplication.shared.delegate {
            
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let mainController = storyBoard.instantiateViewController(withIdentifier: "rootViewController")
            
            appdelegate.window??.rootViewController = mainController
        }
        
        showLanguage = currentLanguage()
        
        if handler != nil {
            
            handler!()
        }
    }
}
