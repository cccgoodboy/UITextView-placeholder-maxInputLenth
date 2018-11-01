//
//  ReimburseDetailViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ReimburseDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var refund = RfundOrderModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tablewViewHeader()
        
        
        tableView.register(UINib.init(nibName: "MyCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCollectionTableViewCell")
       
        tableView.register(UINib.init(nibName: "ReumburseTableViewCell", bundle: nil), forCellReuseIdentifier: "ReumburseTableViewCell")

        tableView.register(UINib.init(nibName: "ReumburseTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "ReumburseTimeTableViewCell")

        tableView.register(UINib.init(nibName: "ReimburseHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReimburseHeader")
        
        
        tableView.register(UINib.init(nibName: "ReimburseFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReimburseFooter")
       loadData()
        
    }
    func loadData(){
        NetworkingHandle.fetchNetworkData(url: "/api/Order/refund_order_view", at: self, params: ["refund_id":refund.refund_id!], success: { (respon) in
            if let data = respon["data"] as? NSDictionary{
               self.refund = RfundOrderModel.deserialize(from: data)!
            }
        }) {
        }
    }
    func tablewViewHeader(){
    
        let tabheader =  UIView()
        tabheader.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 80)
        tabheader.backgroundColor = UIColor.init(hexString: "FFE961")
        let orderState = UILabel()
        orderState.numberOfLines =  0
        orderState.textColor = UIColor.init(hexString: "C98000")
        orderState.font = UIFont.systemFont(ofSize: 15)
        orderState.frame = CGRect.init(x: 20, y: 15, width: kScreenWidth - 40, height: 36)
        if refund.refund_state == "wait_review"{
          orderState.text = "等待审核"
        }else if refund.refund_state == "accept"{
            orderState.text = "接受"
        }
        else if refund.refund_state == "refuse"{
            orderState.text = "拒绝"
        }else if refund.refund_state == "end"{
            orderState.text = "退款成功"
        }
//        orderState.text = "成功回到您的支付宝账号里！宝账号里！"
        tabheader.addSubview(orderState)
        let time = UILabel()
        time.numberOfLines =  0
        time.textColor = UIColor.init(hexString: "C98000")
        time.font = UIFont.systemFont(ofSize: 13)
        time.frame = CGRect.init(x: 20, y: 51, width: kScreenWidth - 40, height: 16)
        time.text = refund.update_time ?? "" //"2016-07-09 15：30"
        tabheader.addSubview(time)
        
        tableView.tableHeaderView = tabheader
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return  1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{

            return 128
        }else if indexPath.section == 1{
            return 240
        }else{
            return 430
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionTableViewCell", for: indexPath) as! MyCollectionTableViewCell
            cell.viewLeftConstraint.constant = 15
            cell.cancleBtn.layer.borderWidth = 0.0
            cell.cancleBtn.isUserInteractionEnabled = false
            cell.selectBtn.isHidden = true
            cell.model = refund

            return cell

        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReumburseTableViewCell", for: indexPath) as! ReumburseTableViewCell
//            cell.viewLeftConstraint.constant = 15
//            cell.cancleBtn.isHidden = true
//            cell.selectBtn.isHidden = true
            return cell

        
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReumburseTimeTableViewCell", for: indexPath) as! ReumburseTimeTableViewCell
            //            cell.viewLeftConstraint.constant = 15
            //            cell.cancleBtn.isHidden = true
            //            cell.selectBtn.isHidden = true
            return cell

        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{

            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReimburseHeader") as! ReimburseHeader
            header.r_titleLab.text = "小馋猫零食店&吃货天堂"
            header.r_img.image = #imageLiteral(resourceName: "dianpu_touxiang")
            header.contentView.backgroundColor = UIColor.white
            return header
        }else{
            return UIView()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReimburseFooter") as! ReimburseFooter
        header.backgroundColor = UIColor.white
        
        return UIView()//header
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 0{
            
            return 40
        }else{
            
            return CGFloat.leastNormalMagnitude
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
