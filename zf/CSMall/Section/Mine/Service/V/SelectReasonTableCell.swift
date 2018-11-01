//
//  SelectReasonTableCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/13.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SelectReasonTableCell: UITableViewCell {


    @IBAction func itemCick(_ sender: UIButton) {
        itemClickBlock?(model)
    }
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var titleBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()


    }
    var itemClickBlock:((OrderRefundReason)->())?
    var model:OrderRefundReason!{
        willSet(m){
            titleLab.text = m.reason_name ?? ""
            titleBtn.isSelected = m.selected
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
