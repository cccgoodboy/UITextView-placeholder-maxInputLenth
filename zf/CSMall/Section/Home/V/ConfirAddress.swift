//
//  ConfirAddress.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/16.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

protocol ConfirAddressDelegate {
    
 func citemClick(view:ConfirAddress)
}

class ConfirAddress: UIView {

    var delegate:ConfirAddressDelegate?
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var phoneLab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet weak var haveAddressView: UIView!
 
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var showTex: UILabel!
    @IBOutlet weak var noAddressView: UIView!
    @IBOutlet weak var rightBtn: UIButton!

    @IBAction func itemClick(_ sender: UIButton) {
        delegate?.citemClick(view: self)
    }

    func refershData(model:AddressModel) {
        
        nameLab.text = model.address_name
        phoneLab.text = model.address_mobile
        addressLab.text = "\(model.address_province ?? "") \(model.address_city ?? "") \(model.address_country ?? "") \(model.address_detailed ?? "")"

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        showTex.text = NSLocalizedString("Addnewaddress", comment: "添加新地址")
    }
}
