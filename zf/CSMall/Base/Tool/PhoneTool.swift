//
//  PhoneTool.swift
//  CSMall
//
//  Created by 初程程 on 2018/9/16.
//  Copyright © 2018年 taoh. All rights reserved.
//

import UIKit

class PhoneTool: NSObject {
    class func clearString(base:String,clearSub:String)->String{
        var baseString = base
        
        let index = self.positionOf(base: baseString, sub: clearSub)
        
        if index == -1 {
            return baseString
        }
        
        baseString.removeSubrange(self.positionOfRange(base: baseString, sub: clearSub))
        
        return baseString
    }
    class func positionOfRange(base:String,sub:String, backwards:Bool = false)->Range<String.Index> {
        
        if let range = base.range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                return range
            }
        }
        let string = "123"
        
        return string.range(of:"1", options: backwards ? .backwards : .literal )!
    }
    class func positionOf(base:String,sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = base.range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = base.distance(from:base.startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    class func getPhoneNumber(mobile:String) -> String{
        var currentNum = ""
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            currentNum = "86"
            
        }else if (languages?.contains("zh"))!{
            currentNum = "63"
        }else{
            currentNum = "63"
        }
        return "\(currentNum)\(mobile)"
    }
    class func getCurrency() -> String {
        var type = ""
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            type = "₱"
        }else if (languages?.contains("zh"))!{
            type = "￥"
        }else{
            type = "₱"
        }
        return type
    }
}
