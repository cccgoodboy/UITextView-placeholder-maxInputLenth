//
//  FourCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/2.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class FourCollectionViewCell: UICollectionViewCell {
	@IBOutlet var itemBtn: [UIButton]!
    var itemClickBlock:((DressModel) -> ())?

    var model:DressModel!{
        willSet(m){
            for i in 0..<min(itemBtn.count, m.seedBeans!.count){
                itemBtn[i].sd_setImage(with: URL.init(string: m.seedBeans![i].img ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }
            for i in  itemBtn.indices{
                if i < m.seedBeans!.count{
                    itemBtn[i].isHidden = false
                }else{
                    itemBtn[i].isHidden = true
                }
            }
        }
    }
    
    @IBAction func itemClick(_ sender: UIButton) {
        if sender.tag - 1 < model.seedBeans!.count{
//            ProgressHUD.showMessage(message: "\(sender.tag - 1)")
            let vcmodel =  model.seedBeans![sender.tag - 1]
            self.itemClickBlock?(vcmodel)

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
