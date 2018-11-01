//
//  LAHomeViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class LAHomeViewController: ViewController {
    
    @IBOutlet weak var homeLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var homeCollect: UICollectionView!
    var kindCollection: UICollectionView!
    var selectedBtn: UIButton!
    
    weak var homeHeaderView: UICollectionReusableView?
    var homeTypeView: UIView!
    
    var liveType = "1"     //1综合；2关注；3热门
    var isSuspension = false
    
    var allIsLoaded = false
    var allIsMore = true
    var allContentOffset = CGPoint.zero
    var allPage = 1
    var allData = [LiveListModel]()
    
    var gcallIsLoaded = false
    var gcallIsMore = true
    var gcallContentOffset = CGPoint.zero
    var gcallPage = 1
    var gcallData = [LiveListModel]()
    
    var rmallIsLoaded = false
    var rmallIsMore = true
    var rmallContentOffset = CGPoint.zero
    var rmallPage = 1
    var rmallData = [LiveListModel]()
    var city = ""
    var cityLab =  UILabel( )
    var bannerData: [BannerModel] = [BannerModel]()
    var showGoodsClassData = [ShowGoodsClassModel]()
    var titleImg = [
        ["normal": "laguanzhu1", "select": "laguanzhu"],
        ["normal": "guanchang1", "select": "guangcheng"],
        ["normal": "remeng1", "select": "remen"]
    ]
    var WactchliveModel:LiveListModel = LiveListModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        city = LocationManager.shared.city
        self.navigationItem.title = "直播"
        homeCollect.register(UICollectionReusableView.self,
                             forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                             withReuseIdentifier: "BannerView")
        
        homeCollect.register(UINib(nibName: "LAHomeCollectionViewCell", bundle: nil),
                             forCellWithReuseIdentifier: "LAHomeCollectionViewCell")
        
        homeCollect.mj_header = MJRefreshNormalHeader { [unowned self] in
            switch self.liveType {
            case "2":
                self.allPage = 1
            case "1":
                self.gcallPage = 1
            default:
                self.rmallPage = 1
            }
            self.loadData(page: 1,type: self.liveType)
            self.loadBannerData()
        }
        
        homeCollect.mj_footer = MJRefreshAutoNormalFooter { [unowned self] in
            let page: Int
            switch self.liveType {
            case "2":
                self.allPage += 1
                page = self.allPage
            case "1":
                self.gcallPage += 1
                page = self.gcallPage
            default:
                self.rmallPage += 1
                page = self.rmallPage
            }
            self.loadData(page: page, type: self.liveType)
        }
        homeCollect.mj_header.beginRefreshing()
        navigationBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    func navigationBtn(){
        let control = UIControl()
        if  #available(iOS 11, *){
            control.frame = CGRect.init(x: -navigationBarTitleViewMargin(), y: 0, width: 70, height: 44)
            control.extendRegionType = ExtendRegionType.ClickExtendRegion
        }else{
            control.frame = CGRect.init(x: -20, y: 0, width: 70, height: 44)
        }
        
        cityLab.text =  city//"新疆维吾尔自治区"
        cityLab.textAlignment = .center
        cityLab.textColor = UIColor.white
        cityLab.adjustsFontSizeToFitWidth = true
        cityLab.frame =  CGRect.init(x:control.frame.origin.x, y: 10, width: control.frame.size.width, height: 20)
        cityLab.font = UIFont.systemFont(ofSize: 14)
        cityLab.minimumScaleFactor  = 0.5
        control.addSubview(cityLab)
        
