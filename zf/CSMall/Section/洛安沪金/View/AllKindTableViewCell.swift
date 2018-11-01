//
//  AllKindTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/30.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class AllKindTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLab.adjustsFontSizeToFitWidth = true
        titleLab.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
