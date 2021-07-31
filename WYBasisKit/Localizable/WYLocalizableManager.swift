//
//  WYLocalizableManager.swift
//  WYBasisKit
//
//  Created by Jacke·xu on 2020/8/29.
//  Copyright © 2020 Jacke·xu. All rights reserved.
//

/*
 languageCode = ["aa", "ab", "ace", "ach", "ada", "ady", "ae", "aeb", "af", "afh", "agq", "ain", "ak", "akk", "akz", "ale", "aln", "alt", "am", "an", "ang", "anp", "ar", "arc", "arn", "aro", "arp", "arq", "ars", "arw", "ary", "arz", "as", "asa", "ase", "ast", "av", "avk", "awa", "ay", "az", "ba", "bal", "ban", "bar", "bas", "bax", "bbc", "bbj", "be", "bej", "bem", "bew", "bez", "bfd", "bfq", "bg", "bgn", "bho", "bi", "bik", "bin", "bjn", "bkm", "bla", "bm", "bn", "bo", "bpy", "bqi", "br", "bra", "brh", "brx", "bs", "bss", "bua", "bug", "bum", "byn", "byv", "ca", "cad", "car", "cay", "cch", "ccp", "ce", "ceb", "cgg", "ch", "chb", "chg", "chk", "chm", "chn", "cho", "chp", "chr", "chy", "ckb", "co", "cop", "cps", "cr", "crh", "cs", "csb", "cu", "cv", "cy", "da", "dak", "dar", "dav", "de", "del", "den", "dgr", "din", "dje", "doi", "dsb", "dtp", "dua", "dum", "dv", "dyo", "dyu", "dz", "dzg", "ebu", "ee", "efi", "egl", "egy", "eka", "el", "elx", "en", "enm", "eo", "es", "esu", "et", "eu", "ewo", "ext", "fa", "fan", "fat", "ff", "fi", "fil", "fit", "fj", "fo", "fon", "fr", "frc", "frm", "fro", "frp", "frr", "frs", "fur", "fy", "ga", "gaa", "gag", "gan", "gay", "gba", "gbz", "gd", "gez", "gil", "gl", "glk", "gmh", "gn", "goh", "gom", "gon", "gor", "got", "grb", "grc", "gsw", "gu", "guc", "gur", "guz", "gv", "gwi", "ha", "hai", "hak", "haw", "he", "hi", "hif", "hil", "hit", "hmn", "ho", "hr", "hsb", "hsn", "ht", "hu", "hup", "hy", "hz", "ia", "iba", "ibb", "id", "ie", "ig", "ii", "ik", "ilo", "inh", "io", "is", "it", "iu", "izh", "ja", "jam", "jbo", "jgo", "jmc", "jpr", "jrb", "jut", "jv", "ka", "kaa", "kab", "kac", "kaj", "kam", "kaw", "kbd", "kbl", "kcg", "kde", "kea", "ken", "kfo", "kg", "kgp", "kha", "kho", "khq", "khw", "ki", "kiu", "kj", "kk", "kkj", "kl", "kln", "km", "kmb", "kn", "ko", "koi", "kok", "kos", "kpe", "kr", "krc", "kri", "krj", "krl", "kru", "ks", "ksb", "ksf", "ksh", "ku", "kum", "kut", "kv", "kw", "ky", "la", "lad", "lag", "lah", "lam", "lb", "lez", "lfn", "lg", "li", "lij", "liv", "lkt", "lmo", "ln", "lo", "lol", "loz", "lrc", "lt", "ltg", "lu", "lua", "lui", "lun", "luo", "lus", "luy", "lv", "lzh", "lzz", "mad", "maf", "mag", "mai", "mak", "man", "mas", "mde", "mdf", "mdh", "mdr", "men", "mer", "mfe", "mg", "mga", "mgh", "mgo", "mh", "mi", "mic", "min", "mis", "mk", "ml", "mn", "mnc", "mni", "mo", "moh", "mos", "mr", "mrj", "ms", "mt", "mua", "mul", "mus", "mwl", "mwr", "mwv", "my", "mye", "myv", "mzn", "na", "nan", "nap", "naq", "nb", "nd", "nds", "ne", "new", "ng", "nia", "niu", "njo", "nl", "nmg", "nn", "nnh", "no", "nog", "non", "nov", "nqo", "nr", "nso", "nus", "nv", "nwc", "ny", "nym", "nyn", "nyo", "nzi", "oc", "oj", "om", "or", "os", "osa", "ota", "pa", "pag", "pal", "pam", "pap", "pau", "pcd", "pdc", "pdt", "peo", "pfl", "phn", "pi", "pl", "pms", "pnt", "pon", "prg", "pro", "ps", "pt", "qu", "quc", "qug", "raj", "rap", "rar", "rgn", "rif", "rm", "rn", "ro", "rof", "rom", "rtm", "ru", "rue", "rug", "rup", "rw", "rwk", "sa", "sad", "sah", "sam", "saq", "sas", "sat", "saz", "sba", "sbp", "sc", "scn", "sco", "sd", "sdc", "sdh", "se", "see", "seh", "sei", "sel", "ses", "sg", "sga", "sgs", "shi", "shn", "shu", "si", "sid", "sk", "sl", "sli", "sly", "sm", "sma", "smj", "smn", "sms", "sn", "snk", "so", "sog", "sq", "sr", "srn", "srr", "ss", "ssy", "st", "stq", "su", "suk", "sus", "sux", "sv", "sw", "swb", "swc", "syc", "syr", "szl", "ta", "tcy", "te", "tem", "teo", "ter", "tet", "tg", "th", "ti", "tig", "tiv", "tk", "tkl", "tkr", "tl", "tlh", "tli", "tly", "tmh", "tn", "to", "tog", "tpi", "tr", "tru", "trv", "ts", "tsd", "tsi", "tt", "ttt", "tum", "tvl", "tw", "twq", "ty", "tyv", "tzm", "udm", "ug", "uga", "uk", "umb", "und", "ur", "uz", "vai", "ve", "vec", "vep", "vi", "vls", "vmf", "vo", "vot", "vro", "vun", "wa", "wae", "wal", "war", "was", "wbp", "wo", "wuu", "xal", "xh", "xmf", "xog", "yao", "yap", "yav", "ybb", "yi", "yo", "yrl", "yue", "za", "zap", "zbl", "zea", "zen", "zgh", "zh", "zu", "zun", "zxx", "zza"]
 */

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
                let userLanguage: String = (UserDefaults.standard.value(forKey: WYBasisKitLanguage) as? String) ?? (Bundle.main.preferredLocalizations.first!)
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
    
    /// 设置本地化语言读取表，不设置默认则使用默认WYLocalizable
    public static var localizableTable: String = "WYLocalizable"
    
    private static var showLanguage: WYLanguage = WYLocalizableManager.currentLanguage()
    
    private static var bundle: Bundle? = Bundle(path: Bundle.main.path(forResource: WYLocalizableManager.currentLanguage().rawValue, ofType: "lproj") ?? "")
    
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
        
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") else {
            return
        }

        guard let bundleTem = Bundle(path: path) else {
            return
        }
        bundle = bundleTem
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
        
        if (Bundle.main.path(forResource: currentLanguage().rawValue, ofType: "lproj") ?? "").isEmpty {
            return key
        }else {
            guard let bundleTem = bundle else {
                return WYLocalizedString(key)
            }
            return bundleTem.localizedString(forKey: key, value: nil, table: localizableTable)
        }
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
}

