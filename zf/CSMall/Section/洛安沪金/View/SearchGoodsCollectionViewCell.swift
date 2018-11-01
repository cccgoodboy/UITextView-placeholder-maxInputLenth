//
//  SearchGoodsCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SearchGoodsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var g_sell_num: UILabel!
    @IBOutlet weak var g_ori_price: UILabel!
    @IBOutlet weak var g_now_price: UILabel!
    @IBOutlet weak var g_title: UILabel!
    @IBOutlet weak var g_img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func refershData(data:MerchantsGoodsListModel){
        g_img.sd_setImage(with: URL.init(string:data.goods_img ?? "") , placeholderImage:#imageLiteral(resourceName: "moren-2") )
        g_title.text = data.goods_name ?? ""
        g_ori_price.text = "\(PhoneTool.getCurrency())：\(data.goods_origin_price ?? "0.00")"
        g_now_price.text = "\(PhoneTool.getCurrency())：\(data.goods_now_price ?? "0.00")"
        g_sell_num.text = "\(data.total_sales ?? "0")人购买"
    }

}
