//
//  WatchLiveMemberCollectionViewCell.swift
//  MoDuLiving
//
//  Created by sh-lx on 2017/3/7.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class WatchLiveMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 30/2
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
    }

}
