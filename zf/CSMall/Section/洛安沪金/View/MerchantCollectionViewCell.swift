//
//  MerchantCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class MerchantCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scale: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func refershData(data:MerchantsModel){
        img.sd_setImage(with:URL.init(string:data.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        scale.text =  "月销量：\(data.total_sales ?? "0")"
        title.text = data.merchants_name ?? ""
        desc.text = data.merchants_content ?? ""
    }
}
