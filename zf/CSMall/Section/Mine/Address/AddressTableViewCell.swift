//
//  AddressTableViewCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/3.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import SnapKit
protocol AddressTableViewCellDelegate{

    func adefaultAddressClick(sender:UIButton,cell:AddressTableViewCell)
    func adeleteClick(sender:UIButton,cell:AddressTableViewCell)

}

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    var normalBtn:UIButton!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    var delegate:AddressTableViewCellDelegate?
    
    var  fixaddress:AddressModel!
    @IBOutlet weak var defaultBtn: UIButton!
    
    @IBOutlet weak var settingDefaultBtn: UIButton!
    
    @IBAction func defaultAddressClick(_ sender: UIButton) {
        
        delegate?.adefaultAddressClick(sender: sender, cell: self)
    }
    @IBAction func deleteClick(_ sender: UIButton) {
        delegate?.adeleteClick(sender: sender, cell: self)

    }
    
    @IBAction func editClick(_ sender: UIButton) {
        let vc = AddAdressVC()
        vc.addressType = 1
        vc.model = fixaddress!
        vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        vc.modalTransitionStyle = .crossDissolve
        responderViewController()?.present(vc, animated: false, completion: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        settingDefaultBtn.setTitle(NSLocalizedString("SetasDefaultaddress", comment: "设为默认地址"), for: .normal)
        defaultBtn.setTitle(NSLocalizedString("Defaultaddress", comment: "默认地址"), for: .normal)
        
        delete.setTitle(NSLocalizedString("Delete", comment: "删除"), for: .normal)
        edit.setTitle(NSLocalizedString("Edit", comment: "编辑"), for: .normal)
    
        defaultBtn.addTarget(self, action:#selector(defaultBtnClick) , for: .touchUpInside);
//        defaultBtn.isHidden = true
//        normalBtn = UIButton(type: .custom)
//    normalBtn.setTitle(NSLocalizedString("SetasDefaultaddress", comment: "设为默认地址"), for: .normal)
//        normalBtn.setImage(UIImage(named: "wode_dizhi_shezhimoren"), for: .normal)
//        self.addSubview(normalBtn)
//        normalBtn.addTarget(self, action:#selector(defaultBtnClick) , for: .touchUpInside);
//        normalBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60)
//        normalBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
////        normalBtn.frame = CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
//        normalBtn.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview()
//            make.left.equalToSuperview()
//            make.width.equalTo(170)
//            make.height.equalTo(30)
//        }
//        settingDefaultBtn.isHidden = true
    }
    @objc func defaultBtnClick(){
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func refershData(address:AddressModel){
        fixaddress = address
        nameLab.text =  address.address_name
        phoneLab.text = address.address_mobile
        addressLab.text = "\(address.address_province ?? "") \(address.address_city ?? "") \(address.address_country ?? "") \(address.address_detailed ?? "")"
        if  address.is_default == "1" {
            
            defaultBtn.isHidden = false
            settingDefaultBtn.isHidden = true
        }else{
           
            defaultBtn.isHidden = true
            settingDefaultBtn.isHidden = false
        }
    }
}
