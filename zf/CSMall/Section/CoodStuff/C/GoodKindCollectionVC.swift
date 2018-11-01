//
//  GoodKindCollectionVC.swift
//  CSMall
//
//  Created by taoh on 2017/9/11.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

private let reuseIdentifier = "ShoppingCollectionViewCell"


class GoodKindCollectionVC: UICollectionViewController{
  
    var shopCarCollect:UICollectionView!
    var recommend = RecommendClassModel()
    var allData:[MerchantsGoodsListModel] = [MerchantsGoodsListModel]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(UINib.init(nibName: "GoodKindViewheader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodKindViewheader")
        collectionView?.register(UINib.init(nibName: "ShoppingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShoppingCollectionViewCell")
        collectionView?.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.pageNo = 1
            self.loadData(page: self.pageNo)
            
        })
        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.pageNo += 1
            self.loadData(page: self.pageNo)
        })
        self.collectionView?.mj_header.beginRefreshing()
        
    }
    func loadData(page:Int) {
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/class_goods", at: self, params: ["page":page,"class_uuid":recommend.class_uuid ?? ""], hasHeaderRefresh: collectionView, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["goodsBean"] as? NSArray{
                if page == 1{
                    self.allData.removeAll()
                }
                if data.count < 10{
                    self.collectionView?.mj_footer.endRefreshingWithNoMoreData()
                }
                self.allData += [MerchantsGoodsListModel].deserialize(from: data) as! [MerchantsGoodsListModel]
            }
//            self.collectionView?.mj_footer.isAutomaticallyHidden =  true
            
            self.collectionView?.reloadData()
        }) {
            if self.pageNo > 1 {
                self.pageNo -= 1
            }
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allData.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCollectionViewCell", for: indexPath) as! ShoppingCollectionViewCell
        cell.refershData(model: allData[indexPath.row])
        return  cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return  CGSize.init(width: kScreenWidth, height: 156/375*kScreenWidth)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodKindViewheader", for: indexPath) as! GoodKindViewheader
        header.banner.sd_setImage(with: URL.init(string: recommend.template_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        header.kind.text = recommend.class_desc ?? recommend.class_name
        header.kind.textColor = themeColor
        header.rightkindView.backgroundColor = themeColor// UIColor.init(hexString: recommend.class_color ?? "3AC2A6")
        header.leftkindView.backgroundColor =  themeColor//UIColor.init(hexString: recommend.class_color ?? "3AC2A6")
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = GoodsDetailVC()
        vc.goods_id = allData[indexPath.row].goods_id ?? "0"
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
