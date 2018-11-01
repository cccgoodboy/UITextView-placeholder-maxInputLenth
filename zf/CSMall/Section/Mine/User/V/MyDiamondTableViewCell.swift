
//
//  MyDiamondTableViewCell.swift
//  Duluo
//
//  Created by 梁毅 on 2017/3/23.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
protocol MyDiamondTableViewCellDelegate {
    func sendindexToVC(index: Int)
}
class MyDiamondTableViewCell: UITableViewCell {

    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var moneyLabel: UIButton!
    var delegate: MyDiamondTableViewCellDelegate?
    var priceListModel : PriceListModel! {
        willSet(m) {
            otherLabel.isHidden = false
            priceBtn.setTitle( "\(PhoneTool.getCurrency())" + m.price!, for: .normal)
//            otherLabel.text  = 
            moneyLabel.setTitle(m.diamond!, for: .normal)
            otherLabel.text = "赠送" + m.zeng!
        }
    }
//    var diomond: DiomondModel! {
//        willSet(m) {
//            moneyLabel.setTitle(m.meters, for:.normal)
//            priceBtn.setTitle(m.k! + "金币", for: .normal)
//            otherLabel.isHidden = true
//        }
//    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        priceBtn.layer.cornerRadius = 27.5 / 2
        priceBtn.layer.borderColor =  UIColor(hexString:"ec6b1a").cgColor
        priceBtn.layer.borderWidth = 1
    }

  
    @IBAction func rechargeMoney(_ sender: UIButton) {
        
        self.delegate?.sendindexToVC(index: sender.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
