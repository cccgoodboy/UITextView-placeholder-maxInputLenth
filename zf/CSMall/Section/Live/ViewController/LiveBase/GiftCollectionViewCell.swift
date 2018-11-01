
//
//  GiftCollectionViewCell.swift
//  52LiveStreaming
//
//  Created by 梁毅 on 2016/11/8.
//  Copyright © 2016年 zhengan88. All rights reserved.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var selectedBg: UIView!
    
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    var model: GiftModel! {
        willSet(m) {
            if  m.img != nil {
                img.sd_setImage(with: URL(string: m.img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            } else {
                img.image = nil
                self.stateLabel.isHidden = true
            }
            if m.price == nil {
                money.text = ""
            } else {
                money.text = m.price! + "钻石"
            }
            if m.name == nil {
                titleLabel.text = ""
            } else {
                stateLabel.backgroundColor = UIColor(hexString: "#CE1939")
                stateLabel.textAlignment = .center
                stateLabel.layer.masksToBounds = true
                stateLabel.layer.cornerRadius = 6
                titleLabel.text = m.name!
            }
            if m.is_running == "2" {
                self.stateLabel.isHidden = false
            } else if m.is_running == "1" {
                self.stateLabel.isHidden = true
            }
            selectedBg.isHidden = !m.isSelected
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBg.layer.borderColor = UIColor.yellow.cgColor
        selectedBg.layer.borderWidth = 0.5
        
        imgWidth.constant = kScreenWidth/5 - 20
        imgHeight.constant = kScreenWidth/5 - 43
    }

}
