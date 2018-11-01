//
//  GiftView.swift
//  CrazyEstate
//
//  Created by 梁毅 on 2017/2/19.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
let gift_listKey = "gift_listKey"
class GiftModel: KeyValueModel {

//    var gift_id: String? 原来
//    var name: String?
//    var img: String?
//    var price: String?
//    var experience: String?
//    var is_running: String?
//    var is_special: String?
//    var isSelected = false
    
    //更改

    var gift_id: String?
    var name: String?
    var img: String?
    var price: String?
    var experience: String?
    var is_running: String?
//    var is_special: String?
    var isSelected = false
    var num_norms:String?
    //new key
    var intime:String?
    var uptime:String?
    var batchGift: String?// 1为批量送礼，0为单个送礼
    //批量送礼数量
    var num: String?
}

class GiftView: UIView ,UITextFieldDelegate{
    
    var dataArr = [GiftModel]()
    var live_ids: String!
    
    @IBOutlet weak var giftNumTF: UITextField!
    @IBAction func skipChargeClick(_ sender: UIButton) {
        NotificationCenter.default.addObserver(self, selector: #selector(rechargeSuccess(niti:)), name: NSNotification.Name(rawValue: "rechargeSuccess"), object: nil)
        responderViewController()?.navigationController?.pushViewController(AccountViewController(), animated: true)
    }
    @IBOutlet weak var moneybutton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var snedBtn: UIButton!
//    @IBOutlet weak var layout: HorizontalPageableLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedModel: GiftModel?
    var didSelected: ((_: GiftModel) ->())?
    
    static func show(atView: UIView, live_id: String, clickSend: @escaping ((_: GiftModel) ->())) -> GiftView {
        
        let selfView = Bundle.main.loadNibNamed("GiftView", owner: nil
            , options: nil)!.last as! GiftView
        atView.addSubview(selfView)
        selfView.live_ids = live_id
        selfView.didSelected = clickSend
        
        let view = selfView.contentView
        view?.isHidden = false
        var frame = view?.frame
        let oldFrame =  frame
        frame?.origin.y = selfView.frame.size.height
        view?.frame = frame!
        UIView.animate(withDuration: 0.25, animations: {
            view?.frame = oldFrame!
        })
        
        return selfView
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           return true
    }
    func show() {
        
        self.contentView?.isHidden = false
        self.isHidden = false
        var frame = self.contentView?.frame
        frame?.origin.y = kScreenHeight - (frame?.height)!
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView?.frame = frame!
        })
    }
    func rechargeSuccess(niti:NotificationCenter){
        
        reloadMoneyLabel()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.giftNumTF.contentHorizontalAlignment = .center
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        snedBtn.setTitleColor(themeColor, for: .normal)
        
        let itemW = kScreenWidth/5
        layout.itemSize = CGSize(width: itemW, height: itemW)
    
        collectionView.register(UINib(nibName: "GiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        reloadMoneyLabel()
        loadData()
    }
    //
    @IBAction func dismissButtonAction(_ sender: Any) {
        let view = self.contentView
        var frame = view?.frame
        frame?.origin.y += (frame?.size.height)!
        UIView.animate(withDuration: 0.25, animations: {
            view?.frame = frame!
        }) { (finished) in
            self.contentView.isHidden = true
            self.isHidden = true
        }
    }
    @IBAction func sendButtonAction(_ sender: UIButton) {
        if self.selectedModel == nil {
            ProgressHUD.showMessage(message: "请选择赠送的礼物")
            return
        }
        let param = ["live_id": self.live_ids!,"gift_id": selectedModel!.gift_id!,"number":giftNumTF.text!]
        NetworkingHandle.fetchNetworkData(url: "/api/live/give_gift", at: self, params: param, isShowHUD: false, success: { (result) in
            if self.selectedModel?.is_running == "1" {
                self.dismissButtonAction(self.snedBtn)
            }
            
            //新增字段，暂时写默认值
            self.selectedModel?.batchGift = "0"
            
            self.selectedModel!.num =  self.giftNumTF.text!
            self.didSelected?(self.selectedModel!)
            
            self.reloadMoneyLabel()
        })
    }

    func reloadMoneyLabel() {
        NetworkingHandle.fetchNetworkData(url: "/api/User/price_list", at: self,isShowError: false, success: { (response) in
            
            let dic = response["data"] as! [String: AnyObject]
            self.moneybutton.setTitle(dic["amount"] as? String ?? "0", for: .normal)
            CSUserInfoHandler.update(grade: dic["grade"] as? String)
        })

    }
    func loadData() {
        let ud = UserDefaults.standard
//        let resultDic = ud.object(forKey: gift_listKey) as? Dictionary<String, Any>
//        if resultDic != nil {
//            self.dataArr = GiftModel.modelsWithArray(modelArray: resultDic?["data"] as! [[String : AnyObject]]) as! [GiftModel]
//        }else {
            NetworkingHandle.fetchNetworkData(url: "/api/live/gift_list", at: self, isShowHUD: false, success: { (result) in
                let data = result["data"] as! [[String: AnyObject]]
                ud.set(result, forKey: gift_listKey)
                self.dataArr = GiftModel.modelsWithArray(modelArray: data) as! [GiftModel]
                self.collectionView.reloadData()
            })
//        }

    }
}
// collection
extension GiftView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let temp = dataArr.count % 10
        let count = temp == 0 ? dataArr.count : (10 - temp) + dataArr.count
        pageControl.numberOfPages = count/10
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCollectionViewCell", for: indexPath) as! GiftCollectionViewCell
        if indexPath.row + 1 > dataArr.count {
            cell.model = GiftModel()
        } else {
            cell.model = dataArr[indexPath.row]
        }
        return cell
    }
    // 代理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / (scrollView.frame.width))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row + 1 > dataArr.count {
            return 
        }
        self.selectedModel?.isSelected = false
        self.selectedModel = self.dataArr[indexPath.row]
        self.selectedModel?.isSelected = true
        collectionView.reloadData()
    }
}

class WatchLiveGiftView: UIView {
    
    var giftContainerView: XGiftContainerView = XGiftContainerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(giftContainerView)
        giftContainerView.snp.makeConstraints { (make) in
           make.edges.equalTo(0)
        }
        giftContainerView.backgroundColor =  UIColor.clear
    }
    func showTheGiftView(username: String, senderURL: String, giftName: String, giftURL: String,giftnum: String) {
        let gift = XGiftModel(senderName: username, senderURL: senderURL, giftName: giftName, giftURL: giftURL,giftNum :giftnum)
        self.giftContainerView.showGiftModel(gift)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



