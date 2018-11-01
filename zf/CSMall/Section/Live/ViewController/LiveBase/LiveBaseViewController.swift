//
//  LiveBaseViewController.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/22.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
class LiveBaseViewController: UIViewController, EMChatManagerDelegate, EMChatroomManagerDelegate, LiveChatViewDelegate {
    

    var listgoods:[LiveGoodsModel] = [LiveGoodsModel]()
    
    @IBOutlet weak var showGoogsBtn: UIButton!
    var livegoodsId = ""//直播中置顶商品的ID

    
    @IBAction func liveShopClick(_ sender: UIButton) {
        let vc = LiveGoosListViewController()
        vc.livesId = liveId!
        vc.isLiving =  1
        vc.seller = anchorId ?? ""
        vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)

    }
    var url: String?      //分享的url
    var avatar: String?   //分享的主播头像
    var username: String? //分享的主播用户名
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // 从右到左
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!//私信
    @IBOutlet weak var btn4: UIButton!//连麦
    
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var messageBtn: UIButton!
    
    
    
    @IBOutlet weak var conferenceMemberView: UIView!
    @IBOutlet weak var conferenceMemberViewHeightConstraint: NSLayoutConstraint!
    //MARK: 更改 1
    var plAudioPlay: AVAudioPlayer?
    var bgmPlayControlView: BGMPlayControlView?
    var player: PLPlayer?
    var sesstion: PLMediaStreamingSession?
    var conferenceUserInfo: Dictionary<String, UIView> = [:]
    var plAnchorId: String?
    var fullScreenView: UIView?
    
    var topView: LiveTopView?
    var chatView: LiveChatView?
    var barrageView: BarrageView?
    var giftAnamatin: WatchLiveGiftView?
    var giftView: GiftView?
    var roomId: String?
    var liveId: String?
    var isCurrentUserLiving = false // 是否是当前用户在直播
    //FIXME:TH等待数据
    var anchorId :String?//CSUserInfoHandler.getIdAndToken()?.uid
    
    var chatInputView: LiveRoomChatView?
    
    var enterView: LiveRoomEnterView?
    var enterRoomCacheData: [[String: String]] = []
    var enterViewShowing = false
    
    var reconnectCount = 0
    var isShowHUD = false
    
    lazy var timer: Timer = {
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(LiveBaseViewController.livingReconnect), userInfo: nil, repeats: true)
    }()
    func livingReconnect() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
        
