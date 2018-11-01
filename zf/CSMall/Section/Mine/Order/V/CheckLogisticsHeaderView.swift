//
//  CheckLogisticsHeaderView.swift
//  FYH
//
//  Created by sh-lx on 2017/7/5.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class CheckLogisticsHeaderView: UIView {

    @IBOutlet weak var goodsImg: UIImageView!
    
    @IBOutlet weak var goodsNum: UILabel!
  
    
    @IBOutlet weak var state2: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    
    @IBOutlet weak var kinds: UILabel!
    var goods_image = ""
    var order_no: String!{
        willSet{
            self.orderNo.text = newValue
        }
    }
    var goodsSum: String!{
        willSet{
            self.goodsNum.text = NSLocalizedString("Hint_70", comment: "共有") + newValue + NSLocalizedString("Hint_71", comment: "件商品")
        }
    }
    var model: LogisticsModel!{
        willSet(m){
            if m.State == "3" {
                self.state2.text = NSLocalizedString("Hint_72", comment:"已收货")
            }else if m.State == "2"{
                self.state2.text = NSLocalizedString("Hint_73", comment: "配送中")
            }else if m.State == "4"{
                self.state2.text = NSLocalizedString("Hint_74", comment: "问题件")

            }
            self.kinds.text = m.Traces?.last?.AcceptTime
            self.goodsImg.sd_setImage(with: URL.init(string: goods_image ), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        }
    }
    class func setView() -> CheckLogisticsHeaderView{
        let view = Bundle.main.loadNibNamed("CheckLogisticsHeaderView", owner: nil)?.first as! CheckLogisticsHeaderView
        return view
    }

}