//        let img = UIImageView()
//        img.image = #imageLiteral(resourceName: "more_up")
//        img.contentMode = .scaleAspectFit
//        if  #available(iOS 11, *){
//            img.frame = CGRect.init(x: control.frame.origin.x, y: 30, width: control.frame.size.width, height: 7)
//        }else{
//            img.frame = CGRect.init(x: control.frame.origin.x, y: 30, width: control.frame.size.width, height: 7)
//        }
//        control.addTarget(self, action: #selector(selectAddress(sender:)), for: .touchUpInside)
//        control.addSubview(img)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: control)
        let rightBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "saoyisao"), style: .done, target: self, action: #selector(scanner))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.setImage(#imageLiteral(resourceName: "dianpu_sousuo"), for: .normal)
        searchBtn.setTitle("请输入需要搜索的内容", for: .normal)
        searchBtn.layer.cornerRadius = 15
        searchBtn.contentHorizontalAlignment = .left
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.backgroundColor =  RGBA(r: 251, g:251, b: 251, a: 0.6)
        if #available(iOS 11, *){
            searchBtn.frame = CGRect.init(x: 50, y: 5, width: kScreenWidth - 90 - 50, height: 30)

        }else{
            searchBtn.frame = CGRect.init(x: 70, y: 5, width: kScreenWidth - 90 - 50, height: 30)

        }
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        self.navigationItem.titleView = searchBtn
        
    }
    func scanner(){
    self.navigationController?.pushViewController(ScanQRCodeViewController(), animated: false)
    }
    func searchClick(){
 
        let search = SearchPageViewController()
        self.navigationController?.pushViewController(search, animated: true)
//        let search =  SearchShopViewController()
//        self.navigationController?.pushViewController(search, animated: true)
    }
    func selectAddress(sender:UIControl){
        let addressvc = ShowAddressViewController()
        addressvc.itemCityClick = {str in
            self.cityLab.text = str
        }
        self.navigationController?.pushViewController(addressvc, animated: true)
    }
    func loadBannerData(){
        NetworkingHandle.fetchNetworkData(url: "/api/index/banner_list", at: self,params:["type":"1"], hasHeaderRefresh: homeCollect, success: { (response) in
            
            if let data = response["data"] as? NSArray {
                self.bannerData = [BannerModel].deserialize(from: data) as! [BannerModel]
            }
            self.homeCollect.reloadData()
            
        }) {
        }
        NetworkingHandle.fetchNetworkData(url: "/api/live/live_class", at: self, isShowHUD: false, isShowError: true, hasHeaderRefresh: homeCollect, success: { (response) in
            if let data = response["data"] as? NSArray {
                self.showGoodsClassData = [ShowGoodsClassModel].deserialize(from: data) as! [ShowGoodsClassModel]
            }
            self.homeCollect.reloadData()
        }) {
            
        }
    }
    func loadData(page: Int, type: String) {
        ///api/LIve/live_list
        NetworkingHandle.fetchNetworkData(url: "/api/live/anchor_list", at: self, params: ["type": type,"p": page], hasHeaderRefresh: homeCollect, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray {
                let totalPages = Int((response["data"] as? NSDictionary)?["page"] as? NSNumber ?? 0)
                let isCanLoadMore = page < totalPages
                switch type {
                case "2":
                    self.allIsLoaded = true
                    if page == 1 {
                        self.allData.removeAll()
                    }
                    self.allIsMore = isCanLoadMore
                    self.allData += [LiveListModel].deserialize(from: data) as! [LiveListModel]
                case "1":
                    self.gcallIsLoaded = true
                    if page == 1 {
                        self.gcallData.removeAll()
                    }
                    self.gcallIsMore = isCanLoadMore
                    self.gcallData += [LiveListModel].deserialize(from: data) as! [LiveListModel]
                default:
                    self.rmallIsLoaded = true
                    if page == 1 {
                        self.rmallData.removeAll()
                    }
                    self.rmallIsMore = isCanLoadMore
                    self.rmallData += [LiveListModel].deserialize(from: data) as! [LiveListModel]
                }
                
                if isCanLoadMore {
                    self.homeCollect.mj_footer.resetNoMoreData()
                }
                else {
                    self.homeCollect.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
            self.homeCollect.reloadData()
        }) {
            switch type {
            case "2":
                self.allPage = max(1, self.allPage - 1)
            case "1":
                self.gcallPage = max(1, self.gcallPage - 1)
            default:
                self.rmallPage = max(1, self.rmallPage - 1)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension LAHomeViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == kindCollection {
            return showGoodsClassData.count
        }
        else {
            if liveType == "2" {
                return allData.count
            }
            else if liveType == "1" {
                return gcallData.count
            }
            else {
                return rmallData.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return collectionView == kindCollection ? CGSize(width: kScreenWidth/5 , height: 90) : CGSize(width: (kScreenWidth - 30)/2 , height: (kScreenWidth - 30)/2 + 32)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  collectionView == kindCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindViewCollectionViewCell", for: indexPath) as! KindViewCollectionViewCell
            cell.model = showGoodsClassData[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LAHomeCollectionViewCell", for: indexPath) as! LAHomeCollectionViewCell
            switch liveType {
            case "2":
                cell.model = allData[indexPath.row]
            case "1":
                cell.model = gcallData[indexPath.row]
            default:
                cell.model = rmallData[indexPath.row]
            }
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == kindCollection {
            return CGSize.zero
        }
        else {
            if !showGoodsClassData.isEmpty {
                return  CGSize(width: kScreenWidth, height: 90 + 44 + spaceHeight * 2 + 150/375 * kScreenWidth)
            }
            else {
                
                if bannerData.count > 0 {
                    return  CGSize(width: kScreenWidth, height:   44 + spaceHeight + 150/375 * kScreenWidth)
                }
                else {
                    return  CGSize.zero
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == homeCollect {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "BannerView",
                                                                         for: indexPath)
            header.backgroundColor = UIColor(hexString: "ECECEC")
            
            let pageScrollView: CarouselView
            
            if let v = header.viewWithTag(1001) as? CarouselView {
                pageScrollView = v
            }
            else {
                pageScrollView = CarouselView(frame: CGRect(x:0, y:0, width:kScreenWidth, height: 150/375 * kScreenWidth), animationDuration: 2.0, didSelect: { [unowned self] index in
                    let Bmodel =  self.bannerData[index]
                    DispatchQueue.main.async { [unowned self] in
                        let dress = DressModel()
                        if Bmodel.jump != nil{
                            dress.jump = (Bmodel.jump)!
                            dress.title = Bmodel.title ?? ""
                            dress.type = Bmodel.b_type ?? ""
                            self.skipCLick(model: dress)
                        }else{
//                            ProgressHUD.showMessage(message:"数据异常")
                        }
//                        let web = MDWebViewController()
//                        //  web.title = "活动详情"
//                        if Bmodel.url != nil{
//                            web.title = Bmodel.title
//                            web.url = (Bmodel.url)!
//                            self.navigationController?.pushViewController(web, animated: true)
//                        }
                    }
                })
            }
            pageScrollView.frame = CGRect(x:0, y:0, width:kScreenWidth, height: 150/375 * kScreenWidth)
            
            pageScrollView.fetchImageUrl = { index in
               
                return "\((self.bannerData[index].b_img)!)"
            }
            pageScrollView.backgroundColor = UIColor.white
            pageScrollView.totalPages = self.bannerData.count
            header.addSubview(pageScrollView)
            
            if homeTypeView == nil {
                
                homeTypeView = UIView()
                
                for i in 0 ..< titleImg.count {
                    let button = UIButton(type: .custom)
                    button.setImage(UIImage(named:titleImg[i]["normal"]!), for: .normal)
                    button.setImage(UIImage(named:titleImg[i]["select"]!), for: .selected)
                    button.frame = CGRect(x:CGFloat(i) * kScreenWidth/3, y: 0, width: kScreenWidth/3, height: 42)
                    button.tag = i + 1
                    button.addTarget(self, action: #selector(itemClick(sender:)), for: .touchUpInside)
                    if selectedBtn != nil {
                        if button.tag == selectedBtn.tag {
                            button.isSelected = true
                        }
                    }
                    else {
                        if i == 1 {
                            button.isSelected = true
                            selectedBtn = button
                        }
                    }
                    homeTypeView.addSubview(button)
                }
            }
            let typeFrame: CGRect
            if !showGoodsClassData.isEmpty {
                if kindCollection == nil {
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .horizontal
                    kindCollection = UICollectionView(frame: CGRect(x: 0, y:150/375 * kScreenWidth + spaceHeight, width: kScreenWidth, height: 90), collectionViewLayout: layout)
                    kindCollection.register(UINib(nibName: "KindViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KindViewCollectionViewCell")
                    kindCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
                    kindCollection.delegate = self
                    kindCollection.dataSource = self
                    kindCollection.backgroundColor = UIColor.white
                }
                header.addSubview(kindCollection)
                typeFrame = CGRect(x: 0, y: 150.0 / 375.0 * kScreenWidth + spaceHeight + spaceHeight + 90, width: kScreenWidth, height: 44)
            }
            else {
                if kindCollection != nil {
                    kindCollection.removeFromSuperview()
                    
                }

                typeFrame = CGRect(x: 0, y: 150/375 * kScreenWidth + spaceHeight , width: kScreenWidth, height: 44)
            }
            if kindCollection != nil{
                kindCollection.reloadData()
            }
            homeTypeView.backgroundColor = UIColor.white
            
            if !isSuspension {
                homeTypeView.frame = typeFrame
                header.addSubview(homeTypeView)
            }
            
            homeHeaderView = header
            
            return header
        }
        else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            return header
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  collectionView == kindCollection {
            
            let vc = HomeTypeViewController()
            vc.model = showGoodsClassData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
//            let dress = DressModel()
////            dress.jump = (Bmodel.jump)!
////            dress.title = Bmodel.title ?? ""
////            dress.type = Bmodel.b_type ?? ""
//           skipCLick(model: dress)
            
            
        }else{
            var  currentmodel = LiveListModel()
            switch liveType {
            case "2":
                currentmodel = allData[indexPath.row]
                
            case "1":
                currentmodel = gcallData[indexPath.row]
                
            default:
                
                currentmodel =  rmallData[indexPath.row]
                
            }
            //去看直播
            if currentmodel.live_id != "0"{//直播中
                
                NetworkingHandle.fetchNetworkData(url: "/api/Live/live_info", at: self, params: ["live_id":currentmodel.live_id!], success: { (response) in
                    if let data = response["data"] as? NSDictionary{
                        self.WactchliveModel = LiveListModel.deserialize(from: data)!
                        self.watchLiving(model:self.WactchliveModel)
                    }
                }) {
                    
                }
                
            }else{
                let other = OtherCenterViewController()
                other.user_id = currentmodel.member_id!
                self.navigationController?.pushViewController(other, animated: true)
            }
        }
    }
    func watchLiving(model:LiveListModel){
        let liveModel =  LiveList()
        liveModel.room_id = model.room_id
        liveModel.user_id = model.member_id!
        liveModel.play_address = model.play_address_m3u8
        liveModel.live_id = model.live_id
        liveModel.play_img = model.play_img
        liveModel.img = model.header_img
        liveModel.share_url = model.share_url
//        liveModel.username = model.merchants_name
        liveModel.username = model.username
        WatchLiveViewController.toWatch(from: self, model: liveModel)
    }
    
    func itemClick(sender: UIButton) {
        selectedBtn.isSelected = false
        selectedBtn = sender
        selectedBtn.isSelected = true
        
        let isLoaded: Bool
        let contentOffset: CGPoint
        let isCanLoadMore: Bool
        switch sender.tag {
        case 1:
            liveType = "2"
            isLoaded = allIsLoaded
            contentOffset = allContentOffset
            isCanLoadMore = allIsMore
        case 2:
            liveType = "1"
            isLoaded = gcallIsLoaded
            contentOffset = gcallContentOffset
            isCanLoadMore = gcallIsMore
        default:
            liveType = "3"
            isLoaded = rmallIsLoaded
            contentOffset = rmallContentOffset
            isCanLoadMore = rmallIsMore
        }
        homeCollect.reloadData()
        homeCollect.contentOffset = contentOffset
        if isCanLoadMore {
            homeCollect.mj_footer.resetNoMoreData()
        }
        else {
            homeCollect.mj_footer.endRefreshingWithNoMoreData()
        }
        if !isLoaded {
            homeCollect.mj_header.beginRefreshing()
        }
    }
}

extension LAHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == homeCollect {
            
            // 记录滚动位置
            switch liveType {
            case "2":
                allContentOffset = scrollView.contentOffset
            case "1":
                gcallContentOffset = scrollView.contentOffset
            default:
                rmallContentOffset = scrollView.contentOffset
            }
            
            if let typeView = homeTypeView {
                if /* typeView.superview == homeHeaderView && */!isSuspension {
                    let toMainFrame = view.convert(typeView.frame, from: typeView.superview)
                    if toMainFrame.origin.y <= 0.0 {
                        var frame = toMainFrame
                        frame.origin.y = 0
                        typeView.frame = frame
                        view.addSubview(typeView)
                        isSuspension = true
                    }
                }
                else /*typeView.superview == view && isSuspension */{
                    if let headerView = homeHeaderView {
                        let toHeaderFrame = headerView.convert(typeView.frame, from: typeView.superview)
                        let toHeaderY = 150.0 / 375.0 * kScreenWidth + spaceHeight +
                            (showGoodsClassData.isEmpty ? 0.0 : (spaceHeight + 90))
                        if toHeaderFrame.origin.y <= toHeaderY {
                            var frame = toHeaderFrame
                            frame.origin.y = toHeaderY
                            typeView.frame = frame
                            headerView.addSubview(typeView)
                            isSuspension = false
                        }
                    }
                }
            }
        }
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
