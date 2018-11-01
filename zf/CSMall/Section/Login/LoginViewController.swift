//
//  LoginViewController.swift
//  FYH
//
//  Created by 梁毅 on 2017/6/17.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import SwiftyJSON

enum LoginType {
    
 case login_normal// 常规需要登录
    
    
 case login_tokenFile//token失效
    
    
}
extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

class LoginViewController: ViewController {
    var log = ""
    var lag = ""
 
    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!
    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var languageSeg: UISegmentedControl!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    // tag 1 登录 2注册 3忘记密码 4微信登录 5微博登录 6获取验证码 7用户协议 8qq
    var currentNum:String?
    var type:Int?
    @IBOutlet weak var tuiteBtn: UIButton!
    var loginType:LoginType?
    @IBOutlet weak var obtainCodeBtn: UIButton!
    @IBAction func itemClick(_ sender: UIButton) {
        view.endEditing(true)
        
        switch sender.tag {
        case 1:
//            NetworkingHandle.fetchNetworkData(url: "/api/pingxx/alipay", at: self, success: { (result) in
//
//                AlipaySDK.defaultService().payOrder(result["data"] as! String, fromScheme: "", callback: { (reult) in
//
//                })
//
//            }) {
//
//            }
            
            let phone = phoneTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            guard phone != "" && phone != nil else{
                ProgressHUD.showMessage(message: NSLocalizedString("Hint_83", comment: "请输入正确的手机号"))

                return
            }
//            print("登录")
//            if !(phone?.isPhoneNumber)!{
//                ProgressHUD.showMessage(message: "请输入正确的手机号")
//                return
//            }

            let pwd = pwdTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

            if (pwd?.isEmpty)!{
                ProgressHUD.showMessage(message: "请输入验证码")
                //                ProgressHUD.showMessage(message: "请输入密码")
                return
            }
            let mobile = "\(currentNum ?? "")\(phoneTF.text!)"
            NetworkingHandle.fetchNetworkData(url:"/api/login/message_login", at: self, params: ["mobile":mobile,"yzm":pwd!,"log":log,"lag":lag],  success: { (response) in
                ProgressHUD.showSuccess(message: "登录成功")

                if let data = response["data"] as? NSDictionary{
                    CSUserInfoHandler.saveUserInfo(model:CSUserInfoModel.deserialize(from: data)!)

                    self.loginSuccess()
                }


            }, failure: {

            })

        case 2:
          
            print("注册")
            let register = UIStoryboard.init(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC")
            self.navigationController?.pushViewController(register, animated: false)
        case 3:
            print("忘记密码")
            let register = UIStoryboard.init(name: "LoginStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ForgetPwdVC")
            self.navigationController?.pushViewController(register, animated: true)
        case 4:
            print("微信登录")

            UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: self) { (result, error) in
                
                if let data = result as? UMSocialUserInfoResponse {
                    let id = data.openid ?? data.uid
                    self.isExistMember(state: "1", openid: id!,header_img: data.iconurl,username: data.name)
//                    let param = ["lag": self.lag, "log": self.log, "state": 1, "openid": id!,"img":data.iconurl,"name": data.name] as [String : Any]
                    
                }
            }
            break
        case 5://facebook

            UMSocialManager.default().getUserInfo(with: .facebook, currentViewController: self) { (result, error) in
                if let data = result as? UMSocialUserInfoResponse {
                    let id = data.openid ?? data.uid
                    self.isExistMember(state: "5", openid: id!,header_img: data.iconurl,username: data.name)
                    
                    //                    let param = ["lag": self.lag, "log": self.log, "state": 1, "openid": id!,"img":data.iconurl,"name": data.name] as [String : Any]
                    
                }
            }
            break
        case 8://qq
            
            UMSocialManager.default().getUserInfo(with: .QQ, currentViewController: self) { (result, error) in
                
                if let data = result as? UMSocialUserInfoResponse {
                    let id = data.openid ?? data.uid
                    self.isExistMember(state: "2", openid: id!,header_img: data.iconurl,username: data.name)
                    //                    let param = ["lag": self.lag, "log": self.log, "state": 1, "openid": id!,"img":data.iconurl,"name": data.name] as [String : Any]
                    
                }
            }
            break

//            UMSocialManager.default().auth(with: .wechatSession, currentViewController: self) { (result, error) in
//                if let data = result as? UMSocialAuthResponse {
//                    let id = data.openid ?? data.uid
//                    let param = ["lag": self.lag, "log": self.log, "state": "1", "openid": id!]
//                    NetworkingHandle.fetchNetworkData(url: "Login/login", at: self, params: param, success: { (response) in
//                        let data = response["data"]
//                        let userModel = DLUserInfoModel.modelWithDictionary(diction: data as! Dictionary<String, AnyObject>)
//                        DLUserInfoHandler.saveUserInfo(model: userModel)
//                        ProgressHUD.showSuccess(message: "登录成功")
//                        UIApplication.shared.keyWindow?.rootViewController = BaseTabbarController()
//                    })
//                }
//            }
        case 6:
            
            
            
            
            print("获取验证码")
//            if !(phoneTF.text?.isPhoneNumber)!{
//                ProgressHUD.showMessage(message: "请输入正确的手机号")
//                return
//            }

            resignTextField()

            if HaveNetwork.isHaveNetwork() == false{
                ProgressHUD.showNoticeOnStatusBar(message: "似乎网络已经断开了")
                return
            }
            let mobile = "\(currentNum ?? "")\(phoneTF.text!)"
            
            NetworkingHandle.fetchNetworkData(url: "/api/login/sendSMS", at: self, params: ["mobile": mobile], isShowHUD: false, isShowError: true, success: { (response) in
                let a = fetchVerificationCodeCountdown(button: self.obtainCodeBtn, timeOut: 60)
                print(a)
                ProgressHUD.showMessage(message: response["data"] as? String ?? "验证码发送成功，请注意查收")
            });
            break
        case 7:
            let web = MDWebViewController()
            web.title = "用户协议"
            web.url = userAgerementURL + "15"
            self.navigationController?.pushViewController(web, animated: true)
            break
            
        case 10086:

            UMSocialManager.default().getUserInfo(with: .facebook, currentViewController: self) { (result, error) in
                if let data = result as? UMSocialUserInfoResponse {
                    let id = data.openid ?? data.uid
                    self.isExistMember(state: "4", openid: id!,header_img: data.iconurl,username: data.name)
                    
                    //                    let param = ["lag": self.lag, "log": self.log, "state": 1, "openid": id!,"img":data.iconurl,"name": data.name] as [String : Any]
                    
                }
            }
            break
        default:
            print("")
        }
    }

    
  
