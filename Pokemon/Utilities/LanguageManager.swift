//
//  LanguageManager.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

struct LanguageStruct {
    static let kUSERDEFAULTS_APP_LANGUAGE = "kUSERDEFAULTS_APP_LANGUAGE"
    static let kLANGUAGE_DEFAULT = "en"
}

enum AppLanguage_Type {
    case in_english
    case in_language
    case in_localize
}

enum AppLanguage : String, CaseIterable {
    case English = "en"
    case Chinese_traditional = "zh-Hant"
    
    func convert2Str(type: AppLanguage_Type) -> String {
        var str = ""
        switch self {
        case .English: str = "English"
        case .Chinese_traditional: str = "Traditional Chinese"
        }
        switch type {
        case .in_english:
            break
        case .in_language:
            switch self {
            case .English: str = "English"
            case .Chinese_traditional: str = "繁體中文"
            }
        case .in_localize:
            str = str.localized().capitalized
        }
        return str
    }
}

enum GPTLanguage : String, CaseIterable {
    case English = "en"
    case Chinese_traditional = "zh-TW"
}

class LanguageManager: NSObject {
    static let shared = LanguageManager()
    var languageEnum: AppLanguage = .English
    
    override init() {
        super.init()
        
        initLanguage()
    }
    
    private func initLanguage() {
        self.languageEnum = .English
        
        if let appLanguageStr = getAppLanguageStr() {
            // user defaults
            self.languageEnum = AppLanguage(rawValue: appLanguageStr) ?? .English
        } else if let sysLanguageStr = getSysLanguageStr() {
            // system
            self.languageEnum = AppLanguage(rawValue: sysLanguageStr) ?? .English
        }
    }
    
    func getLanguageEnum() -> AppLanguage {
        return self.languageEnum
    }
    
    func setAppLanguage(language: AppLanguage, isAppGroup: Bool = true) {
        setAppLauguageStr(languageStr: language.rawValue, isAppGroup: isAppGroup)
    }
    internal func setAppLauguageStr(languageStr: String, isAppGroup: Bool = true) {
        let key = LanguageStruct.kUSERDEFAULTS_APP_LANGUAGE
        
        UserDefaults.standard.setValue(languageStr, forKey: key)
        
        initLanguage()
    }
    
    private func getAppLanguageStr(isAppGroup: Bool = true) -> String? {
        let key = LanguageStruct.kUSERDEFAULTS_APP_LANGUAGE
        return UserDefaults.standard.string(forKey: key) ?? nil
    }
    
    private func getSysLanguageStr() -> String? {
        let sysLanuageStrs = Bundle.main.preferredLocalizations
        if sysLanuageStrs.count > 0 {
            let sysLanuageStr = sysLanuageStrs[0]
            let appLanuageEnum = AppLanguage(rawValue: sysLanuageStr) ?? .English
            return appLanuageEnum.rawValue
        }
        
        return LanguageStruct.kLANGUAGE_DEFAULT
    }
    
    func resetAppLanguage() {
        if let sysLanguageStr = getSysLanguageStr() {
            let languageEnum = AppLanguage(rawValue: sysLanguageStr) ?? .English
            self.languageEnum = languageEnum
            setAppLanguage(language: languageEnum)
        }
    }
}

extension LanguageManager {
    func getGPTLanuageEnum() -> GPTLanguage {
        let gptLanguageEnum = convertAppToGPTLanguage(self.languageEnum)
        return gptLanguageEnum
    }
    
    func convertAppToGPTLanguage(_ language: AppLanguage) -> GPTLanguage {
        switch language {
        case .English: return .English
        case .Chinese_traditional: return .Chinese_traditional
        }
    }
}

class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = Bundle.getLanguageBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle {
    private static var onLanguageDispatchOnce: ()->Void = {
        object_setClass(Bundle.main, BundleEx.self)
    }
    
    func onLanguage(){
        Bundle.onLanguageDispatchOnce()
    }
    
    class func getLanguageBundle() -> Bundle? {
        let currentLanguage = LanguageManager.shared.getLanguageEnum().rawValue
        
        guard let languageBundlePath = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else {
            return nil
        }
        guard let languageBundle = Bundle.init(path: languageBundlePath) else {
            return nil
        }
        return languageBundle
    }
}

extension String {
    func localized(tableName: String? = nil, withComment:String = "") -> String {
        Bundle.main.onLanguage()
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: withComment)
    }
}
