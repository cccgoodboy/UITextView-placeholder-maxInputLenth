//
//  GoodsDetailVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/8.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import WebKit
import  JavaScriptCore
import MWPhotoBrowser

class GoodsDetailVC: CEWebViewController,MWPhotoBrowserDelegate {
    var isLiving = 0//默认0没有直播 1在直播
    var live_id = ""
    var seller = ""
    
    var goodsUrl = ""
    @IBOutlet weak var is_shopLab: UILabel!// //1 商品已下架；2正常
    var skip = ""
    var context:JSContext?
    var goods_id = ""
    var itemOne:UIButton!
    var itemTwo:UIButton!
    var itemThree:UIButton!
//    var line:UIView!
    var goodsModel:SearchGoodsListModel!
    var addressModel:AddressModel?
    var merchant =  MerchantsInfoModel()
    var liveModel = LiveInfoModel()
	var shareView = ShareView()
    var detailWeb:UIWebView!
    var currentInt = 1
    var imagePhoto :[MWPhoto] = [MWPhoto]()

    @IBOutlet weak var collectionImg: UIImageView!
    
    @IBOutlet weak var collectiontitle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        loadData()
        
        detailWeb = UIWebView()
        self.navigationController?.navigationBar.isTranslucent = false
        detailWeb.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64 - 46)
        detailWeb.delegate = self as? UIWebViewDelegate
        if skip == "live"{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "fanhui_bai"), style: .done, target: self, action: #selector(liveback))
        }
        self.view.addSubview(detailWeb)

    }
    
	func liveback(){
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CSUserInfoHandler.getIdAndToken()?.token == nil{
            
            return
        }
        refershData(url: goodsUrl)
        NetworkingHandle.fetchNetworkData(url: "/api/Address/queryDefaultAddress", at: self, isShowHUD: false, success: { (response) in
            if let data = response["data"] as? NSDictionary{

                self.addressModel = AddressModel.deserialize(from: data)
            }
        }) {
        }

    }
    func  webDidFish(webView:UIWebView){
        self.context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext

    }

    override func clickgoodsappShare() {
        if goodsModel?.merchants_id == nil {
            return
        }
        let url = "\(GoodsDetail)\(self.goodsModel.goods_id!)&uid=\(CSUserInfoHandler.getIdAndToken()?.uid ?? "")&token=\(CSUserInfoHandler.getIdAndToken()?.token ?? "")&merchants_id=\(goodsModel?.merchants_id ?? "")"

    
        DispatchQueue.main.async {

            self.shareView = ShareView.show(atView: self.view, url: url, avatar: self.goodsModel?.goods_img ?? "", username: "\(NSLocalizedString("嘿！您的好友", comment: "嘿！您的好友"))\(CSUserInfoHandler.getUserBaseInfo().name)\(NSLocalizedString("Hint_31", comment: "分享了"))\(self.goodsModel?.goods_name ?? "")", type: "0")
        }

    }
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(imagePhoto.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < self.imagePhoto.count{
            
            return imagePhoto[Int(index)]
        }
        return nil
    }
    override func clickbanner(_ imgages: String!, andIndex index: String!) {
        
        DispatchQueue.main.async {
            let images:[String] = imgages.components(separatedBy: ",")
            let mphoto = MWPhotoBrowser.init(delegate: self)
            mphoto?.displayActionButton =  false
            self.imagePhoto.removeAll()
            for i in images.indices{
                if self.goodsModel != nil{
                    
                    //banner图视频展示
                    if self.goodsModel.video_type == "1"{
                        if i == 0{
                            let video = MWPhoto.init(url: URL.init(string: images[i]))
                            video?.videoURL = URL.init(string: self.goodsModel.url!)
                            self.imagePhoto.append(video!)
                            mphoto?.autoPlayOnAppear = true
                        }else{
                            self.imagePhoto.append(MWPhoto.init(url: URL.init(string: images[i])) )
                        }
                    }else{
                        print(images[i])
                        self.imagePhoto.append(MWPhoto.init(url: URL.init(string: images[i])) )
                    }
                    
                }
            }
            mphoto?.setCurrentPhotoIndex(UInt(index)!)
            self.navigationController?.pushViewController(mphoto!, animated: true)
        }
        
    }
    override func clickgoodsappJumpGuige() {
        if CSUserInfoHandler.getIdAndToken()?.token == nil{
            let login = LoginViewController()
            login.loginType = LoginType.login_normal
            
            self.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
            return
        }else{
            if  goodsModel == nil{
                
                ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_32", comment: "正在获取商品信息中。。。"))
                loadData()
                return
            }
//            let vc = AddShopCartViewController()
//            vc.isLiving = isLiving
//            vc.seller =  seller
//            vc.live_id = live_id
//            vc.goodsModel = goodsModel
//            vc.showType = .ShopCart
//            vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
//            vc.modalTransitionStyle = .crossDissolve
//            //        let nav = UINavigationController.init(rootViewController: vc)
//            self.present(vc, animated: false, completion: nil)
            
            let vc = AddShopCartViewController()
            vc.isLiving = isLiving
            vc.seller =  seller
            vc.live_id = live_id

            vc.goodsModel = goodsModel
            vc.showType = .GoodsDetail
            vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
            vc.modalTransitionStyle = .crossDissolve
//            let nav = UINavigationController.init(rootViewController: vc)
            
            
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    override func clickgoodsappJumpPinglun() {
        DispatchQueue.main.async {
            
            let con = CommentViewController()
            con.goodsId = self.goodsModel.goods_id ?? ""
            self.navigationController?.pushViewController(con, animated: true)
        }
     }
    override func clickgoodsappJumpDianpu() {
        DispatchQueue.main.async {
            let vc = MerchantViewController()
            vc.merchants_id = self.goodsModel.merchants_id
            self.navigationController?.pushViewController(vc, animated: false)
        }
     
    }
    
    override func clickgoodsappJumpGuanzhu() {
        if CSUserInfoHandler.getIdAndToken()?.token == nil{
            let login = LoginViewController()
            login.loginType = LoginType.login_normal
            
            self.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)

        }
    }
    func refershData(url:String){
        if (CSUserInfoHandler.getIdAndToken()?.token ?? "") != ""{
            let arr = url.components(separatedBy: "?")
            var secondStr = ""
            if (arr.last?.contains("uid="))!{
                secondStr = "uid=\((CSUserInfoHandler.getIdAndToken()?.uid)!)&token=\((CSUserInfoHandler.getIdAndToken()?.token)!)"
            }
            if goodsModel?.merchants_id == nil {
                return
            }
            let str = "\(arr.first!)?\(secondStr)&merchants_id=\(goodsModel.merchants_id!)&goods_id=\(goodsModel.goods_id!)"
            let request = URLRequest.init(url:URL.init(string: str)!)
            self.detailWeb.loadRequest(request)
        }
    }
    override func clickgoodsappJumpZhibo(){
        DispatchQueue.main.async {

         NetworkingHandle.fetchNetworkData(url: "/api/live/merchants_live", at: self, params: ["member_id":self.goodsModel.merchants_id!], isShowHUD: false, success: { (response) in
            
            if let data = response["data"] as? NSDictionary{
                self.liveModel = LiveInfoModel.deserialize(from: data)!
          
                let live =  LiveList()
                let model = self.liveModel
                
                if model.live_id != nil{
                    live.room_id = model.room_id
                    live.user_id = self.goodsModel.merchants_id
                    live.play_address = model.play_address_m3u8
                    live.live_id = self.merchant.live_id
                    live.play_img = model.play_img
                    live.img = self.merchant.merchants_img
                    live.share_url = model.share_url
                    live.username = self.merchant.merchants_name
                    WatchLiveViewController.toWatch(from: self, model: live)
                }else{
                    ProgressHUD.showMessage(message: "商家还没开始直播呢")
                }
            }
        }, failure: {
        })
        }
    }

    func itemClick(sender:UIButton){
        
        let index = sender.tag
//        if  index < 3{
//            var frame = line.frame
//            frame.origin.x = (kScreenWidth - 120)/3 * CGFloat(index - 1) + ((kScreenWidth - 120)/3 - 36)/2
//            UIView.animate(withDuration: 0.5) { [unowned self] in
//                self.line.frame = frame
//            }
//            DispatchQueue.main.async {
//
//                if index == 1{
//
//                    let jsVale = self.context?.evaluateScript("(function(t){ if(t==1){ angular.element('html, body').animate({ scrollTop: $(\"body\").offset().top }, 300); }else{ angular.element('html, body').animate({ scrollTop: $(\"#goodsDetailsBox\").offset().top }, 300); } })(1)")
//
//                    print(jsVale ?? "")
//                }else{
//                    let jsVale = self.context?.evaluateScript("(function(t){ if(t==1){ angular.element('html, body').animate({ scrollTop: $(\"body\").offset().top }, 300); }else{ angular.element('html, body').animate({ scrollTop: $(\"#goodsDetailsBox\").offset().top }, 300); } })(2)")
//
//                    print(jsVale ?? "")
//                }
//            }
//        }else{
            print("查看评论")
            let con = CommentViewController()
            con.goodsId = goodsModel.goods_id ?? ""
            self.navigationController?.pushViewController(con, animated: true)
//        }
    }
    
    func createViews(){
        
        let titview = UIView()
        titview.frame = CGRect.init(x: 60, y: 20, width: kScreenWidth - 120, height: 44)
        self.navigationItem.titleView = titview
        
        itemOne = UIButton.init(type: .custom)
        itemOne.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        itemOne.setTitle(NSLocalizedString("Hint_33", comment: "商品"), for: .normal)
        itemOne.tag = 1
        itemOne.addTarget(self, action: #selector(itemClick(sender:)), for: .touchUpInside)
        itemOne.frame = CGRect.init(x: 0, y: 0, width: (kScreenWidth - 120)/3, height: 43)
        titview.addSubview(itemOne)
        
        itemTwo = UIButton.init(type: .custom)
        itemTwo.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        itemTwo.setTitle(NSLocalizedString("Hint_34", comment: "详情"), for: .normal)
        itemTwo.tag = 2
        itemTwo.addTarget(self, action: #selector(itemClick(sender:)), for: .touchUpInside)
        itemTwo.frame = CGRect.init(x: (kScreenWidth - 120)/3, y: 0, width: (kScreenWidth - 120)/3, height: 43)
        titview.addSubview(itemTwo)
        
        itemThree = UIButton.init(type: .custom)
        itemThree.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        itemThree.setTitle(NSLocalizedString("Hint_35", comment: "评价"), for: .normal)
        itemThree.tag = 3
        itemThree.addTarget(self, action: #selector(itemClick(sender:)), for: .touchUpInside)
        itemThree.frame = CGRect.init(x: (kScreenWidth - 120)/3*2, y: 0, width: (kScreenWidth - 120)/3, height: 43)
        titview.addSubview(itemThree)
        
//        line = UIView()
//        line.frame = CGRect.init(x: ((kScreenWidth - 120)/3 - 36)/2, y: 43, width: 36, height: 1)
//        line.backgroundColor = UIColor.white
//        titview.addSubview(line)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "gouwuche_bai"), style: .done, target: self, action:#selector(goShopCart) )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //跳转到购物车
    func goShopCart(){
        
        self.navigationController?.pushViewController(ShoppingCartVC(), animated: false)
    }
    //店铺
    @IBAction func shopClick(_ sender: UIButton) {
        
        let vc = MerchantViewController()
        vc.merchants_id = goodsModel.merchants_id ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
    //客服
    @IBAction func serviceClick(_ sender: UIButton) {
        
        if merchant.merchants_id != nil || merchant.contact_mobile != nil {
            if merchant.contact_mobile != ""{
                 let str = String(format:"telprompt://%@",(merchant.contact_mobile)!)
                UIApplication.shared.openURL(URL(string:str )!)
            }else{
                ProgressHUD.showMessage(message:NSLocalizedString("Notconnected", comment:  "抱歉，暂时联系不了"))
            }
        }else{
            
        }

        
    }
    
    //收藏
    @IBAction func collectClick(_ sender: UIButton) {

        if self.goodsModel != nil {
            NetworkingHandle.fetchNetworkData(url: "api/Mall/goods_collect", at: self, params: ["goods_id": self.goodsModel.goods_id!], isShowError: false, success: { (response) in
                self.loadData()
            })
        }
    }
    //加入购物车
    @IBAction func addshopCart(_ sender: UIButton) {
        guard CSUserInfoHandler.getIdAndToken()?.token != nil else {
            let login = LoginViewController()
            login.loginType = LoginType.login_normal
            self.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
            return
        }
        if  goodsModel == nil{
            ProgressHUD.showNoticeOnStatusBar(message:  NSLocalizedString("Hint_32", comment: "正在获取商品信息中。。。"))
            loadData()
            return
        }
        let vc = AddShopCartViewController()
        vc.isLiving = isLiving
        vc.seller =  seller
        vc.live_id = live_id
        vc.goodsModel = goodsModel
        vc.showType = .ShopCart
        vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        vc.modalTransitionStyle = .crossDissolve
//        let nav = UINavigationController.init(rootViewController: vc)
        self.present(vc, animated: false, completion: nil)
    }

    //立即购买
    @IBAction func addPurchaseClick(_ sender: UIButton) {
        
        if CSUserInfoHandler.getIdAndToken()?.token == nil{
            let login = LoginViewController()
            login.loginType = LoginType.login_normal
            self.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
            return
        }
        if  goodsModel == nil{
            
            ProgressHUD.showNoticeOnStatusBar(message:  NSLocalizedString("Hint_32", comment: "正在获取商品信息中。。。"))
            loadData()
            return
        }
        let vc = AddShopCartViewController()
        vc.isLiving = isLiving
        vc.seller =  seller
        vc.live_id = live_id

        vc.goodsModel = goodsModel
        vc.changeParams = {(id,num) in
            let vc = ConfirmOrderViewController()
            vc.isLiving = self.isLiving
            vc.seller = self.seller
            vc.live_id =  self.live_id
            vc.specification_id = id
            vc.goods_num = num
            vc.goods_id = self.goods_id
            vc.confirType = .One_Buy
            vc.address =  self.addressModel
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        vc.showType = .Buy
        vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        vc.modalTransitionStyle = .crossDissolve
//        let nav = UINavigationController.init(rootViewController: vc)
//        nav.view.backgroundColor = UIColor.clear
        self.present(vc, animated: false, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    func loadData(){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/goods_info", at: self, params: ["goods_id":goods_id ], isShowHUD: false, success: { (response) in
            
            if let data = response["data"] as? NSDictionary {
                self.goodsModel = SearchGoodsListModel.deserialize(from: data)
                
                NetworkingHandle.fetchNetworkData(url: "/api/Mall/merchants_info", at: self, params: ["merchants_id":self.goodsModel.merchants_id!], isShowHUD: false, isShowError: true, success: { (response) in
                    self.merchant = MerchantsInfoModel.deserialize(from: response["data"] as? NSDictionary)!
                }) {
                    
                }
                
                if let stop = self.goodsModel.is_stop{
                    if stop == "1"{
                        self.is_shopLab.isHidden = false
                    }else{
                        self.is_shopLab.isHidden = true
                    }
                }
                
                if self.currentInt == 1{
                    self.currentInt += 1
                    self.goodsUrl = "\(GoodsDetail)\(self.goods_id)&uid=\(CSUserInfoHandler.getIdAndToken()?.uid ?? "")&token=\(CSUserInfoHandler.getIdAndToken()?.token ?? "")&merchants_id=\(self.goodsModel.merchants_id ?? "")"
                    let request = URLRequest.init(url: URL.init(string: self.goodsUrl)!)
                    self.detailWeb.loadRequest(request)
                }
                
                DispatchQueue.main.async(execute: {
                    if CSUserInfoHandler.getIdAndToken()?.token == nil || self.goodsModel.is_collect == "2"{
                        self.collectionImg.image = #imageLiteral(resourceName: "xiangqing_shoucang_hui")
                        self.collectiontitle.setTitle(NSLocalizedString("Hint_36", comment: "收藏"), for: .normal)
                    }else if CSUserInfoHandler.getIdAndToken()?.token != nil && self.goodsModel.is_collect == "1"{
                        self.collectionImg.image = #imageLiteral(resourceName: "xiangqing_shoucang_hong")
                        self.collectiontitle.setTitle(NSLocalizedString("Hint_37", comment: "已收藏"), for: .normal)
                    }
                })
            }
        }) {
        }
    
    
    }
   

 
}
