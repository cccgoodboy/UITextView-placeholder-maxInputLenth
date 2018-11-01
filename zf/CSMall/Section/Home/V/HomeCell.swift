//
//  HomeCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit


class HomeCell: UICollectionViewCell {

    @IBOutlet weak var isLiveLab: UILabel! //是否直播中
    
    @IBOutlet weak var h_mimg: UIImageView!
    @IBOutlet weak var h_mnameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isLiveLab.backgroundColor = themeColor

    }
    func refershData(data:MerchantsModel){
        
        isLiveLab.isHidden = data.live_id == "0" ? true : false
        h_mnameLab.text = data.merchants_name
        h_mimg.sd_setImage(with:URL.init(string:data.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
    }
}
