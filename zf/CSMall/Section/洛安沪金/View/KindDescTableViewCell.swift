//
//  KindDescTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/1.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class KindDescTableViewCell: UITableViewCell {

    
    @IBOutlet weak var k_img: UIImageView!
    @IBOutlet weak var k_title: UILabel!
    @IBOutlet weak var k_desc: UILabel!
    @IBOutlet weak var k_sell: UILabel!
    @IBOutlet weak var k_price: UILabel!
    var model:MerchantsGoodsListModel!{
        willSet(m){
            k_img.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            k_title.text = m.goods_name ?? ""
            k_desc.text = m.goods_desc ?? ""
            k_price.text = "\(PhoneTool.getCurrency())\(m.goods_now_price ?? "")"
            k_sell.text = "销量：\(m.total_sales ?? "0")"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
