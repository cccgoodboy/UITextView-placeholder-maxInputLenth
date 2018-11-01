
//
//  EmptyShopView.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class EmptyShopView: UICollectionReusableView {
    @IBOutlet weak var noLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
noLab.text = NSLocalizedString("Hint_42", comment: "购物车里什么都没有哦")    }
    
}
