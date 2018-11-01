
//
//  Conventional.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/20.
//  Copyright © 2017年 tts. All rights reserved.
//
import UIKit
import Foundation

let atUserNotifiction = "atUserNotifiction"

// 直播间环信透传命令
let userApplyConferenceCMD = "applyConference" // 观众申请连麦
let anchorAgreeConferenceCMD = "anchorAgreeConference" // 主播接受连麦申请
let conferenceCMD = "conference" // 主播邀请连麦
let userDisagreeConferenceCMD = "userDisagreeConference" //用户拒绝连麦

let anchorStopLiveCMD = "anchorStopLive" // 主播关闭直播

let settingUpManagerCMD = "settingUpManager" // 设置管理员
let cancelManagerCMD = "cancelManager" //取消管理
let kickoutCMD = "kickout" // 剔出
let blacklistCMD = "balcklist" // 拉黑
let cancelBlacklistCMD = "cancelBlacklist" // 取消拉黑
let disableSendMsgCMD = "disableSendMsg" // 禁言
let ableSendMsgCMD = "ableSendMsg" // 取消禁言

let MerchantsLivingGoodsCMD = "MerchantsLivingGoods" //商家设置直播商品

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kContentHeight = UIScreen.main.bounds.height - 49 - 64
let spaceHeight:CGFloat = 5.0


let urlSchemes = "com.zhengan.zhongfeigou"//丑石

let CommonFontSize  = UIFont.systemFont(ofSize: 12)
let CommonTextColor = RGBA(r:54,g:54,b:54,a:1)
let CommonSepHeight:CGFloat = 5.0
let limit = 10

let CommonBackGroundColor = UIColor.init(hexString: "F6F6F6")
//中菲购
let themeColor = UIColor.init(hexString: "1166F4")
let themeColorString = "0165FF"

let UMAppId = "5a03bad7f29d984166000259"

let WXAppKey = "wxd6947c3b60efcddb"
let WXSecret = "5462c079f23cb6d632477c2e1760f0ec"

let QQAppId = "1106568473"
let QQAppKey = "g5fnxtXQuVLpm8T5"

let FacebookAppId = "614210308926974"
let FacebookAppKey = "47d12eb5cd2bae448f229bf089d23000"

let EMAppKey = "zakj#qiji"//x
let JPushAppKey = "7b411aed8c36576a86e12e4e"//x


public let color_whiteColor = UIColor(hexString: "#ffffff")



//var BaseURL = "http://dspx1.tstmobile.com/"//中菲购
var BaseURL = "http://www.zhongfeigou.com/"//中菲购

let GoodsDetail = "\(BaseURL)webh5/index.html?goods_id="
/********
 
 商家直播协议 id:1
 商家提现协议 id:2
 商户入驻协议 id:3
 商家等级提升规则id:4
  积分的作用6
  如何获得积分7
  不知道怎么购买商品 8
  这里告诉你去哪里看直播9
 主播当前讲的商品在哪买:10
 不知道怎么充值:11
 成为卖家12
 关于我们13
 积分规则 14
 用户协议 15
 ************/
//用户注册协议
let userAgerementURL = "\(BaseURL)/api/Merchant/agreement/id/"

func setLuoAnNav(nav:UINavigationController?){
   let isLuoAn = true
    if isLuoAn{
        nav?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "daohang"), for: .default)
    }else{
        nav?.navigationBar.barTintColor = themeColor
    }
}

func navigationBarTitleViewMargin() -> CGFloat {

    if #available(iOS 11, *){
        return kScreenWidth > 375 ? 20 : 16
    }else{
        return kScreenWidth > 375 ? 12 : 8
    }
}
func scrollercontentInset(sc:UIScrollView?,top:CGFloat,bottom:CGFloat){
    if let _tableView = sc{
        if #available(iOS 11, *){
            _tableView.contentInsetAdjustmentBehavior = .never;
            _tableView.contentInset = UIEdgeInsetsMake(top,0,bottom,0);//64和49自己看效果，是否应该改成0
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }
        else{
        }
    }
}
func defaultFont(size: CGFloat) -> UIFont {
    guard let font = UIFont(name: "PingFang SC", size: size) else {
        return UIFont.systemFont(ofSize: size)
    }
    return font
}
func stringToInt(str:String)->(Int){
    
    let string = str
    var int: Int?
    if let doubleValue = Int(string) {
        int = Int(doubleValue)
    }
    if int == nil
    {
        return 0
    }
    return int!
}
/**
 *  16进制 转 RGBA
 */
