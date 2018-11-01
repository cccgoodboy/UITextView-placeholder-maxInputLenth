//
//  MyCollectViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/25.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class MyCollectViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MyCollectionTableViewCellDelegate {
    
    @IBOutlet weak var selectAll: UIButton!//全选
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userCollections: [UserCollection] = [UserCollection]()
    var allPage = 1

    var isSelected = false
    var edit = false
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "MyCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCollectionTableViewCell")
        
        title = "我的收藏"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Edit", comment: "编辑"), target: self, action: #selector(editClick(sender:)))
        cancleBtn.isHidden = true
        selectAll.isHidden = true
        tableView.tableFooterView = UIView()
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        tableView.mj_header.beginRefreshing()
        
        
//        loadData()
        
    }
    func loadData(page:Int) {
        
     
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/collect", at: self, params: ["pagesize": "10", "p": page], isShowError: false,hasHeaderRefresh: tableView,  success: { (response) in
            
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                
                let list = [UserCollection].deserialize(from: data) as! [UserCollection]
                
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
    func editClick(sender:UIButton){
        if userCollections.count == 0{
            ProgressHUD.showMessage(message: "去收藏你感兴趣的商品吧")
            return
        }
        count += 1
        print(count)
        if count % 2 != 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Hint_43", comment: "完成"), target: self, action: #selector(editClick(sender:)))
            
            bottomConstraint.constant = 45
            cancleBtn.isHidden = false
            selectAll.isHidden = false
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Edit", comment: "编辑"), target: self, action: #selector(editClick(sender:)))
            bottomConstraint.constant = 0
            
            cancleBtn.isHidden = true
            selectAll.isHidden = true

            
        }
        
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userCollections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionTableViewCell", for: indexPath) as! MyCollectionTableViewCell
        cell.delegate = self
        if count % 2 == 0 {
            cell.viewLeftConstraint.constant = 15
            cell.cancleBtn.isHidden = false
            cell.selectBtn.isHidden = true
        } else {
            cell.viewLeftConstraint.constant = 50
            cell.selectBtn.isHidden = false
            cell.cancleBtn.isHidden = true
        }
        cell.configureCell(collection: self.userCollections[indexPath.row])
        return cell
    }
    //TODO:全选
    @IBAction func selectAllClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            for item in userCollections{
                item.isSelected = true
            }
        }else {
            for item in userCollections{
                item.isSelected = false
            }
        }
        self.isSelected = sender.isSelected
        tableView.reloadData()
    }
    //TODO:多个取消收藏
    @IBAction func canclecollectAllClick(_ sender: UIButton) {
        
        let a = userCollections.contains { (item) -> Bool in
            if item.isSelected == true{
                return true
            }else{
                return false
            }
        }
       
        if a == true {
            var allids:[String] = [String]()
            for item in userCollections{
                if item.isSelected == true{
                    allids.append(item.collection_id!)
                }
            }
            NetworkingHandle.fetchNetworkData(url: "api/Mall/del_collect", at: self, params: ["ids": allids.joined(separator: ",")], isShowError: false, success: { (response) in
                self.bottomConstraint.constant = 0
                self.cancleBtn.isHidden = true
                self.selectAll.isHidden = true
                for m in allids.indices{
                    for item  in self.userCollections.indices{
                        if item < self.userCollections.count{
                            if allids[m] == self.userCollections[item].collection_id {
                                self.userCollections.remove(at:item)
                            }
                        }
                    }
                }
                self.count += 1
                self.tableView.reloadData()
            })
        }else{
            ProgressHUD.showMessage(message: "没有选择任何商品！")
        }

        
    }
    
    //TODO:cell上的选择btnd
    func selectitemCell(cell: MyCollectionTableViewCell, collection: UIButton) {
        

        let index = tableView.indexPath(for: cell)
        collection.isSelected = !collection.isSelected
        userCollections[index!.row].isSelected = collection.isSelected
        selectAll.isSelected = userCollections.filter { $0.isSelected }.count == userCollections.count

    }
    
    //TODO:取消收藏
    func singleCancle(cell: MyCollectionTableViewCell, collection: UIButton) {

        let index = tableView.indexPath(for: cell)
        
        NetworkingHandle.fetchNetworkData(url: "api/Mall/goods_collect", at: self, params: ["goods_id": (userCollections[index!.row].goods_id)!], isShowError: false, success: { (response) in
           
            self.selectAll.isSelected = false
            self.isSelected = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Edit", comment: "编辑"), target: self, action: #selector(self.editClick(sender:)))
            
            self.tableView.mj_header.beginRefreshing()

//            for item  in self.userCollections.indices{
            
//                if (self.userCollections[index!.row].goods_id)! == self.userCollections[item].goods_id {
                
//                    self.userCollections.remove(at:(index?.row)!)
            
//                    break
//                }
//            }
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func cancleClick(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

