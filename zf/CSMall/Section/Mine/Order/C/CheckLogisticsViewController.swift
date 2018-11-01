//
//  CheckLogisticsViewController.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/6.
//  Copyright © 2017年 liangyi. All rights reserved.
//


import UIKit

class CheckLogisticsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var header: CheckLogisticsHeaderView!
    var logistics_no: String?
    var logistics_pinyin: String?
    var model: LogisticsModel!
    var tracesArr: [TracesModel] = []
    var order_number: String!
    var goods_number: String!//商品总件数
    var goods_image = ""
    @IBOutlet weak var tableView: UITableView!
    let hedaderBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 140))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Hint_56", comment: "查看物流")
        self.header = CheckLogisticsHeaderView.setView()
        self.header.goodsSum = self.goods_number
        self.header.order_no = self.order_number
        header.goods_image = self.goods_image
        hedaderBgView.addSubview(self.header)
        self.tableView.tableHeaderView = hedaderBgView
        
         self.tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib.init(nibName: "CheckLogisticsTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckLogisticsTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.loadData()
    }
    func loadData(){
        
//        ProgressHUD.showLoading(toView: self.view)
        var params : [String:Any] = [:]
        params["logistics_pinyin"] = self.logistics_pinyin!
        params["logistics_no"] = self.logistics_no!

        NetworkingHandle.fetchNetworkData(url: "/api/Express/getTracesByJson", at: self, params:params, hasHeaderRefresh: self.tableView, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["Traces"] as? NSArray{
                self.model = LogisticsModel.deserialize(from: response["data"] as? NSDictionary)
                self.header.model = self.model
                self.tracesArr = [TracesModel].deserialize(from: data) as! [TracesModel]
                self.tableView.reloadData()
            }
        }) {
        
        }

        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckLogisticsTableViewCell") as! CheckLogisticsTableViewCell
        cell.model = self.tracesArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracesArr.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

