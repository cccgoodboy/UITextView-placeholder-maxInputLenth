//
//  BaseTableViewController.swift
//  DragonVein
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON
class BaseTableViewController: UITableViewController {
    
    var dataArr: [Any] = []
    var pageIndex = 0
    
    var isHeaderRefreshEnable: Bool = false {
        willSet {
            if newValue {
                let header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
                    self.pageIndex = 0
                    self.fetchNetworkingData()
                })
                header?.setTitle("正在刷新。。", for: .idle)
                tableView.mj_header = header
                
            } else {
                tableView.mj_header?.removeFromSuperview()
            }
        }
    }
    var isFooterRefreshEnable: Bool = false {
        willSet {
            if newValue {
                let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
                    self.pageIndex += 1
                    self.fetchNetworkingData()
                })
                footer?.setTitle("上拉加载更多", for: .idle)
                footer?.setTitle("没有更多数据了", for: .noMoreData)
                tableView.mj_footer = footer
            } else {
                tableView.mj_footer?.removeFromSuperview()
            }
        }
    }
    func registerNib(cellTypes: [UITableViewCell.Type]) {
        for cell in cellTypes {
            tableView.register(UINib.init(nibName: cell.description().components(separatedBy: ".").last!, bundle: Bundle.main), forCellReuseIdentifier: cell.description())
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(hexString: "DACAA5")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
//        let bg = UIImageView(image: #imageLiteral(resourceName: "icon_zhengtibg"))
//        bg.contentMode = .scaleAspectFill
//        bg.clipsToBounds = true
//        tableView.backgroundView = bg
    }
    // 网络请求
    func fetchNetworkingData() {
    }
//     网络请求成功回调
    func fetchDataCompleted(model:HandyJSON,result: [String: Any]) {
       
//        let list = modelType.modelsWithArray(modelArray: result["data"] as! [[String : AnyObject]]) as [Any]
//        if list.count == 0 {
//            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
//        }
//        if self.pageIndex == 1 {
//            self.dataArr.removeAll()
//        }
//        self.dataArr += list
//        self.tableView.reloadData()
    }
//     网络请求失败回调
    func fetchDataError() {
        if self.pageIndex > 1 {
            self.pageIndex -= 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
