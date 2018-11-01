//
//  RightTabCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/8.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class RightTabCell: UITableViewCell {

    @IBOutlet weak var havemessage: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
