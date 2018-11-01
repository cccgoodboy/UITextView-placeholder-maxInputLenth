//
//  OtherCenterViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/28.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh
class OtherCenterViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewLayout!

    var user_id = ""
    var allPage = 1
    var userInfo:OtherInfoModel = OtherInfoModel()
    var otherlivelist:[PlayBackListModel] = [PlayBackListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
        self.automaticallyAdjustsScrollViewInsets = false

        scrollercontentInset(sc:collectionView,top:-64 ,bottom:0)
    }
    func setUpViews(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "fanhui_bai_quan"), style: .done, target: self, action: #selector(back))
        //
        

//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//
//        layout.headerReferenceSize = CGSize(width:kScreenWidth, height: kScreenWidth)
//        let w = (kScreenWidth - 30 ) / 2
//        layout.itemSize = CGSize(width: w, height: w + 32)
        
        collectionView.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
        
        collectionView.register(UINib.init(nibName: "LAHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LAHomeCollectionViewCell")
        collectionView.register(UINib.init(nibName: "OtherCenterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "OtherCenterCollectionReusableView")

        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        self.collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        self.collectionView.mj_header.beginRefreshing()
        
    }
    func  loadData() {
        var params  = [String:String]()
        
        if CSUserInfoHandler.getIdAndToken()?.token != nil{
            params = ["user_id":user_id]
        }else{
            params = ["user_id":user_id,"type":"1"]

        }
        NetworkingHandle.fetchNetworkData(url: "/api/live/other_center", at: self, params: params, hasHeaderRefresh: collectionView, success: { (result) in
            if let data = result["data"] as? NSDictionary{
                self.userInfo = OtherInfoModel.deserialize(from: data)!
            }
            self.collectionView.reloadData()
        }) {
        
        }
        
    }
    func loadData(page: Int) {
        ///api/LIve/live_list
        NetworkingHandle.fetchNetworkData(url: "/api/live/playback_list", at: self, params: ["member_id":user_id,"p":page], hasHeaderRefresh: collectionView, success: { (result) in

            if let data = (result["data"] as? NSDictionary)?["list"] as? NSArray{
                if page == 1 {
                    self.otherlivelist.removeAll()
                }
                self.otherlivelist += [PlayBackListModel].deserialize(from: data) as! [PlayBackListModel]
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.collectionView.reloadData()
        }) {
            self.allPage = max(1, self.allPage - 1)
        }
    }
    func  back() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.star()
        self.navigationController?.navigationBar.isTranslucent = true
        scrollViewDidScroll(collectionView)
    }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationController?.navigationBar.change(themeColor, with: scrollView, andValue: 400)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.reset()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (kScreenWidth - 30 ) / 2
        return CGSize(width: w, height: w + 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:kScreenWidth, height: kScreenWidth)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "OtherCenterCollectionReusableView", for: indexPath) as! OtherCenterCollectionReusableView
        if userInfo.member_id != nil{
            header.model = userInfo
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return otherlivelist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LAHomeCollectionViewCell", for: indexPath) as! LAHomeCollectionViewCell
        let model = otherlivelist[indexPath.row]
           cell.type = 2
       let live = LiveListModel()
        live.title = model.title
        live.header_img = model.play_img
        live.fans_count = model.play_number
        live.live_id = "0"
        live.signature = model.date
        cell.model = live
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playModel = otherlivelist[indexPath.row]
        
        let vc = PlayVideoViewController()
        vc.username = playModel.title ?? ""
        
        vc.play_img = playModel.play_img
        vc.url = playModel.url
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
