//
//  MerchantViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/5.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class MerchantViewController: PageViewController{
    
    @IBOutlet var itemBtn: [UIButton]!
    
    @IBOutlet weak var line: UILabel!
    
    let vc1 = Merchant_shopVC()
//    let vc2 = Merchant_LivingVC()
    let vc3 = Merchant_videoVC()
    
    var has_message = false
    var selectedBtn: UIButton?
    
    var index = 0//子视图的选中
    
    @IBOutlet weak var s_img: UIImageView!
    
    @IBOutlet weak var s_name: UILabel!
    
    @IBOutlet weak var s_class: UILabel!
    
    @IBOutlet weak var s_bgimg: UIImageView!
    
    @IBOutlet weak var s_attentionBtn: UIButton!
    
    @IBOutlet var s_startImg: [UIImageView]!
    
    @IBAction func sAttentionClick(_ sender: UIButton) {
        if merchantsInfo != nil{
            
            s_attentionBtn.isHidden =  false
            NetworkingHandle.fetchNetworkData(url: "/api/User/follow_merchants", at: self, params: ["user_id2":(merchantsInfo?.member_id)!], success: { (response) in
                
                self.loadMerchant()
            }) {
            }
            
        }else{
            ProgressHUD.showMessage(message: "网络异常了")
        }
    }
    var kindView:UICollectionView!
