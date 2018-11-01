//
//  OtherCenterCollectionReusableView.swift
//  CSMall
//
//  Created by taoh on 2017/11/28.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class OtherCenterCollectionReusableView: UICollectionReusableView {
    
    @IBAction func userAttenClick(_ sender: UIButton) {
        NetworkingHandle.fetchNetworkData(url: "api/live/follow", at: self, params: ["user_id2":model.member_id!], success: { (respon) in
            if self.model.is_follow == "1"{
                self.model.is_follow = "2"
               self.userAttenBtn.setTitle("已关注", for: .normal)

            }else{
                self.model.is_follow = "1"
                self.userAttenBtn.setTitle("+关注", for: .normal)
            }
        }) {
            
        }
    }
    @IBOutlet weak var userIDLab: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userSignLab: UILabel!
    @IBOutlet weak var userAttenBtn: UIButton!
    @IBOutlet weak var usersexImg: UIImageView!
    
    @IBOutlet weak var usernameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    var model:OtherInfoModel!{
        willSet(m){
            userIDLab.text = m.ID ?? ""
            usernameLab.text = m.username ?? ""
            userAttenBtn.isHidden = false
            if m.is_follow == "1"{//1   未关注；2关注；3自己
                userAttenBtn.setTitle("+关注", for: .normal)
            } else if m.is_follow == "2"{
                userAttenBtn.setTitle("已关注", for: .normal)
            }else{
                userAttenBtn.isHidden = true
            }
            userImg.sd_setImage(with: URL.init(string: m.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            userSignLab.text = m.signature ?? ""
            if m.sex == "1"{
                usersexImg.image = #imageLiteral(resourceName: "man")
            }else if m.sex == "2"{
                usersexImg.image = #imageLiteral(resourceName: "icon_woman")
            }else{
                usersexImg.image = #imageLiteral(resourceName: "xinbie")
            }
        }
    }
}
