//
//  DiscountCouponDetailViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/22.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh
enum DiscountCouponType:Int {
    case DiscountCoupon_NotUse = 1
    case DiscountCoupon_HavedUse = 2
    case DiscountCoupon_OutOfDate = 3
}

class DiscountCouponDetailViewController: UIViewController {

    var allDataArr: [MyCouponModel] = []
    var allPage = 1

    @IBOutlet weak var discoupTab: UITableView!
    
    var couponType:DiscountCouponType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoupTab.tableFooterView =  UIView()
        discoupTab.register(UINib.init(nibName: "DiscountCouponDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DiscountCouponDetailTableViewCell")
        self.discoupTab.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        self.discoupTab.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        self.discoupTab.mj_header.beginRefreshing()
        
        
    }
    func loadData(page:Int){
        var params = [String:Any]()
        if couponType  == DiscountCouponType.DiscountCoupon_NotUse{
            params = ["p":page,"status":1]
        }
        else if couponType == DiscountCouponType.DiscountCoupon_HavedUse{
            params = ["p":page,"status":2]

        }
        else if couponType == DiscountCouponType.DiscountCoupon_OutOfDate{
            params = ["p":page,"status":3]

        }
        NetworkingHandle.fetchNetworkData(url: "/api/User/my_coupon", at: self, params: params, hasHeaderRefresh: discoupTab, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                
                let list = [MyCouponModel].deserialize(from: data) as! [MyCouponModel]
                
                if page == 1 {
                    self.allDataArr.removeAll()
                }
                self.discoupTab.mj_footer.endRefreshing()
                self.allDataArr += list
            }
            self.discoupTab.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DiscountCouponDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return allDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "DiscountCouponDetailTableViewCell", for: indexPath) as! DiscountCouponDetailTableViewCell
         cell.refershData(model: allDataArr[indexPath.row], type: couponType)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

}
