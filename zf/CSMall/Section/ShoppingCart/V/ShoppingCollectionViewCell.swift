//
//  ShoppingCollectionViewCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ShoppingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var s_img: UIImageView!
    @IBOutlet weak var s_title: UILabel!
    @IBOutlet weak var s_price: UILabel!
    @IBOutlet weak var s_oprice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }                       
    func refershData(model:MerchantsGoodsListModel)  {
        s_img.sd_setImage(with:URL.init(string:model.goods_img!), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        s_title.text = model.goods_name
        
        s_price.text = "\(PhoneTool.getCurrency())\(model.goods_now_price ?? "0.00")"
        s_oprice.text = "\(PhoneTool.getCurrency())\(model.goods_origin_price ?? "0.00")"
    }
}
