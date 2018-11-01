//
//  CoodStuffVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class CoodStuffVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var goodCollectView:UICollectionView!
    var kindCollection: UICollectionView!
    var pageControl:UIPageControl!
    var bannerData:[BannerModel] = [BannerModel]() //banner 图
    var isLoad = true
    
    var menuTitleArr:[DressModel] = []
    var kindCollectViewCellHeight = kScreenWidth/5 //分类的高度
    var kindCollectHeight = kScreenWidth/5
    var kindCollectPageHeight = kScreenWidth/5*2 //分类分页
    var currentIndex = 0
    var showGoodsClassData = [ShowGoodsKindClassModel]()//分类
    var maybeEnjoyData:[MerchantsGoodsListModel] = [MerchantsGoodsListModel]()
    var allPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Mall", comment: "商城")
        setUpViews()

        self.goodCollectView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadBannerData()
            self.RecommendClassData()
            self.allPage = 1
            self.loadRecommengGoods(page: self.allPage)
        })
//        self.goodCollectView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
//            self.allPage += 1
//            self.loadRecommengGoods(page: self.allPage)
//        })

        self.goodCollectView.mj_header.beginRefreshing()
    }
    @objc func changeLanguage(nofi : Notification){
        self.goodCollectView.mj_header.beginRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
   
    func loadBannerData(){
        NetworkingHandle.fetchNetworkData(url: "/api/index/banner_list", at: self, params: ["type":"2"], hasHeaderRefresh: goodCollectView, success: { (response) in
            if let data = response["data"] as? NSArray {
                self.bannerData = [BannerModel].deserialize(from: data) as! [BannerModel]
            }
            self.goodCollectView.reloadData()
            
        }) {
            
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Home/home_class", at: self, isShowHUD: false, isShowError: true, hasHeaderRefresh: kindCollection, success: { (response) in
            if let data = response["data"] as? NSArray {
                self.showGoodsClassData = [ShowGoodsKindClassModel].deserialize(from: data) as! [ShowGoodsKindClassModel]
            }
            self.goodCollectView.reloadData()
        }) {
            
        }
        
    }
    func RecommendClassData(){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Home/dress", at: self, hasHeaderRefresh: goodCollectView, success: { (response) in
            if let data = response["data"] as? NSArray {
                self.menuTitleArr.removeAll()
                
                self.menuTitleArr += ([DressModel].deserialize(from: data) as? [DressModel])!
            }
            self.goodCollectView.reloadData()
            
        }) {
        }

    }
    
    func loadRecommengGoods(page:Int) {
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/maybeEnjoy", at: self, params: ["p":page,"pagesize":"100"], hasHeaderRefresh: goodCollectView, success: { (result) in
            
            if let data = (result["data"]  as? NSDictionary)?["goods"] as? NSArray {
              let list = [MerchantsGoodsListModel].deserialize(from: data) as! [MerchantsGoodsListModel]
                
//                if list.count == 0{
//                    self.goodCollectView.mj_footer.isHidden = true
//                    self.goodCollectView.mj_footer.endRefreshing()
//                }
                if page == 1 {
                    self.maybeEnjoyData.removeAll()
                }
                self.maybeEnjoyData += list
            }
            self.goodCollectView.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }

    }
    
    func setUpViews(){
        
        view.backgroundColor = UIColor.green
        goodCollectView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kContentHeight), collectionViewLayout: UICollectionViewFlowLayout())
        goodCollectView.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
        view.addSubview(goodCollectView)
        goodCollectView.delegate = self
        goodCollectView.dataSource = self
        goodCollectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView")
        goodCollectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView0")
        
        //多种布局
        
        goodCollectView.register(UINib.init(nibName: "ThreeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ThreeCollectionViewCell")
        goodCollectView.register(UINib.init(nibName: "FourCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FourCollectionViewCell")
        goodCollectView.register(UINib.init(nibName: "FiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiveCollectionViewCell")
        goodCollectView.register(UINib.init(nibName: "SixCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SixCollectionViewCell")
        
        //推荐商品
        goodCollectView.register(UINib.init(nibName: "ShoppingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShoppingCollectionViewCell")

        
        goodCollectView.register(UINib.init(nibName: "GoodKindViewheader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "GoodKindViewheader")
        goodCollectView.register(UINib.init(nibName: "GoodImgReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "GoodImgReusableView")

        
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "haohuo_sousuo"), style: .plain, target: self, action:  #selector(searchClick))
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "xiaoxi"), style:.plain, target: self, action:  #selector(messageClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "more"), style:.plain, target: self, action: #selector(allCkick))

        let tView = UIButton(type: .custom)
        
        if #available(iOS 11, *){
            tView.frame = CGRect(x: 0, y: 7, width: kScreenWidth - 30 , height: 30)
            tView.extendRegionType = ExtendRegionType.ClickExtendRegion
        }else{
            tView.frame = CGRect(x: -20, y: 7, width: kScreenWidth - 60 , height: 30)
        }
        tView.backgroundColor = RGBA(r: 251, g:251, b: 251, a: 0.6)
        tView.setImage(#imageLiteral(resourceName: "home_sousuo"), for: .normal)
        tView.layer.cornerRadius = 15
        tView.setTitleColor(UIColor(hexString: "#999999"), for: .normal)
        tView.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        tView.clipsToBounds = true
        tView.contentHorizontalAlignment = .left
        tView.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        tView.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        tView.setTitle(NSLocalizedString("Hint_90", comment: "请输入要搜索的商品"), for: .normal)
        tView.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        self.navigationItem.titleView = tView
    }
    func allCkick(){
        self.navigationController?.pushViewController(AllKindViewController(), animated: true)
    }

    
    func searchClick(){
        self.navigationController?.pushViewController(SearchGoodsViewController(), animated: true)
    }
    func messageClick(){
        
        
    }
    //Mark - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == kindCollection {
            return 1
        }
        else {
            //            if bannerData.count > 0 {
            //                return self.menuTitleArr.count + 1
            //            }else{
            //                 return self.menuTitleArr.count
            //            }
            var count = self.menuTitleArr.count
            if bannerData.count > 0{
                count += 1
            }
            if maybeEnjoyData.count > 0{
                count += 1
            }
            return count
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == kindCollection {
            return showGoodsClassData.count
        }
        else {
            if bannerData.count > 0{
                
                if maybeEnjoyData.count == 0{
                    if section == 0{ //第一组只放banner ，故返回0行
                        return 0
                    }else{
                        return self.menuTitleArr[section - 1].seedBeans!.count > 0 ? 1:0
                    }
                }else{
                    if section == 0{ //第一组只放banner ，故返回0行
                        return 0
                    }else if section == self.menuTitleArr.count + 1{
                        return maybeEnjoyData.count
                    }else{
                        return self.menuTitleArr[section - 1].seedBeans!.count > 0 ? 1:0
                    }
                }
                
            }else{
                
                if maybeEnjoyData.count == 0{
                    
                    return self.menuTitleArr[section].seedBeans!.count > 0 ? 1:0

                }else{ //不等于0

                    if section == self.menuTitleArr.count{
                        return maybeEnjoyData.count
                    }else{
                        return self.menuTitleArr[section].seedBeans!.count > 0 ? 1:0
                    }
                   
                    
                }
                
            }
        }
        
    }
   
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        
        if collectionView == kindCollection{
            
            return CGSize(width: kScreenWidth/5 , height: kScreenWidth/5)
        }else{
            if bannerData.count > 0{//有banner时
                //判断是否有推荐分类

                if maybeEnjoyData.count == 0{
                    let model = menuTitleArr[indexPath.section - 1]

                    if model.seedBeans!.count > 0{
                        if model.layout == "4"{
                            return CGSize(width: kScreenWidth , height:StringToFloat(str: model.seedBeans!.first!.height!)/StringToFloat(str: model.seedBeans!.first!.width!)*kScreenWidth)
                        }else{
                            return CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
                        }
                    }else{
                        return CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
                        
                    }
                }else{
                    if indexPath.section == self.menuTitleArr.count + 1 {
                        //推荐商品的大小
                        return CGSize.init(width: (kScreenWidth - 1)/2, height: 254/185*(kScreenWidth - 1)/2)

                    }else{
                        
                        let model = menuTitleArr[indexPath.section - 1]
                        if model.seedBeans!.count > 0{
                            if model.layout == "4"{
                                return CGSize(width: kScreenWidth , height:StringToFloat(str: model.seedBeans!.first!.height!)/StringToFloat(str: model.seedBeans!.first!.width!)*kScreenWidth)
                            }else{
                                return CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
                            }
                        }else{
                            return CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
                            
                        }

                    }
                }
                


            }else{
                
                if indexPath.section == menuTitleArr.count{
                    
                    //推荐商品的大小
                    return CGSize.init(width: (kScreenWidth - 1)/2, height: 254/185*(kScreenWidth - 1)/2)

                }else{
                    let model = menuTitleArr[indexPath.section]

                    if model.seedBeans!.count > 0{
                        
                        if model.layout == "4"{
                            return CGSize(width: kScreenWidth , height:StringToFloat(str: model.seedBeans!.first!.height!)/StringToFloat(str: model.seedBeans!.first!.width!)*kScreenWidth)
                        }else{
                            return CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
                            
                        }
                    }else{
                        return CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
                        
                    }
                }


                
                

            }


        }
//        return collectionView == kindCollection ?
//            CGSize(width: kScreenWidth/5 , height: kScreenWidth/5) :
//            CGSize(width: kScreenWidth , height: kScreenWidth*2/3)
    }
    func StringToFloat(str:String)->(CGFloat){
        
        let string = str
        var cgFloat: CGFloat = 0
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == goodCollectView{
            
        
        if bannerData.count > 0{
            if section == self.menuTitleArr.count + 1{
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 1, right: 0)
            }
        }
        else{
            if section == self.menuTitleArr.count{
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 1, right: 0)
            }

            }
        }
//        if collectionView == goodCollectView{
//            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//        }else{
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == goodCollectView {
            
            if  bannerData.count > 0{
                if indexPath.section == 0{
                    return UICollectionViewCell()
                }else if indexPath.section == self.menuTitleArr.count + 1{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCollectionViewCell", for: indexPath) as! ShoppingCollectionViewCell
                    cell.refershData(model:maybeEnjoyData[indexPath.row])
                    return  cell
                }
                else
                {
                    switch menuTitleArr[indexPath.section - 1].layout!{
                    case "3":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThreeCollectionViewCell", for: indexPath) as! ThreeCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section - 1]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                    case "4":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourCollectionViewCell", for: indexPath) as! FourCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section - 1]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                        
                    case "5":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiveCollectionViewCell", for: indexPath) as! FiveCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section - 1]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                        
                    case "6":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SixCollectionViewCell", for: indexPath) as! SixCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section - 1]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                    default:
                        return UICollectionViewCell()//默认布局
                    }
                }
            }else{
                if indexPath.section == self.menuTitleArr.count{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCollectionViewCell", for: indexPath) as! ShoppingCollectionViewCell
                    cell.refershData(model:maybeEnjoyData[indexPath.row])
                    return  cell

                }else{
                    switch menuTitleArr[indexPath.section].layout!{
                    case "3":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThreeCollectionViewCell", for: indexPath) as! ThreeCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                    case "4":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourCollectionViewCell", for: indexPath) as! FourCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                        
                    case "5":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiveCollectionViewCell", for: indexPath) as! FiveCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                        
                    case "6":
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SixCollectionViewCell", for: indexPath) as! SixCollectionViewCell
                        cell.model = menuTitleArr[indexPath.section]
                        cell.itemClickBlock = { model in
                            self.skipCLick(model: model)
                        }
                        return cell
                    default:
                        return UICollectionViewCell()//默认布局
                    }
                }
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindViewCollectionViewCell", for: indexPath) as! KindViewCollectionViewCell
            cell.kindmodel = showGoodsClassData[indexPath.row]
            cell.backgroundColor  = UIColor.white
            return cell
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var sectionHeight:CGFloat = 0
        
        if collectionView == goodCollectView{
            if bannerData.count > 0{
                
                if section == 0{//banner
                    
                    return CGSize.init(width: kScreenWidth, height: 150/375*kScreenWidth)// + CommonSepHeight )
                }else if section == 1{ //分类
                    
                    if menuTitleArr.count == 0{
                        return CGSize.init(width: kScreenWidth, height:0)// + CommonSepHeight )
                    }
                    if self.showGoodsClassData.count != 0{
                        if showGoodsClassData.count <= 5{
                            sectionHeight += kindCollectHeight
                        }else{
                            sectionHeight += kindCollectPageHeight
                        }
                    }
                    if self.menuTitleArr.count > 0{
                        
                        let h = Float(menuTitleArr[section - 1].height!)!
                        let w = Float(menuTitleArr[section - 1].width!)!
                        if w != 0{
                            sectionHeight +=  CGFloat(h/w)*kScreenWidth //+ CommonSepHeight
                        }
                    }
                   
                    return CGSize.init(width: kScreenWidth, height: sectionHeight)
                }else if section == self.menuTitleArr.count + 1{
                    
                    return  CGSize.init(width: kScreenWidth, height:40)

                }else {
                    var height:CGFloat = 0.0
                    let h = Float(menuTitleArr[section - 1].height!)!
                    let w = Float(menuTitleArr[section - 1].width!)!
                    
                    if w != 0{
                        height = CGFloat(h/w)*kScreenWidth
                    }
                    return  CGSize.init(width: kScreenWidth, height:height)
                }
            }else{
                if section == 0{
                   
                    if self.showGoodsClassData.count != 0{
                        
                        if showGoodsClassData.count <= 5{
                            sectionHeight += kindCollectHeight
                        }else{
                            sectionHeight += kindCollectPageHeight
                        }
                    }
                    if self.menuTitleArr.count > 0{
                        
                        let h = Float(menuTitleArr[section].height!)!
                        let w = Float(menuTitleArr[section].width!)!
                        if w != 0{
                            sectionHeight +=  CGFloat(h/w)*kScreenWidth //+ CommonSepHeight
                        }
                    }
                    return CGSize.init(width: kScreenWidth, height: sectionHeight)
                }else{
                    var height:CGFloat = 0.0
                    let h = Float(menuTitleArr[section - 1].height!)!
                    let w = Float(menuTitleArr[section - 1].width!)!
                    
                    if w != 0{
                        height = CGFloat(h/w)*kScreenWidth
                    }

                    return  CGSize.init(width: kScreenWidth, height: height)
                }
            }
        }else {
            return  CGSize.init(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
     
        if collectionView == goodCollectView{
            
            
            if bannerData.count > 0{
                if section == self.menuTitleArr.count + 1{
                    return 1
                }
            }
            else{
                if section == self.menuTitleArr.count{
                    return 1
                }
                
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if collectionView == goodCollectView{
            
            
            if bannerData.count > 0{
                if section == self.menuTitleArr.count + 1{
                    return 1
                }
            }
            else{
                if section == self.menuTitleArr.count{
                    return 1
                }
                
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == goodCollectView{
            if bannerData.count > 0 { //有banner 图的界面
                if indexPath.section == 0{
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView0", for: indexPath)
                    header.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
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
                            }
                        }
                    })
                    pageScrollView.fetchImageUrl = { index in
                        if index >= self.bannerData.count {
                            return ""
                        }
                        return "\((self.bannerData[index].b_img)! )"
                    }
                    pageScrollView.totalPages = self.bannerData.count
                    header.addSubview(pageScrollView)

                    return header
                }
                else  if  indexPath.section == 1 {
                    
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView", for: indexPath)
                    header.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
                    for view in header.subviews{
                        view.removeFromSuperview()
                    }
                    var maginY:CGFloat = 0
                    
                    if showGoodsClassData.count > 0 {
                        let layout = ELCVFlowLayout()
                        if showGoodsClassData.count <= 5{
                           layout.itemSize = CGSize.init(width: kindCollectViewCellHeight, height:kindCollectHeight)
                            kindCollection = UICollectionView(frame: CGRect(x: 0, y:maginY, width: kScreenWidth, height: kindCollectHeight), collectionViewLayout: layout)
                            maginY += kindCollectHeight //+ CommonSepHeight
                        }else{
                              layout.itemSize = CGSize.init(width: kindCollectViewCellHeight, height:(kindCollectPageHeight - 15)/2)
                            kindCollection = UICollectionView(frame: CGRect(x: 0, y:maginY, width: kScreenWidth, height: kindCollectPageHeight), collectionViewLayout: layout)
                            maginY += kindCollectPageHeight// + CommonSepHeight

                        }
                        kindCollection.backgroundColor = UIColor.white
                        kindCollection.delegate = self
                        kindCollection.dataSource = self
                        kindCollection.showsVerticalScrollIndicator = false
                        kindCollection.showsHorizontalScrollIndicator = false
                        kindCollection.isPagingEnabled = true
                        kindCollection.register(UINib(nibName: "KindViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KindViewCollectionViewCell")
                        kindCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
                        
                        header.addSubview(kindCollection)
                      
                        pageControl = UIPageControl.init(frame: CGRect.init(x: (kScreenWidth - 80)/2, y: maginY - 10 , width: 80, height: 8))
                        pageControl.contentHorizontalAlignment = .fill
                        let a = showGoodsClassData.count%10
                        if a > 0 {
                            pageControl.numberOfPages = showGoodsClassData.count/10 + 1
                        }else{
                            pageControl.numberOfPages = showGoodsClassData.count/10
                        }
                        if (showGoodsClassData.count <= 10){
                            pageControl.alpha = 0
                        }
                        pageControl.currentPage = 0
                        pageControl.pageIndicatorTintColor = UIColor.lightGray
                        pageControl.currentPageIndicatorTintColor = themeColor
                        pageControl.addTarget(self, action: #selector(pageChange(sender:)), for: .valueChanged)
                        header.addSubview(pageControl)
                    }
                    
                    let img = UIImageView()
                    img.frame =  CGRect.init(x: 0, y: maginY, width: kScreenWidth, height: header.frame.size.height - maginY)
                    img.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(imgClick(tapgester:)))
                    img.addGestureRecognizer(tap)
                    img.sd_setImage(with: URL.init(string: menuTitleArr[indexPath.section - 1].img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                    header.addSubview(img)
                    return header
                }else if indexPath.section == self.menuTitleArr.count + 1{
                    //推荐商品
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodImgReusableView", for: indexPath)
                    
                    return header
                } else{
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodKindViewheader", for: indexPath) as! GoodKindViewheader
                    if menuTitleArr.count > 0{
                        header.goodStuffModel =   menuTitleArr[indexPath.section - 1]
                    }
                    header.bannerClick = {model in
                        self.skipCLick(model: model)
                    }
                    return header
                }
            }else{
                if  indexPath.section == 0 {
                    
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView", for: indexPath)
                    header.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
                    for view in header.subviews{
                        view.removeFromSuperview()
                    }
                    var maginY:CGFloat = 0
                    
                    if showGoodsClassData.count > 0 {
                        let layout = ELCVFlowLayout()

                        if showGoodsClassData.count <= 5{
                            layout.itemSize = CGSize.init(width: kindCollectViewCellHeight, height:kindCollectHeight)
                            kindCollection = UICollectionView(frame: CGRect(x: 0, y:maginY, width: kScreenWidth, height: kindCollectHeight), collectionViewLayout: layout)
                            maginY += kindCollectHeight //+ CommonSepHeight
                        }else{
                            layout.itemSize = CGSize.init(width: kindCollectViewCellHeight, height:(kindCollectPageHeight - 15)/2)
                            kindCollection = UICollectionView(frame: CGRect(x: 0, y:maginY, width: kScreenWidth, height: kindCollectPageHeight), collectionViewLayout: layout)
                            maginY += kindCollectPageHeight// + CommonSepHeight
                            
                        }
                        kindCollection.backgroundColor = CommonBackGroundColor

                        kindCollection.delegate = self
                        kindCollection.dataSource = self
                        kindCollection.showsVerticalScrollIndicator = false
                        kindCollection.showsHorizontalScrollIndicator = false
                        kindCollection.isPagingEnabled = true
                        kindCollection.register(UINib(nibName: "KindViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KindViewCollectionViewCell")
                        kindCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
                        
                        header.addSubview(kindCollection)
                    }
                    let img = UIImageView()
                    img.frame =  CGRect.init(x: 0, y: maginY, width: kScreenWidth, height: header.frame.size.height - maginY)
                    if indexPath.section > menuTitleArr.count {
                      
                        img.sd_setImage(with: URL.init(string: menuTitleArr[indexPath.section].img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))

                    }
                    else{
                        if indexPath.section < menuTitleArr.count {
                            img.sd_setImage(with: URL.init(string: menuTitleArr[indexPath.section].img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))

                        }
                        
                    }
                    img.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(imgClick(tapgester:)))
                    img.addGestureRecognizer(tap)

                    header.addSubview(img)
                    return header
                }else{
                    if indexPath.section == menuTitleArr.count{
                        //推荐商品
                        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodImgReusableView", for: indexPath)
                        
                        return header

                    }else{
                        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodKindViewheader", for: indexPath) as! GoodKindViewheader
                        if menuTitleArr.count > 0{
                            header.goodStuffModel = menuTitleArr[indexPath.section]
                        }
                        header.bannerClick = {model in
                            self.skipCLick(model: model)
                        }
                        return header
                    }
                  
                }
            }
        }else{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            return header
            
        }
    }
    func imgClick(tapgester:UITapGestureRecognizer){
        if self.menuTitleArr.count > 0 {
            let model = self.menuTitleArr[0]
            skipCLick(model: model)
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
            vc.title = model.title ?? ""
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
    //MARK:分类分页滑动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //得到每页宽度
        if scrollView == kindCollection{
            pageControl.currentPage = Int(scrollView.contentOffset.x/kScreenWidth)
        }
    }
    func pageChange(sender:UIPageControl){
            kindCollection.setContentOffset(CGPoint.init(x: Int(kScreenWidth)*sender.currentPage, y: 0), animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == kindCollection{
//            let faylout = UICollectionViewFlowLayout()
//            faylout.itemSize =  CGSize.init(width: (kScreenWidth - 10)/2, height: 254/185*(kScreenWidth - 10)/2)
//            let kind = GoodKindCollectionVC.init(collectionViewLayout: faylout)
//            kind.title = showGoodsClassData[indexPath.row].title
//
//            let model = RecommendClassModel()
//            model.class_uuid = showGoodsClassData[indexPath.row].class_uuid ?? ""
//            model.class_name = showGoodsClassData[indexPath.row].title ?? ""
//            kind.recommend = model
//            self.navigationController?.pushViewController(kind, animated: false)
            
            
            
            
//            let vc = KindDescViewController()
//            let classModel =  GoodsClassModel()
//            classModel.class_uuid = showGoodsClassData[indexPath.row].class_uuid ?? ""
//            vc.classModel = classModel
//            self.navigationController?.pushViewController(vc, animated: true)
            let model = showGoodsClassData[indexPath.row]
            let dress = DressModel()
            dress.jump = (model.jump)!
            dress.title = model.title ?? ""
            dress.type = model.type ?? ""
            skipCLick(model: dress)

        }else{
            let model = maybeEnjoyData[indexPath.row]
            let vc = GoodsDetailVC()
            vc.goods_id = model.goods_id ?? ""

            if bannerData.count > 0 {
                if indexPath.section == self.menuTitleArr.count + 1{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if indexPath.section == menuTitleArr.count{
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
        }
        
        
        
//        else{
//            if bannerData != nil{
////                let vc = GoodsDetailVC()
////                vc.goods_id = self.menuTitleArr[indexPath.section - 1].show_goods?[indexPath.row].goods_id ?? "0"
////                self.navigationController?.pushViewController(vc, animated: true)
//
//            }else{
////                let vc = GoodsDetailVC()
////                vc.goods_id = self.menuTitleArr[indexPath.section].show_goods?[indexPath.row].goods_id ?? "0"
////                self.navigationController?.pushViewController(vc, animated: true)
//
//            }
//        }
    }
}


