//
//  LAHomeCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
class LAHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleBg: UIView!
    //    @IBOutlet weak var la_img: UIImageView!
//
//    @IBOutlet weak var la_merchant_name: UILabel!
    @IBOutlet weak var la_name: UIButton!//主播签名
    
    @IBOutlet weak var la_watch_num: UIButton!//观看人数
    @IBOutlet weak var w_title: UIButton!//主播昵称
    
    @IBOutlet weak var la_header_img: UIImageView!//头像
    
    @IBOutlet weak var la_state: UILabel!//直播状态
    var  type = 1//  1是直播   2是录播个人中心跳转过来的
    var model:LiveListModel!{
        willSet(m){
            titleBg.isHidden = false
            
            if type ==  1{
                w_title.setImage(#imageLiteral(resourceName: "zhubo"), for: .normal)

                la_watch_num.setImage(#imageLiteral(resourceName: "livingguanzhu"), for: .normal)
                la_name.setTitle(m.signature ?? "", for: .normal)
                w_title.setTitle(m.username ?? "", for: .normal)

            }else{
                titleBg.isHidden = true
                w_title.setTitle(m.title ?? "", for: .normal)
                la_watch_num.setImage(#imageLiteral(resourceName: "zaixinrenshu"), for: .normal)
                la_name.setTitle(m.signature ?? "", for: .normal)

            }
            la_watch_num.setTitle(m.fans_count ?? "", for: .normal)

            if m.live_id != "0"{
                la_header_img.sd_setImage(with: URL.init(string: m.play_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                la_state.isHidden = false
            }else{
                la_header_img.sd_setImage(with: URL.init(string: m.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                la_state.isHidden = true
            }            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        la_state.backgroundColor = themeColor

//        w_title
    }

}
