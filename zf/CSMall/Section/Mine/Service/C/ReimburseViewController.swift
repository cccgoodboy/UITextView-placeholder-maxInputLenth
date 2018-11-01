//
//  ReimburseViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/26.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class ReimburseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{//,ReimburseFooterDelegate {
   var allDataArr: [RfundOrderModel] = []
    var allPage = 1

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "售后订单"
        tableView.backgroundColor = UIColor.white

        tableView.register(UINib.init(nibName: "MyCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCollectionTableViewCell")

        tableView.register(UINib.init(nibName: "ReimburseHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReimburseHeader")
        
        
        tableView.register(UINib.init(nibName: "ReimburseFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReimburseFooter")
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        tableView.mj_header.beginRefreshing()

    }
    func loadData(page:Int){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Order/refund_order", at: self, hasHeaderRefresh: tableView, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                
                let list = [RfundOrderModel].deserialize(from: data) as! [RfundOrderModel]
                
                if list.count == 0{
                    self.tableView.mj_footer.isHidden = true
                    self.tableView.mj_footer.endRefreshing()
                }
                if page == 1 {
                    self.allDataArr.removeAll()
                }
                self.allDataArr += list
            }
            self.tableView.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return allDataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionTableViewCell", for: indexPath) as! MyCollectionTableViewCell
        cell.viewLeftConstraint.constant = 15
        cell.cancleBtn.layer.borderWidth = 0.0
        cell.cancleBtn.isUserInteractionEnabled = false
        cell.selectBtn.isHidden = true
        cell.model = allDataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 45
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReimburseHeader") as! ReimburseHeader
        header.contentView.backgroundColor = UIColor.white
        header.r_img.sd_setImage(with: URL.init(string: allDataArr[section].merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        header.r_titleLab.text =  allDataArr[section].merchants_name ?? ""
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReimburseFooter") as! ReimburseFooter
        header.contentView.backgroundColor = UIColor.white
//        header.delegate = self
        header.model = allDataArr[section]
        header.reimburseFooterdetailClickBlock = { model in
            let vc = ReimburseDetailViewController()
            vc.refund = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return header

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = ReimburseDetailViewController()
        vc.refund = allDataArr[indexPath.section]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:ReimburseFooterDelegate
//    func reimburseFooterdetailClick(footer:ReimburseFooter){
//       let id = tableView. self.navigationController?.pushViewController(ReimburseDetailViewController(), animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
