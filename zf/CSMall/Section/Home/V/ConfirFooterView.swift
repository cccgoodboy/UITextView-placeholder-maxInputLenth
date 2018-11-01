//
//  ConfirFooterView.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/18.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ConfirFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var sendWayValueLabel: UILabel!
    @IBOutlet weak var sendWayLabel: UILabel!
    @IBOutlet weak var c_remark: UITextField!

    @IBOutlet weak var sallPersonLab: UILabel!
    
    @IBOutlet weak var c_numLab: UILabel!//共计2件商品   小计：
    
    @IBOutlet weak var price: UILabel!
    
//    @IBOutlet weak var discountPriceLab: UILabel!
    var btnClickBlock:(()->())?;
    var textChange:((String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        sendWayLabel.text = NSLocalizedString("Hint_201", comment: "配送方式")
        
        sendWayValueLabel.text = NSLocalizedString("Hint_202", comment: "快速配送")
        
        sallPersonLab.text = NSLocalizedString("Hint_203", comment: "卖家留言")
//        NotificationCenter.default.addObserver(self, selector: #selector(FeedbackViewController.textViewNotifition(noti:)), name: NSNotification.Name.UITextViewTextDidChange, object: textView)

        NotificationCenter.default.addObserver(self, selector: #selector(remakr(noti:)), name:NSNotification.Name.UITextFieldTextDidChange , object: c_remark)
    }
    func remakr(noti:Notification){
     let str = c_remark.text ?? ""
        self.textChange?(str)
    }
    //优惠券
//    @IBAction func discountClick(_ sender: UIButton) {
//        if self.btnClickBlock != nil {
//            //点击按钮执行闭包
//            //注意：属性btnClickBlock是可选类型，需要先解包
//            self.btnClickBlock!();
//        }
//
//    }

}
