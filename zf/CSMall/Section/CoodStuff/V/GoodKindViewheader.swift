//
//  GoodKindViewheader.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/11.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class GoodKindViewheader: UICollectionReusableView {
    @IBOutlet weak var rightkindView: UIView!

    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var kind: UILabel!
    
    @IBOutlet weak var leftkindView: UIView!
    
    var bannerClick:((DressModel)->())?
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func itemClick(_ sender: UIButton) {

        if goodStuffModel != nil{
            self.bannerClick?(goodStuffModel)
        }
    }
    
    var goodStuffModel:DressModel!{
        willSet(m){
            banner.sd_setImage(with: URL.init(string:m.img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            viewheight.constant = 0
            rightkindView.isHidden = true
            leftkindView.isHidden = true
            kind.isHidden = true
        }
    }
    
}
