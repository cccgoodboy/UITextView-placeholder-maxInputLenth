//
//  Merchant_videoTabCell.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/6.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class Merchant_videoTabCell: UITableViewCell {

    var playClickBlock:((VideoListModel)->())?
    var playMdoel:VideoListModel!
    
    
    var playBtn:UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var num: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.playBtn = UIButton.init(type: .custom)
        self.playBtn.setImage(#imageLiteral(resourceName: "direct-seeding_play_Button"), for: .normal)
        self.playBtn.addTarget(self, action: #selector(playClick(sender:)), for: .touchUpInside)
        self.img.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.img)
            make.width.height.equalTo(50)
        }
    }
     func playClick(sender:UIButton) {
        playClickBlock?(playMdoel)
    }
    func refershData(model: VideoListModel){
        playMdoel = model
        img.sd_setImage(with: URL.init(string: model.video_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        title.text = model.title ?? ""
        num.text = "\(NSLocalizedString("Hint_40", comment: "播放次数"))：\(model.watch_nums ?? "1")"
        time.text = "\(NSLocalizedString("Hint_41", comment: "上传时间"))：\(model.date ?? "")"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
