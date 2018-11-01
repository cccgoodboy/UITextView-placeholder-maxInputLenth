//
//  OrderFormSectionHeaderView.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/4.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class OrderFormSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var orderno: UILabel!
    @IBOutlet weak var orderState: UILabel!
    
    @IBOutlet weak var orderimage: UIImageView!
    var model : OrdersMdoel!{
        willSet(m){
            orderno.text = m.merchants_name ?? ""
            orderimage.sd_setImage(with: URL.init(string: m.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            if  m.order_state == "wait_pay" {
                orderState.text = NSLocalizedString("Pendingpayment", comment: "待付款")//"等待付款"
            }
            else if  m.order_state == "wait_send" {

                orderState.text = NSLocalizedString("Waitingfordelivery", comment: "待发货")//"等待发货"
            }
            else if  m.order_state == "wait_receive" {
                orderState.text = NSLocalizedString("Waitingforreceipt", comment: "待收货")//"等待收货"
            }
            else {
                orderState.text = NSLocalizedString("Hint_45", comment: "交易成功")
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView?.backgroundColor = UIColor.white
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
