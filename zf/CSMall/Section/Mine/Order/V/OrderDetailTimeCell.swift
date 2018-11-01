//
//  OrderDetailTimeCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/14.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class OrderDetailTimeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var totalLab: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var remark_height: NSLayoutConstraint!
    @IBOutlet weak var order_remark: UILabel!
    @IBOutlet weak var order_discount: UILabel!
    
    @IBOutlet weak var order_score: UILabel!
    
    @IBOutlet weak var order_num: UILabel!
    
    @IBOutlet weak var create_time: UILabel!
    
    @IBOutlet weak var pay_time: UILabel!
    
    @IBOutlet weak var receive_time: UILabel!
    @IBOutlet weak var send_time: UILabel!
    @IBOutlet weak var discount_heihgt: NSLayoutConstraint!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func refershData(model:QueryOrderViewModel){
        totalLab.text = "实际应付：\(model.order_actual_price ?? "")元"
//        order_discount.text = "优惠卷折扣：\(model.)元"
       
        //如果没有优惠券
        order_discount.isHidden = true
        discount_heihgt.constant = 0.00
        order_discount.text = "优惠卷折扣：\(0.00)元"
        
        order_score.text = "积分折扣：\(model.deduct_integral_value ?? "0")元"
        if model.order_remark != ""{
            order_remark.text = "我的留言：\(model.order_remark ?? "")"
            remark_height.constant = 24 + getLabHeigh("我的留言：\(model.order_remark ?? "")", font: 13.0, width: kScreenWidth - 60)

        }else{
            lineView.isHidden = true
            order_remark.text = ""
            remark_height.constant = 0
        }
        if model.order_state == "wait_pay"{
            create_time.text = "创建时间：\(model.create_time ?? "")"
            pay_time.isHidden = true
            send_time.isHidden = true
            receive_time.isHidden = true
        }else if model.order_state == "wait_send"{
            create_time.text = "创建时间：\(model.create_time ?? "")"
            pay_time.text = "付款时间：\(model.pay_time ?? "")"
//            pay_time.isHidden = false

            send_time.isHidden = true
            receive_time.isHidden = true

        }else if model.order_state == "wait_receive"{
            create_time.text = "创建时间：\(model.create_time ?? "")"
            pay_time.text = "付款时间：\(model.pay_time ?? "")"
            send_time.text =  "发货时间：\(model.send_time ?? "")"

            receive_time.isHidden = true
        }else{
            create_time.text = "创建时间：\(model.create_time ?? "")"
            pay_time.text = "付款时间：\(model.pay_time ?? "")"
            send_time.text =  "发货时间：\(model.send_time ?? "")"
            receive_time.text =  "发货时间：\(model.receive_time ?? "")"
        }
    }
    static func getCellHeight(model:QueryOrderViewModel) -> CGFloat {
        
        var height: CGFloat = 0.00

        height += 180
        if model.order_remark != ""{
            let h = getLabHeigh("我的留言：\(model.order_remark ?? "")", font: 13.0, width: kScreenWidth - 60) + 24
            height += h
        }
        if model.order_state == "wait_pay"{
        
            height += 20
        }else if model.order_state == "wait_send"{
            
            height += 40
        }else if model.order_state == "wait_receive"{
           
            height += 60
        }else{
            height += 80
        }
        //没有优惠券
        height -= 26
        return height
    }
}
