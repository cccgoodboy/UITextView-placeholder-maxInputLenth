//
//  CheckLogisticsTableViewCell.swift
//  FYH
//
//  Created by sh-lx on 2017/7/5.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class CheckLogisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var lineImg: UIImageView!
    
    @IBOutlet weak var state: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    var model: TracesModel!{
        willSet(m){
            if m.isCurrentState{
                self.lineImg.image = #imageLiteral(resourceName: "icon_wuliudangqian")
                self.lineImg.contentMode = .bottom
            }
            self.state.text = m.AcceptStation
            self.time.text = m.AcceptTime
            
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
    
}
