//
//  WatchLiveViewController.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/23.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class WatchLiveViewController: LiveBaseViewController, PLPlayerDelegate {

    var liveList: LiveList! {
        willSet(m) {
            self.roomId = m.room_id
            self.liveId = m.live_id
            self.isCurrentUserLiving = false
            self.anchorId = m.user_id
            self.playAddress = m.play_address
            self.playImg = m.play_img
            self.plAnchorId = m.qiniu_room_id
            self.url = m.share_url
            self.avatar = m.img
            self.username = m.username
        }
    }
    var playAddress: String?
    var playImg: String?
//    var windowType:Int?
    
    var labelAlert: UILabel?
    //MARK: - 更改（全屏按钮）
    var fullBtn: UIButton?
    var goodsModel:SearchGoodsListModel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: "LiveBaseViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.anchorId = liveList.user_id
        
       self.topView?.livingGoodsClick = { [unowned self] in
        //直接展示规格
//            self.loadData(goods_id:self.livegoodsId)
        
            let vc = GoodsDetailVC()
            vc.isLiving = 1
            vc.live_id = self.liveId ?? ""
            vc.seller = self.anchorId ?? ""
            vc.goods_id = self.livegoodsId
            vc.skip = "live"
            self.present(NavigationController(rootViewController: vc), animated: false, completion: nil)
        }
        do { try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) } catch{}
        
        let option = PLPlayerOption.default()
        option.setOptionValue(10, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        player = PLPlayer(url: NSURL(string: playAddress!) as URL?, option: option)
        player?.delegate = self
        player?.delegateQueue = DispatchQueue.main
        NotificationCenter.default.addObserver(self, selector: #selector(returnApp), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        //MARK: -更改
//        if self.windowType == 2 {
//            view.backgroundColor = UIColor.init(hexString: "#222222")
//            
//            player?.playerView?.frame = CGRect.init(x: 0, y: kScreenHeight/2 - 100, width: kScreenWidth, height: 200)
//            player?.playerView?.contentMode = .scaleAspectFit
//            //MARK: -更改
//            fullBtn = UIButton()
//            fullBtn?.setImage(#imageLiteral(resourceName: "mini_launchFullScreen_btn"), for: .normal)
//            fullBtn?.frame = CGRect(x: kScreenWidth - 45, y: kScreenHeight/2 + 55, width: 45, height: 45)
//            fullBtn?.addTarget(self, action: #selector(fullViewBtnClick(sender:)), for: .touchUpInside)
//            self.view.addSubview(fullBtn!)
//
//        }
        
//        if self.windowType == 1 || self.windowType == 0 {
//            player?.playerView?.frame = UIScreen.main.bounds
//            player?.playerView?.contentMode = .scaleAspectFill
//        }

        player?.isBackgroundPlayEnable = true
        player?.launchView?.image = #imageLiteral(resourceName: "playerBg")
//        player?.launchView?.kf.setImage(with: URL(string:"http://img.taopic.com/uploads/allimg/120727/201995-120HG1030762.jpg"))
        player?.launchView?.clipsToBounds = true
        player?.launchView?.contentMode = .scaleAspectFill
        self.view.insertSubview(player!.playerView!, at: 0)
        
        startPlayer()
        //FIXME:TH等待数据

        enterRoomConnectHx { (isSuccess) in
            DispatchQueue.main.async {
                if isSuccess {
//                    ProgressHUD.showNoticeOnStatusBar(message: "进入成功")
                    let model = CSUserInfoHandler.getUserBaseInfo()
                    let messageText = "进场了！"
                    let body = EMTextMessageBody(text:  messageText)

                    let ext = ["user_id": model.id, "username": model.name, "userimg": model.img, "intoroom": "1"]//, "usergrade":model.grade]
                    let message = EMMessage(conversationID: self.roomId!, from: EMClient.shared().currentUsername, to: self.roomId!, body: body, ext: ext)
                    message?.chatType = .init(2)
                    self.sendMessage(message: message!)
                } else {
                    self.prepareExit()
                    let vc = WatchEndViewController()
                    vc.liveId = self.liveId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    func returnApp() {
        
        UIApplication.shared.isIdleTimerDisabled = true
        self.player?.resume()
    }
    func loadData(goods_id:String){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/goods_info", at: self, params: ["goods_id":goods_id ], isShowHUD: false, success: { (response) in
            //                if let stop = self.goodsModel.is_stop{
            //                    if stop == "1"{
            //                        self.is_shopLab.isHidden = false
            //                    }else{
            //                        self.is_shopLab.isHidden = true
            //                    }
            //                }
            if let data = response["data"] as? NSDictionary {
                self.goodsModel = SearchGoodsListModel.deserialize(from: data)
                let vc = AddShopCartViewController()
                vc.goodsModel = self.goodsModel
                vc.isLiving = 1
                vc.live_id = self.liveId ?? "0"
                vc.seller = self.anchorId ?? "0"
                vc.showType = .GoodsDetail
                vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: false, completion: nil)

                
            }
        }) {
        }
    
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLivingGoods()

    }
    func loadLivingGoods(){
        NetworkingHandle.fetchNetworkData(url: "/api/merchant/live_goods", at: self, params: ["live_id":liveId ?? ""], isShowHUD: false, isShowError: true, success: { (response) in
            if let data = response["data"] as? NSArray{
                self.listgoods = [LiveGoodsModel].deserialize(from: data) as! [LiveGoodsModel]
                if self.listgoods.count > 0{
                    
                    if (self.listgoods.first?.is_top)! == "1"{
                        
                        self.topView?.livinggoodsBtn.isHidden = false
                        self.topView?.livinggoodsName.isHidden = false
                        
                        self.livegoodsId = (self.listgoods.first?.goods_id)!
                        
                        self.topView?.livinggoodsBtn.sd_setImage(with: URL.init(string: self.listgoods.first?.goods_img ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "moren-2"))
                        
                        
                    }else{
                        self.topView?.livinggoodsBtn.isHidden = true
                        self.topView?.livinggoodsName.isHidden = true
                    }
                    
                    self.showGoogsBtn.isHidden = false
                }
                else{
                    self.showGoogsBtn.isHidden = true
                    self.topView?.livinggoodsBtn.isHidden = true
                    self.topView?.livinggoodsName.isHidden = true
                    
                }
            }
        }) {
            
        }
    }
    //MARK: 全屏切换
    func fullViewBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        videoplayViewSwitchOrientation(isFull: sender.isSelected)
        showIconControl(sender.isSelected)
    }
    func showIconControl(_ state: Bool) {
        self.btn1.isHidden = state
        self.btn2.isHidden = state
        self.btn3.isHidden = state
        self.btn4.isHidden = state
        self.messageBtn.isHidden = state
        self.closeBtn.isHidden = state
        self.conferenceMemberView.isHidden = state
        self.topView?.isHidden = state
        self.chatView?.isHidden = state
        UIApplication.shared.setStatusBarHidden(state, with: .none)
    }
    func videoplayViewSwitchOrientation(isFull: Bool) {
        if isFull {
            self.player?.rotationMode = .PLPlayerRotateLeft
            self.player?.playerView?.frame = self.view.bounds
            fullBtn?.frame = CGRect(x: 0, y: kScreenHeight - 45, width: 45, height: 45)
        }else{
            self.player?.rotationMode = .PLPlayerNoRotation
            player?.playerView?.frame = CGRect.init(x: 0, y: kScreenHeight/2 - 100, width: kScreenWidth, height: 200)
            fullBtn?.frame = CGRect(x: kScreenWidth - 45, y: kScreenHeight/2 + 55, width: 45, height: 45)
        }
    }
    // 环信代理
    //MARK: 接受透传消息
    func cmdMessagesDidReceive(_ aCmdMessages: [Any]!) {
        //FIXME:TH等待数据
        let message = aCmdMessages.last as! EMMessage
        
        if message.conversationId != roomId {
            return
        }

        let nowTimeInterval = Date().timeIntervalSince1970
        let interval = nowTimeInterval - TimeInterval(message.timestamp/1000)
        print("#########", interval, "#############")
        if interval > 10 {
            return
        }

        let body = message.body as! EMCmdMessageBody
        
        if body.action == anchorStopLiveCMD {
            prepareExit()
            let vc = WatchEndViewController()
            vc.liveId = liveId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if body.action == MerchantsLivingGoodsCMD{
            let dic = message.ext as? Dictionary<String, String>
            if let goods = dic?["goodsId"] {
                loadLivingGoods()
                if goods != "" {
                    self.topView?.livinggoodsBtn.sd_setImage(with: URL.init(string: dic?["goodsImg"] ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "moren-2"))
                    self.livegoodsId = goods
                    self.topView?.livinggoodsBtn.isHidden = false
                    self.topView?.livinggoodsName.isHidden = false
                }else{
                    self.topView?.livinggoodsBtn.isHidden = true
                    self.topView?.livinggoodsName.isHidden = true
                }
            }else{
                self.topView?.livinggoodsBtn.isHidden = true
                self.topView?.livinggoodsName.isHidden = true
            }

        }
        else if message.ext.allKeys().contains("userid") && message.ext["userid"] as? String == CSUserInfoHandler.getIdAndToken()?.uid {
            let action = body.action
            
            if action == kickoutCMD {
                prepareExit()
                let alert = UIAlertController(title: "您已被主播踢出该房间", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "知道了", style: .destructive, handler: { (alert) in
                    self.navigationController?.navigationBar.isHidden = false
                    _ = self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else if action == disableSendMsgCMD {
                ProgressHUD.showNoticeOnStatusBar(message: "你已被主播禁言")
            } else if action == ableSendMsgCMD {
                ProgressHUD.showNoticeOnStatusBar(message: "主播已取消禁言")
            } else if action == conferenceCMD {
                if let s = self.sesstion, s.isRtcRunning {
                    return
                }
                LyAlertView.alert(atVC: self, message: "主播邀请你连麦，是否接受邀请", cancel: "拒绝", ok: "接受", okBlock: {
                    self.startConference()
                })
            } else if action == anchorAgreeConferenceCMD {
                self.startConference()
            } else if action == settingUpManagerCMD {
                ProgressHUD.showNoticeOnStatusBar(message: "你已被主播设置为管理员")
                //FIXME:TH等待数据
                let m = CSUserInfoHandler.getUserBaseInfo()
                self.sendLivingMessage(content: m.name + " 被主播设置为管理员")
            } else if action == cancelManagerCMD {
                ProgressHUD.showNoticeOnStatusBar(message: "你已被主播取消管理")
            }
        }
    }
    
    func startConference() {
        if self.sesstion == nil {
            let videoCatpure = PLVideoCaptureConfiguration.default()
            videoCatpure?.position = .front
            self.sesstion = PLMediaStreamingSession(videoCaptureConfiguration: videoCatpure, audioCaptureConfiguration: PLAudioCaptureConfiguration.default(), videoStreamingConfiguration: nil, audioStreamingConfiguration: nil, stream: nil)
            self.sesstion?.setBeautifyModeOn(true)
            self.sesstion?.setBeautify(0.85)
            self.sesstion?.setWhiten(0.85)
            self.sesstion?.setRedden(0.5)
            self.sesstion?.delegate = self
        }
        if self.sesstion?.isRtcRunning == false {
            self.sesstion?.rtcOption = [kPLRTCRejoinTimesKey: 2, kPLRTCConnetTimeoutKey: 3000]
            self.sesstion?.rtcMinVideoBitrate = 300 * 1000
            self.sesstion?.rtcMaxVideoBitrate = 800 * 1000
            
            let conf = PLRTCConfiguration(videoSize: .preset240x432, conferenceType: .audioAndVideo)
            //FIXME:TH等待数据
            self.sesstion?.startConference(withRoomName: liveList.qiniu_room_name!, userID: CSUserInfoHandler.getIdAndToken()?.uid, roomToken: self.liveList.qiniu_token!, rtcConfiguration: conf)
        }
    }
    
    // 七牛代理
    //MAKR: 播放器状态改变
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        switch state {
        case .statusUnknow:
            print("***===播放端状态: 未知状态")
        case .stateAutoReconnecting:
            print("***===播放端状态: 自动重连状态")
        case .statusError:
            print("***===播放端状态: 错误状态")
        case .statusCaching:
            print("***===播放端状态: 缓存数据为空状态")
            if isShowHUD == false {
                ProgressHUD.showLoading(toView: self.contentView)
                isShowHUD = true
            }
        case .statusReady:
            print("***===播放端状态: 播放组件准备完成，准备开始播放状态")
        case .statusStopped:
            print("***===播放端状态: 停止状态")
        case .statusPaused:
            print("***===播放端状态: 暂停状态")
        case .statusPlaying:
            print("***===播放端状态: 正在播放状态")
            if reconnectCount > 0 {
                timer.pause()
                reconnectCount = 0
            }
            if isShowHUD {
                ProgressHUD.hideLoading(toView: self.contentView)
                isShowHUD = false
            }
        case .statusPreparing:
            print("***===播放端状态: 正在准备播放所需组件状态")
        default:
            print("aaa")
        }
    }
    
    override func livingReconnect() {
        if reconnectCount >= 6 {
            timer.pause()
            prepareExit()
            let vc = WatchEndViewController()
            vc.liveId = liveId
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            startPlayer()
            reconnectCount += 1
            if isShowHUD == false {
                ProgressHUD.showLoading(toView: self.contentView)
                isShowHUD = true
            }
        }
    }
    
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        print("重连：", error as Any)
        guard let s = self.sesstion, s.isRtcRunning else {
            if reconnectCount < 6 {
                timer.resume()
            }
            return
        }
    }
    //MARK: 开始播放
    func startPlayer() {
        self.player?.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 退出
    override func quitLiveRoom() {
        prepareExit()
        
        self.navigationController?.navigationBar.isHidden = false
        _ = self.navigationController?.popViewController(animated: true)
    }
    // 退出准备
    override func prepareExit() {
        // 离开直播间
        
        NetworkingHandle.fetchNetworkData(url: "/api/live/out_live", at: self, params: ["live_id": liveId!], success: { (result) in
        })
        
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.isIdleTimerDisabled = false
        
        timer.invalidate()
        
        self.player?.stop()
        self.player?.delegate = nil
        self.player = nil
        
        self.sesstion?.stopConference()
        self.sesstion?.delegate = nil
        self.sesstion?.destroy()
        self.sesstion = nil
        //FIXME:TH等待数据
        let model = CSUserInfoHandler.getUserBaseInfo()
        let messageText = "离开了直播间"
        let body = EMTextMessageBody(text:  messageText)

        let ext = ["user_id": model.id, "username": model.name, "userimg": model.img,// "usergrade":model.grade,
            "leaveChatroom": "1"]
        let message = EMMessage(conversationID: self.roomId!, from: EMClient.shared().currentUsername, to: self.roomId!, body: body, ext: ext)
        message?.chatType = .init(2)
        self.sendMessage(message: message!, isShow: false)
    }
    // 私聊
    override func privateChat() {
        let chat = PrivateChatViewController.show(atVC: self, atView: contentView, isCurrentUserLiving: isCurrentUserLiving)
        chat.liveList = liveList
    } 
    // 外部调用
    class func toWatch(from vc: UIViewController, model: LiveList) {
        if model.live_id == nil{
            return
        }
//        NetworkingHandle.fetchNetworkData(url: "Index/check_anchor_state", at: vc, params: ["user_id": model.user_id!], success: { (result) in
            NetworkingHandle.fetchNetworkData(url: "/api/live/into_live", at: vc, params: ["live_id": model.live_id!], success: { (result) in
                
                let watch = WatchLiveViewController()
//                watch.windowType = Int(model.livewindow_type!)
                watch.liveList = model
                vc.navigationController?.pushViewController(watch, animated: true)
            })
//        })
    }
}
