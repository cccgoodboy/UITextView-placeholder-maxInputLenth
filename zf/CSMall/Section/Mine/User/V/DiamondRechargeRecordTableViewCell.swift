//
//  DiamondRechargeRecordTableViewCell.swift
//  MoDuLiving
//
//  Created by 曾觉新 on 2017/3/7.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class DiamondRechargeRecordTableViewCell: UITableViewCell {
    
    var diamondImageView: UIImageView!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var stateLabel: UILabel!
    
    var model: StuRecharageRecordModel? {
        didSet {
            titleLabel.text = model?.title ?? ""
            dateLabel.text = model?.uptime
            stateLabel.text = "成功"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initViews() {
        diamondImageView = UIImageView();
        diamondImageView.image = UIImage(named: "Diamonds")
        self.contentView.addSubview(diamondImageView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 9)
        dateLabel.textColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.00)
        self.contentView.addSubview(dateLabel)
        
        
        stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 13)
        stateLabel.textColor = themeColor
        self.contentView.addSubview(stateLabel)
        
        updateUI()
    }
    
    func updateUI() {
        
        diamondImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.diamondImageView.snp.right).offset(12);
            make.bottom.equalTo(self.contentView.snp.centerY).offset(-3)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
        }
        
        stateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
