//
//  SignTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/18.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SignTableViewCell: UITableViewCell {

    @IBOutlet weak var signTitleLab: UILabel!
    @IBOutlet weak var signTextV: UITextView!
    var model:CSUserInfoModel! {
        willSet(m){
            signTextV.text = m.signature
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       signTitleLab.text = NSLocalizedString("Hint_216", comment: "签名")
    NotificationCenter.default.addObserver(self, selector: #selector(textViewNotifition(noti:)), name: NSNotification.Name.UITextViewTextDidChange, object: signTextV)

    }
    func textViewNotifition(noti: Notification) {
        let textVStr = signTextV.text!
        

        if (textVStr.characters.count > 150) {
            let str = textVStr.substring(to: textVStr.at(500))
            signTextV.text = str
        }
        model.signature = signTextV.text
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
