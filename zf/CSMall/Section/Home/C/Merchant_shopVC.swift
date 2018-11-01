//
//  Merchant_shopVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/5.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class Merchant_shopVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var shopCarCollect:UICollectionView!
    
    var allDataArr: [MerchantsGoodsListModel] = []
    var allPage = 1

    var merchants_id:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyShopCar()

        self.shopCarCollect.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        self.shopCarCollect.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        self.shopCarCollect.mj_header.beginRefreshing()
        
        
    }
    func loadData(page:Int){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/merchants_goods", at: self, params: ["merchants_id":merchants_id ?? "","p":page], hasHeaderRefresh: shopCarCollect, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
            
              let list = [MerchantsGoodsListModel].deserialize(from: data) as! [MerchantsGoodsListModel]
                
                if list.count == 0{
                    self.shopCarCollect.mj_footer.isHidden = true
                    self.shopCarCollect.mj_footer.endRefreshing()
                }
                if page == 1 {
                    self.allDataArr.removeAll()
                }
                self.allDataArr += list
            }
            self.shopCarCollect.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }
        
    }
    func emptyShopCar(){
//        shopCarCollect = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 165 - 46 ), collectionViewLayout: UICollectionViewFlowLayout())
        shopCarCollect = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 165), collectionViewLayout: UICollectionViewFlowLayout())

        shopCarCollect.backgroundColor = UIColor.white
        view.addSubview(shopCarCollect)
        
        shopCarCollect.delegate = self
        shopCarCollect.dataSource = self
        shopCarCollect.register(UINib.init(nibName: "ShoppingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShoppingCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allDataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{// 11:14
        
        return CGSize.init(width: (kScreenWidth - 1)/2, height: 254/185*(kScreenWidth - 1)/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 1, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCollectionViewCell", for: indexPath) as! ShoppingCollectionViewCell
        cell.refershData(model:allDataArr[indexPath.row])
        return  cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GoodsDetailVC()
        vc.goods_id = allDataArr[indexPath.row].goods_id ?? "0"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
