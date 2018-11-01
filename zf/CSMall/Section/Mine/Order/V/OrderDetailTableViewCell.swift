//
//  OrderDetailTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/14.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var kinds: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var serviceBtn: UIButton!

    var serviceClickBlock:((OrderGoodsBeansModel)->())?
    @IBAction func serviceClick(_ sender: UIButton) {
        serviceClickBlock?(model)
    }
    @IBOutlet weak var num: UILabel!
    var model:OrderGoodsBeansModel!{
        willSet(m){
            if m.specification_img == ""{
                goodsImg.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }else{
                goodsImg.sd_setImage(with: URL.init(string: m.specification_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }
            self.goodsName.text = m.goods_name
            self.kinds.text = m.specification_names
            self.num.text = "*" + (m.goods_num ?? "")
            self.goodsPrice.attributedText = (m.specification_price ?? "")!.stringToAttributed(size: 20, str: m.specification_price ?? "")
            if m.has_refund == "1"{
                serviceBtn.setTitle(NSLocalizedString("Hint_81", comment: "售后详情"), for: .normal)
            }else{
                serviceBtn.setTitle(NSLocalizedString("Hint_82", comment: "申请售后"), for: .normal)

            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
