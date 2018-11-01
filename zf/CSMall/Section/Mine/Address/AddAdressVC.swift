//
//  AddAdressVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/3.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddAdressVC: UIViewController {
   
    
    var model:AddressModel?
    var addressType = 0 //0 新增地址   1是
    
    @IBOutlet weak var titileLab: UILabel!
    @IBOutlet weak var defaultView: UIView!
    
    @IBOutlet weak var a_nameTF: UITextField!
    
    @IBOutlet weak var a_PhoneTF: UITextField!
    
    @IBOutlet weak var a_areaBtn: UIButton!
    
    @IBOutlet weak var a_codeTF: UITextField!
    
    @IBOutlet weak var a_detailTF: UITextField!
    
    @IBOutlet weak var defaultaddressBtn: UIButton!
    
    var province = ""
    var city = ""
    var country = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        self.modalPresentationStyle = .custom
        
        if addressType == 1{//修改地址
            titileLab.text = "编辑收货地址"
            province =  model?.address_province ?? ""
            city = model?.address_city ?? ""
            country = model?.address_country ?? ""
            if model?.is_default == "1"{
                defaultView.isHidden = true
            }else{
                defaultView.isHidden = false
            }
            
            a_nameTF.text = model?.address_name
            a_PhoneTF.text = model?.address_mobile
            a_areaBtn.setTitle("\(model?.address_province ?? "")-\(model?.address_city ?? "")-\(model?.address_country ?? "")", for: .normal)
            a_areaBtn.setTitleColor(UIColor.black, for: .normal)
            a_detailTF.text = model?.address_detailed
            a_codeTF.text = model?.address_zip_code
            defaultaddressBtn.isSelected = model?.is_default == "1" ? true: false
            
        }else{
            titileLab.text = "新增收货地址"
            defaultView.isHidden = true
        
        }
    }
    @IBAction func dismisClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func defaultaddressClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        NetworkingHandle.fetchNetworkData(url: "/api/Address/saveDefaultAddress", at: self, params: ["address_id":(model?.address_id)!], success: { (response) in
            
            ProgressHUD.showMessage(message: "默认地址设置成功")
            
        }) { 
            
        }
        
    }
    
    
    @IBAction func commitClick(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        let  name = a_nameTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if name?.characters.count == 0 || name == nil {
            sender.isEnabled = true
            ProgressHUD.showMessage(message: "请填写收货人姓名")
            return
        }
        
        let phone = a_PhoneTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
//        if !(phone!.isPhoneNumber){
//
//            ProgressHUD.showMessage(message: "请输入正确的手机号")
//            return
//        }
        
        let  addressdetail = a_detailTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if addressdetail?.characters.count == 0 || name == nil {
            sender.isEnabled = true
            ProgressHUD.showMessage(message: "请填写详细地址")
            return
        }
        
//        if province == ""{
//            ProgressHUD.showMessage(message: "请选择省市区")
//            return
//
//        }
        
        if addressType == 0{
        
        
            NetworkingHandle.fetchNetworkData(url: "/api/Address/insertAddress", at: self, params: ["address_mobile":phone!,"address_name":name ?? "","address_province":province,"address_city":city,"address_country":country,"address_detailed":addressdetail ?? "","address_zip_code":a_codeTF.text ?? ""], success: { (response) in
                sender.isEnabled = true
                ProgressHUD.showMessage(message: "地址添加成功")
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSuccess"), object: nil, userInfo: nil)
            }, failure: {
                sender.isEnabled = true
            })

        }else{
        
            
            NetworkingHandle.fetchNetworkData(url: "/api/Address/saveAddress", at: self, params: ["address_id":(model?.address_id)!,"address_mobile":phone!,"address_name":name ?? "","address_province":province,"address_city":city,"address_country":country,"address_detailed":addressdetail ?? "","address_zip_code":a_codeTF.text ?? ""], success: { (response) in
                sender.isEnabled = true
                ProgressHUD.showMessage(message: "地址修改成功")
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSuccess"), object: nil, userInfo: nil)
            }, failure: {
                sender.isEnabled = true
            })
        }
        
     
    }
    
    
    @IBAction func selectClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let v = ProvinceCityDistrictChoice(frame: CGRect.init(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight))
        v.show(choiced: { [unowned self] (p, c, d) in
            sender.setTitle("\(p)-\(c)-\(d)", for: .normal)
            self.province = p
            self.city = c
            self.country = d
            sender.setTitleColor(UIColor.black, for: .normal)
        })
        self.view.addSubview(v)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
