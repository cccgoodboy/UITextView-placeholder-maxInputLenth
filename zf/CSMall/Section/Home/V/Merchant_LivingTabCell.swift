//
//  Merchant_LivingTabCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/6.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class Merchant_LivingTabCell: UITableViewCell {

    @IBOutlet weak var live_img: UIImageView!
    
    @IBOutlet weak var live_title: UILabel!
    @IBOutlet weak var live_watch: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    func refershData(model:LiveInfoModel){
        live_img.sd_setImage(with: URL.init(string: model.play_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        live_watch.setTitle("\(NSLocalizedString("Hint_40", comment: "在线人数")):\(model.watch_nums ?? "")", for: .normal)
        live_title.text = model.title ?? ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
