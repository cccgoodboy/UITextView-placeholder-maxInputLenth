//
//  MyCollectionTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/9/23.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
protocol MyCollectionTableViewCellDelegate {
    
    func  selectitemCell(cell:MyCollectionTableViewCell, collection: UIButton)
    func  singleCancle(cell:MyCollectionTableViewCell, collection: UIButton)
}

class MyCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancleBtn: UIButton!//取消收藏
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var specLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    
    var model:RfundOrderModel!{
        willSet(m){
//            goodImage.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage:moren-2 )
            nameLab.text = m.goods_name ?? ""
        goodImage.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            specLab.text = m.specification_names ?? ""
            priceLab.text = m.refund_price ?? ""
            cancleBtn.setTitle("*\(m.refund_count ?? "1")", for: .normal)
        }
    }
    var delegate:MyCollectionTableViewCellDelegate?
    
    @IBAction func selectClick(_ sender: UIButton) {
        delegate?.selectitemCell(cell: self, collection: sender)
    }
    @IBAction func cancleClick(_ sender: UIButton) {
        delegate?.singleCancle(cell: self, collection: sender)
    }
    
    func configureCell(collection: UserCollection) {
        goodImage.sd_setImage(with:URL.init(string: collection.goods_img ?? "") , placeholderImage: #imageLiteral(resourceName: "moren-2"))
    
        nameLab.text = collection.goods_name ?? ""
        specLab.text = collection.goods_desc ??  ""
        priceLab.text = collection.goods_now_price ?? ""
        selectBtn.isSelected = collection.isSelected
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

