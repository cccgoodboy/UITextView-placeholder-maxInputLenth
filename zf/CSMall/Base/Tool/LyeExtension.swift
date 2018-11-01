
//
//  LyeExtension.swift
//  MoDuLiving
//
//  Created by sh-lx on 2017/3/10.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import Foundation
import UIKit
public func getImgAndColor(userGrade grade: String?) ->(img: UIImage, color: UIColor) {
    var g = 1
    if grade != nil {
        if let gg = Int(grade!) {
            g = gg
        }
    }
    var hex = "90f5a0"
    var img = "dengji1"
    switch g {
            case 1...9999:    hex = "90f5a0"; img = "btn_chongzhijine"

//    case 1...16:    hex = "90f5a0"; img = "dengji1"
//    case 17...37:   hex = "1e92df"; img = "dengji2"
//    case 38...56:   hex = "f92e36"; img = "dengji3"
//    case 57...99:   hex = "2dfffe"; img = "dengji3"
//    case 100...199: hex = "5d46db"; img = "dengji4"
//    case 200...299: hex = "b32cf5"; img = "dengji4"
//    case 300...399: hex = "f56f9e"; img = "dengji4"
//    case 400...499: hex = "eea5eb"; img = "dengji4"
//    case 500...599: hex = "a2af2a"; img = "dengji5"
//    case 600...699: hex = "0b24fa"; img = "dengji5"
//    case 700...799: hex = "1b9a30"; img = "dengji5"
//    case 800...899: hex = "a2050d"; img = "dengji5"
//    case 900...999: hex = "f9a92e"; img = "dengji6"
    default: break
    }
    return (UIImage(named: img)!, UIColor(hexString: hex))
}

extension UIButton {
    func set(grade ggg: String?) {
        var g = 1
        if ggg != nil {
            if let gg = Int(ggg!) {
                g = gg
            }
        }
        let m = getImgAndColor(userGrade: ggg)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        self.backgroundColor = m.color
        self.setImage(m.img, for: .normal)
        self.setTitle(" \(g)", for: .normal)
        self.titleLabel?.font = defaultFont(size: 14)
        self.setTitleColor(UIColor.white, for: .normal)
        self.tintColor = UIColor.clear
        self.layer.cornerRadius = 2
    }
}



typealias Task = (_ cancel : Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}
func cancel(_ task: Task?) {
    task?(true)
}

extension UIView{

    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}

