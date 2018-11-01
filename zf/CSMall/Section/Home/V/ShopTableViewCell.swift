//
//  ShopTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/14.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var hint_01: UILabel!//商品描述
    @IBOutlet weak var hint_02: UILabel!//卖家服务
    
    @IBOutlet weak var hint_03: UILabel!//物流服务
    
    @IBOutlet weak var hint_04: UIButton!//进入店铺
    @IBOutlet weak var s_title: UILabel!
    @IBOutlet weak var s_image: UIImageView!

    @IBOutlet weak var m_salesvolume: UILabel!
    
    @IBOutlet weak var m_shopDescNum: UILabel!//商品描述
    
    @IBOutlet weak var m_logisticsNum: UILabel!//物流服务
    @IBOutlet weak var m_serviceNum: UILabel!//卖家服务
    @IBAction func shopClick(_ sender: Any) {
//        resignFirstResponder().
        responderViewController()?.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var watchLiveBtn: UIButton!
    
    @IBAction func gotoLiveClick(_ sender: UIButton) {
        
        if model.live_id != "0" && livemodel != nil{
            let liveModel =  LiveList()
            //去看直播
                liveModel.room_id = livemodel?.room_id
                liveModel.user_id = livemodel?.member_id!
                liveModel.play_address = livemodel?.play_address_m3u8
                liveModel.live_id = livemodel?.live_id
                liveModel.play_img = livemodel?.play_img
                liveModel.img = livemodel?.header_img
                liveModel.share_url = livemodel?.share_url
                liveModel.username = livemodel?.merchants_name
                liveModel.username = livemodel?.username
            WatchLiveViewController.toWatch(from: (responderViewController()!), model: liveModel)
        
        }
    }
  
   
    @IBOutlet weak var m_attentionBtn: UIButton!
    //关注按钮 未关注 +关注 关注 已关注
    @IBAction func m_attentionBtnClick(_ sender: UIButton) {//关注
        if model.is_follow == "2"{//已关注
            NetworkingHandle.fetchNetworkData(url: "/api/User/follow_merchants", at: self, params: ["user_id2":(model.member_id)!], success: { (response) in
                self.model.is_follow = "1"
                self.m_attentionBtn.setTitle(NSLocalizedString("Hint_88", comment: "关注"), for: .normal)
            }) {
            }
        }else{
            NetworkingHandle.fetchNetworkData(url: "/api/User/follow_merchants", at: self, params: ["user_id2":(model.member_id)!], success: { (response) in
                self.model.is_follow = "2"
                self.m_attentionBtn.setTitle(NSLocalizedString("Hint_89", comment: "已关注"), for: .normal)
            }) {
            }
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        hint_01.text = NSLocalizedString("Hint_84", comment: "商品描述")
        hint_02.text = NSLocalizedString("Hint_85", comment: "卖家描述")
        hint_03.text = NSLocalizedString("Hint_86", comment: "物流服务")
        hint_04.setTitle(NSLocalizedString("Hint_87", comment: "进入店铺"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    var livemodel:LiveListModel?
    var model:MerchantsInfoModel!{
        willSet(m){
            s_image.sd_setImage(with: URL.init(string: m.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            s_title.text = m.merchants_name ?? ""
            m_salesvolume.text = "\(NSLocalizedString("Monthlysales", comment: "月销量"))：\(m.month_sales ?? "0")"
            m_serviceNum.text = m.merchants_star2
            m_logisticsNum.text = m.merchants_star3
            m_shopDescNum.text = m.merchants_star1
            if m.live_id == "0"{
                watchLiveBtn.backgroundColor = UIColor.gray
                watchLiveBtn.layer.borderWidth = 0.0
                watchLiveBtn.setTitleColor(UIColor.white, for: .normal)
            }else
            {
                watchLiveBtn.backgroundColor = UIColor.white
                watchLiveBtn.setTitleColor(UIColor.red, for: .normal)

                watchLiveBtn.layer.borderColor = UIColor.red.cgColor
                watchLiveBtn.layer.borderWidth = 1.0
            }
            if m.is_follow == "3"{
                m_attentionBtn.isHidden = true
            }else{
                m_attentionBtn.isHidden = false
                if m.is_follow == "2"{
                    self.m_attentionBtn.setTitle(NSLocalizedString("Hint_89", comment: "已关注"), for: .normal)
                }else{
                    self.m_attentionBtn.setTitle(NSLocalizedString("Hint_88", comment: "+关注"), for: .normal)
                }
            }
        }
    }
}
