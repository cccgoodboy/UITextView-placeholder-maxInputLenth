//
//  DiamondRechargeRecordViewController.swift
//  MoDuLiving
//
//  Created by 曾觉新 on 2017/3/7.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import MJRefresh

class DiamondRechargeRecordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var dataArr: [StuRecharageRecordModel] = [StuRecharageRecordModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "充值记录"
        
        
        self.tableView.register(DiamondRechargeRecordTableViewCell.self, forCellReuseIdentifier: "cell")
       
        self.tableView.tableFooterView = UIView()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.requestDate(page: 1)
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.page += 1
            self.requestDate(page:self.page)
        })
        
        self.tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row;
       // let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiamondRechargeRecordTableViewCell
        cell.model = dataArr[row]
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: 请求数据
    func requestDate(page: Int) {
        
        let params = ["p" : "\(page)"];
        NetworkingHandle.fetchNetworkData(url: "/api/User/recharge_record", at: self, params: params,  hasHeaderRefresh: tableView, success: { (response) in
            self.page = page
            if let data = (response as AnyObject).value(forKeyPath: "data.data") as? NSArray{
             
                
                if self.page == 1 {
                    if data.count == 0{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()

                    }
                    self.dataArr.removeAll()
                    self.dataArr = [StuRecharageRecordModel].deserialize(from: data) as! [StuRecharageRecordModel]
                } else {
                    
                    let data =  [StuRecharageRecordModel].deserialize(from: data) as! [StuRecharageRecordModel]
                    if data.count < 10{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        self.dataArr += data
                    }
                }
            }
            

            self.tableView.reloadData()
        }) {
            
        }
    }
    
}
