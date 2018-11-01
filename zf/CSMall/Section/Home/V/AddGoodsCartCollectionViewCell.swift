//
//  AddGoodsCartCollectionViewCell.swift
//  FYH
//
//  Created by sh-lx on 2017/6/29.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class AddGoodsCartCollectionViewCell: UICollectionViewCell {
   
    var heightForCell : Float = 30

    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var title: UILabel!

    var model: SpecificationBeansModel!{
        willSet(m){
            self.title.text = m.specification_value
            self.updateConstraintsIfNeeded()
            self.layoutIfNeeded()
        }
    }
    override var isSelected: Bool{
        willSet{
        
            if newValue{
                didselectLab()
            }else{
                didntselectLab()
            }
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = UIColor.init(hexString: "EBEBEB")
        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
//        self.contentView.layer.borderWidth = 1.0
        
//        let selectedBackgroundView = UIView()
//        selectedBackgroundView.backgroundColor = UIColor.init(hexString: "FF4B4B")
//        selectedBackgroundView.layer.cornerRadius = 15
//        selectedBackgroundView.layer.masksToBounds = true
//        self.selectedBackgroundView = selectedBackgroundView
        self.title.highlightedTextColor = UIColor.white
    }
    func sizeForCell() -> CGSize {
        
        let height = getLabHeigh(model.specification_value!, font: 13, width: kScreenWidth - 90) + 18
        self.contentView.layer.cornerRadius = height/2
        
        var width:CGFloat = 0.00
        if self.title.sizeThatFits(CGSizeFromString(model.specification_value!)).width + CGFloat(heightForCell) < kScreenWidth - 40{
            width = self.title.sizeThatFits(CGSizeFromString(model.specification_value!)).width + CGFloat(heightForCell)
        }else{
            width = kScreenWidth - 40
        }
        return CGSize(width:width , height: height)
    }
//    func sizeForCell() -> CGSize {
//
//        return CGSize(width: self.title.sizeThatFits(CGSizeFromString(model.specification_value!)).width + CGFloat(heightForCell), height: CGFloat(heightForCell))
//
//    }
    func didselectLab(){
        self.contentView.backgroundColor = UIColor.init(hexString: "FF4B4B")
//        self.contentView.backgroundColor = UIColor.clear
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
    func didntselectLab(){
        
        self.contentView.backgroundColor = UIColor.init(hexString: "EBEBEB")
//        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
