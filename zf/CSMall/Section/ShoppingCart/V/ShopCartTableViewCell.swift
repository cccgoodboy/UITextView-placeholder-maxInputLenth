 //
//  ShopCartTableViewCell.swift
//  FYH
//
//  Created by sh-lx on 2017/6/29.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class ShopCartTableViewCell: UITableViewCell {

    @IBOutlet weak var goodsImg: UIImageView!
    
    @IBOutlet weak var goodsName: UILabel!
    
    @IBOutlet weak var textureLab: UILabel!
        
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var numLab: UILabel!
    
    @IBOutlet weak var markBtn: UIButton!
    var clickGoods:((ShopCarBeanModel,UIButton)->())?
    
    @IBOutlet weak var reduceBtn: UIButton!
    @IBOutlet weak var novalidLab: UILabel!
    var changeNum: ((Double)->())?
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var pricesymbol: UILabel!
    var model: ShopCarBeanModel!{
        willSet(m){
            
            self.goodsImg.sd_setImage(with: URL.init(string: m.goods_img ?? "")!, placeholderImage: #imageLiteral(resourceName: "moren-2"))
            self.goodsName.text = m.goods_name
            self.priceLab.attributedText = m.goods_now_price?.stringToAttributed(size: 20, str: m.goods_now_price!)
            self.numLab.text = m.goods_num
            self.textureLab.text = "规格：\(m.specification_names ?? "无")"
            self.markBtn.isSelected = m.isSelected
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
    
    @IBAction func addAction(_ sender: UIButton) {
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/plusShopCar", at: self, params: ["car_id":self.model.car_id!], isShowHUD: false, isShowError: true, hasHeaderRefresh: nil, success: { (response) in
            self.numLab.text = "\(Int(self.numLab.text!)! + 1)"
            self.model.goods_num = self.numLab.text
            self.changeNum?(Double(self.model.goods_now_price!)!)
        }) {
            
        }
    }
    
    @IBAction func subAction(_ sender: UIButton) {
        if self.numLab.text == "1"{
            ProgressHUD.showNoticeOnStatusBar(message: "商品数量不能小于1")
            return
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/minusShopCar", at: self, params: ["car_id":self.model.car_id!], isShowHUD: false, isShowError: true, hasHeaderRefresh: nil, success: { (response) in
            self.numLab.text = "\(Int(self.numLab.text!)! - 1)"
            self.model.goods_num = self.numLab.text

            self.changeNum?(-Double(self.model.goods_now_price!)!)
            
        }) {
            
        }
    }
    
    @IBAction func selectGoodsAction(_ sender: UIButton) {
        self.model.isSelected = !self.model.isSelected
        self.markBtn.isSelected = self.model.isSelected
        self.clickGoods?(self.model,sender)
    }
}
