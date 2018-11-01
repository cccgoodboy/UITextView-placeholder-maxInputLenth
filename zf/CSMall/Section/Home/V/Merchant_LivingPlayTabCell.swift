//
//  Merchant_LivingPlayTabCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/6.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class Merchant_LivingPlayTabCell: UITableViewCell {

    @IBOutlet weak var l_time: UILabel!
    @IBOutlet weak var l_num: UIButton!//观看人数:10000
    @IBOutlet weak var l_title: UILabel!//
    @IBOutlet weak var l_img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    func refershData(model:PlayBackListModel){
        l_time.text = "开播时间：\(model.date ?? "")"
        l_num.setTitle("播放次数：\(model.play_number ?? "")", for: .normal)
        l_title.text = model.title ?? ""
        l_img.sd_setImage(with: URL.init(string: model.play_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
