//
//  SearchPAnchorViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/29.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class SearchPAnchorViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    @IBOutlet weak var collectView: UICollectionView!
    
    var allPage:Int = 1
    var allData:[MerchantsModel] = []
    var seaarchText = ""
    var havedsearch = false //是否已经搜索过了
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refershsearchanchorData(noti:)), name: NSNotification.Name(rawValue: "searchanchor"), object: nil)

        collectView.register(UINib.init(nibName: "LAHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LAHomeCollectionViewCell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.allPage = 1
            self.loadData(page: self.allPage,searchStr:self.seaarchText,type:"")
        })
        self.collectView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.allPage += 1
            self.loadData(page: self.allPage,searchStr:self.seaarchText,type:"")
        })
        self.collectView.mj_header.beginRefreshing()

    }
    func refershsearchanchorData(noti:Notification){
        
        if let content = noti.userInfo!["content"] as? String{
            self.collectView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
                self.allPage = 1
                self.loadData(page: self.allPage,searchStr:content,type:"")
            })
            self.collectView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
                self.allPage += 1
                self.loadData(page: self.allPage,searchStr:content,type:"")
            })
            self.collectView.mj_header.beginRefreshing()
        }
    }
    func loadData(page:Int,searchStr:String,type:String){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/searchMerchants", at: self, params: ["p":page,"name":searchStr,"member_type":"1"], hasHeaderRefresh: collectView, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["merchants_list"] as? NSArray{
                if self.allPage == 1{
                    self.allData.removeAll()
                }
                if data.count < 10{
                    self.collectView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.allData += [MerchantsModel].deserialize(from: data) as! [MerchantsModel]
            }
//            self.collectView.mj_footer.isAutomaticallyHidden =  true
            
            self.collectView.reloadData()
        }) {
            if self.allPage > 1 {
                self.allPage -= 1
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LAHomeCollectionViewCell", for: indexPath) as! LAHomeCollectionViewCell
        let currentModel = allData[indexPath.row]
        let livemodel = LiveListModel()
        livemodel.username = currentModel.merchants_name
        livemodel.signature = currentModel.merchants_content
        livemodel.fans_count = currentModel.fans_count
        livemodel.live_id = currentModel.live_id ?? ""
        livemodel.header_img = currentModel.merchants_img
        cell.type = 2
        cell.model = livemodel
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: (kScreenWidth - 30)/2 , height: (kScreenWidth - 30)/2 + 32)
        
    }

}
