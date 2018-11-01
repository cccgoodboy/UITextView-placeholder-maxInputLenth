//
//  KindCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class KindCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var k_state: UILabel!
    
    @IBOutlet weak var k_img: UIImageView!
    @IBOutlet weak var k_per: UILabel!
    @IBOutlet weak var k_name: UILabel!
    var model:LiveListModel!{
        willSet(m){
            k_state.backgroundColor = themeColor
            k_img.sd_setImage(with: URL.init(string: m.play_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            k_per.text = "\(m.watch_nums ?? "0")人在线"
            k_name.text = m.username ?? ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
