//
//  AllKindCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/30.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class AllKindCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func refershData(model:GoodsClassModel ){
        title.text = model.class_name ?? ""
        img.sd_setImage(with: URL.init(string: model.class_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
    }
}
