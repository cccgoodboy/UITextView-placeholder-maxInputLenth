//
//  GoodStuHeader.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/11.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class GoodStuHeader: UICollectionReusableView {

    @IBOutlet weak var leftline: UIView!
    
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var rightline: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func refershData(model:RecommendClassModel) {
        kind.text = "\(model.class_name ?? "")推荐"
        leftline.backgroundColor  = UIColor.init(hexString: model.class_color ?? "3AC2A6")
        rightline.backgroundColor = UIColor.init(hexString: model.class_color ?? "3AC2A6")
    }
 
    
}
