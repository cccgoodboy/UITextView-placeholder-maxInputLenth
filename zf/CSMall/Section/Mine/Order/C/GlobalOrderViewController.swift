//
//  GlobalOrderViewController.swift
//  FKDCClient
//
//  Created by 梁毅 on 2017/2/16.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import MJRefresh
class GlobalOrderViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var doType = 0
    var vcType: String?
    var orderList:[OrdersMdoel] = [OrdersMdoel]()
    override func viewWillAppear(_ animated: Bool) {
        if  vcType != nil {
            self.navigationController?.navigationBar.isHidden = false
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: EvaluateGoodsSuccessNotification), object: nil)

        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName:"OrderFormSectionHeaderView", bundle:nil), forHeaderFooterViewReuseIdentifier: "OrderFormSectionHeaderView")
        tableView.register(UINib(nibName:"OrderFormSectionFooterView", bundle:nil), forHeaderFooterViewReuseIdentifier: "OrderFormSectionFooterView")
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.page = 1
            self.loadData()
        })
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.page += 1
            self.loadData()
        })
        footer?.setTitle("", for: .noMoreData)
        footer?.setTitle("", for: .idle)
        tableView.mj_footer = footer

        self.tableView.mj_header.beginRefreshing()
        
    }
    func updateUI() {
        self.tableView.mj_header.beginRefreshing()
    }
    func loadData() {
        var parma = [String:String]()
        if doType == 0 {
            //cancel,wait_pay,wait_send,wait_receive,wait_assessment,end
            parma = ["p":String(page),"order_state":""]
        }
        else if doType ==  1{
            parma = ["p":String(page),"order_state":"wait_pay"]
        }
        else if doType ==  2{
            parma = ["p":String(page),"order_state":"wait_send"]
        }else if doType ==  3{
            parma = ["p":String(page),"order_state":"wait_receive"]
        }else if doType ==  4{
            parma = ["p":String(page),"order_state":"wait_assessment"]
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Order/queryOrderByState", at: self, params: parma, isAuthHide: true, isShowHUD: true, isShowError: true,hasHeaderRefresh: self.tableView, success: { (response) in
          
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                
                let list = [OrdersMdoel].deserialize(from: data) as! [OrdersMdoel]
                
                if list.count == 0{
                    self.tableView.mj_footer.isHidden = true
                    self.tableView.mj_footer.endRefreshing()
                }
                if data.count < 10{
                    self.tableView.mj_footer.isHidden = true
                }
                if self.page == 1 {
                    self.orderList.removeAll()
                }
                self.orderList += list
            }
            self.tableView.reloadData()
        }) {
            self.page =  self.page - 1
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 87
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return orderList.count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OrderFormSectionHeaderView") as! OrderFormSectionHeaderView

        view.model = orderList[section]
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OrderFormSectionFooterView") as! OrderFormSectionFooterView
        if orderList.count > 0{
            let model = QueryOrderViewModel()
            model.merchants_name = orderList[section].merchants_name ?? ""
            model.merchants_img = orderList[section].merchants_img
           view.merchant = model
        }
       view.target = self
        view.cancelOrderForm = { model in  //取消订单
            for m in self.orderList{
                if m.order_no == model.order_no {
                    m.isCancel = model.isCancel
                    break
                }
            }
            for (index,model) in self.orderList.enumerated() {
                if model.isCancel == true {
                    self.orderList.remove(at: index)
                    break
                }
            }
            self.loadData()
        }
        view.confirmReceiveGoods = {model in //确认收货
            NetworkingHandle.fetchNetworkData(url: "/api/Order/receiveOrder", at: self, params: ["order_merchants_id":model.order_merchants_id ?? ""], success: { (response) in
                self.loadData()
            }, failure: {
            
            })
//            print("确认收货了")
        
        }
        view.deleteOrderForm = { model in //删除订单
            for (index,m) in self.orderList.enumerated() {
                if model.order_no == m.order_no {
                    self.orderList.remove(at: index)
                    break
                }
            }
            self.loadData()
        }
        
        view.orvercancelOrderForm = {model in //删除已完成的订单
            for m in self.orderList{
                if m.order_no == model.order_no {
                    m.isDelete = model.isDelete
                    break
                }
            }
            for (index,model) in self.orderList.enumerated() {
                if model.isDelete == true {
                    self.orderList.remove(at: index)
                    break
                }
            }
            self.loadData()

        
        }
        view.model = orderList[section]
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  orderList[section].orderBeans?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
        cell.model = (orderList[indexPath.section].orderBeans?[indexPath.row])!
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderDetailViewController()
        vc.order_merchants_id = orderList[indexPath.section].order_merchants_id ?? "0"
        vc.order_State = orderList[indexPath.section].order_state ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
