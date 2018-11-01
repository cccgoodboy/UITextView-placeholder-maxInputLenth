//
//  SearchShopViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/26.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class SearchShopViewController: UIViewController ,UISearchBarDelegate{
    
    var searchBar: UISearchBar!
    var allPage:Int = 1
    @IBOutlet weak var searchCollection: UICollectionView!
    var allData:[MerchantsModel] = []
    var remeberData:[MerchantsModel] = []
    
    @IBOutlet weak var showLab: UILabel!
    
    @IBOutlet var itemBtn: [UIButton]!
    var isSearch =  false //是否搜索结束了 没结束显示推荐商品，结束了显示搜索结果
    var selectedBtn: UIButton!
    
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
    @IBOutlet weak var showConditionView: UIView!
    @IBOutlet weak var shopCollection: UICollectionView!
    var type = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView()
        
        self.searchBar.becomeFirstResponder()
        shopCollection.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        searchCollection.register(UINib.init(nibName: "MerchantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MerchantCollectionViewCell")
        
        self.shopCollection.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadData()
        })
        self.shopCollection.mj_header.beginRefreshing()
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
    func titleView() {
        
        let tView = UIView()
        if #available(iOS 11, *){
            tView.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 30 , height: 44)
            tView.extendRegionType = ExtendRegionType.ClickExtendRegion
        }else{
            tView.frame = CGRect(x: -20, y: 0, width: kScreenWidth - 60 , height: 44)
        }

        tView.backgroundColor = UIColor.clear
        tView.extendRegionType = ExtendRegionType.ClickExtendRegion
        //        tView.backgroundColor =  UIColor.red
        searchBar = UISearchBar()
        
        searchBar.backgroundColor =  UIColor.clear
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        
        searchBar.placeholder = NSLocalizedString("Hint_91", comment: "请输入店铺名称、商家ID号")
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.setSearchFieldBackgroundImage(getImage(color:RGBA(r: 251, g:251, b: 251, a: 0.6), height: 29), for: .normal)
        searchBar.setImage(#imageLiteral(resourceName: "haohuo_sousuo"), for: .search, state: .normal)
        searchBar.enablesReturnKeyAutomatically = true
        tView.addSubview(searchBar)
        
        let tf = searchBar.value(forKey: "_searchField") as? UITextField
        tf?.font = defaultFont(size: 13)
        tf?.tintColor = themeColor
        tf?.textColor = UIColor(hexString: "#999999")
        tf?.layer.cornerRadius = 15
        tf?.layer.masksToBounds = true
        searchBar.frame = tView.frame
        
        self.navigationItem.titleView = tView
        for btn in itemBtn {
            btn.setTitleColor(themeColor, for: .selected)
        }
        showConditionView.isHidden = true
        self.itemBtn[0].isSelected = true
        
        selectedBtn = self.itemBtn[0]
        
        searchCollection.isHidden = true
        shopCollection.isHidden = false
    }
    func getImage(color: UIColor, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        shopCollection.isHidden = false
        showConditionView.isHidden =  true
        searchCollection.isHidden = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.shopCollection.isHidden = false
        self.searchCollection.isHidden = true
        showConditionView.isHidden =  true

    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let tf = searchBar.value(forKey: "_searchField") as? UITextField
        if tf?.text == nil || tf?.text == ""{
            
            return
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let tf = searchBar.value(forKey: "_searchField") as? UITextField
        if tf?.text == nil || tf?.text == ""{
            ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_91", comment: "请输入店铺名称、商家ID号"))
//            ProgressHUD.showNoticeOnStatusBar(message: "请输入店铺名称、商家ID号")
            return
        }
        isSearch = true
        searchBar.resignFirstResponder()
        
        self.shopCollection.isHidden = true
        self.showConditionView.isHidden = false
        self.searchCollection.isHidden = false
        
        self.searchCollection.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.allPage = 1
            self.loadData(page: self.allPage,searchStr:(tf!.text ?? "")!,type:self.type)
        })
        self.searchCollection.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.allPage += 1
            self.loadData(page: self.allPage,searchStr:(tf!.text ?? "")!,type:self.type)
        })
        self.searchCollection.mj_header.beginRefreshing()
        
    }
    func loadData(page:Int,searchStr:String,type:String){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/searchMerchants", at: self, params: ["p":page,"name":searchStr,"type":type], hasHeaderRefresh: searchCollection, success: { (response) in
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension SearchShopViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
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

