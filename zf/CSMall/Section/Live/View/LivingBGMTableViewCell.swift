//
//  LivingBGMTableViewCell.swift
//  Duluo
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

protocol LivingBGMTableViewCellDelegate {
    func livingBGM(_ view: LivingBGMTableViewCell, model: LivingBGMModel, selectBtn: UIButton?)
}

class LivingBGMTableViewCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    var delegate: LivingBGMTableViewCellDelegate?
    
    var model: LivingBGMModel! {
        willSet(m) {
            if m.pathPostfix == nil {
                selectBtn.isSelected = false
            } else {
                selectBtn.isSelected = true
            }
            selectBtn.isEnabled = !m.isDownloading
            songName.text = m.song_name
            singer.text = m.singer
            time.text = m.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func selectButtonAction(_ sender: UIButton) {
        if let _ = model.pathPostfix {
            self.delegate?.livingBGM(self, model: model, selectBtn: nil)
        } else {
            self.delegate?.livingBGM(self, model: model, selectBtn: selectBtn)
        }
    }
}