extension UICollectionView {
    func display(image: UIImage?, title: String?, count: Int) {
        if count > 0 {
            self.backgroundView = nil
        } else {
            if image != nil {
                let bgView = UIView()
                let img = UIImageView(frame: CGRect(x: (kScreenWidth - image!.size.width)/2, y: 0, width: image!.size.width, height: image!.size.height))
                img.image = image
                bgView.addSubview(img)
                if title != nil {
                    let label = UILabel(frame: CGRect(x: 10, y: img.frame.maxY + 10, width: kScreenWidth - 20, height: 20))
                    label.text = title
                    label.textColor = UIColor(hexString: "#A7ADB4")
                    label.textAlignment = .center
                    label.font = UIFont.systemFont(ofSize: 12)
                    bgView.addSubview(label)
                    self.backgroundView = bgView
                }
            } else {
                let label = UILabel()
                label.text = title
                label.textColor = UIColor(hexString: "#A7ADB4")
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                label.sizeToFit()
                self.backgroundView = label
            }
        }
    }
    func displayfawu(image: UIImage?, title: String?, count: Int) {
        if count > 0 {
            self.backgroundView = nil
        } else {
            if image != nil {
                let bgView = UIView()
                let img = UIImageView(frame: CGRect(x:(kScreenWidth - image!.size.width - 100)/2, y:106/375.0 * kScreenWidth, width: image!.size.width, height: image!.size.height))
                img.image = image
                bgView.addSubview(img)
                if title != nil {
                    let label = UILabel(frame: CGRect(x: 10, y: img.frame.maxY + 10, width: kScreenWidth - 120, height: 20))
                    label.text = title
                    label.textColor = UIColor.black
                    label.textAlignment = .center
                    label.font = UIFont.systemFont(ofSize: 20)
                    bgView.addSubview(label)
                    self.backgroundView = bgView
                }
            } else {
                let label = UILabel()
                label.text = title
                label.textColor = UIColor(hexString: "#A7ADB4")
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                label.sizeToFit()
                self.backgroundView = label
            }
        }
    }
}
extension UITableView {
    func display(image: UIImage?, title: String?, count: Int) {
        if count > 0 {
            if let bg = backgroundView {
                for subview in bg.subviews {
                    subview.removeFromSuperview()
                }
            }
        } else {
            if image != nil {
                var bgView = backgroundView
                if bgView == nil {
                    bgView = UIImageView(image: #imageLiteral(resourceName: "icon_zhengtibg"))
                    bgView?.contentMode = .scaleAspectFill
                    bgView?.clipsToBounds = true
                    backgroundView = bgView
                }
                let img = UIImageView(frame: CGRect(x: (kScreenWidth - image!.size.width)/2, y: 106/375.0 * kScreenWidth, width: image!.size.width, height: image!.size.height))
                img.image = image
                bgView?.addSubview(img)
                if title != nil {
                    let label = UILabel(frame: CGRect(x: 10, y: img.frame.maxY + 17, width: kScreenWidth - 20, height: 20))
                    label.text = title
                    label.textColor = UIColor(hexString: "#222222")
                    label.textAlignment = .center
                    label.font = UIFont.systemFont(ofSize: 20)
                    bgView?.addSubview(label)
                }
            } else {
                var bgView = backgroundView
                if bgView == nil {
                    bgView = UIImageView(image: #imageLiteral(resourceName: "icon_zhengtibg"))
                    bgView?.contentMode = .scaleAspectFill
                    bgView?.clipsToBounds = true
                    backgroundView = bgView
                }
                let label = UILabel(frame: CGRect(x: 10, y: kScreenHeight/2, width: kScreenWidth - 20, height: 20))
                label.text = title
                label.textColor = UIColor(hexString: "#A7ADB4")
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                label.sizeToFit()
                bgView?.addSubview(label)
            }
        }
    }
}
extension String {
    
    //获取子字符串
    func substingInRange(r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.characters.count{
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return self.substring(with:startIndex..<endIndex)
    }
    

    // 是否全是数字
    var isPureInt: Bool {
        let scan = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    // 16进制
    var isHexCharacter: Bool {
        let regex = "^[0-9a-fA-F]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    //用户名验证（允许使用小写字母、数字、下滑线、横杠，一共4~20个字符）
    var isFormatNick:Bool{
        let regex = "^[a-zA-F0-9_-]{4,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    /// 密码限制
    var isProperPassword: Bool {
        if self.characters.count < 6 {
            return false
        }
        let regex = "^[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    /// 验证手机号
    var isPhoneNumber: Bool {
        let regex = "^((13[0-9])|(14[5,7,9])|(15[^4,\\D])|(17[^2,^4,^9,\\D])|(18[0-9]))\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    /// 验证座机和手机号
    var isPhoneandFixedNumber: Bool {
        let regex = "^((13[0-9])|(14[5,7,9])|(15[^4,\\D])|(17[^2,^4,^9,\\D])|(18[0-9]))\\d{8}$"
        
        let strNum = "^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|14[5|7|9]|15[0-9]|17[0|1|3|5|6|7|8]|18[0-9])\\d{8}$)";
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let fixedLinepredicate = NSPredicate(format: "SELF MATCHES %@", strNum)
        
        if predicate.evaluate(with: self) ==  true || fixedLinepredicate.evaluate(with: self) ==  true{
            return true
        }else{
            return false
        }
        //        return predicate.evaluate(with: self)
    }
    /// 验证邮编号
    var isZipcode: Bool {
        let regex = "[1-9]\\d{5}(?!\\d)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    /// 精确验证身份证号
    var isIDCard: Bool {
        var msg: String
        let count = self.characters.count
        if count != 18, count != 15 {
            msg = "中国公民身份证的长度应为15位或者18位，而您输入的长度为: \(self.characters.count)位"
            print(msg)
            return false
        }
        // 地区码
        let areas = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
        let areaCode = self.substring(to: self.at(2))
        if !areas.contains(areaCode) {
            print("不存在地区码: \(areaCode)")
            return false
        }
        var id = self
        if count == 15 {
            // 将15位转为18位
            id.insert(Character("1"), at: self.at(6))
            id.insert(Character("9"), at: id.at(7))
            id.append("1")
            print("15位: \(self), 被转为18位: \(id)")
        }
        let year = Int(id.substring(with: id.at(6)..<id.at(10)))!
        var regular = "^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9X]$"
        // 闰年
        if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) {
            regular = "^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9X]$"
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", regular)
        let isMatch = predicate.evaluate(with: id)
        if count == 15, isMatch {
            print("满足15位身份证格式")
            return true
        }
        // 18 位
        if isMatch {
            // 校验位计算，对应系数
            let conefficient = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
            var num = 0
            for i in 0..<count - 1 {
                num += Int(self.substring(with: self.at(i)..<self.at(i + 1)))! * conefficient[i]
            }
            // 结果校验码
            let checkCode = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"]
            if checkCode[num % 11] == self.substring(from: self.index(before: self.endIndex)) {
                print("满足18位身份证格式")
                return true
            } else {
                print("校验码不对, 正常应为: \(checkCode[num % 11])")
            }
        } else {
            print("可能年月日格式不对")
        }
        return false
    }
    
    func at(_ index: String.IndexDistance) -> String.Index {
        return self.index(self.startIndex, offsetBy: index)
    }
    public func stringToAttributed(size:CGFloat,str:String) -> NSMutableAttributedString{
        let attributed = NSMutableAttributedString(string: str)
        attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hexString: "#BF191B"), range: NSMakeRange(0, str.characters.count - 3))
        attributed.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: size), range: NSMakeRange(0, str.characters.count - 3))
        return attributed
        
    }
    public func stringToAttributedColor(startColor:UIColor,string:String,ranStr:String)->NSMutableAttributedString{
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
        let str = NSString(string: string)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSForegroundColorAttributeName, value: startColor, range: theRange)
        
        return  attrstring
    }
}

extension UIBarButtonItem {
    convenience init(title: String, target: Any?, action: Selector?) {
        self.init(title: title, style: .done, target: target, action: action)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hexString: "#ffffff"), NSFontAttributeName: UIFont.systemFont(ofSize: 16)], for: .normal)
    }
}
extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
extension UIColor {
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner   = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        
        if scanner.scanHexInt32(&color) {
            self.init(hex: color)
        }
        else {
            self.init(hex: 0x000000)
        }
    }
    public convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var log = "121.495832"
    var lag = "31.166807"
    var city = "上海市"
    
    static var shared = LocationManager()
    
    private override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.distanceFilter = 100
        manager.requestWhenInUseAuthorization()
        
        updateLocation()
    }
    
    func updateLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            manager.startUpdatingLocation()
            print("定位开始")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let coordinate: CLLocationCoordinate2D = (location?.coordinate)!
        manager.stopUpdatingLocation()
        
        print(coordinate.longitude)
        print(coordinate.latitude)
        
        lag = String(coordinate.latitude)
        log = String(coordinate.longitude)
        
        lonLatToCity(location: location!)
    }
    
    func lonLatToCity(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) -> Void in
            if error == nil {
                let mark = placemark?.first
                //这个是城市
                self.city = mark?.addressDictionary?["City"] as? String ?? "上海市"
            }
        }
    }
}


