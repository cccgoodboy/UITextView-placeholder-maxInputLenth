//
//  SearchPShopViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/29.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class SearchPShopViewController: UIViewController {

    var allPage:Int = 1
    @IBOutlet weak var searchCollection: UICollectionView!
    var allData:[MerchantsModel] = []
    var remeberData:[MerchantsModel] = []
    
    @IBOutlet weak var showLab: UILabel!
    @IBOutlet weak var showConditionView: UIView!
    @IBOutlet weak var shopCollection: UICollectionView!

    @IBOutlet var itemBtn: [UIButton]!
    var isSearch =  false //是否搜索结束了 没结束显示推荐商品，结束了显示搜索结果
    var selectedBtn: UIButton!
    var type = "1"
    var searchStr =  ""
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refershsearchData(noti:)), name: NSNotification.Name(rawValue: "searchmerchant"), object: nil)
        shopCollection.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        searchCollection.register(UINib.init(nibName: "MerchantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MerchantCollectionViewCell")
        
        self.shopCollection.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            
            self.loadData()
        })
        self.shopCollection.mj_header.beginRefreshing()
        
        self.searchCollection.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.allPage = 1
            self.loadData(page: self.allPage,searchStr:self.searchStr,type:self.type)
        })
        self.searchCollection.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.allPage += 1
            self.loadData(page: self.allPage,searchStr:self.searchStr,type:self.type)
        })
        self.searchCollection.mj_header.beginRefreshing()
        showConditionView.isHidden = true
        self.itemBtn[0].isSelected = true
       
        for btn in itemBtn {
            btn.setTitleColor(themeColor, for: .selected)
        }
        selectedBtn = self.itemBtn[0]
        
        searchCollection.isHidden = true
        shopCollection.isHidden = false
    }
    func refershsearchData(noti:Notification){
        self.isSearch = true
//        self.resignFirstResponder()
        
        self.shopCollection.isHidden = true
        self.showConditionView.isHidden = false
        self.searchCollection.isHidden = false
        if let content = noti.userInfo!["content"] as? String{
            self.searchCollection.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
                self.allPage = 1
                self.loadData(page: self.allPage,searchStr:content,type:self.type)
            })
            self.searchCollection.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
                            self.allPage += 1
                            self.loadData(page: self.allPage,searchStr:content,type:self.type)
                        })
            self.searchCollection.mj_header.beginRefreshing()
        }
    }
    func loadData(){
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/showMerchants", at: self, params: ["pagesize":"18"], isShowHUD: true, isShowError: false, hasHeaderRefresh: shopCollection, success: { (response) in
            if let data = response["data"] as?  NSArray{
                self.remeberData = [MerchantsModel].deserialize(from: data) as! [MerchantsModel]
                self.shopCollection.reloadData()
            }
        }) {
            
        }
    }
    func loadData(page:Int,searchStr:String,type:String){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/searchGoods", at: self, params: ["p":page,"name":searchStr,"type":type], hasHeaderRefresh: searchCollection, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["merchants_list"] as? NSArray{
                if self.allPage == 1{
                    self.allData.removeAll()
                }
                if data.count < 10{
                    self.searchCollection.mj_footer.endRefreshingWithNoMoreData()
                }
                self.allData += [MerchantsModel].deserialize(from: data) as! [MerchantsModel]
            }
//            self.searchCollection.mj_footer.isAutomaticallyHidden =  true
            
            self.searchCollection.reloadData()
        }) {
            if self.allPage > 1 {
                self.allPage -= 1
            }
        }
    }
    @IBAction func itemClick(_ sender: UIButton) {
        if selectedBtn === sender {
            return
        }
        selectedBtn.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        if selectedBtn.tag == 1{
            type = "1"
        }else{
            type = "2"
        }
        self.searchCollection.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SearchPShopViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  isSearch ? allData.count : remeberData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{// 11:14
        
        return isSearch ? CGSize.init(width: kScreenWidth, height: 80) : CGSize.init(width: (kScreenWidth - 40)/3, height: 14/11*(kScreenWidth - 40)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if  collectionView == searchCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantCollectionViewCell", for: indexPath) as! MerchantCollectionViewCell
            let model = self.allData[indexPath.row]
            cell.refershData(data:model)
            return  cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            let model = self.remeberData[indexPath.row]
            cell.refershData(data:model)
            return  cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model = MerchantsModel()
        if collectionView == searchCollection {
            model = self.allData[indexPath.row]
        }else{
            model = self.remeberData[indexPath.row]
        }
        let vc = MerchantViewController()
        vc.merchants_id = model.member_id
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
}
