//
//  ToApplyInfosCell.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit

class ToApplyInfosCell: UITableViewCell {

    @IBOutlet weak var infoBtn: UIButton!
    
   
    @IBOutlet weak var t_titleLab: UILabel!
    @IBOutlet weak var t_contentTF: UITextField!
    var infoBtnClickBlock:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        t_contentTF.contentVerticalAlignment = .center
    }
    @IBAction func infoBtnClick(_ sender: UIButton) {
      
        self.infoBtnClickBlock?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
