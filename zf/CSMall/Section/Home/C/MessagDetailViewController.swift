//
//  MessagDetailViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/18.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh
class MessagDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var doType = 0
    var vcType: String?
    var messageList:[SystemMessageModel] = [SystemMessageModel]()
    override func viewWillAppear(_ animated: Bool) {
        if  vcType != nil {
            self.navigationController?.navigationBar.isHidden = false
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: EvaluateGoodsSuccessNotification), object: nil)
        tableView.estimatedRowHeight = 100

        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "MessagDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagDetailTableViewCell")
        tableView.register(UINib(nibName: "MessageDetailOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageDetailOrderTableViewCell")
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
//    func updateUI() {
//        self.tableView.mj_header.beginRefreshing()
//    }
    func loadData() {
        var parma = [String:String]()
        if doType == 0 {
            parma = ["p":String(page),"type":"1"]
        }
        else if doType ==  1{
            parma = ["p":String(page),"type":"2"]
        }

        NetworkingHandle.fetchNetworkData(url: "/api/User/message", at: self, params: parma, isAuthHide: true, isShowHUD: true, isShowError: true,hasHeaderRefresh: self.tableView, success: { (response) in
            
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                
                let list = [SystemMessageModel].deserialize(from: data) as! [SystemMessageModel]
                
                if list.count == 0{
                    self.tableView.mj_footer.isHidden = true
                    self.tableView.mj_footer.endRefreshing()
                }
                if data.count < 10{
                    self.tableView.mj_footer.isHidden = true
                }
                if self.page == 1 {
                    self.messageList.removeAll()
                }
                self.messageList += list
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
        return CommonSepHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return messageList.count
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 // orderList[section].orderBeans?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if doType == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessagDetailTableViewCell") as! MessagDetailTableViewCell
                    cell.model = messageList[indexPath.section]
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDetailOrderTableViewCell") as! MessageDetailOrderTableViewCell
                    cell.model = messageList[indexPath.section]
            return cell

            
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = OrderDetailViewController()
//        vc.order_merchants_id = orderList[indexPath.section].order_merchants_id ?? "0"
//        vc.order_State = orderList[indexPath.section].order_state ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
