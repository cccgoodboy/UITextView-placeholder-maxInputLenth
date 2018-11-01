//
//  SelectReasonViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/12.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SelectReasonViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var  data:[OrderRefundReason] = [OrderRefundReason]()
    var selectModel:OrderRefundReason = OrderRefundReason()
    var selectReasonBlock:((OrderRefundReason)->())? //原因回传
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sureClick(_ sender: UIButton) {

        let a = data.contains { (model) -> Bool in
            if model.selected == true{
                self.selectReasonBlock?(model)
                return true
            }
            return false
        }
        print(a)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var sureBtn: UIButton!
    @IBAction func closeClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.register(UINib.init(nibName: "SelectReasonTableCell", bundle: nil), forCellReuseIdentifier: "SelectReasonTableCell")
        self.modalPresentationStyle = .custom
        
        NetworkingHandle.fetchNetworkData(url: "/api/Order/order_refund_reason", at: self,  hasHeaderRefresh: tableView, success: { (response) in
            if let a = response["data"] as? NSArray{
                self.data = [OrderRefundReason].deserialize(from: a) as! [OrderRefundReason]
                
                if self.selectModel.refund_reason_id != nil{
                    for item in self.data {
                        if item.refund_reason_id == self.selectModel.refund_reason_id{
                            item.selected = true
                        }else{
                            item.selected = false
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }) {
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectReasonTableCell", for: indexPath) as!SelectReasonTableCell
        cell.itemClickBlock = { model in
            for item in self.data {
                if model.refund_reason_id == item.refund_reason_id{
                    model.selected = !model.selected
                }else{
                    item.selected = false
                }
            }
            self.tableView.reloadData()
        }
        
       cell.model = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        for item in self.data {
            if model.refund_reason_id == item.refund_reason_id{
                model.selected = !model.selected
            }else{
                item.selected = false
            }
        }
        self.tableView.reloadData()

    }
}
