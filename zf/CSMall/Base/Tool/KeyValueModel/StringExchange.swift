//
//  StringExchange.swift
//  HExtension
//
//  Created by 朱子豪 on 16/4/5.
//  Copyright © 2016年 Space. All rights reserved.
//

import Foundation
import UIKit
protocol StringExchange {
    func exchange()->AnyObject
}
extension Dictionary:StringExchange{
    func exchange() -> AnyObject {
        var dic:[String:AnyObject] = [String:AnyObject]()
        self.enumerateKeysAndObjects { (hash, value, _) in
            switch "\(value.self)".lowercased() {
            case let one where one.contains("dictionary"):
                dic["\(hash)"] = (value as! [String:AnyObject]).exchange()
                break
            case let one where one.contains("array"):
                dic["\(hash)"] = (value as! [String]).exchange()
                break
            case let one where one.contains("KeyValueModel"):
                dic["\(hash)"] = (value as! KeyValueModel).dictionary() as AnyObject?
                break
            default:
                dic["\(hash)"] = value as AnyObject?
                break
            }
        }
        return dic as AnyObject
    }
}
extension Array:StringExchange{
    func exchange() -> AnyObject {
        var content:[AnyObject] = [AnyObject]()
        if self.count==0{return content as AnyObject}
        self.enumerateKeysAndObjects { (value, _) in
            switch "\(value.self)".lowercased() {
            case let one where one.contains("dictionary"):
                content.append((value as! [String:AnyObject]).exchange())
                break
            case let one where one.contains("array"):
                content.append((value as! [String]).exchange())
                break
            case let one where one.contains("KeyValueModel"):
                content.append((value as! KeyValueModel).dictionary() as AnyObject)
                break
            default:
                content.append(value as AnyObject)
                break
            }
        }
        return content as AnyObject
    }
}