func rgbaColorFromHex(rgb:Int, alpha: CGFloat) ->UIColor {
    
    return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                   alpha: alpha)
}
func getLabHeigh(_ labelStr:String,font:CGFloat,width:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
    let dic = [NSFontAttributeName :UIFont.systemFont(ofSize: font)]
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
    return strSize.height
}
func showTextColor(origalStr:String,changStr:String)-> NSAttributedString{

//    let  string = "\(firstMember["nickname"]!) 回复：\(dic["context"]!)"
//    let ranStr = "\(firstMember["nickname"] ?? "")"
    let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:origalStr)
    let str = NSString(string: origalStr)
    let theRange = str.range(of: changStr)
//    attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 79.0/255.0, green: 133.0/255.0, blue: 231.0/255.0, alpha: 1), range: theRange)
    attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hexString: "60401F"), range: theRange)

    return attrstring
}
/*
 时间显示样式
 */
func getShowFormat(requestDate:Date) -> String {
    
    //获取当前时间
    let calendar = Calendar.current
    //判断是否是今天
    if calendar.isDateInToday(requestDate as Date) {
        //获取当前时间和系统时间的差距(单位是秒)
        //强制转换为Int
        let since = Int(Date().timeIntervalSince(requestDate as Date))
        //  是否是刚刚
        if since < 60 {
            return "刚刚"
        }
        //  是否是多少分钟内
        if since < 60 * 60 {
            return "\(since/60)分钟前"
        }
        //  是否是多少小时内
        return "\(since / (60 * 60))小时前"
    }
    
    //判断是否是昨天
    var formatterString = " HH:mm"
    if calendar.isDateInYesterday(requestDate as Date) {
        formatterString = "昨天" + formatterString
    } else {
        //判断是否是一年内
        formatterString = "MM-dd" + formatterString
        //判断是否是更早期
        
        let comps = calendar.dateComponents([Calendar.Component.year], from: requestDate, to: Date())
        
        if comps.year! >= 1 {
            formatterString = "yyyy-" + formatterString
        }
    }
    
    //按照指定的格式将日期转换为字符串
    //创建formatter
    let formatter = DateFormatter()
    //设置时间格式
    formatter.dateFormat = formatterString
    //设置时间区域
    formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
    
    //格式化
    return formatter.string(from: requestDate as Date)
}
/**
 *  16进制 转 RGB
 */
 func rgbColorFromHex(rgb:Int) -> UIColor {
    
    return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                   alpha: 1.0)
}
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor {
   
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

/**
 时间戳转时间
 
 
 :param: timeStamp <#timeStamp description#>
 
 :returns: return time
 */
func timeStampToString(timeStamp:String,format:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:TimeInterval = string.doubleValue
    let dfmatter = DateFormatter()
    dfmatter.timeStyle = .short
    dfmatter.dateStyle = .medium
    dfmatter.dateFormat = format
    
    let date = NSDate(timeIntervalSince1970: timeSta)

    print(dfmatter.string(from: date as Date))
    return dfmatter.string(from: date as Date)
}
func compareNowTime(timeStamp:String,format:String)->Bool {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:TimeInterval = string.doubleValue
    let dfmatter = DateFormatter()
    dfmatter.timeStyle = .short
    dfmatter.dateStyle = .medium
    dfmatter.dateFormat = format
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    let currentDate = Date()
    let result:ComparisonResult = date.compare(currentDate)
   
    if result.rawValue == 1{
        return true
    }else{
        return false
    }
}


class ProgressHUD: NSObject {
    static func showSuccess(message: String) -> () {
        SwiftNotice.showNoticeWithText(.success, text: message, autoClear: true, autoClearTime: 3)
    }
    static func showMessage(message: String) -> () {
        UIApplication.shared.keyWindow?.showMessage(message, interval: 2, position: "center" as AnyObject)
    }
    static func showLoading(toView: UIView, message: String = "努力加载中...") -> () {
        toView.showLoadingTilteActivity(message, position: "center" as AnyObject?)
    }
    static func hideLoading(toView: UIView) -> () {
        toView.hideActivity()
    }
    static func showNoticeOnStatusBar(message: String) {
        SwiftNotice.noticeOnStatusBar(message, autoClear: true, autoClearTime: 3)
    }
    
  
}
extension  NSObject {
    
    func getCurrentController() -> UIViewController? {
        
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        
        var tempView: UIView?
        
        for subview in window.subviews.reversed() {
            
            
            if subview.classForCoder.description() == "UILayoutContainerView" {
                
                tempView = subview
                
                break
            }
        }
        
        if tempView == nil {
            
            tempView = window.subviews.last
        }
        
        var nextResponder = tempView?.next
        
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }
        
        while next{
            
            tempView = tempView?.subviews.first
            
            if tempView == nil {
                
                return nil
            }
            
            nextResponder = tempView!.next
        }
        
        return nextResponder as? UIViewController
    }
}
//  UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium)
// 计算文字高度或者宽度与weight参数无关
extension String {
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.width)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
}

