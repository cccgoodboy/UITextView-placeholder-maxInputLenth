//
//  SelectCouponTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SelectCouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var couponBtn: UIButton!
    var selectClickBlock:((CouponBeanModel,UIButton)->())?
    var model:CouponBeanModel!{
        willSet(m){
            titleLab.text = m.title ?? ""
            couponBtn.isSelected = m.isSeleted
        }
    }
    @IBOutlet weak var titleLab: UILabel!

    @IBAction func couponClick(_ sender: UIButton) {//选择优惠券
        sender.isSelected = !sender.isSelected
        self.selectClickBlock?(model,sender)
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
