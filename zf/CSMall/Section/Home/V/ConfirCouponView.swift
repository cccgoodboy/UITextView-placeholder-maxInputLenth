//
//  ConfirCouponView.swift
//  CSMall
//
//  Created by taoh on 2017/10/13.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ConfirCouponView: UIView {

    @IBOutlet weak var tickTitleLab: UILabel!
    @IBOutlet weak var scoreTitleLab: UILabel!
    @IBOutlet weak var ticketTitleLab: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var scoreLab: UILabel!
    
    @IBOutlet weak var discountBtn: UIButton!
    @IBOutlet weak var discountLab: UILabel!
    
    var scoreClickBlock:((UIButton)->())? //0表示没使用积分 ，积分实际值表示使用了积分
    var discountClickBlock:((UIButton)->())?
    @IBAction func scoreClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.scoreClickBlock?(sender)
    }
 
    @IBAction func discountClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.discountClickBlock?(sender)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreTitleLab.text = NSLocalizedString("Hint_204", comment: "优惠券折扣")
        
        tickTitleLab.text = NSLocalizedString("Hint_205", comment: "积分可抵扣")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
