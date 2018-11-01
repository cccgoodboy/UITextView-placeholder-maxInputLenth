//
//  LiveTopView.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/22.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class LiveTopView: UITableViewCell {
    
    @IBOutlet weak var anchorInfoView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var watchNumber: UILabel!
    @IBOutlet weak var attent: UIButton!
    @IBOutlet weak var attentWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var membarView: UIView!
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var livinggoodsBtn: UIButton!
    
    @IBOutlet weak var livinggoodsName: UILabel!
  
    
    var liveId: String?
    var roomId: String?
    var anchorId = ""
    var isCurrentUserLiving = true
//    var isCurrentUserLiving: Bool!

    var attentAnchorSuccessBlock: (()->())?
    var livingGoodsClick:(()->())?
    var model: ChatRoomMember! {
        willSet(m) {
//            money.text = m.b_diamond
            if !isCurrentUserLiving, m.is_follow == "2" {
                attentWidthConstraint.constant = 0
                attent.isHidden = true
            }
            avatar.sd_setImage(with: URL.init(string: m.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            
            let memView = LiveRoomMemberView.show(liveId: liveId!, isCurrentUserLiving: isCurrentUserLiving, roomId: roomId!, memberNumber: { [unowned self] (count) in
                self.watchNumber.text = "\(count)人"
            })
            membarView.addSubview(memView)
            memView.snp.makeConstraints { (make) in
                make.edges.equalTo(0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 174)
        livinggoodsBtn.layer.borderColor = themeColor.cgColor
        anchorInfoView.layer.cornerRadius = 33/2.0
        
        avatar.layer.cornerRadius = 30/2.0
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        
        avatar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(LiveTopView.clickAnchorAvatar))
        avatar.addGestureRecognizer(tap)
        
        moneyView.layer.cornerRadius = 23/2.0
    }
    func clickAnchorAvatar() {
        //FIXME:TH等待数据
        if CSUserInfoHandler.getIdAndToken()?.uid != model.member_id {
            model.live_id = liveId
            model.roomId = roomId
            _ = WatchUserInfo.show(atView: (self.responderViewController()?.view)!, model: model, isCurrentUserLiving: isCurrentUserLiving, isAnchor: true)
        }
    }
    class func show(atView: UIView, liveId: String, isCurrentUserLiving: Bool = false, anchorId: String, roomId: String) -> LiveTopView {
        let view = Bundle.main.loadNibNamed("LiveTopView", owner: nil, options: nil)?.first as! LiveTopView
        view.isCurrentUserLiving = isCurrentUserLiving
        view.liveId = liveId
        view.roomId = roomId
        view.id.text = roomId
        view.anchorId = anchorId
        if isCurrentUserLiving {
            view.attentWidthConstraint.constant = 0
            view.attent.isHidden = true
        }
        atView.addSubview(view)
        view.fetchAnchorInfo()
        view.reloadAnchorMoney()
        return view
    }
    // 获取主播信息
    func fetchAnchorInfo() {
        NetworkingHandle.fetchNetworkData(url: "/api/live/get_live_info", at: self, params: ["user_id": anchorId,"live_id":liveId!], isShowHUD: false, isShowError: false, success: { (result) in
            let data = result["data"]
            let userModel = ChatRoomMember.modelWithDictionary(diction: data as! Dictionary<String, AnyObject>)
            self.model = userModel
        })
    }
    // 刷新主播的金币量
    func reloadAnchorMoney() {
        NetworkingHandle.fetchNetworkData(url: "/api/live/get_get_money", at: self, params: ["user_id": anchorId], isShowHUD: false, isShowError: false, success: { (result) in
            self.money.text = result["data"] as? String
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func attentButtonAction(_ sender: UIButton) {
        focusOtherPerson(viewResponder: self, other_id: anchorId, btn: sender, type: model.is_follow!) {
            if self.model.is_follow == "2" {
                self.model.is_follow = "1"
            } else {
                self.model.is_follow = "2"
                self.attentAnchorSuccessBlock?()
            }
            DispatchQueue.main.async {
                self.attentWidthConstraint.constant = 0
                self.attent.isHidden = true                
            }
        }
    }
    @IBAction func livinggoodsClick(_ sender: UIButton) {
        livingGoodsClick?()
        
    }
}

