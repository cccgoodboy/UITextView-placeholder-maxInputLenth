//
//  BundleExt.swift
//  CSMall
//
//  Created by 初程程 on 2018/9/9.
//  Copyright © 2018年 taoh. All rights reserved.
//

import UIKit
enum Language : String {
    case english = "en"
    case chinese = "zh-Hans"
}

class BundleExt: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = Bundle.getLanguageBundel() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}



extension Bundle {
    
    private static var onLanguageDispatchOnce: ()->Void = {
        //替换Bundle.main为自定义的BundleEx
        object_setClass(Bundle.main, BundleExt.self)
    }
    
    func onLanguage(){
        Bundle.onLanguageDispatchOnce()
    }
    
    class func getLanguageBundel() -> Bundle? {
        let languages:[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        var str2:String = languages[0]
        str2 = str2.replacingOccurrences(of: "-CN", with: "")
        
        str2 = str2.replacingOccurrences(of: "-US", with: "")
        let languageBundlePath = Bundle.main.path(forResource:str2, ofType: "lproj")
        //        print("path = \(languageBundlePath)")
        guard languageBundlePath != nil else {
            return nil
        }
        let languageBundle = Bundle.init(path: languageBundlePath!)
        guard languageBundle != nil else {
            return nil
        }
        return languageBundle!
    }
}
