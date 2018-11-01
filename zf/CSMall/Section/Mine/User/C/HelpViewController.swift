//
//  HelpViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/25.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import HandyJSON
import MJRefresh
import HandyJSON

struct NoticeListModel:HandyJSON {
    var id = ""
    var title = ""
}

class HelpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
//    var data:[[String:String]] = [[String:String]]()
    var data = [NoticeListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "帮助"
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "HelpTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpTableViewCell")
//        data = [["title":"积分的作用？","url":"\(userAgerementURL)6"],
//                ["title":"如何获得积分？","url":"\(userAgerementURL)7"],
//                ["title":"不知道怎么购买商品？","url":"\(userAgerementURL)8"],
//                ["title":"不知道怎么去充值？","url":"\(userAgerementURL)11"],
//                ["title":"这里！告诉你去哪看直播！","url":"\(userAgerementURL)9"],
//                ["title":"主播当前讲解的商品在哪里买？","url":"\(userAgerementURL)10"]]
//
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadBannerData()
        })
//        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
//            self.allPage += 1
//            self.loadRecommengGoods(page: self.allPage)
//        })
         tableView.mj_header.beginRefreshing()
        
    }
    fileprivate func loadBannerData(){
        NetworkingHandle.fetchNetworkData(url: "/api/merchant/notice_list", at: self, success: { (response) in
            if let info =  (response["data"] as? NSDictionary)?["list"] as? NSArray{
                self.data = [NoticeListModel].deserialize(from: info) as! [NoticeListModel]
                self.tableView.mj_header.endRefreshing()

                self.tableView.reloadData()
            }
          
        }) {
            
        }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell", for: indexPath) as! HelpTableViewCell
//        cell.titles.text = data[indexPath.row]["title"]
        cell.titles.text = data[indexPath.row].title

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = MDWebViewController()
        web.url = "\(userAgerementURL)\(data[indexPath.row].id)"
        web.title = data[indexPath.row].title
//        web.url = data[indexPath.row]["url"]
//        web.title = data[indexPath.row]["title"]
        self.navigationController?.pushViewController(web, animated: true)
//        print(data[indexPath.row]["url"]!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
