//
//  LiveGoodsListTableViewCell.swift
//  CSLiving
//
//  Created by taoh on 2017/10/15.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class LiveGoodsListTableViewCell: UITableViewCell {

    @IBOutlet weak var g_title: UILabel!
    @IBOutlet weak var g_image: UIImageView!
    @IBOutlet weak var g_nowPrice: UILabel!
    
    @IBOutlet weak var g_delete :UIButton!//删除
    @IBOutlet weak var g_top :UIButton!//置顶
    
    var topClick:((LiveGoodsModel)->())?
    var deleteClick:((LiveGoodsModel)->())?

    var model:LiveGoodsModel!{
        willSet(m){

            g_top.backgroundColor = UIColor.red
            self.g_top.layer.borderWidth = 1
            self.g_image.sd_setImage(with:URL.init(string:m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            self.g_title.text = m.goods_name ?? ""
            self.g_nowPrice.text = "\(PhoneTool.getCurrency())\(m.goods_now_price ?? "")"
        }
    }
    @IBAction func topClick(_ sender: UIButton) {

//            NetworkingHandle.fetchNetworkData(url: "/api/merchant/operateGoodsTop", at: self, params: ["live_goods_id":self.model.live_goods_id!], success: { (response) in
//
//                if self.model.is_top == "1"{
//                    self.model.is_top = "0"
//                }else{
//                    self.model.is_top = "1"
//                }
//                self.topClick?(self.model)
//
//            }, failure: {
//
//            })
    }
    
    @IBAction func delteClick(_ sender: UIButton) {

//        NetworkingHandle.fetchNetworkData(url: "/api/merchant/delGoods", at: self, params: ["live_goods_id":self.model.live_goods_id!], success: { (response) in
//
//            self.deleteClick?(self.model)
//
//        }, failure: {
//
//        })
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
