//
//  GoodListViewController.swift
//  CSLiving
//
//  Created by 梁毅 on 2017/8/17.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class GoodListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var goodsTab: UITableView!
    
    var selectGoods = [MerchantsClassGoodsModel]() //已选中的商品
    var class_uuid = ""
    var pagerItemData: GoodsPagerItemData!
    var merchants_id = ""
//    var goodsClick:((MerchantsClassGoodsModel)->())?
    required init() {
        super.init(nibName: "GoodListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goodsTab.tableFooterView = UIView()
        goodsTab.register(UINib(nibName: "GoodListTabCell", bundle: nil), forCellReuseIdentifier: "GoodListTabCell")
        
        self.goodsTab.mj_header = MJRefreshNormalHeader { [weak self] in
            guard let `self` = self else {
                return
            }
            self.pagerItemData.page = 1
            self.loadData()
        }
        
        self.goodsTab.mj_footer = MJRefreshBackNormalFooter { [weak self] in
            guard let `self` = self else {
                return
            }
            self.pagerItemData.page += 1
            self.loadData()
        }
    }
    func updateselectGoods(noti:Notification){
        
        self.selectGoods = noti.userInfo!["commit"] as! [MerchantsClassGoodsModel]
    }
    func loadData(){
        if pagerItemData.isLoading {
            return
        }
        pagerItemData.isLoading = true
        NetworkingHandle.fetchNetworkData(url: "api/Mall/merchants_class_goods", at: self, params: ["merchants_id": merchants_id , "class_uuid": class_uuid, "p": pagerItemData.page, "pagesize": 10], hasHeaderRefresh: goodsTab, success: { (response) in
            if let data = (response as AnyObject).value(forKeyPath: "data.list") as? NSArray {
                
                let list = [MerchantsClassGoodsModel].deserialize(from: data) as! [MerchantsClassGoodsModel]
                
                if list.isEmpty {
//                    self.goodsTab.mj_footer.isHidden = true
                    self.goodsTab.mj_footer.endRefreshing()
                }
                if self.pagerItemData.page == 1 {
                    self.pagerItemData.data.removeAll()
                }
                
                self.pagerItemData.data += list
                
            }
            self.pagerItemData.isLoading = false
            self.pagerItemData.isLoaded = true
            self.goodsTab.reloadData()
        }) {
            self.pagerItemData.isLoading = false
            self.pagerItemData.page = max(1, self.pagerItemData.page - 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !pagerItemData.isLoaded {

            goodsTab.mj_header.beginRefreshing()
        }
        
        self.goodsTab.reloadData()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return pagerItemData == nil ? 0 : pagerItemData.data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodListTabCell", for: indexPath)  as! GoodListTabCell
        if pagerItemData != nil{
            cell.model = pagerItemData.data[indexPath.section]
        }
//        cell.selectGoodsClick = {model in
//
//            self.goodsClick?(model)
//
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

