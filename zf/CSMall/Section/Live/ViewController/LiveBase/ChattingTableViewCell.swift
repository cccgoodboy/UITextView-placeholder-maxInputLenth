//
//  ChattingTableViewCell.swift
//  CrazyEstate
//
//  Created by 梁毅 on 2017/1/11.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import MLEmojiLabel

class ChattingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankBtn: UIButton!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var chat: Chat!{
        willSet(m) {
            if m.user_id == "-000" {
                rankBtn.isHidden = true
                emojiLabel.textColor = UIColor(hexString: "#ea4933")
                let content = m.userName + ": " + m.content
                let att = NSMutableAttributedString(string: content)
                att.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: (content as NSString).range(of: m.userName + ": "))
                emojiLabel.attributedText = att
            }
            else {
                emojiLabel.textColor = UIColor.white
                                
                if let name = m.atUserName {
                    let content = m.userName + ": " + "@" + name + " " + m.content
                    if m.isAtOneself {
                        emojiLabel.textColor = themeColor
                        emojiLabel.text = content
                    } else {
                        let att = NSMutableAttributedString(string: content)
                        att.addAttributes([NSForegroundColorAttributeName: themeColor], range: (content as NSString).range(of: m.userName + ": "))
                        emojiLabel.attributedText = att
                    }
                } else {
                    let content = m.userName + ": " + m.content
                    let att = NSMutableAttributedString(string: content)
                    att.addAttributes([NSForegroundColorAttributeName: themeColor], range: (content as NSString).range(of: m.userName + ": "))
                    emojiLabel.attributedText = att
                }
                emojiLabel.sizeToFit()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //rankBtn.layer.cornerRadius = 5
        emojiLabel.isUserInteractionEnabled = true
        rankBtn.isHidden = true
        self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
