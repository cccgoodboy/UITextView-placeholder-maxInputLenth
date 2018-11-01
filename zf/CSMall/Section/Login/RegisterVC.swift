
//
//  RegisterVC.swift
//  FYH
//
//  Created by 梁毅 on 2017/6/17.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class RegisterVC: ViewController {


    
    @IBOutlet weak var phoneTF: UITextField!//手机号
    @IBOutlet weak var codeTF: UITextField!//验证码

    @IBOutlet weak var obtainCodeBtn:
    UIButton!
    
    @IBOutlet weak var pwdsTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!

    @IBOutlet weak var agressBtn: UIButton!//同意协议
    @IBOutlet weak var xieyiBtn: UIButton!
    
    //tag  3 首次输入密码  4再次输入
    @IBAction func showPwdClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 3{
            pwdTF.isSecureTextEntry = !sender.isSelected
        }else{
            pwdsTF.isSecureTextEntry = !sender.isSelected
        }
        
    }
    // tag 1获取验证码 2 注册
    @IBAction func xieyiClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func lookxieyiClick(_ sender: UIButton) {
        let web = MDWebViewController()
        web.title = "服务和隐私条款"
        web.url = userAgerementURL + "3"
        self.navigationController?.pushViewController(web, animated: true)
    }

    @IBAction func registerClick(_ sender: UIButton) {
        
    
//        if !(phoneTF.text?.isPhoneNumber)!{
//
//            ProgressHUD.showMessage(message: "请输入正确的手机号")
//            return
//        }
        if sender.tag == 1{
            resignTextField()
            
            let mobile = PhoneTool.getPhoneNumber(mobile: phoneTF.text!)
            
            let phoneNum = PhoneTool.getPhoneNumber(mobile: mobile)
            
            NetworkingHandle.fetchNetworkData(url: "settingInterfaces.api?sendCode", at: self, params: ["mobile": phoneNum, "code_type": "register"], isShowHUD: false, isShowError: true, success: { (response) in
                let a = fetchVerificationCodeCountdown(button: self.obtainCodeBtn, timeOut: 60)
                print(a)
                ProgressHUD.showMessage(message: response["data"] as? String ?? "验证码发送成功，请注意查收")
            });

            
        }else{
            if (codeTF.text?.isEmpty)!{
                
                ProgressHUD.showMessage(message: "请输入验证码")
                return
            }
            if (pwdTF.text?.isEmpty)!{
                
                ProgressHUD.showMessage(message: "请输入密码")
                return
            }
            if (pwdTF.text?.isEmpty)!{
                
                ProgressHUD.showMessage(message: "请输入密码")
                return
            }
            if agressBtn.isSelected == false{
                ProgressHUD.showMessage(message: "必须同意丑石服务条款")
                return
            }
//            if (invitePhone.text?.isEmpty)!{
//            }
//                else {
//                if !(invitePhone.text?.isPhoneNumber)!{
//                    ProgressHUD.showMessage(message: "邀请人的手机号不正确")
//                    return
//                }
            let mobile = PhoneTool.getPhoneNumber(mobile: phoneTF.text!)
            NetworkingHandle.fetchNetworkData(url: "memberInterfaces.api?registerMember", at: self, params: ["member_account": mobile, "member_password": pwdTF.text!, "code": codeTF.text!,"member_type":"1"], isShowHUD: true, isShowError: true, success: { (response) in
                self.Login()
            });


        
        }
    }

    func resignTextField() -> () {
        UIApplication.shared.keyWindow?.endEditing(true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = RGBA(r: 48, g: 195, b: 166, a: 1)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.automaticallyAdjustsScrollViewInsets = true

        self.title = "注册"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func Login(){
        self.view.endEditing(true)
        NetworkingHandle.fetchNetworkData(url:"memberInterfaces.api?loginMember", at: self, params: ["member_account":phoneTF.text!,"member_password":pwdTF.text!],  success: { (response) in
            if let data = response["data"] as? NSDictionary{
                CSUserInfoHandler.saveUserInfo(model:CSUserInfoModel.deserialize(from: data)!)
            }
            ProgressHUD.showSuccess(message: "登录成功")
            UIApplication.shared.keyWindow?.rootViewController = BaseTabbarController()
            
        }, failure: {
            
        })
        
    }

}
