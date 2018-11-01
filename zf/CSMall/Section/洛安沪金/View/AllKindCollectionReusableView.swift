//
//  AllKindCollectionReusableView.swift
//  CSMall
//
//  Created by taoh on 2018/5/25.
//  Copyright © 2018年 taoh. All rights reserved.
//

import UIKit

class AllKindCollectionReusableView: UICollectionReusableView {

    
    @IBOutlet weak var kindImageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
