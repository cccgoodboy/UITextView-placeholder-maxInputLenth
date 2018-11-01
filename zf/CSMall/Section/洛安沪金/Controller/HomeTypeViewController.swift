//
//  HomeTypeViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class HomeTypeViewController: UIViewController {

    @IBOutlet weak var typeCollection: UICollectionView!
    var bannerData:[BannerModel] = [BannerModel]()
    var allPage:Int = 1
    var allData:[LiveListModel] = []
    var currentAddress = UILabel()
    var city = LocationManager.shared.city
    var model = ShowGoodsClassModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = model.tag
        typeCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView")
        
        typeCollection.register(UINib.init(nibName: "KindCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KindCollectionViewCell")

        self.typeCollection.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.allPage = 1
            self.loadData(page: self.allPage,city: self.city)
            self.loadBannerData()
            
        })
        self.typeCollection.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.allPage += 1
            self.loadData(page: self.allPage,city: self.city)
        })
        self.typeCollection.mj_header.beginRefreshing()
    }
    func loadBannerData(){
    
        NetworkingHandle.fetchNetworkData(url: "/api/index/banner_list", at: self, params: ["type":"3"], hasHeaderRefresh: typeCollection, success: { (response) in
            
            if let data = response["data"] as? NSArray {
                self.bannerData = [BannerModel].deserialize(from: data) as! [BannerModel]
            }
            self.typeCollection.reloadData()
            
        }) {
            
        }
    }
    func loadData(page:Int,city:String){
        
        NetworkingHandle.fetchNetworkData(url: "/api/live/tag_live_list", at: self, params: ["live_class_id":model.live_class_id ?? "","p":page,"city":city], hasHeaderRefresh: typeCollection, success: { (response) in
            if let data = response["data"] as? NSArray{
                if page == 1{
                    self.allData.removeAll()
                }
                if data.count < 10{
                    self.typeCollection.mj_footer.endRefreshingWithNoMoreData()
                }
                self.allData += [LiveListModel].deserialize(from: data) as! [LiveListModel]
            }
//            self.typeCollection.mj_footer.isAutomaticallyHidden =  true
            
            self.typeCollection.reloadData()
        }) {
            if self.allPage > 1 {
                self.allPage -= 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
extension HomeTypeViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return  allData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return  CGSize.init(width: kScreenWidth/2 - 2 , height:(228/184)*(kScreenWidth/2 - 2))
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets.init(top: spaceHeight, left: 0, bottom: 10, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return spaceHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindCollectionViewCell", for: indexPath) as! KindCollectionViewCell
        cell.model = allData[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
                return  CGSize.init(width: kScreenWidth, height:   44 + spaceHeight + 150/375 * kScreenWidth)
        }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BannerView", for: indexPath)
            header.backgroundColor = UIColor.init(hexString: "ECECEC")
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
//                        ProgressHUD.showMessage(message:"数据异常")
                    }
//                    let web = MDWebViewController()
//                    //  web.title = "活动详情"
//                    if Bmodel?.url != nil{
//                        web.title = Bmodel?.title
//                        web.url = (Bmodel?.url)!
//                        self.navigationController?.pushViewController(web, animated: true)
//                    }
                }
            })
            pageScrollView.fetchImageUrl = { index in
                return "\((self.bannerData[index].b_img)! )"
            }
            pageScrollView.backgroundColor = UIColor.white
            pageScrollView.totalPages = self.bannerData.count
            header.addSubview(pageScrollView)
        
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "dianwei")
        img.frame = CGRect.init(x: 8, y: 10 + 150/375 * kScreenWidth , width: 25, height: 25)
        header.addSubview(img)
        currentAddress.text = city
        currentAddress.font = UIFont.systemFont(ofSize: 14)
        currentAddress.frame =  CGRect.init(x: 40, y: 10 + 150/375 * kScreenWidth, width: 120, height: 25)
        
        let updateAddress = UIButton()
        updateAddress.frame =  CGRect.init(x: 0, y: 150/375 * kScreenWidth, width: kScreenWidth, height: 44)
        updateAddress.contentHorizontalAlignment = .right
        updateAddress.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        updateAddress.setTitleColor(UIColor.lightGray, for: .normal)
        updateAddress.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        updateAddress.setTitle("点击切换地区", for: .normal)
        
        updateAddress.addTarget(self, action: #selector(updateAddressClick), for: .touchUpInside)
        header.addSubview(updateAddress)
        header.addSubview(currentAddress)
            return header
    }
    func updateAddressClick(){
        let addressvc = ShowAddressViewController()
        addressvc.itemCityClick = {str in
            self.currentAddress.text = str
            self.city = str
            self.allPage = 1
            self.loadData(page: self.allPage, city: str)
        }
        self.navigationController?.pushViewController(addressvc, animated: true)
        
//        let v = ProvinceCityDistrictChoice(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
//        v.show(choiced: { [unowned self] (p, c, d) in
//            self.currentAddress.text = c
//            self.city = c
//            self.allPage = 1
//            self.loadData(page: self.allPage, city: c)
////            sender.setTitle("\(p)-\(c)-\(d)", for: .normal)
////            self.province = p
////            self.city = c
////            self.country = d
////            sender.setTitleColor(UIColor.black, for: .normal)
//        })
//        self.view.addSubview(v)

    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let liveModel =  LiveList()
        let model = self.allData[indexPath.row]
        //去看直播
        if model.live_id != ""{
            liveModel.room_id = model.room_id
            liveModel.user_id = model.member_id
            liveModel.play_address = model.play_address
            liveModel.live_id = model.live_id
            liveModel.play_img = model.play_img
            liveModel.img = model.header_img
            liveModel.share_url = model.play_address_m3u8
            liveModel.username = model.username
            WatchLiveViewController.toWatch(from: self, model: liveModel)
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
