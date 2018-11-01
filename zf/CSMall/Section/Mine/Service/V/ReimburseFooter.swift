//
//  ReimburseFooter.swift
//  CSMall
//
//  Created by taoh on 2017/9/26.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

//protocol ReimburseFooterDelegate {
//    func reimburseFooterdetailClick(footer:ReimburseFooter)
//}

class ReimburseFooter: UITableViewHeaderFooterView {

    var reimburseFooterdetailClickBlock:((RfundOrderModel)->())?
    @IBOutlet weak var titleLab: UILabel!
//    var delegate:ReimburseFooterDelegate?
    
    var model:RfundOrderModel!{
        willSet(m){
            titleLab.text = "\(PhoneTool.getCurrency())\(m.refund_actual_price ?? "")"
        }
    }
    @IBAction func detailClick(_ sender: UIButton) {
        reimburseFooterdetailClickBlock?(model)
//        delegate?.reimburseFooterdetailClick(footer: self)
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
