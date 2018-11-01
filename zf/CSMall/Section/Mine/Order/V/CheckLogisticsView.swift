//
//  CheckLogisticsView.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/22.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class CheckLogisticsView: UIView {

    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var number: UILabel!
    
    
    
    
    class func set()->CheckLogisticsView{
        let view = Bundle.main.loadNibNamed("CheckLogisticsView", owner: nil, options: nil)?.first as! CheckLogisticsView
        return view
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
