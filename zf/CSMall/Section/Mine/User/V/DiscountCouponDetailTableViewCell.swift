//
//  DiscountCouponDetailTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/9/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class DiscountCouponDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var d_typeLab: UILabel!
    
    @IBOutlet weak var d_rulerLab: UILabel!
    
    @IBOutlet weak var d_discLab: UILabel!
    @IBOutlet weak var d_priceLab: UILabel!
    @IBOutlet weak var d_timeLab: UILabel!
    @IBOutlet weak var d_typeI: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    func refershData(model:MyCouponModel,type:DiscountCouponType){
    
        if type == DiscountCouponType.DiscountCoupon_NotUse{
            d_typeI.image = UIImage.init()
        }
        else if type == DiscountCouponType.DiscountCoupon_HavedUse{
            d_typeI.image = #imageLiteral(resourceName: "yishiyong")

        }else{
            d_typeI.image = #imageLiteral(resourceName: "yiguoqi")

        }
        if type == DiscountCouponType.DiscountCoupon_NotUse{
            d_rulerLab.textColor = UIColor.init(hexString: "333333")
            d_typeLab.textColor = UIColor.black
            d_discLab.textColor = UIColor.init(hexString: "9A9A9A")
            d_priceLab.textColor = UIColor.init(hexString: "E33C3C")
            d_timeLab.textColor = UIColor.init(hexString: "333333")
        }else{
            d_rulerLab.textColor = UIColor.init(hexString: "9A9A9A")
            d_typeLab.textColor = UIColor.init(hexString: "9A9A9A")
            d_discLab.textColor = UIColor.init(hexString: "9A9A9A")
            d_priceLab.textColor = UIColor.init(hexString: "9A9A9A")
            d_timeLab.textColor = UIColor.init(hexString: "9A9A9A")
        }
        d_typeLab.text = model.name ?? ""
        d_rulerLab.text = model.title ?? ""
        d_timeLab.text = "有效期：\(model.end_time ?? "")"
        d_priceLab.text = model.value ?? ""
    }
    
}
