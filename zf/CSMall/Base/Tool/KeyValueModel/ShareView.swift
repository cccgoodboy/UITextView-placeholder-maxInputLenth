//
//  ShareView.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/23.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class ShareView: UIView {
    var urls: String?
    var avatars: String?
    var usernames: String?
    var type: String?
    
    var shareLivingBlock: (()->())?
    var dismissBlock: (()->())?
    @IBOutlet weak var backView: UIView!
    
    class func show(atView: UIView,url: String,avatar: String, username: String, type: String) -> ShareView {
        
        let view = Bundle.main.loadNibNamed("ShareView", owner: nil
            , options: nil)!.first as! ShareView
        view.avatars = avatar
        view.usernames = username
        view.urls = url
        view.type = type
        //type 1：直播，2：帖子， 3：录播/课程
        if type == "1"{ //直播
            
//            || type == "3"{
            
            view.frame = CGRect(x: 0, y: 0 , width: kScreenWidth, height: kScreenHeight)
        }else {
            
            view.frame = CGRect(x: 0, y: 0 , width: kScreenWidth, height: kScreenHeight - 64)
        }
        atView.addSubview(view)
        view.showTheView()
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismissBlock?()
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
    func dismiss() {
        var frame = self.backView.frame
        frame.origin.y += frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.frame = frame
            self.alpha = 0.1
        }) { (finished) in
            
            self.removeFromSuperview()
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        if sender.tag == 1000 {
            shareAction(type: .wechatTimeLine)
        } else if sender.tag == 1001 {
            shareAction(type: .wechatSession)
        } else if sender.tag == 1002 {
            UIPasteboard.general.string = self.urls
            ProgressHUD.showSuccess(message: "复制成功'")
        } else if sender.tag == 1003 {
            shareAction(type: .QQ)
        } else if sender.tag == 1004 {
            shareAction(type: .qzone)
        } else if sender.tag == 1005 {
            shareAction(type: .facebook)
        }else {
            UIPasteboard.general.string = self.urls
            ProgressHUD.showSuccess(message: "复制成功'")
        }
    }
    func shareAction(type: UMSocialPlatformType) {
        let object = UMShareWebpageObject()
        object.webpageUrl = self.urls
        print("~~~~~~~" + self.urls!)
        if self.type == "1" {
            object.title = "名师「" + self.usernames! + "」正在直播"
            object.descr = "这么多人在欣赏" + self.usernames! + "动情演绎，快来加入吧"
        } else if self.type == "2"{
            object.title = "快来看看我分享的这条帖子"
            object.descr = "给我点赞和评价"
        }else {
            object.title = "我分享了" + self.usernames! + "的精彩课程"
            object.descr = "大家一起来欣赏"
        }
        let data: Data = try! Data.init(contentsOf: URL(string: self.avatars!)!)
        let image = UIImage(data:data, scale: 1.0)
        object.thumbImage = image
        
        let messageObject = UMSocialMessageObject(mediaObject: object)
        
        UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: self.responderViewController()) { (data, error) in
            if error == nil {
                ProgressHUD.showSuccess(message: "分享成功")
                self.shareLivingBlock?()
            } else {
                ProgressHUD.showMessage(message: "失败")
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
