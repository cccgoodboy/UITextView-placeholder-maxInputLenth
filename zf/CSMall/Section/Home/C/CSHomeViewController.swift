//
//  CSHomeViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/24.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit


class GoodsClassPagerItemData {
    var data = [QueryLiveListByClassModel]()
    var page = 0
//    var banner = [BannerModel]()
    var isLoaded = false
    var isLoading = false
}

class CSHomeViewController: TYTabPagerController,TYTabPagerControllerDataSource,TYTabPagerControllerDelegate{
//    var currentIndex = 0
//    var isFirst =  true
//    var merchantId = ""
    var datas:[GoodsClassModel] = []
    var pagerItemsData = [Int: GoodsClassPagerItemData]()
    var refershBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "haohuo_sousuo"), style: .plain, target: self, action: #selector(searchClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "xiaoxi"), style: .plain, target: self, action: #selector(messageClick))

        self.navigationItem.title = "首页"
        
        refershBtn.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64)
        refershBtn.setTitle("点我刷新", for: .normal)
        refershBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        refershBtn.setTitleColor(UIColor.black, for: .normal)
        refershBtn.isHidden = true
        refershBtn.addTarget(self, action: #selector(refershData), for: .touchUpInside)
        self.view.addSubview(refershBtn)
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/parent_class", at: self, success: { (response) in
            self.refershBtn.isHidden = true
            
            if let a = response["data"] as? NSArray{
                self.datas = [GoodsClassModel].deserialize(from: a) as! [GoodsClassModel]
                self.reloadData()
            }
        }) {
            self.refershBtn.isHidden = false
        }
        
        view.backgroundColor = UIColor.white
        self.dataSource = self
        self.delegate = self
        self.register(HomeVC.self, forPagerCellWithReuseIdentifier: "HomeVC")
        
        //            self.reloadData()
    }
    func searchClick(){
        
        let search =  SearchShopViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }
    func messageClick(){
        let message = MessageViewController()
        self.navigationController?.pushViewController(message, animated: true)
    }
    func refershData(){
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/parent_class", at: self, success: { (response) in
            self.refershBtn.isHidden = true
            
            if let a = response["data"] as? NSArray{
                self.datas = [GoodsClassModel].deserialize(from: a) as! [GoodsClassModel]
                self.reloadData()
                
            }
        }) {
            self.refershBtn.isHidden = false
        }
        
    }
    func numberOfControllersInTabPagerController() -> Int {
        return datas.count
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        
        let vc = tabPagerController.dequeueReusablePagerCell(withReuseIdentifier: "HomeVC", for: index) as! HomeVC
        
        vc.class_id = datas[index].class_id ?? ""
        let classInfo = datas[index]
        
        let pagerItemData: GoodsClassPagerItemData
        if let d = pagerItemsData[index] {
            
            pagerItemData = d
        }
        else {
            pagerItemData = GoodsClassPagerItemData()
            pagerItemsData[index] = pagerItemData
        }
        vc.pagerItemData = pagerItemData
        vc.title = classInfo.class_name ?? ""
        
//        if isFirst == true{
//            
//            self.scrollToController(at: currentIndex, animate: false)
//        }
//        isFirst = false
        return vc;
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        
        return datas[index].class_name ?? "分类出错了"
    }
    
    
}

