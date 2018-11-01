//
//  BarrageView.swift
//  MoDuLiving
//
//  Created by 梁毅 on 2017/3/7.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class BarrageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var manager : KYBarrageManager?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        manager = KYBarrageManager()
        manager?.bindingView = self
        manager?.delegate = self
        manager?.scrollSpeed = 30
        manager?.memoryMode = 0
        manager?.refreshInterval = 1
    }
    class func show(atView: UIView,TopMargin:CGFloat,BottomMargin: CGFloat) -> BarrageView {
        let toolBarView = Bundle.main.loadNibNamed("BarrageView", owner: nil
            , options: nil)!.last as! BarrageView
        atView.addSubview(toolBarView)
        toolBarView.snp.makeConstraints { (make) in
            make.top.equalTo(TopMargin)
            make.bottom.equalTo(-BottomMargin)
            make.left.right.equalTo(0)
        }
        return toolBarView
    }

    func sendBarrage(name: String, str: String, avatarUrl: String) {
        let m = KYBarrageModel()
        m.direction = .directRightToLeft
        m.barrageType = .customView
        let barrageUser = KYBarrageUserModel()
        barrageUser.userId = 1001
        barrageUser.name = name
        barrageUser.txt = str
        barrageUser.url = avatarUrl
        barrageUser.vipFrom = arc4random() % 2 == 1 ? 1 : 0
        barrageUser.vip = 1
        m.barrageUser = barrageUser
        manager?.showBarrage(withDataSource: m)
    }
}
extension BarrageView: KYBarrageManagerDelegate {
    func barrageManagerDataSource() -> Any {
        
        let a = arc4random() % 100000
        let str  = "I'm coming " + String(a)
        let attr = NSMutableAttributedString(string: str)
        attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: str.characters.count))
        
        let m = KYBarrageModel(barrageContent: attr)
        m.displayLocation = .center
        m.direction = .directRightToLeft
        m.barrageType = .customView
        
        return m
    }
}
