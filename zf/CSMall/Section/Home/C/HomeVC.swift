//
//  HomeVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class HomeVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{//,YHAlertViewDelegate{
   
    var homeCollectView:UICollectionView!
    var allPage:Int = 1
    var allData:[QueryLiveListByClassModel] = []
    var bannerData:[BannerModel] = [BannerModel]()
    var class_id = ""//分类ID
    var live = LiveListModel()
    var pagerItemData: GoodsClassPagerItemData!

    var isLoad = false
    var liveModel:LiveListModel?

//    var didIndex = IndexPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        self.navigationItem.title = "首页"
        self.homeCollectView.mj_header = MJRefreshNormalHeader { [weak self] in
            guard let `self` = self else {
                return
            }
            self.loadBannerData()

            print(self.pagerItemData)
            self.pagerItemData.page = 1
            self.loadData()

        }
        
        self.homeCollectView.mj_footer = MJRefreshBackNormalFooter { [weak self] in
            guard let `self` = self else {
                return
            }
            self.pagerItemData.page += 1
            self.loadData()
        }
//        self.homeCollectView.mj_header.beginRefreshing()
        
    }
  
    
    func loadBannerData(){
        NetworkingHandle.fetchNetworkData(url: "/api/index/banner_list", at: self, params: ["type":"1"], hasHeaderRefresh: homeCollectView, success: { (response) in

            if let data = response["data"] as? NSArray {
                self.bannerData = [BannerModel].deserialize(from: data) as! [BannerModel]
            }
            self.homeCollectView.reloadData()
            
        }) {
        }
    }
    func loadData(){
        if pagerItemData.isLoading {
            return
        }
        pagerItemData.isLoading = true

        NetworkingHandle.fetchNetworkData(url: "/api/Live/queryLiveListByClass", at: self, params: ["class_id": class_id, "p": pagerItemData.page, "pagesize": 10], hasHeaderRefresh: homeCollectView, success: { (response) in
            if let data = (response as AnyObject).value(forKeyPath: "data.list") as? NSArray {
                
                let list = [QueryLiveListByClassModel].deserialize(from: data) as! [QueryLiveListByClassModel]
                
                if list.isEmpty {
                    //                    self.goodsTab.mj_footer.isHidden = true
                    self.homeCollectView.mj_footer.endRefreshing()
                }
                if self.pagerItemData.page == 1 {
                    self.pagerItemData.data.removeAll()
                }
                self.pagerItemData.data += list
            }
            self.pagerItemData.isLoading = false
            self.pagerItemData.isLoaded = true
            self.homeCollectView.reloadData()
        }) {
            self.pagerItemData.isLoading = false
            self.pagerItemData.page = max(1, self.pagerItemData.page - 1)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBannerData()
        if !pagerItemData.isLoaded {
            
            homeCollectView.mj_header.beginRefreshing()
        }
        
        self.homeCollectView.reloadData()
        
    }
//    func loadData(page:Int){
//
//        NetworkingHandle.fetchNetworkData(url: "/api/live/merchants_list", at: self, params: ["p":page], hasHeaderRefresh: homeCollectView, success: { (response) in
//            self.isLoad = true
//            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
//                if page == 1{
//                    self.allData.removeAll()
//                }
//                if data.count < 10{
//                    self.homeCollectView.mj_footer.endRefreshingWithNoMoreData()
//                }
//                self.allData += [MerchantsModel].deserialize(from: data) as! [MerchantsModel]
//            }
//            self.homeCollectView.mj_footer.isAutomaticallyHidden =  true
//
//            self.homeCollectView.reloadData()
//        }) {
//            if self.allPage > 1 {
//                self.allPage -= 1
//            }
//            self.isLoad = false
//        }
//    }
    func setUpViews(){
        
        view.backgroundColor = UIColor.green
        homeCollectView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kContentHeight), collectionViewLayout: UICollectionViewFlowLayout())
        homeCollectView.backgroundColor = UIColor.init(hexString: "F0F0F1")
        view.addSubview(homeCollectView)
        homeCollectView.delegate = self
        homeCollectView.dataSource = self
        homeCollectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView")
        homeCollectView.register(UINib.init(nibName: "CSHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CSHomeCollectionViewCell")
        
    }
 
    //Mark - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pagerItemData == nil ? 0 : pagerItemData.data.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{// 11:14
        
        return CGSize.init(width: (kScreenWidth - 30)/2, height: 48 + (kScreenWidth - 30)/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }

   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CSHomeCollectionViewCell", for: indexPath) as! CSHomeCollectionViewCell
        if pagerItemData != nil{
            let model = pagerItemData.data[indexPath.row]
            cell.refershData(data:model)

        }
        
        return  cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return   isLoad == true ? CGSize.init(width: kScreenWidth, height: 150/375*kScreenWidth + 35):CGSize.init(width: kScreenWidth, height: 150/375*kScreenWidth)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView", for: indexPath)

        for view in header.subviews{
            view.removeFromSuperview()
        }
        
        let pageScrollView = CarouselView(frame: CGRect(x:0, y:0, width:kScreenWidth, height: 150/375 * kScreenWidth), animationDuration: 2, didSelect: { [unowned self] index in
             let Bmodel =  self.bannerData[index]
            DispatchQueue.main.async { [unowned self] in
                let dress = DressModel()
                if Bmodel.jump != nil{
                    dress.jump = (Bmodel.jump)!
                    dress.title = Bmodel.title ?? ""
                    dress.type = Bmodel.b_type ?? ""

                    self.skipCLick(model: dress)
                }else{
//                    ProgressHUD.showMessage(message:"数据异常")
                }
//                  let web = MDWebViewController()
//                //  web.title = "活动详情"
//                  if Bmodel.url != nil{
//                    web.title = Bmodel.title
//                  web.url = (Bmodel.url)!
//                  self.navigationController?.pushViewController(web, animated: true)
//                  }
            }
        })
        pageScrollView.fetchImageUrl = { index in
            return "\((self.bannerData[index].b_img)! )"
        }
        pageScrollView.totalPages = self.bannerData.count ?? 0
        header.addSubview(pageScrollView)
        if isLoad == false{
            return header
        }
        let leftline = UIView()
        leftline.backgroundColor = UIColor.orange
        header.addSubview(leftline)
        leftline.snp.makeConstraints { (make) in
            make.left.equalTo((kScreenWidth - 240)/2)
            make.height.equalTo(1)
            make.width.equalTo(40)
            make.top.equalTo(pageScrollView.snp.bottom).offset(17)
        }
        
       let centerLab = UILabel()
        centerLab.text = "    店 铺 都 在 这 啦   "
        centerLab.font = UIFont.systemFont(ofSize: 16)
        centerLab.textColor = UIColor.init(hexString: "#333333")
        header.addSubview(centerLab)
        centerLab.snp.makeConstraints { (make) in
            make.left.equalTo(leftline.snp.right)
            make.width.equalTo(160)
            make.top.equalTo(pageScrollView.snp.bottom)
            make.height.equalTo(35)
        }
        let rightline = UIView()
        rightline.backgroundColor = UIColor.orange
        header.addSubview(rightline)
        rightline.snp.makeConstraints { (make) in
            make.right.equalTo(-(kScreenWidth - 240)/2)
            make.height.equalTo(1)
            make.width.equalTo(40)
            make.top.equalTo(pageScrollView.snp.bottom).offset(17)
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        didIndex = indexPath
//        let liveModel =  LiveList()
//        let model = self.allData[didIndex.row]
//        let model = self.allData[indexPath.row]
        let model = pagerItemData.data[indexPath.row]
     
        if model.live_id != "0"{
            NetworkingHandle.fetchNetworkData(url: "/api/Live/live_info", at: self, params: ["live_id":model.live_id!], success: { (response) in
//                if let data = response["data"] as? NSDictionary{
//                    self.live = LiveListModel.deserialize(from: data)!
//                    let liveModel =  LiveList()
//                    liveModel.room_id = self.live.room_id
//                    liveModel.user_id = self.live.member_id
//                    liveModel.play_address = self.live.play_address
//                    liveModel.live_id = self.live.live_id
//                    liveModel.play_img = model.merchants_img
//                    liveModel.img = model.play_img
//                    liveModel.url = self.live.url
//                    liveModel.username = self.live.merchants_name
//                    WatchLiveViewController.toWatch(from: self, model: liveModel)
//
//                }
          
            }) {
                
            }
            //去看直播
//            if model.live_id != ""{
//            }
            //直播状态的店铺出现提示框
            
//            let alertV = YHAlertView(title: "", message: "当前店铺正在直播，去看看吧！\n亲~", delegate: self, cancelButtonTitle: "先看看店铺", otherButtonTitles: ["那就看看呗"])
//            alertV.visual = false
//            alertV.delegate = self
//            alertV.animationOption = .noanima
//            alertV.show()
        }else{
            //去店铺详情
            let vc = MerchantViewController()
            vc.merchants_id = model.member_id
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
//    func alertView(alertView:YHAlertView,clickedButtonAtIndex:Int){
//
//        let liveModel =  LiveList()
//        let model = self.allData[didIndex.row]
//
//        if clickedButtonAtIndex == 0{
//        //去店铺详情
//            let vc = MerchantViewController()
//            vc.merchants_id = model.member_id
//            self.navigationController?.pushViewController(vc, animated: false)
//        }else{
//            //去看直播
//            if model.live_id != ""{
//                liveModel.room_id = model.room_id
//                liveModel.user_id = model.member_id
//                liveModel.play_address = model.play_address
//                liveModel.live_id = model.live_id
//                liveModel.play_img = model.merchants_img
//                liveModel.img = model.img
//                liveModel.url = model.url
//                liveModel.username = model.merchants_name
//                WatchLiveViewController.toWatch(from: self, model: liveModel)
//            }
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func skipCLick(model:DressModel){
        switch model.type!{//1无跳转；2web;3分类页；4商家；5商品；6优惠券
        case "2"://web
            let web = MDWebViewController()
            web.title = model.title
            web.url = (model.jump)!
            self.navigationController?.pushViewController(web, animated: true)
            break
        case "3"://分类页
            let vc = KindDescViewController()
            let classModel =  GoodsClassModel()
            classModel.class_uuid = model.jump ?? ""
            vc.classModel = classModel
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case "4"://商家
            let vc = MerchantViewController()
            vc.merchants_id = model.jump ?? "0"
            self.navigationController?.pushViewController(vc, animated: false)
            
            break
        case "5"://商品
            let vc = GoodsDetailVC()
            vc.goods_id = model.jump ?? "0"
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case "6"://
            let web = ClickWebViewController()
            web.title = model.title
            web.url = (model.jump)!
            self.navigationController?.pushViewController(web, animated: true)
            
            break
            
        default:
            print("1无跳转")
        }
    }
    
}
