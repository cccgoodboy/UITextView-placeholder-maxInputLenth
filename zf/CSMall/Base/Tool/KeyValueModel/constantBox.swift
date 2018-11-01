//
//  constantBox.swift
//
//
//  Created by space on 15/12/21.
//  Copyright © 2015年 Space. All rights reserved.
//

import UIKit
/**Dictionary*/
extension Dictionary {
    /**得到所有键 数组*/
    func  allKeys() ->[Key]{
        var array = [Key]()
        var  gener = self.keys.makeIterator()
        while let key = gener.next() {
            array.append(key)
        }
        return array;
    }
    /**遍历字典*/
    func enumerateKeysAndObjects(option:(Key,Value,Int)->()){
        let allK = self.allKeys()
        for i in 0  ..< allK.count  {
            let value = self[allK[i]]
            option(allK[i],value!,i)
        }
    }
}

extension Array{
    func enumerateKeysAndObjects(option:(Element,Int)->()){
        for i in 0  ..< self.count  {
            option(self[i],i)
        }
    }
}

extension String{
    func getTypeName()->String{
        let a = self as  NSString
        let range = a.range(of: "Optional<")
        if range.length == 0 {return self}
        let b = a.substring(from: range.location + range.length) as NSString
        return b.substring(to: b.length-1)
    }
    func getClassName() ->String{
        ////Optional<Array<photo>>  ---->photo
        
        var name = self.substring(from: self.index(self.startIndex, offsetBy: 15))
        name = name.substring(to: name.index(name.endIndex, offsetBy: -2))
        return name
    }
    func getWholeClassName()->String{
        
        var ClassName = "\(classPrefix)"
        ClassName.append("." + self)
        return ClassName
    }
}
