//
//  ApplyDetailDepositCell.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class ApplyDetailDepositCell: UITableViewCell {
    var payClickBlock:(()->())?
    var registModel:RegisterModel = RegisterModel()
    @IBAction func a_operaClick(_ sender: UIButton) {
        if sectionindex.section == 1{
            if registModel.pay_state != nil{
                if registModel.apply_state == "2" && registModel.pay_state == "0"{
                    payClickBlock?()
                }
            }
            
        }else{
            if model.tel != nil || model.tel != "" {
                
                sender.isEnabled = false
                self.perform(#selector(changeButtonStatus), with: nil, afterDelay: 2.0)

                if model.tel == nil{
                    model.tel  = "4008985789"
                }
                let str = String(format:"telprompt://%@",model.tel as! String)
                
                UIApplication.shared.openURL(URL(string:str )!)
            }else{
                ProgressHUD.showMessage(message: NSLocalizedString("Notconnected", comment: "抱歉，暂时联系不了"))
            }
        }
        
        
    }
    func  changeButtonStatus(){
        a_operaBtn.isEnabled =  true
    }
    
    @IBOutlet weak var a_operaBtn: UIButton!
    @IBOutlet weak var a_priceLab: UILabel!
    @IBOutlet weak var a_contentLab: UILabel!
    var sectionindex:IndexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func refershData(index:IndexPath,modle:RegisterModel){
        sectionindex = index
        registModel = modle
        if index.section ==  1{
            //用户当前状态，用户是否缴费（审核通过）
            if modle.pay_state == "1"{
                a_operaBtn.isHidden = true
            }else{
                a_operaBtn.isHidden = false
                a_operaBtn.layer.borderWidth = 0.0
                a_contentLab.text = NSLocalizedString("Deposit", comment: "交付押金") 
                a_priceLab.isHidden = false
                a_priceLab.text = "\(PhoneTool.getCurrency())\(modle.deposit ?? "")"
                
                if modle.apply_state == "2"{
                    a_operaBtn.backgroundColor = UIColor.red
                    a_operaBtn.setTitle(NSLocalizedString("Immediatedelivery", comment: "立即交付"), for: .normal)
                }else{
                    a_operaBtn.backgroundColor = UIColor.init(hexString: "999999")
                    a_operaBtn.setTitle( NSLocalizedString("Immediatedelivery", comment: "立即交付"), for: .normal)
                }
            }
            
        }else{
            a_operaBtn.backgroundColor = UIColor.white
            a_operaBtn.setTitleColor(UIColor.init(hexString: "E53D3D"), for: .normal)
            a_operaBtn.layer.borderColor = UIColor.init(hexString: "E53D3D").cgColor
            a_operaBtn.layer.borderWidth = 1.0
            a_operaBtn.setTitle(NSLocalizedString("Contact", comment: "联系平台") , for: .normal)
            a_priceLab.isHidden = true
            a_contentLab.text = NSLocalizedString("Somethingwrong", comment: "信息有误？")
        }
        
    }
    var model:CompanyInfoModel!
    
    
}

