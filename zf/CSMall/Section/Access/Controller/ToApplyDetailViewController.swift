//
//  ToApplyDetailViewController.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class ToApplyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var regisetrModel = RegisterModel()
    var company:CompanyInfoModel = CompanyInfoModel()
    var info:CSUserInfoModel!
    var type = 0//从验证信息过来得返回直接到首页 == 1

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = NSLocalizedString("Auditingdetails", comment: "入驻审核详情")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "withIdentifier")
        tableView.register(UINib.init(nibName: "ToApplyDetailStateCell", bundle: nil), forCellReuseIdentifier: "ToApplyDetailStateCell")
        tableView.register(UINib.init(nibName: "ApplyDetailDepositCell", bundle: nil), forCellReuseIdentifier: "ApplyDetailDepositCell")
        tableView.register(UINib.init(nibName: "ApplyDetailInfoCell", bundle: nil), forCellReuseIdentifier: "ApplyDetailInfoCell")
        loadData()
        NetworkingHandle.fetchNetworkData(url: "/api/Home/company_info", at: self, isShowHUD: false, isShowError: true, success: { (response) in
            if let data = response["data"] as? NSDictionary{
                self.company = CompanyInfoModel.deserialize(from: data)!
            }
        }) {
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(paySuccess), name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payfail), name: NSNotification.Name(rawValue: "payFail"), object: nil)

        if type == 1{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "fanhui_bai"), style: .done, target: self, action: #selector(back))
        }
    }
    func back(){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    func paySuccess(){
        loadData()
        ProgressHUD.showMessage(message: NSLocalizedString("Paymentsuccess", comment: "付款成功"))
    }
    func payfail() {
        ProgressHUD.showMessage(message: NSLocalizedString("Paymentfailurepleaserepay", comment: "支付失败，请重新支付"))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.reset()
    }
    func loadData(){
        NetworkingHandle.fetchNetworkData(url: "/api/Merchant/material_info", at: self, success: { (response) in
            if let data = response["data"] as? NSDictionary{
                self.regisetrModel = RegisterModel.deserialize(from: data)!
                self.tableView.reloadData()
            }
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToApplyDetailStateCell", for: indexPath) as! ToApplyDetailStateCell
            cell.refershData(model:regisetrModel)
            return cell
        }
        else if indexPath.section == 1 {
            if regisetrModel.deposit == "0"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "withIdentifier", for: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyDetailDepositCell", for: indexPath) as! ApplyDetailDepositCell
                cell.refershData(index:indexPath,modle:regisetrModel)
                cell.payClickBlock = {
                    let vc = UIAlertController.init(title: NSLocalizedString("Pleasechoosethewayofpayment", comment: "请选择支付方式") , message: "", preferredStyle: .actionSheet)
                    let actionWX = UIAlertAction.init(title: NSLocalizedString("WeChat", comment: "微信") , style: .default) { (action) in
                        //                    self.payWay = "wx"
                        NetworkingHandle.fetchNetworkData(url: "/api/Order/insert_merchants_deposit", at: self, params: ["type": "wx"], isShowHUD: true, success: { (response) in
                            let data = response["data"] as! [String:AnyObject]
                            //TODO:添加支付
                            let pay =  PayReq()
                            pay.partnerId = data["partnerid"] as! String//"10000100"
                            pay.prepayId =  data["prepayid"] as! String//"1101000000140415649af9fc314aa427"
                            pay.package = data["package"] as! String//"Sign=WXPay"
                            pay.nonceStr = data["noncestr"] as! String//"a462b76e7436e98e0ed6e13c64b4fd1c"
                            pay.timeStamp = UInt32(data["timestamp"] as! String)! // 1397527777
                            pay.sign = data["sign"] as! String//"582282D72DD2B03AD892830965F428CB16E7A256"
                            WXApi.send(pay)
                            //                        [WXApi sendReq：request];
                            
                            
                            //                        Pingpp.createPayment(data as NSObject, appURLScheme: WXAppKey, withCompletion: { (result, error) in
                            //
                            //                        })
                            //
                        }, failure: {
                            
                        })
                    }
                    let actionzfb = UIAlertAction.init(title: NSLocalizedString("Alipay", comment: "支付宝"), style: .default) { (action) in
                        //                    self.payWay = "alipay"
                        NetworkingHandle.fetchNetworkData(url: "/api/Order/insert_merchants_deposit", at: self, params: ["type": "ali_app"], isShowHUD: true, success: { (response) in
                            
                            if let data = response["data"] as? String{
                                AlipaySDK.defaultService().payOrder(data, fromScheme: "com.zhengan.zhongfeigou", callback: { (reult) in
                                    self.paySuccess()
                                    
                                })
                            }
                            //TODO:添加支付
                            
                            //                        Pingpp.createPayment(data as NSObject, viewController: self, appURLScheme: urlSchemes, withCompletion: { (str, error) in
                            //
                            //                        })
                            
                        }, failure: {
                            
                        })
                        
                    }
                    let cancel = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: "取消"), style: .default) { (action) in
                        
                    }
                    vc.addAction(actionWX)
                    vc.addAction(actionzfb)
                    vc.addAction(cancel)
                    
                    self.present(vc, animated: true, completion: nil)
                }
                return cell

            }
        }
            
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyDetailInfoCell", for: indexPath) as! ApplyDetailInfoCell
            cell.refershData(model:regisetrModel)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyDetailDepositCell", for: indexPath) as! ApplyDetailDepositCell
            cell.model  = company
            cell.refershData(index:indexPath,modle:regisetrModel)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            if regisetrModel.deposit == "0"{
                return 0
            }else{
                return 30
            }
        }else{
            return section == 2 ? 30 : 10
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            
            return 70
        }
        else if indexPath.section == 2{
            return 341
        }
        else {
            if indexPath.section == 1{
                if regisetrModel.deposit == "0"{
                    return 0
                }else{
                    return 45
                }
            }else{
                return  45
                
            }
           
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2{
            
            let view = UIView()
            let lab = UILabel()
            lab.frame = CGRect.init(x: 15, y: 10, width: 300, height: 20)
            
            lab.text = NSLocalizedString("Theinformationisasfollows", comment: "入驻信息如下")
            lab.textColor = UIColor.lightGray
            view.addSubview(lab)
            return view
        }else{
            return UIView()
        }
        
    }
}

