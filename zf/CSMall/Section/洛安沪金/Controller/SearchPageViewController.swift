//
//  SearchPageViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SearchPageViewController: PageViewController ,UISearchBarDelegate{
    
    
    @IBOutlet var itemBtn: [UIButton]!
    
    let sgoods = SearchPShopViewController()
    let sanchor = SearchPAnchorViewController()
    var sliderLine : UILabel!
    var selectedBtn: UIButton!
    var searchBar: UISearchBar!
    var searchShop = false
    var searchAnchor = false
    var searchText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView()
        
        self.viewControllerArray = [sgoods,sanchor]
        self.buttonArray = itemBtn
        
        selectedBtn = itemBtn[0]
        
        var frame = self.view.bounds
        frame.origin.y = 45
        frame.size.height -= 45
        pageViewController.view.frame = frame
        pageViewController.setViewControllers([self.viewControllerArray[0]], direction: .forward, animated: true, completion: nil)
        
        self.sliderLine = UILabel()
        self.sliderLine.frame = CGRect(x: kScreenWidth/2 * CGFloat(0), y: 42, width: kScreenWidth/2, height: 2)
        self.sliderLine.backgroundColor = UIColor(hexString: "E53D3D")
        self.view.addSubview(self.sliderLine)
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
        
        searchBar.placeholder = "请输入店铺名称、主播名称"
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
    }
    
    @IBAction func itemClick(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1) {
            self.sliderLine.frame = CGRect(x: sender.frame.origin.x, y: 42, width: sender.frame.size.width, height: 2)
        }
        if searchText != "" && searchAnchor == false{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchanchor"), object: nil, userInfo: ["content" :searchText])
            sanchor.seaarchText = searchText
            
            searchAnchor = true
            
        }
        if searchText != "" && searchShop == false{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchmerchant"), object: nil, userInfo: ["content" :searchText])
            searchShop = true
        }
        self.selectedViewController(atButton: sender )
        
//        if searchAnchor == true{
//            sanchor.havedsearch = true
//        }
        
    }
    // 重写父类刷新按钮方法
    override func viewControllerTransition(toIndex index: Int) {
        
        let btn = self.buttonArray[index]
        UIView.animate(withDuration: 0.1) {
            self.sliderLine.frame = CGRect(x: btn.frame.origin.x, y: 42, width: btn.frame.size.width, height: 2)
        }
        self.title = btn.titleLabel?.text
        
        if selectedBtn === btn {
            
            return
        }
        
        
        selectedBtn.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
                
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:--UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if selectedBtn == itemBtn[0]{
            sgoods.shopCollection.isHidden = false
            sgoods.showConditionView.isHidden =  true
            sgoods.searchCollection.isHidden = true
        }
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if selectedBtn == itemBtn[0]{
            sgoods.shopCollection.isHidden = false
            sgoods.searchCollection.isHidden = true
            sgoods.showConditionView.isHidden =  true
        }
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
            ProgressHUD.showNoticeOnStatusBar(message: "请输入店铺名称、商家ID号")
            return
        }
        searchText  = tf!.text ?? ""
        if selectedBtn == itemBtn[0]{
            
            searchBar.resignFirstResponder()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchmerchant"), object: nil, userInfo: ["content" :tf!.text ?? ""])
            searchShop = true
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchanchor"), object: nil, userInfo: ["content" :tf!.text ?? ""])
            searchAnchor = true
        }
    }
    
    
}

