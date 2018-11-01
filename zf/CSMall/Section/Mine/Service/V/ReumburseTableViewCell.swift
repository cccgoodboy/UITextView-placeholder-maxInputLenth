//
//  ReumburseTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/9/29.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ReumburseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model:RfundOrderModel!{
        willSet(m){
            //            goodImage.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage:moren-2 )
//            nameLab.text = m.goods_name ?? ""
//            goodImage.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
//            specLab.text = m.specification_names ?? ""
//            priceLab.text = m.refund_price ?? ""
//            cancleBtn.setTitle("*\(m.refund_count ?? "1")", for: .normal)
        }
    }
    
}
