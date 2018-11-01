//
//  MineViewController.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/28.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: CustomCollectionViewFlowLayout!
    
    let itemTitles:[String] = [
//        NSLocalizedString("Myaccount", comment: "我的账号") ,
        NSLocalizedString("Mycollection", comment: "我的收藏"),
        NSLocalizedString("Myinteresting", comment: "我的关注"),
        NSLocalizedString("Myaddress", comment: "我的地址"),
        NSLocalizedString("Mydiscountcoupon", comment: "我的优惠券"),
        NSLocalizedString("Applyforashop", comment: "成为卖家"),
        NSLocalizedString("Set", comment: "设置"),
        NSLocalizedString("Help", comment: "帮助"),
        NSLocalizedString("Aboutus", comment: "关于我们")]
    
    var userInfo:CSUserInfoModel?

    let itemImgs = [//"wode_zhanghao",
                    "wode_shoucang","wode_guanzhu","wode_dizhi","wode_youhuiquan","wode_chengweimaijia","wode_shezhi","wode_bangzhu","wode_guanyuwomen"]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        layout.headerReferenceSize = CGSize(width:kScreenWidth, height: 200/375.0 * kScreenWidth + 110)
        let w = (kScreenWidth - 2 ) / 3
        layout.itemSize = CGSize(width: w, height: 115/125.0 * w)

        collectionView.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
        collectionView.register(UINib.init(nibName: "MineCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MineCollectionReusableView")
        collectionView.register(UINib.init(nibName: "MineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MineCollectionViewCell")

    }
    func loadUserInfo(){
        NetworkingHandle.fetchNetworkData(url: "/api/user/user_info", at: self,isShowHUD:false, success: { (response) in
            if let data = response["data"] as? NSDictionary{
                self.userInfo = CSUserInfoModel.deserialize(from: data)
                CSUserInfoHandler.saveUserInfo(model:self.userInfo!)
                self.collectionView.reloadData()
            }
        }) {
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return itemTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCollectionViewCell", for: indexPath) as! MineCollectionViewCell
        cell.itemName.text = itemTitles[indexPath.row]
        cell.itemImg.image =  UIImage.init(named: itemImgs[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MineCollectionReusableView", for: indexPath) as! MineCollectionReusableView
        if userInfo != nil{
            
            header.reloadUSerData(model:userInfo!)
            
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
//        case 0://我的账号
//
//            self.navigationController?.pushViewController(AccountViewController(), animated: true)
//
//            break
            
        case 0://我的收藏
            
            self.navigationController?.pushViewController(MyCollectViewController(), animated: true)
            break
        case 1://我的关注
            self.navigationController?.pushViewController(MyAttentionViewController(), animated: true)

            
            break
        case 2://我的地址
           let adressVc = AddressVC()
           adressVc.fromMine = true
           self.navigationController?.pushViewController(adressVc, animated: true)
            break
        case 3://我的优惠劵
            self.navigationController?.pushViewController(DiscountCouponViewController(), animated: true)

            break
        case 4://成为卖家
            
            let web = MDWebViewController()
            web.url = userAgerementURL + "12"
            web.title = "成为卖家"
            web.type = 1
            self.navigationController?.pushViewController(web, animated: true)

            break
        case 5://设置
            
            self.navigationController?.pushViewController(SettingViewController(), animated: true)

            break
        case 6://帮助
            self.navigationController?.pushViewController(HelpViewController(), animated: true)
            
            break
        case 7://关于我们
            let web = MDWebViewController()
            web.url = userAgerementURL + "13"
            web.title = "关于我们"
            self.navigationController?.pushViewController(web, animated: true)

            break
            
            
        default:
            print("")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        self.navigationController?.navigationBar.change(themeColor, with: scrollView, andValue: 600)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.star()
        self.navigationController?.navigationBar.isTranslucent = true
        scrollViewDidScroll(collectionView)
        self.navigationController?.navigationBar.isHidden = true
        loadUserInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.reset()
        self.navigationController?.navigationBar.isHidden = false

    }
    

}
class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let collectionView = self.collectionView
        let insets = collectionView?.contentInset
        let offset = collectionView?.contentOffset
        let minY = -((insets?.top)!)
        
        let attributesArray = super.layoutAttributesForElements(in: rect)
        if offset!.y < minY {
            let headerSize = self.headerReferenceSize
            let deltaY = CGFloat(fabsf(Float((offset?.y)! - CGFloat(minY))))
            for attrs: UICollectionViewLayoutAttributes in attributesArray! {
                if attrs.representedElementKind == UICollectionElementKindSectionHeader {
                    var headerRect = attrs.frame
                    headerRect.size.height = max(minY, headerSize.height + deltaY)
                    headerRect.origin.y = headerRect.origin.y - deltaY
                    attrs.frame = headerRect
                    break
                }
            }
        }
        return attributesArray
    }
}
