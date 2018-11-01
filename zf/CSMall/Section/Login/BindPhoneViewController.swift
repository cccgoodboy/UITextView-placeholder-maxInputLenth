//
//  BindPhoneViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class BindPhoneViewController: UIViewController {
    @IBOutlet weak var codeBtn: UIButton!
    var log = ""
    var lag = ""
    var username = ""
    var header_img = ""
    var currentNum = ""
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    var loginType:LoginType?
    var openid = ""
    var state = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "绑定手机号"
        loadData()
        log = LocationManager.shared.log
        lag = LocationManager.shared.lag
        codeBtn.backgroundColor = themeColor
        loginBtn.backgroundColor = themeColor

        // Do any additional setup after loading the view.
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
    @IBAction func itemClick(_ sender: UIButton) {
        view.endEditing(true)
        
        switch sender.tag {
        case 1:
            let phone = phoneTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            print("登录")
            if !(phone?.isPhoneNumber)!{
                ProgressHUD.showMessage(message: "请输入正确的手机号")
                return
            }
            
            let pwd = pwdTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            if (pwd?.isEmpty)!{
                ProgressHUD.showMessage(message: "请输入验证码")
                //                ProgressHUD.showMessage(message: "请输入密码")
                return
            }
//            var currentNum = ""
//            let languages = Locale.preferredLanguages.first
//
//            if (languages?.contains("en"))!{//英文环境
//                currentNum = "86"
//
//            }else if (languages?.contains("zh"))!{
//                currentNum = "63"
//            }else{
//                currentNum = "63"
//            }
//            let mobile = "\(currentNum)\(phone!)"
            let mobile = "\(currentNum )\(phoneTF.text!)"
            NetworkingHandle.fetchNetworkData(url:"/api/login/third_login", at: self, params: ["mobile":mobile,"yzm":pwd!,"log":log,"lag":lag,"openid":openid,"state":state,"username":username,"header_img":header_img],  success: { (response) in
                ProgressHUD.showSuccess(message: "登录成功")
                
                if let data = response["data"] as? NSDictionary{
                    CSUserInfoHandler.saveUserInfo(model:CSUserInfoModel.deserialize(from: data)!)
                    
                    self.loginSuccess()
                }
                
                
            }, failure: {
                
            })
            

       
        case 6:
            print("获取验证码")
            if !(phoneTF.text?.isPhoneNumber)!{
                ProgressHUD.showMessage(message: "请输入正确的手机号")
                return
            }
            
            resignTextField()
            
            if HaveNetwork.isHaveNetwork() == false{
                ProgressHUD.showNoticeOnStatusBar(message: "似乎网络已经断开了")
                return
            }
            let mobile = "\(currentNum )\(phoneTF.text!)"
            NetworkingHandle.fetchNetworkData(url: "/api/login/sendSMS", at: self, params: ["mobile": mobile,"state":state], isShowHUD: false, isShowError: true, success: { (response) in
                let a = fetchVerificationCodeCountdown(button: self.codeBtn, timeOut: 60)
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
        default:
            print("")
        }
    }
    func resignTextField() -> () {
        
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
