
//
//  MyDiamondRemainTableViewCell.swift
//  Duluo
//
//  Created by 梁毅 on 2017/3/23.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class MyDiamondRemainTableViewCell: UITableViewCell {

    @IBOutlet weak var remianBtn: UIButton!
    
    @IBOutlet weak var accoutMoney: UILabel!
    
    @IBOutlet weak var longpiaoNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
