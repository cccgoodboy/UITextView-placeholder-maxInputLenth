//
//  ShowDescLabTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/15.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ShowDescLabTableViewCell: UITableViewCell {

    @IBOutlet weak var lable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model:MerchantsInfoModel!{
        willSet(m){
            lable.text = "店铺简介：\n\(m.merchants_content ?? "")"
        }
    }
    
}
