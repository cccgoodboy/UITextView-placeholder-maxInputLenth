//
//  ApplicationForDrawbackViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/29.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import HandyJSON

let ApplicationGoodsSuccessNotification = "ApplicationGoodsSuccessNotification"

class ApplicationForDrawbackViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var commitBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var order_merchants_id = ""
    var order_goods_id = ""
    var refundModel = RefundGoodsModel()
    var applyRefund = ApplyRefundModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Applicationforrefund", comment: "申请退款")
        commitBtn.backgroundColor = themeColor
        tableView.register(UINib.init(nibName: "ApplicationForDrawbackGoodsTabCell", bundle: nil), forCellReuseIdentifier: "ApplicationForDrawbackGoodsTabCell")
        
        tableView.register(UINib.init(nibName: "ApplicationForDrawbackTableViewCell", bundle: nil), forCellReuseIdentifier: "ApplicationForDrawbackTableViewCell")
        tableView.register(UINib.init(nibName: "ReimburseHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReimburseHeader")
        
        tableView.register(UINib.init(nibName: "ReimburseFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReimburseFooter")
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyRefund.order_merchants_id = order_merchants_id
        applyRefund.order_goods_id = order_goods_id
    }
    
    func loadData(){
        NetworkingHandle.fetchNetworkData(url: "/api/Order/refund_goods", at: self, params: ["order_merchants_id":order_merchants_id,"order_goods_id":order_goods_id], isShowHUD: true, isShowError: false, hasHeaderRefresh: tableView, success: { (response) in
            if let data = response["data"] as? NSDictionary{
                self.refundModel = RefundGoodsModel.deserialize(from: data)!
                self.applyRefund.refund_price = self.refundModel.refund_price!
                self.tableView.reloadData()
            }
        }) {
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return refundModel.goods_id == nil ?0 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 128 : 536 - 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicationForDrawbackGoodsTabCell", for: indexPath) as! ApplicationForDrawbackGoodsTabCell
            cell.model = refundModel
            cell.applyNumClick = {model in
                self.applyRefund.refund_count = model.num
                self.applyRefund.refund_selectNum = true
                
                self.tableView.reloadData()
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicationForDrawbackTableViewCell", for: indexPath) as! ApplicationForDrawbackTableViewCell
            cell.model = applyRefund
            cell.itemClick = {sender,model in
                //                if sender.tag == 10088{
                
                let vc = SelectReasonViewController()
                vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
                vc.selectReasonBlock = {model in
                    self.applyRefund.refund_Id = model.refund_reason_id
                    self.applyRefund.refund_reason = model.reason_name
                    self.tableView.reloadData()
                    
                }
                if self.applyRefund.refund_Id != nil{
                    let reason = OrderRefundReason()
                    reason.refund_reason_id = self.applyRefund.refund_Id
                    vc.selectModel = reason
                }
                vc.modalTransitionStyle = .crossDissolve
                self.navigationController?.present(vc, animated: false, completion: nil)
                
                //                }
                //                else{
                //                    self.applyRefund.refund_type = model.refund_type
                //                }
            }
            cell.textDesc = {model in
                self.applyRefund.refund_img = model.refund_img
                self.applyRefund.refund_desc = model.refund_desc
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReimburseHeader") as! ReimburseHeader
        header.contentView.backgroundColor = UIColor.white
        header.r_titleLab.text = NSLocalizedString("Number", comment: "选择退货数量") + "："
        header.heightcon.constant = 0
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 40:CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @IBAction func commitClick(_ sender: UIButton) {
        
//        if applyRefund.refund_type == nil{
//            ProgressHUD.showMessage(message: "请选择退货类型")
//            return
//        }
        if applyRefund.refund_reason == nil{
            ProgressHUD.showMessage(message: NSLocalizedString("Reasonsforrefunds", comment: "请填写退货原因") )
            return
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Order/apply_refund", at: self, params: ["order_goods_id":applyRefund.order_goods_id!,"order_merchants_id":applyRefund.order_merchants_id!,"refund_count":applyRefund.refund_count,"refund_type":applyRefund.refund_type,"refund_reason":applyRefund.refund_reason!,"refund_desc":applyRefund.refund_desc ?? "","refund_img":applyRefund.refund_img ?? ""], success: { (response) in
            if let data = response["data"] as? String{
                ProgressHUD.showMessage(message: data)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:ApplicationGoodsSuccessNotification), object: nil, userInfo: nil)
                self.navigationController?.popViewController(animated: true)
                
            }
        }) {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

