//
//  ToApplyViewController.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class ApplyInfo: NSObject {
    
    var label: String?
    var place: String?
    var content: String?
    
    
    func initWithLabel(label: String, place: String, content: String) -> ApplyInfo{
        self.label = label
        self.place = place
        self.content = content
        return self
    }
}


class ToApplyViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var merchants_account_id:String?
    var regisetrModel = RegisterInfoModel()
    
    var info:CSUserInfoModel!
    @IBOutlet weak var tableView: UITableView!
    var contents = [ApplyInfo]()
    
    var name: String?
    var phone: String?
    var shopName: String?
    var shopAddress: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "商家入驻申请"
        
        contents = [ApplyInfo().initWithLabel(label: NSLocalizedString("Name", comment: "姓名"), place: NSLocalizedString("Pleaseenteryourname", comment: "请输入您的姓名"), content: ""),
                    ApplyInfo().initWithLabel(label:
                        NSLocalizedString("ContactTel", comment: "联系电话"), place: NSLocalizedString("PleaseenteryourcontactTel", comment: "请输入您的联系电话"), content: ""),
                    ApplyInfo().initWithLabel(label: "店铺名称", place: "请输入您的店铺名称", content: ""),
                    ApplyInfo().initWithLabel(label: "店铺地址", place: "请选择您店铺的所在区域", content: ""),
                ApplyInfo().initWithLabel(label: "详细地址", place: "请输入您的店铺详细地址", content: ""),
                ApplyInfo().initWithLabel(label: "统一社会信用代码", place: "请输入统一社会信用代码(18位)", content: "")]
        
        tableView.register(UINib.init(nibName: "ToApplyProtocolCell", bundle: nil), forCellReuseIdentifier: "ToApplyProtocolCell")
        tableView.register(UINib.init(nibName: "ToApplyInfosCell", bundle: nil), forCellReuseIdentifier: "ToApplyInfosCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.reset()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return contents.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ToApplyProtocolCell", for: indexPath)
            return cell
        }else {//if indexPath.section == 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToApplyInfosCell", for: indexPath) as! ToApplyInfosCell
            if indexPath.row == 1{
                cell.t_contentTF.keyboardType = .numberPad
                NotificationCenter.default.addObserver(self, selector: #selector(phoneNoti(noti:)), name: NSNotification.Name.UITextFieldTextDidChange, object: cell.t_contentTF)
                
            }
            if  indexPath.row == 5 {
                cell.t_contentTF.keyboardType = .numbersAndPunctuation
            }
            if indexPath.row == 3{
                cell.infoBtn.isHidden = false
                self.view.endEditing(true)
                
                cell.infoBtnClickBlock = {
                    self.view.endEditing(true)
                    let v = ProvinceCityDistrictChoice(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                    
                    v.show(choiced: { [unowned self] (p, c, d) in
                        self.regisetrModel.merchants_province = p
                        self.regisetrModel.merchants_city = c
                        self.regisetrModel.merchants_country = d

//                        sender.setTitle("\(p)-\(c)-\(d)", for: .normal)
//                        self.province = p
//                        self.city = c
//                        self.country = d
//                        sender.setTitleColor(UIColor.black, for: .normal)
                        cell.t_contentTF.text = "\(p)-\(c)-\(d)"
                    })
                    self.view.addSubview(v)

                }
            }else{
                cell.infoBtn.isHidden = true

            }
            cell.t_titleLab.text = contents[indexPath.row].label
            cell.t_contentTF.placeholder = contents[indexPath.row].place
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let web = MDWebViewController()
            web.title = NSLocalizedString("Businessadmissionagreement", comment: "商家入驻协议")
            web.url = userAgerementURL + "3"
            self.navigationController?.pushViewController(web, animated: true)
        }
    }
    func phoneNoti(noti:Notification){
        if  let tf = noti.object as? UITextField{
            
            if (tf.text!.characters.count > 11) {
                let str = tf.text!.substring(to: tf.text!.at(11))
                tf.text = str
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return section == 0 ? CGFloat.leastNormalMagnitude : 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 10 : 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let headerView = UIView()
            let showText = UILabel()
            showText.frame =  CGRect.init(x: 15, y: 0, width: 200, height: 30)
            showText.text = NSLocalizedString("Fillininformation", comment: "填写入驻信息")
            showText.textColor = UIColor.init(hexString: "#666666")
            showText.font = UIFont.systemFont(ofSize: 12)
            headerView.addSubview(showText)
            return headerView
        }else{
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1{
            let headerView = UIView()
            let commitBtn = UIButton.init(type: .custom)
            commitBtn.frame =  CGRect.init(x: 30, y: 50, width: kScreenWidth - 60, height: 45)
            commitBtn.setTitle(NSLocalizedString("Next", comment: "下一步"), for: .normal)
            commitBtn.layer.masksToBounds = true
            commitBtn.layer.cornerRadius = 4.0
            commitBtn.backgroundColor = RGBA(r: 48, g: 195, b: 166, a: 1)
            commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            commitBtn.addTarget(self, action: #selector(commitInfo), for: .touchUpInside)
            headerView.addSubview(commitBtn)
            return headerView
        }else{
            return UIView()
        }
    }
    func commitInfo(){
        
        for i in 0..<contents.count{
            let cell = tableView.cellForRow(at: NSIndexPath.init(row: i, section: 1) as IndexPath) as! ToApplyInfosCell
            let str = cell.t_contentTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            if  i == 1{

                if str?.count == 0
                {
                    ProgressHUD.showMessage(message: NSLocalizedString("Pleaseenterthecorrectphonenumber", comment: "请输入正确的电话号码"))
                    return
                }
                regisetrModel.contact_mobile = str
            }
            if str == ""{
                ProgressHUD.showMessage(message: contents[i].place!)
                return
            }
            contents[i].content = str
            if i == 0{
                regisetrModel.contact_name = str
            }
            else if i == 2{
                regisetrModel.merchants_name = str
            }
            else if i == 4{
                regisetrModel.merchants_address = str
            }
            else if i == 5{
                
                regisetrModel.business_number = str
            }
        }
        if regisetrModel.merchants_city == nil{
            ProgressHUD.showMessage(message:NSLocalizedString("Pleasechoosethecity", comment: "请选择所在的城市"))
            return
        }else{
            NetworkingHandle.fetchNetworkData(url: "/api/Merchant/message_authentication", at: self, params: ["contact_name":regisetrModel.contact_name!,"contact_mobile":(regisetrModel.contact_mobile)!,"merchants_name":regisetrModel.merchants_name!,"merchants_address":regisetrModel.merchants_address!,"business_number":regisetrModel.business_number!,"merchants_province":regisetrModel.merchants_province!,"merchants_city":regisetrModel.merchants_city!,"merchants_country":regisetrModel.merchants_country!], isShowHUD: false, isShowError: true, success: { (response) in
                let upload = UploadIdentityViewController()
                upload.info = self.contents
                upload.shopInfo = self.info
                upload.registerModel = self.regisetrModel
                self.navigationController?.pushViewController(upload, animated: true)
            }) {
                
            }
        }
       
        
    }
    
}
