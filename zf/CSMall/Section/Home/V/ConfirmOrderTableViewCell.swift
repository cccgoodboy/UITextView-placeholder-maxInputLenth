//
//  ConfirmOrderTableViewCell.swift
//  FYH
//
//  Created by sh-lx on 2017/6/30.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class ConfirmOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var kinds: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    
    @IBOutlet weak var num: UILabel!
    //    var model: ShopCartModel!{
    //        willSet(m){
    //            self.goodsImg.sd_setImage(with: URL(string:m.goods_img!), placeholderImage: #imageLiteral(resourceName: "icon_moren"))
    //            self.goodsImg.kf.setImage(with: URL(string:m.goods_img!)!)
    //
    //            self.goodsName.text = m.goods_name
    //            self.kinds.text = m.kinds
    //            self.goodsPrice.attributedText = m.sale_price?.stringToAttributed(size: 20, str: m.sale_price!)
    //            self.num.text = "*" + m.goods_num!
    //        }
    //    }
    //        var model: SearchGoodsListModel!{
    //            willSet(m){
    //                self.goodsImg.sd_setImage(with: URL(string:BaseURL + m.goods_img!), placeholderImage: #imageLiteral(resourceName: "moren-2"))
    //                self.goodsName.text = m.goods_name
    //                self.kinds.text = m.kinds
    //                self.goodsPrice.attributedText = m.sale_price?.stringToAttributed(size: 20, str: m.sale_price!)
    //                self.num.text = "*" + m.goods_num!
    //            }
    //        }
    func  refershData(model:ShopCarBeanModel){
        self.goodsImg.sd_setImage(with: URL(string: model.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        self.goodsName.text = model.goods_name
        self.kinds.text = model.specification_names
        self.num.text = "*" + (model.goods_num ?? "")
        self.goodsPrice.attributedText = (model.goods_now_price ?? "")!.stringToAttributed(size: 20, str: model.goods_now_price ?? "")
        
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
