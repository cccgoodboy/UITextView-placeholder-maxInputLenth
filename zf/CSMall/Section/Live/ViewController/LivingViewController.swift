////
////  LivingViewController.swift
////  Duluo
////
////  Created by sh-lx on 2017/3/22.
////  Copyright © 2017年 tts. All rights reserved.
////
//

//FIXME:TH等待数据

//import UIKit
//
//class LivingViewController: LiveBaseViewController, AnchorBeautifyViewDelegate, LivingBGMViewControllerDelegate {
//    
//    var audioCapture: PLAudioCaptureConfiguration?
//    
//    let queue1 = DispatchQueue(label: "Queue1")
//    
//    var volume: Float = 0.5
//    var accompany: Float = 0
//    var beutyValue: Float = 0.5
//    
//    var dismissLive: (() -> ())?
//    
//    var isOpenMirror = false
//    var isAuthConference = false
//    
//    //更改
//    var audio: AVAudioPlayer?
//    var musicModel: LivingBGMModel?
//    var rounterState: Int?
//    
//    
//    var startLiving: StartLiving! {
//        willSet(m) {
//            self.roomId = m.room_id
//            self.liveId = m.live_id
//            self.url = m.url
//            self.plAnchorId = m.qiniu_room_id
//            self.isAuthConference = m.is_wheat == "1" ? true : false
//        }
//    }
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: "LiveBaseViewController", bundle: Bundle.main)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.isScrollEnabled = false
//        
//        initSesion()
//        
//        //FIXME:TH等待数据
////        let userInfo = DLUserInfoHandler.getUserBaseInfo()
////        self.avatar = userInfo.img
////        self.username = userInfo.name
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(intoTheBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(returnApp), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(conferenceNotificationAction(noti:)), name: Notification.Name(conferenceCMD), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListenerCallback(noti:)), name: Notification.Name.AVAudioSessionRouteChange, object: nil)
//    }
//    func isHeadsetPluggedIn() -> Bool {
//        let route = AVAudioSession.sharedInstance().currentRoute
//        for desc in route.outputs {
//            if desc.portType == AVAudioSessionPortHeadphones {
//                return true
//            }
//        }
//        return false
//    }
//    func audioRouteChangeListenerCallback(noti: Notification) {
//        let interuptionDict = noti.userInfo as? [String: Any]
//        let routeChangeReason = interuptionDict?[AVAudioSessionRouteChangeReasonKey] as? Int
//        if routeChangeReason == 1 {
//            print("耳机插入")
//            //耳机插入
//            //返听开启
//            self.sesstion?.isPlayback = true
//        } else if routeChangeReason == 2 {
//            print("耳机拔出")
//            //耳机拔出
//            //返听关闭
//            self.sesstion?.isPlayback = false
//            LyAlertView.alert(atVC: self, message: "插入耳机观众听到的效果更好哦", ok: "知道了~", okBlock: {
//                
//            })
//
//        }
//        //changeRoute(state: routeChangeReason!)
//        print(routeChangeReason as Any)
//    }
//    func conferenceNotificationAction(noti: Notification) {
//        self.startConference()
//        let ext = noti.object as? [String : Any]
//        if conferenceUserInfo.allKeys().contains((ext?["userid"] as? String)!) {
//            ProgressHUD.showNoticeOnStatusBar(message: "TA已经在连麦中了！")
//            return
//        }
//        if (self.sesstion?.rtcParticipantsCount)! >= 3 {
//            ProgressHUD.showNoticeOnStatusBar(message: "连麦人数已达上限！")
//            return
//        }
//        self.sendCmdMessageToChatRoom(action: conferenceCMD, ext: ext)
//    }
//    func startConference() {
//        if self.sesstion?.isRtcRunning == false {
//            self.sesstion?.startConference(withRoomName: startLiving.qiniu_room_name!, userID: startLiving.qiniu_room_id!, roomToken: startLiving.qiniu_token!, rtcConfiguration: PLRTCConfiguration(videoSize: .preset352x640, conferenceType: .audioAndVideo))
//            
//            let interval = 640/kScreenHeight
//            let height = (640 - interval*(65+91))/3
//            let width = height/16 * 12
//            
//            var valueArr: [Any] = []
//            for i in 0...2 {
//                let value = NSValue.init(cgRect: CGRect(x: 352 - width, y: 640 - 65*interval - CGFloat(i + 1)*(height + 4), width: width, height: height))
//                valueArr.append(value)
//            }
//            self.sesstion?.rtcMixOverlayRectArray = valueArr
//        }
//    }
//    func initSesion() {
//        let videoSize = CGSize(width: kScreenWidth , height: kScreenHeight)
//        
//        let videoStreaming = PLVideoStreamingConfiguration(videoSize: videoSize, expectedSourceVideoFrameRate: UInt(24), videoMaxKeyframeInterval: UInt(72), averageVideoBitRate: UInt(768 * 1024), videoProfileLevel: AVVideoProfileLevelH264HighAutoLevel, videoEncoderType: .avFoundation)
//        
//        let videoCapture = PLVideoCaptureConfiguration.default()
//        videoCapture?.position = .front
//        
//        audioCapture = PLAudioCaptureConfiguration.default()
//        
//        let audioStreaming = PLAudioStreamingConfiguration.default()
//        
//        self.sesstion = PLMediaStreamingSession(videoCaptureConfiguration: videoCapture, audioCaptureConfiguration: audioCapture, videoStreamingConfiguration: videoStreaming, audioStreamingConfiguration: audioStreaming, stream: nil)
//        
//        self.sesstion?.delegate = self
//        self.sesstion?.setBeautifyModeOn(true)
//        self.sesstion?.isContinuousAutofocusEnable = false
//        
//        self.sesstion?.setBeautify(0.5)
//        self.sesstion?.setWhiten(0.5)
//        self.sesstion?.setRedden(0.5)
//        
//        self.sesstion?.isAutoReconnectEnable = true
//        self.accompany = self.sesstion!.inputGain
//        
//        let previewView = self.sesstion!.previewView
//        previewView?.frame = UIScreen.main.bounds
//        self.view.insertSubview(previewView!, at: 0)
//        startSession()
//        
//        enterRoomConnectHx { [unowned self] (isSuccess) in
//            if isSuccess == false {
//                ProgressHUD.showMessage(message: "直播开启失败")
//                self.prepareExit()
//                self.navigationController?.dismiss(animated: true, completion: nil)
//                NetworkingHandle.fetchNetworkData(url: "Index/end_live", at: self, params: ["live_id": self.liveId!], success: { (result) in
//                })
//            }
//        }
//    }
//    // home键
//    func intoTheBackground() {
//
//        UIApplication.shared.isIdleTimerDisabled = false
//        self.sendLivingMessage(content: "主播离开一下，精彩不中断，不要走开哦")
//    }
//    func returnApp() {
//        UIApplication.shared.isIdleTimerDisabled = true
//        self.sendLivingMessage(content: "主播回来了，视频即将恢复")
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    // 七牛代理
//    //MARK: 开始推流
//    func startSession() {
//        queue1.async { [unowned self] in
//            self.sesstion?.startStreaming(withPush: URL(string: self.startLiving.push_flow_address!), feedback: { (feedback) in
//            })
//            self.sesstion?.isMonitorNetworkStateEnable = true
//        }
//    }
//    //MARK: 停止推流
//    func stopSession() {
//        queue1.async { [unowned self] in
//            self.sesstion?.stopStreaming()
//        }
//    }
//    // 环信代理
//    //MARK: 接受透传消息
//    func cmdMessagesDidReceive(_ aCmdMessages: [Any]!) {
//        let message = aCmdMessages.last as! EMMessage
//        if message.conversationId != roomId {
//            return
//        }
//        
//        let nowTimeInterval = Date().timeIntervalSince1970
//        let interval = nowTimeInterval - TimeInterval(message.timestamp/1000)
//        print("#########", interval, "#############")
//        if interval > 10 {
//            return
//        }
//        
//        let body = message.body as! EMCmdMessageBody
//        if body.action == userApplyConferenceCMD {
//            if let count = self.sesstion?.rtcParticipantsCount, count >= 3 {
//                return
//            }
//            LyAlertView.alert(atVC: self, message: "「\(message.ext["username"]!)」申请与您连麦，是否同意申请", ok: "同意", okBlock: {
//                self.sendCmdMessageToChatRoom(action: anchorAgreeConferenceCMD, ext: message.ext as? [String : Any])
//                self.startConference()
//            })
//        }
//    }
//    
//    override func livingReconnect() {
//        if reconnectCount >= 18 {
//            timer.pause()
//            self.exit()
//        } else {
//            startSession()
//            reconnectCount += 1
//            if isShowHUD == false {
//                ProgressHUD.showLoading(toView: self.contentView)
//                isShowHUD = true
//            }
//        }
//    }
//    func mediaStreamingSession(_ session: PLMediaStreamingSession!, didDisconnectWithError error: Error!) {
//        print("***推流重连错误信息: ", error)
//        if reconnectCount < 18 {
//            timer.resume()
//        }
//    }
//    func mediaStreamingSession(_ session: PLMediaStreamingSession!, streamStateDidChange state: PLStreamState) {
//        switch state {
//        case .unknow:
//            print("***推流状态: 未知状态")
//        case .autoReconnecting:
//            print("***推流状态: 正在等待自动重连状态")
//        case .connected:
//            print("***推流状态: 已连接状态")
//            if reconnectCount > 0 {
//                timer.pause()
//                reconnectCount = 0
//            }
//            if isShowHUD {
//                ProgressHUD.hideLoading(toView: self.contentView)
//                isShowHUD = false
//            }
//        case .connecting:
//            print("***推流状态: 连接中状态")
//        case .disconnected:
//            print("***推流状态: 已断开连接状态")
//            if reconnectCount < 18 {
//                timer.resume()
//            }
//        case .disconnecting:
//            print("***推流状态: 断开连接中状态")
//        case .error:
//            print("***推流状态: 错误状态")
//        }
//    }
//    // 退出
//    override func quitLiveRoom() {
//        let alert = UIAlertController(title: "提示", message: "当前有\((topView?.watchNumber.text)!)在观看你的直播，是否退出当前直播？", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "退出", style: .default, handler: { [unowned self] alert in
//            self.exit()
//        })
//        let cancel = UIAlertAction(title: "继续直播", style: .destructive, handler: nil)
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        self.present(alert, animated: true, completion: nil)
//    }
//    func exit() {
//        prepareExit()
//    
//        let end = LivingEndViewController()
//        end.liveId = liveId
//        self.navigationController?.pushViewController(end, animated: true)
//    }
//    // 退出准备
//    override func prepareExit() {
//        UIApplication.shared.isIdleTimerDisabled = false
//        NotificationCenter.default.removeObserver(self)
//
//        timer.invalidate()
//        
//        queue1.async { [unowned self] in
//            self.sesstion?.stopStreaming()
//        }
//        
//        self.stopPlayAudio()
//        
//        self.sesstion?.stopConference()
//        self.sesstion?.stopStreaming()
//        self.sesstion?.destroy()
//        self.sesstion?.delegate = nil
//        self.sesstion = nil
//        
//        self.audioCapture = nil
//        
//        sendCmdMessageToChatRoom(action: anchorStopLiveCMD)
//    }
//    override func toggleCamera() {
//        self.sesstion?.toggleCamera()
//    }
//    override func beautify() {
//        _ = LivingMoreItemView.show(atView: self.view, isAuthLM: isAuthConference, isOpenJX: isOpenMirror, selectedItem: { [unowned self] index in
//            if index == 3 {
//                // 美颜
//                let beautify = AnchorBeautifyView.show(atView: self.view, beautifyValue: self.beutyValue, volume: self.volume, accompany: self.accompany)
//                beautify.delegate = self                
//            } else if index == 2 {
//                self.isOpenMirror = !self.isOpenMirror
//                self.sesstion?.streamMirrorRearFacing = self.isOpenMirror
//                self.sesstion?.streamMirrorFrontFacing = self.isOpenMirror
//            } else if index == 1 {
//                NetworkingHandle.fetchNetworkData(url: "Index/save_wheat", at: self, params: ["type": self.isAuthConference ? "2" : "1"], success: { (result) in
//                    self.isAuthConference = !self.isAuthConference
//                })
//            } else if index == 4 {
//                // 美颜
//                let beautify = AnchorBeautifyView.show(atView: self.view, beautifyValue: self.beutyValue, volume: self.volume, accompany: self.accompany, isMusic: true)
//                beautify.delegate = self
//            }
//        })
//    }
//    // anchor Beautify 代理
//    func anchorBeautifyView(_ view: AnchorBeautifyView, changeValue value: Float, index: Int) {
//        if index == 0 {
//            // 美颜
//            if !view.isMusic {
//                self.beutyValue = value
//                self.sesstion?.setBeautify(CGFloat(value))
//                self.sesstion?.setWhiten(CGFloat(value))
//            } else {
//                self.volume = value
//                self.plAudioPlay?.volume = value
//            }
//        } else if index == 1 {
//            self.accompany = value
//            self.sesstion?.inputGain = value
//        }
//    }
//    // bgm vc 代理
//    func livingBGMViewController(_ vc: LivingBGMViewController, model: LivingBGMModel) {
//        if self.sesstion?.isRtcRunning == true {
//            ProgressHUD.showNoticeOnStatusBar(message: "连麦时，不能播放音乐")
//            return
//        }
//        if let path = plAudioPlay?.url, path.path.hasSuffix(model.pathPostfix!) {
//            return
//        }
//        if plAudioPlay?.isPlaying == nil || plAudioPlay?.isPlaying == false {
//            startPlayAudio()
//        }
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let fileURL = documentsURL?.appendingPathComponent(model.pathPostfix!)
//        try? plAudioPlay = AVAudioPlayer(contentsOf: fileURL!)
//        plAudioPlay?.prepareToPlay()
//        plAudioPlay?.play()
//        plAudioPlay?.numberOfLoops = -1
//        plAudioPlay?.volume = self.volume
//    }
//    override func startPlayAudio() {
//        bgmPlayControlView = BGMPlayControlView.show(atView: view)
//        bgmPlayControlView?.selectedButton = { [unowned self] (btn, type) in
//            if type == 1 {
//                btn.isSelected = !btn.isSelected
//                if btn.isSelected {
//                    self.plAudioPlay?.pause()
//                } else {
//                    self.plAudioPlay?.play()
//                }
//            } else {
//                self.stopPlayAudio()
//            }
//        }
//    }
//    func stopPlayAudio() {
//        self.plAudioPlay?.stop()
//        self.plAudioPlay?.delegate = nil
//        self.plAudioPlay = nil
//    }
//    // PLAudioPlayer 代理
//    func audioPlayer(_ audioPlayer: PLAudioPlayer!, find fileError: PLAudioPlayerFileError) {
//        switch fileError {
//        case PLAudioPlayerFileError_FileNotExist:
//            print("文件不存在")
//        case PLAudioPlayerFileError_FileOpenFail:
//            print("文件打开失败")
//        case PLAudioPlayerFileError_FileReadingFail:
//            print("文件读取失败")
//        default: break
//        }
//        bgmPlayControlView?.removeFromSuperview()
//    }
//}
////MARK: -- model
//class AnchorLiveEndModel: KeyValueModel {
//    var live_id: String?
//    var user_id: String?
//    var play_img: String?
//    var title: String?
//    var start_time: String?
//    var end_time: String?
//    var watch_nums: String?
//    var share: String?
//    var img: String?
//    var username: String?
//    var company: String?
//    var duty: String?
//    var autograph: String?
//    var id: String?
//    var beat: String?
//    var time: String?
//    var get_fire: String?
//    var url: String?
//}
