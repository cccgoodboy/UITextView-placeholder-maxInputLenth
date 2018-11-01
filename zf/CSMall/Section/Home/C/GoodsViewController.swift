//
//  GoodsViewController.swift
//  CSLiving
//
//  Created by 梁毅 on 2017/8/17.
//  Copyright © 2017年 taoh. All rights reserved.
//

/**
 *
 *  商家的商品
 *
 **/
import UIKit


class GoodsPagerItemData {
    var data = [MerchantsClassGoodsModel]()
    var page = 0
    var isLoaded = false
    var isLoading = false
}
class GoodsViewController: TYTabPagerController,TYTabPagerControllerDataSource,TYTabPagerControllerDelegate{
    var currentIndex = 0
    var isFirst =  true
    var merchantId = ""
    var datas:[MerchantsClassModel] = []
    var pagerItemsData = [Int: GoodsPagerItemData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.dataSource = self
        self.delegate = self
        self.register(GoodListViewController.self, forPagerCellWithReuseIdentifier: "GoodListViewController")

        self.reloadData()
    }
    func numberOfControllersInTabPagerController() -> Int {
        return datas.count
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        
        let vc = tabPagerController.dequeueReusablePagerCell(withReuseIdentifier: "GoodListViewController", for: index) as! GoodListViewController
        vc.merchants_id = merchantId
        let classInfo = datas[index]
        
        let pagerItemData: GoodsPagerItemData
        if let d = pagerItemsData[index] {
            
            pagerItemData = d
        }
        else {
            pagerItemData = GoodsPagerItemData()
            pagerItemsData[index] = pagerItemData
        }
        vc.pagerItemData = pagerItemData
        vc.title = classInfo.class_name ?? ""
        vc.class_uuid = classInfo.class_uuid ?? ""
//        vc.goodsClick = { good  in
//
//        }
        if isFirst == true{
            
            self.scrollToController(at: currentIndex, animate: false)
        }
        isFirst = false
        return vc;
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
       
        return datas[index].class_name ?? NSLocalizedString("Hint_29", comment: "分类出错了")
    }
  
    
}

