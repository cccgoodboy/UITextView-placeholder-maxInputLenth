//
//  WatchUserInfo.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/24.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class WatchUserInfo: UIView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var manage: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var city: UIButton!
    @IBOutlet weak var abstract: UILabel!
    @IBOutlet weak var attent: UIButton!
    @IBOutlet weak var fens: UIButton!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var income: UIButton!
    @IBOutlet weak var attentBtn: UIButton!
    
    var isCurrentUserLiving: Bool?
    var isAnchor: Bool!
    
    var model: ChatRoomMember! {
        willSet(m) {
            avatar.kf.setImage(with: URL(string: m.header_img!))
            nickname.preferredMaxLayoutWidth = kScreenWidth - 160
            nickname.text = m.username
            
//            grade.set(grade: Int(m.grade!)!)
            
            
            if m.sex == "2" {
                gender.image = #imageLiteral(resourceName: "nv")
            } else {
                gender.image = #imageLiteral(resourceName: "nan")
            }
            ID.text = "ID号:" + m.roomId!
            
            if m.city == nil || m.city == "" {
                m.city = "火星"
            }
            
            city.setTitle(m.city, for: .normal)
            attent.setTitle("关注：\(m.follow_count ?? "")", for: .normal)
            fens.setTitle("送出：\(m.give_count ?? "")", for: .normal)

//            abstract.text = m.autograph
//            fens.setTitle("粉丝：\(m.fans_count!)", for: .normal)
//            attent.setTitle("关注：\(m.follow_count!)", for: .normal)
//            send.setTitle("送出：\(m.give_count!)", for: .normal)
//            income.setTitle("收益：\(m.b_diamond!)", for: .normal)
            if m.is_follow == "2" {
                attentBtn.isSelected = true
            } else {
                attentBtn.isSelected = false
            }
        }
    }
    
    class func show(atView: UIView, model: ChatRoomMember, isCurrentUserLiving: Bool, isAnchor: Bool = false) -> WatchUserInfo {
        let view = Bundle.main.loadNibNamed("WatchUserInfo", owner: nil
            , options: nil)!.first as! WatchUserInfo
        atView.addSubview(view)
        view.model = model
        view.isCurrentUserLiving = isCurrentUserLiving
        view.isAnchor = isAnchor
        view.showTheView()
    
        if isAnchor {
            return view
        }
//        if isCurrentUserLiving == false {
//            NetworkingHandle.fetchNetworkData(url: "Index/is_mangement", at: atView, params: ["live_id": model.live_id!], isShowHUD: false, success: { (result) in
//                if result["data"] as? String == "2" {
//                    view.manage.isHidden = false
//                }
//            })
//        } else {
//            view.manage.isHidden = false
//        }
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0 , width: kScreenWidth, height: kScreenHeight)
        nickname.preferredMaxLayoutWidth = kScreenWidth - 160
        backView.layer.cornerRadius = 10
        avatar.layer.cornerRadius = 97/2
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    private  func showTheView() {
        var frame = self.backView.frame
        let oldFrame =  frame
        self.alpha = 0.1
        frame.origin.y = self.frame.size.height
        self.backView.frame = frame
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.frame = oldFrame
            self.alpha = 1
        })
    }
    private func dismiss() {
        var frame = self.backView.frame
        frame.origin.y += frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.frame = frame
            self.alpha = 0.1
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func reportButtonAction(_ sender: UIButton) {
        
        //FIXME:TH等待数据

        if CSUserInfoHandler.getIdAndToken()?.uid == model.member_id {
            ProgressHUD.showNoticeOnStatusBar(message: "不能举报自己")
        } else {
            var type = "1"
            if isAnchor == false {
                type = "2"
            }
            NetworkingHandle.fetchNetworkData(url: "/api/live/report", at: self, params: ["type": type], success: { (result) in
//                let data = result["data"] as! [[String: AnyObject]]
//                let list = ReportModel.modelsWithArray(modelArray: data) as! [ReportModel]
//                self.reportAlert(arr: list)
            })
        }
    }
    @IBAction func attentButtonAction(_ sender: UIButton) {
        focusOtherPerson(viewResponder: self, other_id: model.member_id!, btn: sender, type: model.is_follow!) {
            if self.model.is_follow == "1" {
                self.model.is_follow = "2"
            } else {
                self.model.is_follow = "1"
            }
        }
    }
    @IBAction func privateChatButtonAction(_ sender: UIButton) {
        let chatController = DirectChatViewController(conversationChatter: model.hx_username!, conversationType: EMConversationTypeChat)
        chatController?.img = model.header_img
        chatController?.usernameTHEY = model.username
        chatController?.userId = model.member_id
        self.responderViewController()?.navigationController?.pushViewController(chatController!, animated: true)
    }
    
    @IBAction func connectTAButtonAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(atUserNotifiction), object: ["userid": self.model.member_id!, "username": self.model.username!])
        self.dismiss()
    }
    
    @IBAction func toTAPersonCenter(_ sender: UIButton) {
        let targetVC = MerchantViewController()
        targetVC.merchants_id = model.member_id
        self.responderViewController()?.navigationController?.pushViewController(targetVC, animated: true)

//        pushToUserInfoCenter(atViewController: self.responderViewController()!, uId: model.member_id!,isHasLive:true,isCurrentUserLiving: isCurrentUserLiving!)
    }
    
    @IBAction func manageButtonAction(_ sender: UIButton) {
//        NetworkingHandle.fetchNetworkData(url: "Index/check_user", at: self, params: ["live_id": model.live_id!, "user_id": model.user_id!], success: { (result) in
//            let data = result["data"] as! [String: String]
//            self.manageAlert(isManager: data["is_management"]!, isBlack: data["is_shield"]!, isBanned: data["is_banned"]!)
//        })
    }
    // 举报
    func reportAlert(arr: [ReportModel]) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for model in arr {
            let alertAction = UIAlertAction(title: model.name!, style: .default) { (action) in
                self.uploadReportData(why: model.name!)
            }
            alert.addAction(alertAction)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.responderViewController()?.present(alert, animated: true, completion: nil)
    }
    func uploadReportData(why: String) {
//        var params = ["user_id": model.member_id!, "why": why]
//        var url = "User/report"
////        if isAnchor == true {
////            params["live_id"] = model.live_id!
////            url = "Index/report"
////        }
//        NetworkingHandle.fetchNetworkData(url: url, at: self, params: params, success: { (result) in
//            ProgressHUD.showSuccess(message: "举报成功")
//        })
    }
    // 管理
    func manageAlert(isManager: String, isBlack: String, isBanned: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let microphone = UIAlertAction(title: "连麦", style: .default) { (action) in
            NotificationCenter.default.post(name: Notification.Name(conferenceCMD), object: ["userid": self.model.member_id!, "username": self.model.username!])
            self.dismiss()
        }
//        let manager = UIAlertAction(title: isManager == "2" ? "取消管理" : "设为管理", style: .default) { (action) in
//            NetworkingHandle.fetchNetworkData(url: "Index/live_manag", at: self, params: ["live_id": self.model.live_id!, "user_id": self.model.user_id!, "type": isManager], success: { (result) in
//                if isManager == "2" {
//                    self.sendEMCmdMessage(action: cancelManagerCMD)
//                } else {
//                    self.sendEMCmdMessage(action: settingUpManagerCMD)
//                }
//            })
//        }
//        let managerList = UIAlertAction(title: "管理员列表", style: .default) { (action) in
//            let vc = BlacklistViewController()
//            vc.live_id = self.model.live_id
//            self.responderViewController()?.navigationController?.pushViewController(vc, animated: true)
//        }
//        let blacklist = UIAlertAction(title: isBlack == "2" ? "取消拉黑" : "拉黑", style: .default) { (action) in
//            func uploadData() {
//                NetworkingHandle.fetchNetworkData(url: "Index/shield", at: self, params: ["live_id": self.model.live_id!, "user_id2": self.model.user_id!, "type": isBlack], success: { (result) in
//                })
//            }
//            if isBlack != "2" {
//                LyAlertView.alert(atVC: self.responderViewController(), message: "拉黑后TA将不能再私信你了哟，还要继续吗～", ok: "拉黑", okBlock: {
//                    uploadData()
//                })
//            } else {
//                uploadData()
//            }
//        }
//        let bannedToPost = UIAlertAction(title: isBanned == "2" ? "取消禁言" : "禁言", style: .default) { (action) in
//            NetworkingHandle.fetchNetworkData(url: "Index/banned", at: self, params: ["live_id": self.model.live_id!, "user_id": self.model.user_id!, "type": isBanned], success: { (result) in
//            })
//        }
//        let kickout = UIAlertAction(title: "踢出", style: .default) { (action) in
//            LyAlertView.alert(atVC: self.responderViewController(), message: "踢出后TA将不能再进入此直播间了哟，还要继续吗~", ok: "踢出", okBlock: {
//                NetworkingHandle.fetchNetworkData(url: "Index/kicking", at: self, params: ["live_id": self.model.live_id!, "user_id": self.model.user_id!], success: { (result) in
//                    self.sendEMCmdMessage(action: kickoutCMD)
//                })
//            })
//        }
//        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        
//        alert.addAction(blacklist)
//        alert.addAction(bannedToPost)
//        if isCurrentUserLiving! {
//            alert.addAction(microphone)
//            alert.addAction(kickout)
//            alert.addAction(manager)
//        }
//        alert.addAction(managerList)
//        alert.addAction(cancel)
//        self.responderViewController()?.present(alert, animated: true, completion: nil)
    }
    // 发送环信命令消息
    func sendEMCmdMessage(action: String) {
//        let body = EMCmdMessageBody(action: action)
//        let message = EMMessage(conversationID: model.roomId!, from: EMClient.shared().currentUsername, to: model.roomId!, body: body!, ext: ["userid": self.model.user_id!, "username": self.model.username!])
//        message?.chatType = .init(2)
//        EMClient.shared().chatManager.send(message!, progress: nil) { (messages, error) in
//        }
//        dismiss()
    }
}
class ReportModel: KeyValueModel {
    var report_why_id: String?
    var name: String?
}
