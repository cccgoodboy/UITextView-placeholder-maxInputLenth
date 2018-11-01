//
//  KindViewCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class KindViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topHeight: NSLayoutConstraint!
//    @IBOutlet weak var height: NSLayoutConstraint!
//    @IBOutlet weak var titles: UILabel!
    @IBOutlet weak var images: UIImageView!
    var model:ShowGoodsClassModel!{
        willSet(m){
//            height.constant = 24
//            topHeight.constant = 4
//            titles.text = m.tag ?? ""
//               titles.isHidden = false
            images.sd_setImage(with: URL.init(string: m.img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        }
        
    }
    var kindmodel:ShowGoodsKindClassModel!{
        willSet(m){
//            height.constant = 0
//            topHeight.constant = 0
//            titles.isHidden = true
//            titles.text = m.class_name ?? ""
            images.sd_setImage(with: URL.init(string: m.img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