    @IBAction func selectLanguage(_ sender: Any) {
        
        let seg:UISegmentedControl = sender as! UISegmentedControl
        
        if seg.selectedSegmentIndex == 0 {
            setLanguage(langeuage: "zh-Hans")
        }else{
            setLanguage(langeuage: "en")
        }
    }
    func setLanguage(langeuage: String) {
        var str = langeuage
        let def = UserDefaults.standard
//        var bundle : Bundle?
        let languages:[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        
        
        if langeuage == "" {
            
            let languages:[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
            let str2:String = languages[0]
            
            if ((str2=="zh-Hans-CN")||(str2=="zh-Hans"))
            {
                str = "zh-Hans"
            }else
            {
                str="en"
            }
            
        }
        
        //语言设置
        def.set([str], forKey: "AppleLanguages")
        def.synchronize()
        Bundle.main.onLanguage()
        NotificationCenter.default.post(name: NSNotification.Name("changeLanguage"), object: self, userInfo: ["":""])
        
//        let path = Bundle.main.path(forResource:str , ofType: "lproj")
//        bundle = Bundle(path: path!)
    }
    
    func isExistMember(state:String,openid:String,header_img:String,username:String){
        
        if state == "2" {
            NetworkingHandle.fetchTestNetworkData(url: "/api/login/is_exist_member", at: self, params: ["state":state,"openid":openid], success: { (response) in
                
                if let data = response["data"]?.dictionaryValue{
                    print(data);
                    if (data["status"]?.stringValue) == "0"{//未绑定
                        //绑定界面
                        let bind = BindPhoneViewController()
                        bind.loginType = self.loginType
                        bind.state = state
                        bind.openid = openid
                        bind.header_img = header_img
                        bind.username = username
                        self.navigationController?.pushViewController(bind, animated: true)
                    }else{
                        CSUserInfoHandler.saveUserInfo(model:CSUserInfoModel.deserialize(from: data)!)
                        
                        self.loginSuccess()
                    }
                    ProgressHUD.hideLoading(toView: self.view)
                }
            })
        }else{
            NetworkingHandle.fetchNetworkData(url: "/api/login/is_exist_member", at: self, params: ["state":state,"openid":openid], success: { (response) in
                if let data = response["data"] as? NSDictionary{
                    if (data["status"] as? String) == "0"{//未绑定
                        //绑定界面
                        let bind = BindPhoneViewController()
                        bind.loginType = self.loginType
                        bind.state = state
                        bind.openid = openid
                        bind.header_img = header_img
                        bind.username = username
                        self.navigationController?.pushViewController(bind, animated: true)
                    }else{
                        CSUserInfoHandler.saveUserInfo(model:CSUserInfoModel.deserialize(from: data)!)
                        
                        self.loginSuccess()
                    }
                    ProgressHUD.hideLoading(toView: self.view)
                }
            })
        }
        
        

    }
func loginSuccess(){
    
    if let m = CSUserInfoHandler.getUserHXInfo(),EMClient.shared().isLoggedIn == false, EMClient.shared().isAutoLogin == false {
        
        EMClient.shared().login(withUsername: m.name, password: m.pw, completion: { str, error in
            if error == nil {
                print("环信登录成功")
                EMClient.shared().options.isAutoLogin = true
            } else {
                print("环信登录失败")
            }
        })
    }
    if self.loginType == LoginType.login_normal{
        self.dismiss(animated: true, completion: nil)
    }else{
        UIApplication.shared.keyWindow?.rootViewController = BaseTabbarController()
        
    }
    
}
    func resignTextField() -> () {
        
        UIApplication.shared.keyWindow?.endEditing(true)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
//        title = "登录"
        loadData()
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            languageSeg.selectedSegmentIndex = 1
            type = 1
        }else if (languages?.contains("zh"))!{
            languageSeg.selectedSegmentIndex = 0
            type = 0
        }else{
            languageSeg.selectedSegmentIndex = 0
            type = 0
        }
        
        codeBtn.backgroundColor = themeColor
        loginBtn.backgroundColor = themeColor
        
        log = LocationManager.shared.log
        lag = LocationManager.shared.lag
        faceBookBtn.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage.init(named: "fanhui_bai"), style: .plain, target: self, action: #selector(back))
        
        
    }
    func loadData(){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Home/country_num", at: self, params: ["p":"1"], hasHeaderRefresh: nil, success: { (result) in
            if let data = (result["data"]  as? NSDictionary)?["list"] as? NSArray {
                var dataArr:[String] = []
                for dict in data {
                    let dataDict = dict as! Dictionary<String, Any>
                    
                    dataArr.append(dataDict["country_num"] as! String)
                }
                let defaultTitle = dataArr[0]
                self.currentNum = dataArr[0]
                let choices = dataArr
                let rect = CGRect(x: 0, y: 0, width:50, height: 50)
                let dropBoxView = TGDropBoxView(parentVC: self, title: defaultTitle, items: choices, frame: rect)
                dropBoxView.isHightWhenShowList = false
                
                dropBoxView.willShowOrHideBoxListHandler = { (isShow) in
                    if isShow { NSLog("will show choices") }
                    else { NSLog("will hide choices") }
                }
                dropBoxView.didShowOrHideBoxListHandler = { (isShow) in
                    if isShow { NSLog("did show choices") }
                    else { NSLog("did hide choices") }
                }
                dropBoxView.didSelectBoxItemHandler = { (row) in
                    NSLog("selected No.\(row): \(dropBoxView.currentTitle())")
                    self.currentNum = dropBoxView.currentTitle()
                }
                
                self.phoneTF.leftView = dropBoxView
                
                self.phoneTF.leftViewMode = UITextFieldViewMode.always
                
            }
        }) {
            
        }
    }
    func back(){
        view.endEditing(true)
//        phoneTF.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var currentType = 0
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            languageSeg.selectedSegmentIndex = 1
            currentType = 1
        }else if (languages?.contains("zh"))!{
            languageSeg.selectedSegmentIndex = 0
            currentType = 0
        }else{
            languageSeg.selectedSegmentIndex = 0
            currentType = 0
        }
        
        if type != currentType {
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent =  false
        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.navigationBar.barTintColor = themeColor
//        setLuoAnNav(nav: self.navigationController)
        
        if UMSocialManager.default().isInstall(UMSocialPlatformType.QQ){
            qqBtn.isHidden =  false
        }else{
            qqBtn.isHidden =  true
        }
        if UMSocialManager.default().isInstall(UMSocialPlatformType.wechatSession){
            wxBtn.isHidden =  false
        }else{
            wxBtn.isHidden =  true
        }
        
        if UMSocialManager.default().isInstall(UMSocialPlatformType.facebook){
            faceBookBtn.isHidden =  false
        }else{
            faceBookBtn.isHidden =  true
        }
//        if UMSocialManager.default().isInstall(UMSocialPlatformType.facebook){
//            tuiteBtn.isHidden =  false
//        }else{
//            tuiteBtn.isHidden =  true
//        }

    }
    deinit {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension String {
    // MD5 加密字符串
    var MD5: String {
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString()
        for i in 0..<16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}



