//
//  MessagDetailTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/18.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class MessagDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var messageLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var model:SystemMessageModel!{
        willSet(m){
            let str =  "\(m.title ?? "")\n\(m.message ?? "")"
            
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:str)
            let str1 = NSString(string: m.message ?? "")
            let theRange = str1.range(of: m.message ?? "")
            attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hexString: "999999"), range: theRange)
            messageLab.attributedText = attrstring
            
            messageLab.text = "\(m.title ?? "")\n\(m.message ?? "")"
            messageTime.text = m.intime ?? ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
