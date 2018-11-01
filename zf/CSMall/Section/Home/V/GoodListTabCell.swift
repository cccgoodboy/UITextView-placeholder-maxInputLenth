//
//  GoodListTabCell.swift
//  CSLiving
//
//  Created by 梁毅 on 2017/8/17.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit



class GoodListTabCell: UITableViewCell {

    @IBOutlet weak var g_title: UILabel!
    @IBOutlet weak var g_image: UIImageView!
    @IBOutlet weak var g_nowPrice: UILabel!
    
    @IBOutlet weak var g_oriPrice: UILabel!//原价：120.0
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var saleNumLab: UILabel!
    var selectGoodsClick:((MerchantsClassGoodsModel)->())?
    var model:MerchantsClassGoodsModel!{
        willSet(m){
            
            self.g_title.text = m.goods_name ?? ""
            self.g_image.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            self.g_nowPrice.text = "\(PhoneTool.getCurrency())\(m.goods_now_price ?? "0")"
            self.g_oriPrice.text = m.goods_origin_price
            
            saleNumLab.text = "\(m.total_sales ?? "0")\(NSLocalizedString("Hint_39", comment: "人购买"))"

//            self.selectBtn.good = m
        }
    }
//    @IBAction func selectClick(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected{
//            model.userSelect = true
//            sender.backgroundColor = UIColor.init(hexString: "DF3D3D")
//            sender.setTitleColor(UIColor.white, for: .normal)
//        }else{
//            model.userSelect = false
//            sender.backgroundColor = UIColor.white
//            sender.setTitleColor(UIColor.init(hexString: "DF3D3D"), for: .normal)
//        }
//       self.selectGoodsClick?(model)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
