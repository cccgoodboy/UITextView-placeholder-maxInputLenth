//
//  MyAttentionViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/26.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class MyAttentionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MyAttentionTableViewCellDelegate {
    var userCollections: [UserfollowModel] = [UserfollowModel]()
    var allPage = 1

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "MyAttentionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAttentionTableViewCell")
        tableView.tableFooterView = UIView()
        title = "我的关注"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "全部取消", target: self, action: #selector(editClick(sender:)))
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
    func editClick(sender:UIButton){
        if self.userCollections.count > 0{
            NetworkingHandle.fetchNetworkData(url: "/api/User/del_all_follow", at: self, hasHeaderRefresh: tableView, success: { (response) in
                ProgressHUD.showMessage(message: (response["data"] ?? "取消成功") as! String)
                self.userCollections.removeAll()
                self.tableView.reloadData()
            }) {
                
            }
        }else{
            ProgressHUD.showMessage(message: "请先去关注你喜欢的店家！！！")
        }
       
    
    }
    func loadData(page:Int) {
        
        
        NetworkingHandle.fetchNetworkData(url: "/api/User/user_follow", at: self, params: ["pagesize": "10", "p": page], isShowError: false,hasHeaderRefresh: tableView,  success: { (response) in
            
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                
                let list = [UserfollowModel].deserialize(from: data) as! [UserfollowModel]
                
                if list.count == 0{
                    self.tableView.mj_footer.isHidden = true
                    self.tableView.mj_footer.endRefreshing()
                }
                if page == 1 {
                    self.userCollections.removeAll()
                }
                self.userCollections += list
            }
            self.tableView.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userCollections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAttentionTableViewCell", for: indexPath) as! MyAttentionTableViewCell
        cell.delegate =  self
        cell.model = userCollections[indexPath.row]
//        cell.refershData(model: userCollections[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func singleCancle(cell:MyAttentionTableViewCell){
        
        let index = tableView.indexPath(for: cell)
        let alert = UIAlertController.init(title: "", message: "确定要取消关注吗？", preferredStyle: .alert)
        let action  = UIAlertAction.init(title: "取消", style: .cancel) { (a) in
            
        }
        let ID = self.userCollections[index!.row].follow_id!
        let sureaction  = UIAlertAction.init(title: "确定", style: .destructive) { (a) in
            NetworkingHandle.fetchNetworkData(url: "/api/User/del_user_follow", at: self, params: ["follow_id":ID ], success: { (result) in
                ProgressHUD.showMessage(message: "取消成功")
                for item in self.userCollections.indices{
                    if self.userCollections[item].follow_id! == ID{
                         self.userCollections.remove(at: item)
                        self.tableView.reloadData()
                        return
                    }
                }
                
            })
            
        }
        alert.addAction(action)
        alert.addAction(sureaction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
