//
//  ForgetPwdVC.swift
//  FYH
//
//  Created by 梁毅 on 2017/6/20.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class ForgetPwdVC: BaseViewController {

    @IBOutlet weak var obtainCodeBtn: UIButton!
    @IBOutlet weak var PwdsTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    // tag 1 验证码 2确认
    @IBAction func itemClick(_ sender: UIButton)  {
        
        
        if !(phoneTF.text?.isPhoneNumber)!{
            
            ProgressHUD.showMessage(message: "请输入正确的手机号")
            return
        }
        if sender.tag == 1{
            resignTextField()
            NetworkingHandle.fetchNetworkData(url: "settingInterfaces.api?sendCode", at: self, params:  ["mobile": phoneTF.text!, "code_type": "forget_passwrod"], isShowHUD: false, isShowError: true, success: { (response) in
                let a = fetchVerificationCodeCountdown(button: self.obtainCodeBtn, timeOut: 60)
                print(a)
                ProgressHUD.showMessage(message: response["data"] as? String ?? "验证码发送成功，请注意查收")
                
            })
        }else{
            if (codeTF.text?.isEmpty)!{
                
                ProgressHUD.showMessage(message: "请输入验证码")
                return
            }
            if (pwdTF.text?.isEmpty)!{
                
                ProgressHUD.showMessage(message: "请输入密码")
                return
            }
            if pwdTF.text != PwdsTF.text{
                
                ProgressHUD.showMessage(message: "两次密码不一致")
                return
            }
            
            NetworkingHandle.fetchNetworkData(url: "memberInterfaces.api?memberForgetPassword", at: self, params: ["member_account": phoneTF.text!, "code":self.codeTF!,"member_password":pwdTF.text!], success: { (response) in
                                ProgressHUD.showMessage(message: "密码修改成功")
                
                self.navigationController?.popViewController(animated: true)
                
            }, failure: {
                
            })
            
            
        }
    }
    func resignTextField() -> () {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBA(r: 240, g: 240, b: 241, a: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = RGBA(r: 48, g: 195, b: 166, a: 1)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.automaticallyAdjustsScrollViewInsets = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
