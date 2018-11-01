//
//  OrderTableViewCell.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/5/17.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {


    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsType: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsNum: UILabel!
    
    
    
    var model: OrderGoodsBeansModel!{
        willSet(m){
            if m.specification_img == ""{
                goodsImg.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }else{
                goodsImg.sd_setImage(with: URL.init(string: m.specification_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }
            goodsName.text = m.goods_name
            goodsNum.text = "x" + m.goods_num!
            goodsType.text = "规格: " + m.specification_names!
            goodsPrice.text = "\(PhoneTool.getCurrency()) " + m.specification_price!
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.goodsImg.clipsToBounds = true
        self.goodsImg.contentMode = .scaleAspectFill
        goodsName.numberOfLines = 2
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
