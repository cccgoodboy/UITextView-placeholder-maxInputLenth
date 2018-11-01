//
//  PrivateChatAnchorTableViewCell.swift
//  MoDuLiving
//
//  Created by 梁毅 on 2017/3/3.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class PrivateChatAnchorTableViewCell: UITableViewCell {

//    @IBOutlet weak var messageBtn: UIButton!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var headImg: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var sexImg: UIImageView!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var badge: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBG.layer.cornerRadius = 5
        viewBG.layer.masksToBounds = true
        
        headImg.layer.cornerRadius = 39/2
        headImg.layer.masksToBounds = true
        
//        badge.layer.cornerRadius = badge.frame.size.width/2
//        badge.layer.masksToBounds = true
    }
    var model: PrivateChatModel! {
        willSet(m) {
            
            usernameLabel.text = m.name
            headImg.kf.setImage(with: URL(string: m.img))
            messageLabel.text = EaseConvertToCommonEmoticonsHelper.convert(toSystemEmoticons: m.content)
            sexImg.isHidden = false
            if m.sex == "1" {
                sexImg.image = UIImage(named:"nan")
            } else {
                sexImg.image = UIImage(named:"nv")
            }
            if m.unreadCount > 0 {
                badge.isHidden = false
                badge.text = "\(m.unreadCount)"
                let size = badge.sizeThatFits(CGSize(width: 100, height: 16))
                let s = max(size.height, size.width)
                badge.layer.cornerRadius = s/2
                badge.layer.masksToBounds = true
            } else {
                badge.isHidden = true
            }
            timeLabel.text = m.time
            
        }
    }
    var sysMessageModel: sysMessageModel! {
        willSet(model) {
            usernameLabel.text = "龙小脉"
            headImg.image = UIImage(named:"Icon-60")
            messageLabel.text = model.content!
            timeLabel.text = model.time!
            sexImg.isHidden = true
            badge.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
class MessageModel: KeyValueModel {
    var message_id: String?
    var type: String?
    var user_id: String?
    var user_id2: String?
    var content: String?
    var state: String?
    var intime: String?
    //var uptime: String?
    var date: String?
    var information_id: Any?
    var stats: String?
    
    var img: String?
    var username: String?
    var info_img: String?
}

