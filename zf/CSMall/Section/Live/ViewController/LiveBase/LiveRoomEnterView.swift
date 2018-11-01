//
//  LiveRoomEnterView.swift
//  MoDuLiving
//
//  Created by sh-lx on 2017/3/9.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class LiveRoomEnterView: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var grade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: kScreenWidth, y: kScreenHeight - 140.0/667*kScreenHeight - 70 - 40, width: 266, height: 30)
    }
    
    class func setup() -> LiveRoomEnterView {
        let v = Bundle.main.loadNibNamed("LiveRoomEnterView", owner: nil, options: nil)?.first as! LiveRoomEnterView
        return v
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
