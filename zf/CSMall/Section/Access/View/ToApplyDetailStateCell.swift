//
//  ToApplyDetailStateCell.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class ToApplyDetailStateCell: UITableViewCell {
    
    @IBOutlet weak var applyin: UILabel!
    @IBOutlet weak var commit_lab: UILabel!
    @IBOutlet weak var stateLab: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    //ruzhushenhe_dangqian3(审核通过)  ruzhushenhe_dangqian2(平台审核中)
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func refershData(model:RegisterModel){
        applyin.text = NSLocalizedString("Auditing", comment: "平台审核中")
        commit_lab.text = NSLocalizedString("Submitapplication", comment: "提交申请")
        if model.pay_state == "1"{
            stateImageView.image = #imageLiteral(resourceName: "ruzhushenhe_dangqian3")
            stateLab.text = NSLocalizedString("Pass", comment: "审核通过")
        }else{
            if model.apply_state == "0"{
                stateImageView.image = #imageLiteral(resourceName: "ruzhushenhe_dangqian")
            }else if model.apply_state == "1"{
                stateImageView.image = #imageLiteral(resourceName: "ruzhushenhe_dangqian2")
                
            }else if model.apply_state == "2"{
                stateImageView.image = #imageLiteral(resourceName: "ruzhushenhe_dangqian3")
                stateLab.text = NSLocalizedString("Pass", comment: "审核通过")
            }else if model.apply_state == "3"{
                stateImageView.image = #imageLiteral(resourceName: "ruzhushenhe_dangqian3")
                stateLab.text = NSLocalizedString("Rejected", comment: "审核被拒")
            }
        }
    }
}

