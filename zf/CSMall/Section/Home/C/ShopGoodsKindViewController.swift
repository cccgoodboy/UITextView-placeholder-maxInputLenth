//
//  ShopGoodsKindViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/21.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ShopGoodsKindViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    var itemClick:(([MerchantsClassModel],Int)->())?
    @IBAction func closeClick(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    var merchantId = ""
    var merchantName = ""
    var merchantsclass:[MerchantsClassModel]?

    @IBOutlet weak var kindView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
                layout.itemSize = CGSize.init(width: (kScreenWidth - 22*4)/3, height: 30)

        kindView.register(UINib.init(nibName: "ShowKindCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowKindCollectionViewCell")

        NetworkingHandle.fetchNetworkData(url: "/api/Mall/merchants_class", at: self, params: ["merchants_id":merchantId], isShowHUD: false, isShowError: true, success: { (response) in
            
            self.merchantsclass = ([MerchantsClassModel].deserialize(from: response["data"] as? NSArray) as! [MerchantsClassModel])
            self.kindView.reloadData()
        }) {
            
        }
        self.modalPresentationStyle = .custom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return merchantsclass?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowKindCollectionViewCell", for: indexPath) as! ShowKindCollectionViewCell
        
        cell.kindtitle.text = merchantsclass?[indexPath.row].class_name ?? ""
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        print(indexPath.row)
//        bottomBtn.isSelected = !bottomBtn.isSelected
//        self.showView.isHidden = true
//        let goods = GoodsViewController()
//        goods.currentIndex = indexPath.row
//        goods.merchantId = merchantId ?? ""
//        goods.title = merchantName //"小馋猫&美味零食店"
//        goods.datas = merchantsclass!
        self.itemClick?(merchantsclass!,indexPath.row)
//        self.navigationController?.pushViewController(goods, animated: false)
        self.dismiss(animated: true, completion: nil)

    }


}