//    var showView:UIControl!
    var bottomBtn:UIButton!
    var tabBg:UIView!
    var rightControl:UIControl!
    var rightTab:UITableView!
    let imageNames:[UIImage] = [#imageLiteral(resourceName: "dianpu_gengduo_xiaoxi"),#imageLiteral(resourceName: "dianpu_gengduo_shouye"),#imageLiteral(resourceName: "dianpu_gengduo_jianjie"),#imageLiteral(resourceName: "dianpu_gengduo_fenxiang"),#imageLiteral(resourceName: "dianpu_gengduo_kefu")]
    
    let titles = ["消息","首页","店铺简介","联系卖家"]//,"分享","联系卖家"]
    
    var merchants_id:String?
    var merchantsInfo:MerchantsInfoModel?//顶部商家信息
//    var merchantsclass:[MerchantsClassModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createViews()
        vc1.merchants_id = merchants_id
//        vc2.merchants_id = merchants_id
        vc3.merchants_id = merchants_id

        var frame = self.view.bounds
        frame.origin.y = 165
        frame.size.height -= frame.origin.y
        
        
        buttonArray = itemBtn
        
        for item in itemBtn{
            item.setTitleColor(themeColor, for: .selected)
        }
        line.backgroundColor = themeColor
        
        pageViewController.view.frame = frame
//        viewControllerArray = [vc1,vc2,vc3]
        viewControllerArray = [vc1,vc3]

        pageViewController.setViewControllers([viewControllerArray[index]], direction: .forward, animated: true, completion: nil)
        viewControllerTransition(toIndex: index)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.navigationController?.navigationBar.change(RGBA(r: 0,g: 197,b: 166,a: 1), with: scrollView, andValue: 600)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func loadMerchant(){
        if merchants_id == nil{
            return
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/merchants_info", at: self, params: ["merchants_id":merchants_id!], isShowHUD: false, isShowError: true, success: { (response) in
            
            self.merchantsInfo = MerchantsInfoModel.deserialize(from: response["data"] as? NSDictionary)
            if self.merchantsInfo?.is_follow == "3"{
                self.s_attentionBtn.isHidden = true
            }else{
                if self.merchantsInfo?.is_follow == "1"{
                    self.s_attentionBtn.setTitle("已关注", for: .normal)
                }else{
                    self.s_attentionBtn.setTitle("+关注", for: .normal)
                }
            }
        }) {
            
        }
        
    }
    func loadData(){
    
        if merchants_id == nil{
            return
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/merchants_info", at: self, params: ["merchants_id":merchants_id!], isShowHUD: false, isShowError: true, success: { (response) in

            self.merchantsInfo = MerchantsInfoModel.deserialize(from: response["data"] as? NSDictionary)
            if self.merchantsInfo?.is_follow == "3"{
                self.s_attentionBtn.isHidden = true
            }else{
                if self.merchantsInfo?.is_follow == "1"{
                    self.s_attentionBtn.setTitle("已关注", for: .normal)
                }else{
                    self.s_attentionBtn.setTitle("+关注", for: .normal)
                }
            }
            DispatchQueue.main.async(execute: {
                 self.setUpUI()
            })
          
        }) {
            
        }
        
   
    }
    func setUpUI(){
        if merchantsInfo?.member_id != nil{
            
//            if merchantsInfo?.merchants_content == ""{
//                merchantsInfo?.merchants_star1 = "0"
//            }
            s_class.text = merchantsInfo?.merchants_content ?? ""
            s_img.sd_setImage(with: URL.init(string: merchantsInfo?.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            s_name.text = merchantsInfo?.merchants_name
            
//            s_class.text = "等级\(merchantsInfo?.merchants_star1 ?? "0")："
            s_bgimg.sd_setImage(with: URL.init(string: merchantsInfo?.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
//            for i in s_startImg {
//                if s_startImg.index(of: i)! < Int(merchantsInfo?.merchants_star1 ?? "0")! {
//                    i.isHidden = false
//                }else{
//                    i.isHidden = true
//                }
//            }
            
        }
    }
    @IBAction func itemClick(_ sender: UIButton) {
        
        selectedViewController(atButton: sender)
    }
    
    override func viewControllerTransition(toIndex index: Int) {
        let btn = self.itemBtn[index]
        if selectedBtn == btn{
            return
        }
        var  frame = line.frame
        frame.origin.x = CGFloat(index) * kScreenWidth/2
        UIView.animate(withDuration: 0.5) {
            self.line.frame = frame
        }
        selectedBtn?.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    //底部试图
//    func createViews(){
//
//        bottomBtn = UIButton.init(type: .custom)
//        bottomBtn.setTitle("查看所有分类", for: .normal)
//        bottomBtn.setImage(#imageLiteral(resourceName: "dianpu_zhankai"), for: .normal)
//        bottomBtn.setTitle("收起所有分类", for: .selected)
//        bottomBtn.setImage(#imageLiteral(resourceName: "dianpu_shouqi"), for: .selected)
//        bottomBtn.contentHorizontalAlignment = .center
//        bottomBtn.titleEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
//        bottomBtn.setTitleColor(UIColor.init(hexString: "#666666"), for: .normal)
//        bottomBtn.imageEdgeInsets = UIEdgeInsets.init(top: -15, left:100, bottom: 0, right: 0)
//        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        bottomBtn.addTarget(self, action: #selector(showKindClick(sender:)), for: .touchUpInside)
//        self.view.addSubview(bottomBtn)
//        bottomBtn.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview()
//            make.left.right.equalToSuperview()
//            make.height.equalTo(46)
//        }
//
//        let line = UIView()
//        line.backgroundColor = UIColor.init(hexString: "CCCCCC")
//        self.view.addSubview(line)
//        line.snp.makeConstraints { (make) in
//            make.height.equalTo(1)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(bottomBtn.snp.top).offset(0)
//        }
//    }
    
    //App展示分类的点击事件
    func showKindClick(sender:UIButton){
        
        let vc = ShopGoodsKindViewController()
        vc.merchantId = merchants_id ?? ""
        vc.merchantName = merchantsInfo?.merchants_name ?? ""
        vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        vc.modalTransitionStyle = .crossDissolve
        vc.itemClick = { data,index in
            let goods = GoodsViewController()
            goods.currentIndex = index
            goods.merchantId = self.merchants_id ?? ""
            goods.title =  self.merchantsInfo?.merchants_name ?? ""
            goods.datas = data
            self.navigationController?.pushViewController(goods, animated: false)
        }
        self.navigationController?.present(vc, animated: false, completion: nil)

    }
    @IBAction func backClick(_ sender: UIButton) {
      
        self.navigationController?.popViewController(animated: true)
    }
//    func hideKindClick(){
//
//        bottomBtn.isSelected = !bottomBtn.isSelected
//        self.showView.isHidden = true
//
//    }
    
    //跳转到搜索页面
    @IBAction func searchClick(_ sender: UIButton) {
        if merchants_id == nil{
            ProgressHUD.showMessage(message: "查找不到该店的信息，请稍后再试")
            return
        }
        let search = SearchGoodsViewController()
        search.merchant_id =  merchants_id!
        self.navigationController?.pushViewController(search, animated: false)
    }
    
    @IBAction func skipShopCarClick(_ sender: UIButton) {
       let shop = ShoppingCartVC()
        self.navigationController?.pushViewController(shop, animated: true)
    }

    @IBAction func popViewClick(_ sender: UIButton) {
        NetworkingHandle.fetchNetworkData(url: "/api/User/has_message", at: self, success: { (response) in
            if let a = response["data"] as? String{
                if a == "1"{
                   self.has_message =  true
                }else{
                    self.has_message =  false

                }
            }
        }) {
            
        }
        if rightTab == nil{
            rightControl = UIControl()
            rightControl.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            rightControl.backgroundColor  = RGBA(r: 0, g: 0, b: 0, a: 0)
            rightControl.addTarget(self, action: #selector(hiderightTab), for: .touchUpInside)
            self.view.addSubview(rightControl)
            
            tabBg = UIView()
            tabBg.frame = CGRect.init(x: kScreenWidth - 185, y: 60, width: 180, height: 160)
            tabBg.layer.shadowColor = UIColor.black.cgColor
            tabBg.layer.shadowOpacity = 0.8
            tabBg.layer.shadowOffset = CGSize.init(width: 0, height: 0)
            tabBg.layer.shadowRadius = 4.0
            tabBg.backgroundColor = UIColor.white
            tabBg.layer.cornerRadius = 4
            rightControl.addSubview(tabBg)
            
            rightTab = UITableView()
            rightTab.frame =  tabBg.bounds
            rightTab.delegate = self
            rightTab.dataSource = self
            tabBg.addSubview(rightTab)
            rightTab.register(UINib.init(nibName: "RightTabCell", bundle: nil), forCellReuseIdentifier: "RightTabCell")
            
        }else{
            rightControl.isHidden = false
        
        }
        
    }
    func hiderightTab(){
        rightControl.isHidden = true
    }
    @IBAction func attentionClick(_ sender: UIButton) {
        
    }
    
      
    
    
}
extension MerchantViewController:UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        tableView.separatorInset = UIEdgeInsets.zero
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightTabCell") as! RightTabCell
        cell.icon.image = imageNames[indexPath.row]
        cell.message.text =  titles[indexPath.row]
        if indexPath.row == 0 && has_message == true{
        //如果有消息
            
           cell.havemessage.isHidden = false
        }else{
            cell.havemessage.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        
        if tableView ==  rightTab {
            rightControl.isHidden = true
            if indexPath.row == 0{
                let message = MessageViewController()
                self.navigationController?.pushViewController(message, animated: true)
            }
           else if indexPath.row == 1{
                self.navigationController?.popToRootViewController(animated: true)
               
            }
            else if indexPath.row == 2
            {
                let merchantVC = MerchantShopDescViewController()
                merchantVC.merchantInfo = merchantsInfo!
                self.navigationController?.pushViewController(merchantVC, animated: true)
            }
            else if indexPath.row == 3
            {
                if merchantsInfo?.contact_mobile != ""{
                    let str = String(format:"telprompt://%@",(merchantsInfo!.contact_mobile)!)
                    UIApplication.shared.openURL(URL(string:str )!)
                }else{
                    ProgressHUD.showMessage(message: "抱歉，暂时联系不了")
                }
                
            }
            
        }
    }
}
