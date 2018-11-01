//
//  AppDelegate.swift
//  LoveAnimation
//
//  Created by xiudou on 16/6/21.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

extension UIColor
{
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber() , alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        // 0 ~ 255
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
    public var hexString: String {
        var red:	CGFloat = 0
        var green:	CGFloat = 0
        var blue:	CGFloat = 0
        var alpha:	CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return NSString(format:"#%06x", rgb).uppercased as String
    }
    
//    public func hexStringToColor(hexString: String) -> UIColor{
//        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.newlines)
//        
//        if cString.characters.count < 6 {return UIColor.black}
//        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.startIndex)}
//        
//        if cString.hasPrefix("#") {cString = cString.substring(from: cString.startIndex)}
//        if cString.characters.count != 6 {return UIColor.black}
//        
//        var range: NSRange = NSMakeRange(0, 2)
//        
//        let rString = (cString as NSString).substring(with: range)
//        range.location = 2
//        let gString = (cString as NSString).substring(with: range)
//        range.location = 4
//        let bString = (cString as NSString).substring(with: range)
//        
//        var r: UInt32 = 0x0
//        var g: UInt32 = 0x0
//        var b: UInt32 = 0x0
//        Scanner.init(string: rString).scanHexInt32(&r)
//        Scanner.init(string: gString).scanHexInt32(&g)
//        Scanner.init(string: bString).scanHexInt32(&b)
//        
//        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
//        
//    }
//
    public convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    

}
