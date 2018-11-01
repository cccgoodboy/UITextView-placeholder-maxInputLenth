//
//  ApplyDetailInfoCell.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class ApplyDetailInfoCell: UITableViewCell {

    @IBOutlet weak var a_nameLab: UILabel!//姓———名:魔芋将
    
    @IBOutlet weak var a_phoenLab: UILabel!//联系电话：18232343233
    
    @IBOutlet weak var a_bussinessLab: UILabel!
    @IBOutlet weak var a_shopNameLab:
    UILabel!//店铺名称：小馋猫%精品零食店
    
    @IBOutlet weak var a_adressLab: UILabel!
    //店铺地址
    
    @IBOutlet weak var a_IDCardBgView: UIView!
    @IBOutlet weak var idHeight: NSLayoutConstraint!
    
    @IBOutlet var a_IDImgView: [UIImageView]!
    
    @IBOutlet weak var a_comBgView: UIView!
    @IBOutlet weak var a_comheight: NSLayoutConstraint!
    @IBOutlet var a_ComImgView: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func refershData(model:RegisterModel){
        a_nameLab.text = NSLocalizedString("Name1", comment: "姓   名:") + "\(model.contact_name ?? "")"
        a_phoenLab.text = NSLocalizedString("ContactTel", comment: "联系电话") + "：\(model.contact_mobile ?? "")"
        a_shopNameLab.text = NSLocalizedString("ShopName", comment: "店铺名称") + "：\(model.merchants_name ?? "")"
        a_adressLab.text = "\(model.merchants_province ?? "")\(model.merchants_city ?? "")\(model.merchants_country ?? "")\(model.merchants_address ?? "")"
        
        a_bussinessLab.text = NSLocalizedString("CompanyID", comment: "营业执照编号") + "：\(model.business_number ?? "")"
        var images:[String] = [String]()
        if model.legal_img != nil{
            images.append(model.legal_img ?? "")
        }
        if model.legal_hand_img != nil{
            images.append(model.legal_hand_img ?? "")
        }
        if model.legal_face_img != nil{
            images.append(model.legal_face_img ?? "")
        }
        if model.legal_opposite_img != nil{
            images.append(model.legal_opposite_img ?? "")
        }
        for i in 0..<a_IDImgView.count{
            if i < images.count{
                a_IDImgView[i].sd_setImage(with: URL.init(string: images[i]), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                a_IDImgView[i].isHidden = false
            }else{
                a_IDImgView[i].isHidden = true
            }
        }
        if model.business_img != nil{
            a_ComImgView[0].sd_setImage(with: URL.init(string: model.business_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        }
        
    }
}
