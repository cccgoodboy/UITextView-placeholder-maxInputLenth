//
//  AppDelegate.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/26.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import LocalAuthentication
import Bugly
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate{
    var isRotation = false
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isRotation {
            return .all
        } else {
            return .portrait
        }
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //bugly
        
        Bugly.start(withAppId: "ed5e58151d")
        //paypal
        
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                                PayPalEnvironmentSandbox: "YOUR_CLIENT_ID_FOR_SANDBOX"])
        
        let config = PayPalConfiguration()
        config.acceptCreditCards = false
        config.merchantName = "中菲购"
        config.payPalShippingAddressOption = .payPal
        config.languageOrLocale = Locale.preferredLanguages[0]
        config.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        config.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        PayPalConfig.payPal.config = config
        
        
        PLStreamingEnv.initEnv()
        
        //注册微信sdk
        WXApi.registerApp(WXAppKey)
        
//         WXApi.registerApp("wxf27a06796405c589")
        
//        if let  arr =  UserDefaults.standard.object(forKey: "AppleLanguages") as? NSArray
//        {
//            if (arr.firstObject as! String) == "zh-Hans-US"{//简体中文
//                BaseURL = "http://dspx1.tstmobile.com/"
//            }else{
//                BaseURL = "http://dspx1.tstmobile.com/"
//            }
//        }
        
        LocationManager.shared.updateLocation()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true //点击背景收起键盘
//        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = UMAppId
       UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: WXAppKey, appSecret: WXSecret, redirectURL: "")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: QQAppId, appSecret:QQAppKey, redirectURL: "")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.facebook, appKey: FacebookAppId, appSecret:FacebookAppKey, redirectURL: "https://developers.facebook.com")

        
//        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "3035553764", appSecret:"9cd003507b311d4856c91d5ca88109e3", redirectURL: "http://longmaitv.com")
        
        let options = EMOptions(appkey: EMAppKey)
        options?.apnsCertName = ""
        EMClient.shared().initializeSDK(with: options!)
        
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: nil, apsForProduction: false)
        
        JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue, categories: nil)
        
        
        if CSUserInfoHandler.getIdAndToken() != nil {
            
            if let m = CSUserInfoHandler.getUserHXInfo(), EMClient.shared().isLoggedIn == false, EMClient.shared().isAutoLogin == false {
                EMClient.shared().login(withUsername: m.name, password: m.pw, completion: { str, error in
                    
                    if error == nil {
                        print("环信登录成功")
                        EMClient.shared().options.isAutoLogin = true
                    } else {
                        print("环信登录失败")
                    }
                })
            }
        }
       
        self.LoadRoot()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue:"changeLanguage"), object: nil)
//        upgradeVersion()

        return true
    }
    func changeLanguage() {
        self.LoadRoot()
    }
//    func upgradeVersion(){
//
//        NetworkingHandle.fetchNetworkData(url: "/api/tools/upgrade", at: (self.window?.rootViewController!)!, params: ["version":"ios_version"],isShowHUD: false, isShowError: false ,success: { (result) in
//
////            if let url = (result["data"] as? [String:Any] )?["version"] as? String {
//
//                let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//
//                if Double(localVersion)! <=  Double(((result["data"] as? [String:Any] )?["version"] as? String)!)! {
//
//                    UserDefaults.standard.set(1, forKey: "version_zfg_user")
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatetabbar"), object: nil)
////
//
////                    let alert = UIAlertController(title: "更新可用", message: "\(Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? "")的新版本可用，请立即更新至\( (result["data"] as? [String:Any] )?["version"] ?? "1.0")。", preferredStyle: .alert)
////                    let action_sure = UIAlertAction(title: "更新", style: .default) { (action) in
////                        let urla = NSURL(string: url)
////                        UIApplication.shared.openURL(urla! as URL)
////                    }
////                    let action_cancel = UIAlertAction(title: "下一次", style: .cancel, handler: nil)
////                    alert.addAction(action_sure)
////                    alert.addAction(action_cancel)
////
////                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//
//                }else{
//                    UserDefaults.standard.set(0, forKey: "version_zfg_user")
//
//                }
//
////            }
//        }) {
//
//        }
//    }
    
//    func evaluateAuthenticate(){
//        let a = LAContext()
//        let error = NSError()
//        if let ass = a.canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics)), error: error){
//            if a.evaluateAccessControl(<#T##accessControl: SecAccessControl##SecAccessControl#>, operation: <#T##LAAccessControlOperation#>, localizedReason: <#T##String#>, reply: <#T##(Bool, Error?) -> Void#>)
//
//
//        }
//
//    }
    func LoadRoot() {
        if (!(UserDefaults.standard.bool(forKey: "everLaunched"))) {
            UserDefaults.standard.set(true, forKey:"everLaunched")
            let guid = GuideViewController()
            self.window?.rootViewController = guid
            print("guideview launched!")
            
        }else{
            let tabbar = BaseTabbarController()
            self.window?.rootViewController = tabbar
            
        }
    }
  
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return WXApi.handleOpen(url, delegate: self)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    //ping++ 支付结果
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let str = String(describing: url)
        
        if str.range(of: "pay/?") != nil {// wxd6947c3b60efcddb://pay/?returnKey=(null)&ret=-2
            if str.range(of: "wxd6947c3b60efcddb://pay") != nil{
                if let data = str.components(separatedBy: "&").last?.components(separatedBy: "=").last{
                    if data == "-2"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payFail"), object: nil)
                    }else {// 0
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
                    }
                }
                return WXApi.handleOpen(url, delegate: self)

            }else{
                AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
                    if let str = resultDic?["resultStatus"] as? String{
                        if  str == "9000"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paySuccess"), object: nil)

                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payFail"), object: nil)

                    }
                    }
                    
                }
                return true
            }
            

           
            //                    if  err == nil {
            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
            //                    } else {
            //                        print(err?.getMsg() ?? "")
            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payFail"), object: nil)
            //                    }
            
        }else{
            return UMSocialManager.default().handleOpen(url)
            
        }
        
        //        if str.range(of: "pay/?") != nil {
        //            let canHandleUrl = Pingpp.handleOpen(url) { (result, err) in
        //                if  err == nil {
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
        //                } else {
        //                    print(err?.getMsg() ?? "")
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payFail"), object: nil)
        //                }
        //            }
        //            return canHandleUrl
        //        } else {
        //        }
    }

    func onReq(_ req: BaseReq!) {
        print("req++++++++++++++++\(req)")
        //                    if  err == nil {
        //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
        //                    } else {
        //                        print(err?.getMsg() ?? "")
        //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payFail"), object: nil)
        //                    }

        
//        if req.type == ConstantsAPI. {//ConstantsAPI.COMMAND_PAY_BY_WX{
//            Log.d(TAG,"onPayFinish,errCode="+resp.errCode);
//            AlertDialog.Builderbuilder=newAlertDialog.Builder(this);
//            builder.setTitle(R.string.app_tip);
//        }
        
    }

}

