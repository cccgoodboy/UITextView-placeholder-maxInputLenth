//
//  MessageDetailOrderTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/18.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class MessageDetailOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderImg: UIImageView!
    @IBOutlet weak var orderNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model:SystemMessageModel!{
        willSet(m){
            orderState.text = m.message ?? ""
            orderTime.text = m.intime ?? ""
            orderName.text = m.goods?.goods_name ?? ""
            orderNum.text = "订单编号：\(m.goods?.order_no ?? "")"
            orderImg.sd_setImage(with: URL.init(string: m.goods?.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            
        }
    }
}
