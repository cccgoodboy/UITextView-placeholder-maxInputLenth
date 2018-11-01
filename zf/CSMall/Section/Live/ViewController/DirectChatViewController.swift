//
//  DirectChatViewController.swift
//  CrazyEstate
//
//  Created by 梁毅 on 2017/1/19.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
//MARK:个人中心设置的开播提醒，暂时添加在这
let isShowMessageNotification = "IsShowMessageNotification"

var isLivingOrWatchLive = false

class DirectChatViewController: EaseMessageViewController ,EaseMessageViewControllerDataSource, EaseMessageViewControllerDelegate {
    
    var img: String?
    var usernameTHEY: String?
    var vcType: String?
    var userId: String?
    
    var isCustomNav = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    deinit {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: isShowMessageNotification), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: isShowMessageNotification), object: nil)
        
        self.dataSource = self
        self.delegate = self
        self.tableView.backgroundColor = UIColor(hexString: "#F3F6F9")
        self.title = usernameTHEY
        
        if  vcType == "1" {
            self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .done, target: self, action: #selector(back))
            self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        }
        if isLivingOrWatchLive {
            (chatToolbar as? EaseChatToolbar)?.styleChangeButton.isEnabled = false
        }
        if isCustomNav {
            self.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: naviHeight + differValue - 64)
            self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: naviHeight + differValue - 64 - 46)
            NotificationCenter.default.addObserver(self, selector: #selector(DirectChatViewController.keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(DirectChatViewController.keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        }
    }
    //MARK: - 键盘监听
    func keyboardWillHide(noti: Notification) {
        let kbInfo = noti.userInfo
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        var frame = self.navigationController?.view.frame
        UIView.animate(withDuration: duration, animations: {
            frame?.origin.y = kScreenHeight - naviHeight
            frame?.size.height = naviHeight + differValue
            self.navigationController?.view.frame = frame!
        })
    }
    func keyboardWillShow(noti: Notification) {
        
        let kbInfo = noti.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        var frame = self.navigationController?.view.frame
        UIView.animate(withDuration: duration, animations: {
            frame?.origin.y = kScreenHeight - naviHeight - kbRect.height
            frame?.size.height += kbRect.height
            self.navigationController?.view.frame = frame!
        })
    }

    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    override func messagesDidReceive(_ aMessages: [Any]!) {
        let messate = aMessages as NSArray
        print(messate)
        for messageNew in messate {
            if  self.shouldMarkMessageAsRead() == true {
                let newMessage = messageNew as! EMMessage
                self.conversation.markMessageAsRead(withId: newMessage.messageId, error: nil)
            }
        }
    }

    func shouldMarkMessageAsRead() -> Bool {
        var iSMark = true
        if  dataSource != nil {
            if  dataSource.responds(to: #selector(messageViewControllerShouldMarkMessages
                )) != true {
                iSMark = dataSource.messageViewControllerShouldMarkMessages!(asRead: self)
            }
            else {
                
            }
        }
            
        else {
            if UIApplication.shared.applicationState == UIApplicationState.background || self.isViewDidAppear {
                iSMark = false
            }
        }
        
        return iSMark;
        
    }
    func messageViewControllerShouldMarkMessages(asRead viewController: EaseMessageViewController!) -> Bool {
        return true
    }
    //FIXME:TH等待数据
//    func messageViewController(_ viewController: EaseMessageViewController!, modelFor message: EMMessage!) -> IMessageModel! {
//        
//        let model = EaseMessageModel(message: message)
//        
//        
//        if  model?.isSender == true {
//            
//            
//            
//            let m = DLUserInfoHandler.getUserBaseInfo()
//            model?.avatarURLPath = m.img
//            model?.nickname = m.name
//        }
//        else {
//            model?.avatarURLPath = img!
//            model?.nickname = usernameTHEY!
//        }
//        
//        return model
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func messageCellSelected(_ model: IMessageModel!) {
        if isLivingOrWatchLive {
            if model.bodyType == EMMessageBodyTypeVoice {
                ProgressHUD.showNoticeOnStatusBar(message: "直播时不能读语言哦！")
                return
            }
        }
        super.messageCellSelected(model)
    }
    // 设置 imagePicker 导航栏
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:defaultFont(size: 16)]
        navigationController.navigationBar.barTintColor = themeColor
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
