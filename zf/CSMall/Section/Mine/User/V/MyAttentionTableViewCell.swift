//
//  MyAttentionTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/9/26.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

protocol MyAttentionTableViewCellDelegate {
    func singleCancle(cell:MyAttentionTableViewCell)

}
class MyAttentionTableViewCell: UITableViewCell {

    var model:UserfollowModel!{
        willSet(m) {
            m_img.sd_setImage(with: URL.init(string: m.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            m_title.text = m.merchants_name ?? ""
            m_scale.text = "月销量：\(m.month_sales ?? "")"
        }
    }
    @IBOutlet weak var m_img: UIImageView!
    
    @IBOutlet weak var m_title: UILabel!
    
    @IBAction func cancleClick(_ sender: UIButton) {
        self.delegate?.singleCancle(cell: self)
    }
    
    @IBOutlet weak var m_scale: UILabel!
    
    var delegate:MyAttentionTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()

    }
//    func refershData(model:UserfollowModel){
//        m_img.sd_setImage(with: URL.init(string: model.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
//        
//        
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