//        self.conferenceMemberViewHeightConstraint.constant = kScreenHeight - 65 - 91
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        EMClient.shared().roomManager.add(self, delegateQueue: nil)
        
        setupSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveBaseViewController.keyboardWillHide(noti:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveBaseViewController.keyboardWillShow(noti:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(atUserNotifictionAction(noti:)), name: Notification.Name(atUserNotifiction), object: nil)
        
        isLivingOrWatchLive = true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        let keyboardRec = nsValue.cgRectValue
        
        let height = keyboardRec.size.height
        
        //print("keybordShow:\(height)")
        
        giftView?.frame = CGRect.init(x: 0, y: kScreenHeight - height - kScreenHeight, width: kScreenWidth, height: (self.giftView?.frame.size.height)!)
    }
    
    func keyBoardWillHidden(notification:Notification) {
        
        giftView?.frame = CGRect.init(x: 0, y: kScreenHeight - (giftView?.frame.height)! , width: kScreenWidth, height: (self.giftView?.frame.size.height)!)
    }
    
    func atUserNotifictionAction(noti: Notification) {
        let dic = noti.object as? [String : String]
        talkBtnClicked(otherName: dic?["username"], otherId: dic?["userid"])
    }
    @IBAction func thumbClick(_ sender: UIButton) {
        //        KAPI_ThumbUp
        
        NetworkingHandle.fetchNetworkData(url: "/api/live/give_praise", at: self, params: ["member_id":anchorId!], success: { (response) in
            let str =  "点亮了爱心"
            self.sendLiveRoomMessage(text: str, isDanmu: false,isPraise: true)

                    let heartView = HeartAnimationView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    self.view.addSubview(heartView)

                    let sourcePoint = CGPoint(x: kScreenWidth - 85, y: self.view.bounds.height - 40)

                    heartView.center = sourcePoint

                    heartView.animationInView(view: self.view)

        }) {
        
        }
  
    }
    // 设置子视图
    func setupSubviews() {
        
        if CSUserInfoHandler.getIdAndToken()?.uid == nil{
            
            self.present(NavigationController(rootViewController:LoginViewController()), animated: false, completion:  nil)
            return
        }
            
        UIApplication.shared.isIdleTimerDisabled = true
        
        
        topView = LiveTopView.show(atView: contentView, liveId: liveId!, isCurrentUserLiving: isCurrentUserLiving, anchorId: anchorId!, roomId: roomId!)
            topView?.attentAnchorSuccessBlock = { [unowned self] in
            let m = CSUserInfoHandler.getUserBaseInfo()
            self.sendLivingMessage(content: m.name + " 关注了主播，不错过下一次直播")
        }
//        topView?.reloadAnchorMoney()
//        topView?.livingGoodsClick = { [unowned self] in
//            let vc = GoodsDetailVC()
//            vc.goods_id = self.livegoodsId
//            vc.skip = "live"
//            self.present(NavigationController(rootViewController: vc), animated: false, completion: nil)
//        }
        
        barrageView = BarrageView.show(atView: contentView, TopMargin: 100 + 90, BottomMargin:140.0/667*kScreenHeight + 70 + 40 + 80)
        
        chatView = LiveChatView.show(atView: contentView)
        chatView?.delegate = self
        
        giftAnamatin = WatchLiveGiftView()
        contentView.addSubview(giftAnamatin!)
        
        giftAnamatin?.snp.makeConstraints { (make) in
            make.bottom.equalTo(chatView!.snp.top).inset(-40)
            make.left.equalTo(10)
            make.right.equalTo(-90)
            make.height.equalTo(80)
        }
        
        if !isCurrentUserLiving {
            let chat = Chat(name: "直播消息", id: "-000", content: "我们提倡绿色直播，请保持房间的干净整洁!！", grade: "")
            chatView?.tableViewReloadData(data: chat)
            
            btn1.setImage(#imageLiteral(resourceName: "fenxiang"), for: .normal)
            btn2.setImage(#imageLiteral(resourceName: "zengsongliwu"), for: .normal)
            btn3.setImage(#imageLiteral(resourceName: "zhanneixin"), for: .normal)
            btn4.setImage(#imageLiteral(resourceName: "lianmai"), for: .normal)
        }
    }
    // 发送直播信息
    func sendLivingMessage(content: String) {
        let body = EMTextMessageBody(text: content)
        let ext = ["user_id": "-000", "username": "直播信息"]
        let message = EMMessage(conversationID: self.roomId!, from: EMClient.shared().currentUsername, to: self.roomId!, body: body, ext: ext)
        message?.chatType = .init(2)
        self.sendMessage(message: message!)
    }
    //MARK: -- 环信相关
    // 连接环信聊天室
    func enterRoomConnectHx(isSuccess: @escaping ((Bool) -> ())) {
        //FIXME:TH等待数据
        var count = 0
        let hxInfo = CSUserInfoHandler.getUserHXInfo()
        func joinChatroom() {
            EMClient.shared().roomManager.joinChatroom(roomId!, completion: { room, error in
                if error != nil {
                    count += 1
                    if let m = hxInfo, EMClient.shared().isLoggedIn == false, EMClient.shared().isAutoLogin == false {
                        EMClient.shared().login(withUsername: m.name, password: m.pw, completion: { str, error in
                            if error == nil { EMClient.shared().options.isAutoLogin = true }
                            if count == 5 { isSuccess(false) } else { joinChatroom() }
                        })
                    } else {
                        if count == 5 { isSuccess(false) } else { joinChatroom() }
                    }
                } else {
                    isSuccess(true)
                }
            })
        }
        joinChatroom()
    }
    // 环信发送命令信息（群发)
    func sendCmdMessageToChatRoom(action: String, ext: [String: Any]? = nil) {
        //FIXME:TH等待数据
        
        var extTemp = ext
        if extTemp == nil {
            let model = CSUserInfoHandler.getUserBaseInfo()
            extTemp = ["userid": model.id, "username": model.name]
        }
        let body = EMCmdMessageBody(action: action)
        let message = EMMessage(conversationID: self.roomId!, from: EMClient.shared().currentUsername, to: self.roomId!, body: body!, ext: extTemp!)
        message?.chatType = .init(2)
        EMClient.shared().chatManager.send(message!, progress: nil) { (messages, error) in
        }
    }
    // 环信发送命令信息（单发）
    func sendCmdMessageTo(chatID: String, action: String) {
        //FIXME:TH等待数据
        let model = CSUserInfoHandler.getUserBaseInfo()
        let body = EMCmdMessageBody(action: action)
        let message = EMMessage(conversationID: chatID, from: EMClient.shared().currentUsername, to: chatID, body: body!, ext: ["userid": model.id, "username": model.name])
        message?.chatType = .init(0)
        EMClient.shared().chatManager.send(message!, progress: nil) { (messages, error) in
        }
    }
    // 环信直播间发送消息
    func sendMessage(message: EMMessage, isShow: Bool = true) {
        EMClient.shared().chatManager.send(message, progress: nil, completion: { emessage , errors in
            
        })
        if isShow {
            
            self.messagesDidReceive([message as Any])
        }
    }
    // 准备退出
    func prepareExit() {
    }
    //MARK:  环信代理
    // 接收环信消息
    func messagesDidReceive(_ aMessages: [Any]!) {
        print(aMessages)
        let newMessage = aMessages.last as! EMMessage
        if newMessage.conversationId != roomId {
            return
        }
        
        let nowTimeInterval = Date().timeIntervalSince1970
        let interval = nowTimeInterval - TimeInterval(newMessage.timestamp/1000)
        print("#########", interval, "#############")
        if interval > 10 {
            return
        }
        //只接收群聊信息
        if newMessage.chatType == EMChatTypeChatRoom, newMessage.ext != nil {
            
            let body = newMessage.body as! EMTextMessageBody
            let dic = newMessage.ext as? [String:Any]
            
            if dic == nil{
                return
            }

            // 强制下线
            
            if isCurrentUserLiving, let contains = dic?.allKeys().contains("forced_off"), contains {
                prepareExit()
                let alert = UIAlertController(title: body.text, message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "知道了", style: .destructive, handler: { (alert) in
                    let end = LivingEndViewController()
                    end.liveId = self.liveId
                    self.navigationController?.pushViewController(end, animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            var usid = (dic?["user_id"] as? String) ?? ""
            var uname = (dic?["username"] as? String) ?? ""
            var uimg = (dic?["userimg"] as? String) ?? ""
//            let authName = dic?["authName"] ?? ""
            var ugrade = (dic?["usergrade"] as? String) ?? "1"
        
            //PC端送礼
            if usid == ""{
                usid = (newMessage.ext["user_id"] as? String) ?? ""
                uname = (newMessage.ext["username"] as? String) ?? ""
                uimg = (newMessage.ext["userimg"] as? String) ?? ""
                ugrade = ""//newMessage.ext["usergrade"] as? String ?? ""
                var total = 0
                var num = ""
                if newMessage.ext["num"] as? NSNumber == 1{
                    total = 1
                }else{
                    num = newMessage.ext["num"] as? String ?? ""
                    total = Int(num)!
                }
                let gname = newMessage.ext?["giftname"] as? String ?? ""
                let gimg = newMessage.ext?["giftimg"] as? String ?? ""
                //批量送礼
                if newMessage.ext?["batchGift"] as! NSNumber == 1 {
                
                    
                    let chat: Chat = Chat(name: uname , id: usid, content: "送了主播\(total)个 " + gname, grade: "1")
                    chatView?.tableViewReloadData(data: chat)
                    
                    for _ in 0...total - 1{
                    
                        let gift = XGiftModel(senderName: uname, senderURL: uimg, giftName: gname, giftURL: gimg,giftNum:"1")
                    
                    self.giftAnamatin?.giftContainerView.showGiftModel(gift)
                    
                    topView?.reloadAnchorMoney()
                  }
                    return
                }
 
            }
            
            if let intoroom = dic?["intoroom"] as? String{
                if intoroom == "1"{
                    reloadChatroomMember()
                    let chat: Chat = Chat(name: uname, id: usid, content: body.text!, grade: ugrade , isEnterRoom: true)
                    chatView?.tableViewReloadData(data: chat)
                    showEnterRoomMessage(grade: ugrade , name: uname)
                    return
                }
            }
//            if dic?["intoroom"] == "1" {
//                reloadChatroomMember()
//                let chat: Chat = Chat(name: uname, id: usid, content: body.text!, grade: ugrade, isEnterRoom: true)
//                chatView?.tableViewReloadData(data: chat)
//                showEnterRoomMessage(grade: ugrade, name: uname)
//                return
//            }
            if let barrage = dic?["barrage"] as? String{
                if barrage == "1"{
                    let chat: Chat = Chat(name: uname , id: usid , content: body.text!, grade: ugrade )
                    chatView?.tableViewReloadData(data: chat)
                    
                    self.barrageView?.sendBarrage(name: chat.userName, str: body.text, avatarUrl: uimg)
                    
                    topView?.reloadAnchorMoney()
                    return

                }
            }
            
//            if dic?["barrage"] == "1" {
//                let chat: Chat = Chat(name: uname, id: usid, content: body.text!, grade: ugrade)
//                chatView?.tableViewReloadData(data: chat)
//
//                self.barrageView?.sendBarrage(name: chat.userName, str: body.text, avatarUrl: uimg)
//
//                topView?.reloadAnchorMoney()
//                return
//            }
            if let praise = dic?["praise"] as? String{
                if praise == "1"{
                    let chat: Chat = Chat(name: "直播消息", id: usid, content: body.text!, grade: ugrade, isEnterRoom: true)
                    chatView?.tableViewReloadData(data: chat)
                    if usid != CSUserInfoHandler.getIdAndToken()?.uid {
                        let heartView = HeartAnimationView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        self.view.addSubview(heartView)
                        
                        let sourcePoint = CGPoint(x: kScreenWidth - 85, y: self.view.bounds.height - 40)
                        
                        heartView.center = sourcePoint
                        
                        heartView.animationInView(view: self.view)
                        
                    }
                    return
                    
                }
                
            }

//            if dic?["praise"] == "1"{
//                let chat: Chat = Chat(name: "直播消息", id: usid, content: body.text!, grade: ugrade, isEnterRoom: true)
//                chatView?.tableViewReloadData(data: chat)
//                if usid != CSUserInfoHandler.getIdAndToken()?.uid {
//                    let heartView = HeartAnimationView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//                    self.view.addSubview(heartView)
//
//                    let sourcePoint = CGPoint(x: kScreenWidth - 85, y: self.view.bounds.height - 40)
//
//                    heartView.center = sourcePoint
//
//                    heartView.animationInView(view: self.view)
//
//                }
//                return
//            }
            if let gimg = dic?["giftimg"] as? String{
                let gname = ( dic?["giftname"]  as? String) ?? ""
                let gift = XGiftModel(senderName: uname, senderURL: uimg, giftName: gname, giftURL: gimg,giftNum:(dic?["gift_num"] as? String) ?? "1")
                
                let chat: Chat = Chat(name: uname, id: usid, content: "送了主播\(dic?["gift_num"] ?? "1")个 " + gname, grade: ugrade)
                chatView?.tableViewReloadData(data: chat)
                
                self.giftAnamatin?.giftContainerView.showGiftModel(gift)
                
                topView?.reloadAnchorMoney()
                return

            }
            //普通礼物
//            if let gimg = dic?["giftimg"]{
//
//
//                let gname = dic?["giftname"] ?? ""
//                let gift = XGiftModel(senderName: uname, senderURL: uimg, giftName: gname, giftURL: gimg,giftNum:dic?["gift_num"] ?? "1")
//
//                let chat: Chat = Chat(name: uname, id: usid, content: "送了主播\(dic?["gift_num"] ?? "1")个 " + gname, grade: ugrade)
//                chatView?.tableViewReloadData(data: chat)
//
//                self.giftAnamatin?.giftContainerView.showGiftModel(gift)
//
//                topView?.reloadAnchorMoney()
//                return
//            }
            
            let chat: Chat = Chat(name: uname, id: usid, content: body.text!, grade: ugrade)
            if (dic?["intoroom"] as? String) ?? "" == "0" {
                reloadChatroomMember()
                return
            }
//            if dic?["leaveChatroom"] == "1" {
//                reloadChatroomMember()
//                return
//            }
            //FIXME:TH等待数据
            if let otherName = dic?["otherName"] {
                chat.atUserName = otherName as? String
                if (dic?["otherId"] as? String) == CSUserInfoHandler.getIdAndToken()?.uid {
                    chat.isAtOneself = true
                }
            }
            chatView?.tableViewReloadData(data: chat)
        }
    }
    // 有人加入聊天室
    func userDidJoin(_ aChatroom: EMChatroom!, user aUsername: String!) {
//        reloadChatroomMember()
    }
    // 有人退出聊天室
    func userDidLeave(_ aChatroom: EMChatroom!, user aUsername: String!) {
        //reloadChatroomMember()
    }
    // 刷新房间成员
    func reloadChatroomMember() {
        NotificationCenter.default.post(name: Notification.Name.init(reloadChatRoomMemberNotifiction), object: nil)
    }
    // 有人进入直播间
    func showEnterRoomMessage(grade: String, name: String) {
        enterRoomCacheData.append(["grade": grade, "name": name])
        if enterViewShowing == false {
            showEenterRoomView(dic: enterRoomCacheData.first!)
        }
    }
    func showEenterRoomView(dic: [String: String]) {
        if enterView == nil {
            enterView = LiveRoomEnterView.setup()
            contentView?.addSubview(enterView!)
        }
        //enterView?.grade.text = dic["grade"]! + "级"
        enterView?.content.text = dic["name"]! + "   进入了房间！"
        
        var frame = enterView?.frame
        frame?.origin.x = kScreenWidth
        enterView?.frame = frame!
        
        enterViewShowing = true
        UIView.animate(withDuration: 0.5, animations: {
            frame?.origin.x = kScreenWidth - 276
            self.enterView?.frame = frame!
        }) { (stop) in
            UIView.animate(withDuration: 1.6, delay: 0, options: .curveLinear, animations: {
                frame?.origin.x = 10
                self.enterView?.frame = frame!
            }, completion: { (stop) in
                UIView.animate(withDuration: 0.5, animations: {
                    frame?.origin.x = -266
                    self.enterView?.frame = frame!
                }) { stop in
                    self.enterViewShowing = false
                    self.enterRoomCacheData.removeFirst()
                    if self.enterRoomCacheData.count > 0 {
                        self.showEenterRoomView(dic: self.enterRoomCacheData.first!)
                    }
                }
            })
        }
    }

    // 弹幕相关
    //MARK: - 键盘监听
    func keyboardWillHide(noti: Notification) {
        let kbInfo = noti.userInfo
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        var frame = chatInputView?.inputBgView.frame
        UIView.animate(withDuration: duration, animations: {
            frame?.origin.y = kScreenHeight
            self.chatInputView?.inputBgView.frame = frame!
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        })
    }
    func keyboardWillShow(noti: Notification) {
        if let tf = chatInputView?.textField, tf.isFirstResponder {
            let kbInfo = noti.userInfo
            let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
            var frame = chatInputView?.inputBgView.frame
            
            UIView.animate(withDuration: duration, animations: {
                frame?.origin.y = kScreenHeight - kbRect.height - LiveRoomChatView.inputViewHeight
                self.chatInputView?.inputBgView.frame = frame!
                self.scrollView.setContentOffset(CGPoint(x: 0, y: kbRect.height + LiveRoomChatView.inputViewHeight - 70), animated: true)
            })
        }
    }
    // 弹出键盘
    func talkBtnClicked(otherName: String? = nil, otherId: String? = nil) {
        
        func start() {
            if chatInputView == nil {
                chatInputView = LiveRoomChatView.show(atView: view, send: { (text, isDanmu) in
                    if let name = otherName, text.contains("@" + name) {
                        let content = text.substring(from: text.at(name.characters.count + 1))
                        self.sendLiveRoomMessage(text: content, isDanmu: isDanmu, otherName: otherName, otherId: otherId)
                    } else {
                        self.sendLiveRoomMessage(text: text, isDanmu: isDanmu)
                    }
                })
            }
            chatInputView?.isHidden = false
            chatInputView?.textField.becomeFirstResponder()
            if let name = otherName {
                chatInputView?.textField.text = "@" + name + " "
            }
        }
        if isCurrentUserLiving == false {
            NetworkingHandle.fetchNetworkData(url: "/api/live/is_banned", at: self, params: ["live_id": liveId!], isShowHUD: false, success: { (result) in
                if result["data"] as? String == "1" {
                    start()
                } else {
                    ProgressHUD.showNoticeOnStatusBar(message: "你已被主播禁言")
                }
            })
        } else {
            start()
        }
    }
    // 发送信息
    func sendLiveRoomMessage(text: String, isDanmu: Bool, otherName: String? = nil, otherId: String? = nil,isPraise: Bool? = false) {
        //FIXME:TH等待数据
        let body = EMTextMessageBody(text: text)
        
        let m = CSUserInfoHandler.getUserBaseInfo()
        var ext = ["user_id": m.id, "username": m.name, "userimg": m.img]//, "usergrade": m.grade]
        if isDanmu {
            ext["barrage"] = "1"
        }
        if isPraise == true{
            ext["praise"] = "1"
        }
        if let name = otherName {
            ext["otherName"] = name
            ext["otherId"] = otherId!
        }
        
        let message = EMMessage(conversationID: roomId!, from: EMClient.shared().currentUsername, to: roomId!, body: body, ext: ext)
        message?.chatType = .init(2)
        
        if isDanmu {
//            NetworkingHandle.fetchNetworkData(url: "Index/screen_price", at: self, params: ["live_id": liveId!], isShowHUD: false, success: { (reslut) in
                self.topView?.reloadAnchorMoney()
                self.sendMessage(message: message!)
//            })
        } else {
            self.sendMessage(message: message!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 退出按钮
    @IBAction func closeButtonAction(_ sender: Any) {
        quitLiveRoom()
    }
    func quitLiveRoom() {
    }
    
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        //FIXME:TH等待数据

        if sender == btn1 {
            if isCurrentUserLiving {
                beautify()
            } else {
                let shareView = ShareView.show(atView: view, url: self.url ?? "https://www.baidu.com", avatar: self.avatar!, username: self.username!,type:"1" )
                shareView.shareLivingBlock = { [unowned self] in
                    //FIXME:TH等待数据
                    let m = CSUserInfoHandler.getUserBaseInfo()
                    self.sendLivingMessage(content: m.name + " 对主播爱不完，送礼之余还分享")
                }
            }
        } else if sender == btn2 {
//            if isCurrentUserLiving {
//                // 消息
//                _ = PrivateChatViewController.show(atVC: self, atView: contentView, isCurrentUserLiving: isCurrentUserLiving)
//            } else {
                if giftView != nil {
                    giftView?.show()
                } else {
                    giftView = GiftView.show(atView: self.view, live_id: liveId!, clickSend: { model in
                        self.sendGift(model: model)
                    })
                }
//            }
        } else if sender == btn3 {
            if isCurrentUserLiving {
                let share = ShareView.show(atView: view, url: self.url!, avatar: self.avatar!, username: self.username!,type: "1")
            } else {
                // 消息
                privateChat()
            }
        } else if sender == btn4 {
            if isCurrentUserLiving {
                toggleCamera()
            } else {
                if let s = self.sesstion, s.isRtcRunning {
//                    sesstion?.setBeautifyModeOn(false)
//                    ProgressHUD.showNoticeOnStatusBar(message: "你正在与主播连麦")
                    self.sesstion?.toggleCamera()
                    return
                }
                NetworkingHandle.fetchNetworkData(url: "/api/live/is_wheat", at: self, params: ["user_id": CSUserInfoHandler.getIdAndToken()?.uid ?? ""], isShowHUD: false, success: { (reslut) in
                    if reslut["data"] as? String == "1" {
                        if let s = self.sesstion, s.isRtcRunning {
                            return
                        }
                        LyAlertView.alert(atVC: self, message: "是否确定申请与主播连麦", ok: "申请", okBlock: {
                            self.sendCmdMessageToChatRoom(action: userApplyConferenceCMD)
                        })
                    } else {
                        ProgressHUD.showNoticeOnStatusBar(message: "主播不允许连麦！")
                    }
                })
            }
        } else {
            talkBtnClicked()
        }
    }
    // 美颜
    func beautify(){
        
    }
    // 翻转
    func toggleCamera(){}
    // 消息
    func privateChat(){}
    // 送礼
    func sendGift(model: GiftModel) {
        //原来
//        let body = EMTextMessageBody(text: "")
//        
//        let m = DLUserInfoHandler.getUserBaseInfo()
//        
//        let ext = ["user_id": m.id, "username": m.name, "userimg": m.img, "usergrade": m.grade, "giftimg": model.img!, "giftprice": model.price!, "giftname": model.name!, "gift_id": model.gift_id!]
//        let message = EMMessage(conversationID: roomId!, from: EMClient.shared().currentUsername, to: roomId!, body: body, ext: ext)
//        message?.chatType = .init(2)
//        
//        self.sendMessage(message: message!)
        //更改
        //FIXME:TH等待数据
        let body = EMTextMessageBody(text: "")
        let m = CSUserInfoHandler.getUserBaseInfo()
        let ext = ["user_id": m.id, "username": m.name, "userimg": m.img, "giftimg": model.img!, "giftprice": model.price!, "giftname": model.name!, "gift_id": model.gift_id!, "batchGift":model.batchGift!, "gift_num":model.num!]//, "usergrade": m.grade
        let message = EMMessage(conversationID: roomId!, from: EMClient.shared().currentUsername, to: roomId!, body: body, ext: ext)
        message?.chatType = .init(2)
        
        self.sendMessage(message: message!)

    }
    // 聊天消息的代理
    func liveChatView(_: LiveChatView, userId: String) {
    
        NetworkingHandle.fetchNetworkData(url: "/api/live/get_live_info", at: self, params: ["user_id": userId,"live_id":anchorId], success: { (result) in
            let data = result["data"] as! [String: AnyObject]
            let model = ChatRoomMember.modelWithDictionary(diction: data)
            model.live_id = self.liveId
            model.roomId = self.roomId
            _ = WatchUserInfo.show(atView: self.view, model: model, isCurrentUserLiving: self.isCurrentUserLiving, isAnchor: self.anchorId == userId ? true : false)
        })
    }
    
    deinit {
        EMClient.shared().roomManager.remove(self)
        EMClient.shared().chatManager.remove(self)
        isLivingOrWatchLive = false
        print("========主播关闭直播========")
        EMClient.shared().roomManager.leaveChatroom(roomId!) { (error) in
            print("离开聊天室: ", error as Any)
        }
        if isCurrentUserLiving {
            EMClient.shared().roomManager.destroyChatroom(roomId!) { (error) in
                print("销毁聊天室: ", error as Any)
            }
        }
    }
    // 主播间使用
    func startPlayAudio() {}
    
    fileprivate lazy var conferenceCloseBtn: UIButton = {
        let closeBtn = UIButton(frame: CGRect(x: kScreenWidth/3.0 - 30, y: 0, width: 30, height: 30))
        closeBtn.setImage(#imageLiteral(resourceName: "guanbi"), for: .normal)
        closeBtn.addTarget(self, action: #selector(self.closeConferenceButtonAction), for: .touchUpInside)
        return closeBtn
    }()
}

extension LiveBaseViewController: PLMediaStreamingSessionDelegate {
    
    func closeConferenceButtonAction() {
        if let session = self.sesstion, session.isRtcRunning {
            session.stopConference()
            self.removeConferenceMember(view: session.previewView)
            session.destroy()
            session.delegate = nil
            self.sesstion = nil
            if let fsv = fullScreenView {
                fsv.removeFromSuperview()
                fullScreenView = nil
            }
            btn4.setImage(#imageLiteral(resourceName: "lianmai"), for: .normal)
            for (_, view) in conferenceUserInfo {
                view.removeFromSuperview()
            }
        }
        self.player?.play()
    }
    
    //MARK: - 连麦回调
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, rtcStateDidChange state: PLRTCState) {
        print(state)
        
        if isCurrentUserLiving {
            if state == .conferenceStarted {
                plAudioPlay?.pause()
                bgmPlayControlView?.removeFromSuperview()
            } else if state == .conferenceStopped, plAudioPlay?.prepareToPlay() == true {
                startPlayAudio()
                plAudioPlay?.play()
            }
            return
        }
        if state == .conferenceStarted {
            btn4.setImage(#imageLiteral(resourceName: "jiepin"), for: .normal)
            let view = self.sesstion!.previewView!
            let tap = UITapGestureRecognizer(target: self, action: #selector(switchFullView(gesture:)))
            view.addGestureRecognizer(tap)
            self.addConferenceMember(view: view)
            view.addSubview(conferenceCloseBtn)
        }
    }
    // 切换预览全屏 view
    func switchFullView(gesture: UITapGestureRecognizer) {
        if fullScreenView == nil {
            return
        }
        if self.sesstion?.previewView == gesture.view {
            
            self.view.insertSubview((self.sesstion?.previewView)!, aboveSubview: (player?.playerView)!)
            for ges in (self.sesstion?.previewView.gestureRecognizers)! {
                self.sesstion?.previewView.removeGestureRecognizer(ges)
            }
            self.addConferenceMember(view: fullScreenView!, frame: self.sesstion?.previewView.frame)
            self.sesstion?.previewView.frame = UIScreen.main.bounds
            fullScreenView?.addSubview(conferenceCloseBtn)
            let tap = UITapGestureRecognizer(target: self, action: #selector(switchFullView(gesture:)))
            fullScreenView?.addGestureRecognizer(tap)
            
        } else {
            
            self.view.insertSubview(fullScreenView!, aboveSubview: (player?.playerView)!)
            for ges in (fullScreenView?.gestureRecognizers)! {
                fullScreenView?.removeGestureRecognizer(ges)
            }
            self.addConferenceMember(view: (self.sesstion?.previewView!)!, frame: fullScreenView?.frame)
            fullScreenView?.frame = UIScreen.main.bounds
            self.sesstion?.previewView.addSubview(conferenceCloseBtn)
            let tap = UITapGestureRecognizer(target: self, action: #selector(switchFullView(gesture:)))
            self.sesstion?.previewView?.addGestureRecognizer(tap)
        }
    }
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, userID: String!, didAttachRemoteView remoteView: UIView!) {
        
        if userID == plAnchorId {
            player?.stop()
            remoteView.frame = UIScreen.main.bounds
            self.fullScreenView = remoteView
            self.view.insertSubview(remoteView, aboveSubview: (player?.playerView)!)
            return
        }
        addConferenceMember(view: remoteView)
        conferenceUserInfo[userID] = remoteView
        
        if isCurrentUserLiving {
            
            let closeBtn = UIButton(frame: CGRect(x: kScreenWidth/3 - 30, y: 0, width: 30, height: 30))
            closeBtn.setImage(#imageLiteral(resourceName: "guanbi"), for: .normal)
            remoteView.addSubview(closeBtn)
            closeBtn.addTarget(self, action: #selector(kickoutButtonAction(btn:)), for: .touchUpInside)
        }
    }
    
    func addConferenceMember(view: UIView, frame: CGRect? = nil) {
        let width = kScreenWidth/3.0
        let height = 16.0/12 * width
        let minY = (height + 2) * CGFloat(2 - conferenceUserInfo.allKeys().count) + 100
        if frame != nil {
            view.frame = frame!
        } else {
            view.frame = CGRect(x: kScreenWidth - width, y: minY, width: width, height: height)
        }
        self.view.addSubview(view)
        let lyeGesture = LyeCustomGestureRecognizer(target: nil, action: nil)
        view.addGestureRecognizer(lyeGesture)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.clipsToBounds = true
    }
    func removeConferenceMember(view: UIView?) {
        view?.removeFromSuperview()
        if isCurrentUserLiving, (self.sesstion?.rtcParticipantsCount)! == 0 {
            self.sesstion?.stopConference()
        }
    }
    // 踢出
    func kickoutButtonAction(btn: UIButton) {
        let view = btn.superview
        for (key, value) in conferenceUserInfo {
            if value == view {
                sesstion?.kickoutUserID(key)
                break
            }
        }
    }
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, didKickoutByUserID userID: String!) {
        self.sesstion?.stopConference()
        removeConferenceMember(view: self.sesstion?.previewView)
        self.sesstion?.destroy()
        self.sesstion?.delegate = nil
        self.sesstion = nil
        self.player?.play()
        if let fsv = fullScreenView {
            fsv.removeFromSuperview()
            fullScreenView = nil
        }
        for (_, view) in conferenceUserInfo {
            view.removeFromSuperview()
        }
        btn4.setImage(#imageLiteral(resourceName: "lianmai"), for: .normal)
        ProgressHUD.showNoticeOnStatusBar(message: "主播结束了连麦！")
    }
    // 1 移除
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, userID: String!, didDetachRemoteView remoteView: UIView!) {
        removeConferenceMember(view: remoteView)
        conferenceUserInfo.removeValue(forKey: userID)
    }
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, rtcDidFailWithError error: Error!) {
        print(error.localizedDescription)
        ProgressHUD.showNoticeOnStatusBar(message: "未知错误，连麦失败")
    }

}
