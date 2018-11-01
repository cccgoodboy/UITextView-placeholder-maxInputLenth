//
//  ApplicationForDrawbackGoodsTabCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/9.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ApplicationForDrawbackGoodsTabCell: UITableViewCell {
    @IBOutlet weak var a_img: UIImageView!
    @IBOutlet weak var a_price: UILabel!
    
    var applyNumClick:((RefundGoodsModel)->())?
    @IBAction func reduceBtnClick(_ sender: UIButton) {
        
        let a = Int(model.num)
        if a! > 1  {
            self.model.num = "\(Int(model.num)! - 1)"
            a_num.text = model.num
            
            self.applyNumClick?(model)
        }else{
            ProgressHUD.showMessage(message: "最少退款一件")
        }
        
        
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        let a = Int(model.goods_num!)
        let b = Int(model.num)
        if   b! < a!{
            model.num = "\(Int(model.num)! + 1)"
            a_num.text = model.num
            self.applyNumClick?(model)
        }else{
            ProgressHUD.showMessage(message: "不能超过您的购买数")
        }
    }
    @IBOutlet weak var a_num: UILabel!
    @IBOutlet weak var a_kind: UILabel!
    @IBOutlet weak var a_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    var model:RefundGoodsModel!{
        willSet(m){
            a_num.text = m.num
            a_kind.text = "规格：\( m.specification_names ?? "")"
            a_title.text = m.goods_name ?? ""
            a_price.text = m.refund_price ?? ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
