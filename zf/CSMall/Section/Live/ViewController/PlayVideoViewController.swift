
//
//  PlayVideoViewController.swift
//  CrazyEstate
//
//  Created by 梁毅 on 2017/1/12.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class PlayVideoViewController: UIViewController,PLPlayerDelegate {
    var player: PLPlayer? = nil
    var playTimer: Timer?
    var reconnectCount = Int()
    var playerSlider = UISlider()
    var quitButton = UIButton()
    var url : String?
    var play_img: String?
    var stopBtn = UIButton()
    var live_store_id: String?
    var isCollection: String?
    var username: String?
    var type = 2
    
    var previewImg: UIImage?
    
    var countdown = UILabel()
    
    var isDismiss = false
    var moreButton = UIButton()
    var hisInfo = HisInfo()
    func countdownComputer() -> String {
        let time = (player?.totalDuration.seconds)! - (player?.currentTime.seconds)!
        if time <= 0 || time.isNaN {
            return "00:00:00"
        }
        let interval = Int(time)
        let hour = interval / (60 * 60)
        let min = interval % (60 * 60) / 60
        let seconds = interval % (60 * 60) % 60
        
        return "-" + String(format: "%02d", hour) + ":" + String(format: "%02d", min) + ":" + String(format: "%02d", seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        do { try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) } catch {}
        
        
        let option = PLPlayerOption.default()
        option.setOptionValue(10, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        option.setOptionValue(true, forKey: PLPlayerOptionKeyVODFFmpegEnable)
        player = PLPlayer(url: NSURL(string: url!) as URL?, option: option)
        player?.delegate = self
        player?.delegateQueue = DispatchQueue.main
        if type == 2 {
            player?.playerView?.contentMode = .scaleToFill
        } else {
            player?.playerView?.contentMode = .scaleAspectFit
            (UIApplication.shared.delegate as! AppDelegate).isRotation = true
        }
        player?.isBackgroundPlayEnable = true
        if previewImg == nil {
            player?.launchView?.kf.setImage(with: URL(string: play_img!))
        } else {
            player?.launchView?.image = previewImg
        }
        player?.playerView?.backgroundColor = UIColor(hexString: "#f1f3f5")
        player?.launchView?.clipsToBounds = true
        player?.launchView?.contentMode = .scaleAspectFill
        let playerView = player!.playerView
        self.view.addSubview(playerView!)
        playerView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        playerView?.isUserInteractionEnabled = true
        
        startPlayer()
        
        self.view.addSubview(quitButton)
        quitButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-20)
            make.height.width.equalTo(40)
        }
        quitButton.setImage(UIImage(named: "guanbi"), for: .normal)
        quitButton.addTarget(self, action: #selector(quitButtonClicked), for: .touchUpInside)
        
        
        let collectionButton = UIButton()
        self.view.addSubview(collectionButton)
        collectionButton.snp.makeConstraints { (make) in
            make.right.equalTo(quitButton.snp.left).inset(-10)
            make.centerY.equalTo(quitButton.snp.centerY)
            make.height.width.equalTo(40)
        }
        collectionButton.setImage(UIImage(named: "fenxiang"), for: .normal)
        
        collectionButton.addTarget(self, action: #selector(collectionButtonAction), for: .touchUpInside)
        
     
        
        self.view.addSubview(stopBtn)
        stopBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-20)
            make.height.width.equalTo(40)
        }
        stopBtn.setImage(UIImage(named: "stop"), for: .normal)
        stopBtn.setImage(UIImage(named: "paly"), for: .selected)
        
        stopBtn.addTarget(self, action: #selector(stopBtnClicked(btn:)), for: .touchUpInside)
        stopBtn.isSelected = false
        
        
        playerSlider.minimumValue=0  //最小值
        playerSlider.maximumValue=1  //最大值
        self.view.addSubview(playerSlider)
        playerSlider.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-70)
            make.height.equalTo(30)
        }
        
        countdown.font = UIFont.systemFont(ofSize: 12)
        countdown.textColor = UIColor.gray
        self.view.addSubview(countdown)
        countdown.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(playerSlider.snp.centerY)
            make.left.equalTo(playerSlider.snp.right).inset(-6)
        }
        countdown.text = countdownComputer()
        
        playerSlider.setThumbImage(UIImage(named: "播放按钮"), for: .normal)
        
        playerSlider.isContinuous = true  //滑块滑动停止后才触发ValueChanged事件
        playerSlider.addTarget(self, action: #selector(playerSliderChanger(slider:)), for: .valueChanged)
        playerSlider.minimumTrackTintColor = UIColor(red:0.24, green:0.69, blue:0.94, alpha:1.00)  //左边槽的颜色
        playerSlider.maximumTrackTintColor = UIColor.gray //右边槽的颜色
        
        moreButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        moreButton.addTarget(self, action: #selector(reportVedio), for: .touchUpInside)
        moreButton.backgroundColor = UIColor(hexString:"#333333").withAlphaComponent(0.5)
        moreButton.layer.cornerRadius = 20
        moreButton.layer.masksToBounds = true
        self.view.addSubview(moreButton)
        
        moreButton.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.right.equalTo(-15)
            make.width.height.equalTo(40)
            
        }
        

        // 播放记录
//        NetworkingHandle.fetchNetworkData(url: "/User/play_store",at: self, params: ["live_store_id": live_store_id ?? ""], isShowHUD: false, success: { result in
//        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    func reportVedio(){
        print("举报视频")
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let Report = UIAlertAction(title: "举报", style: .default) { (alert) in

            NetworkingHandle.fetchNetworkData(url: "/api/live/report", at: self,  success: { (response) in
                ProgressHUD.showSuccess(message: "举报成功")
            })
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        action.addAction(Report)

        action.addAction(cancel)
        self.present(action, animated: true, completion: {
            
        })

    }

    func stopBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if  btn.isSelected {
            self.player?.pause()
            self.playTimer?.fireDate = Date.distantFuture
        } else {
            self.player?.resume()
            self.playTimer?.fireDate = Date()
        }
    }
    func quitButtonClicked() {
         (UIApplication.shared.delegate as! AppDelegate).isRotation = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIApplication.shared.isIdleTimerDisabled = false

        player?.stop()
        isDismiss = true
        playTimer?.invalidate()
        self.navigationController?.navigationBar.isHidden = false
        _ = self.navigationController?.popViewController(animated: true)
    }
    func playTimerFunc() {
        countdown.text = countdownComputer()
        playerSlider.value = Float(CMTimeGetSeconds((player?.currentTime)!) / CMTimeGetSeconds((player?.totalDuration)!))
    }
    func playerSliderChanger(slider: UISlider) {
        let seconds = Float64(slider.value) * CMTimeGetSeconds((player?.totalDuration)!)
        player?.seek(to: CMTimeMakeWithSeconds(seconds, 1))
    }
    func startPlayer() {
        UIApplication.shared.isIdleTimerDisabled = true
        self.player?.play()
        playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(playTimerFunc), userInfo: nil, repeats: true)
        playTimer?.fire()
    }
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        
        if .statusStopped == state && !isDismiss {
            (UIApplication.shared.delegate as! AppDelegate).isRotation = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            UIApplication.shared.isIdleTimerDisabled = false

            self.navigationController?.navigationBar.isHidden = false
            _ = self.navigationController?.popViewController(animated: true)
            self.player?.stop()
            playTimer?.invalidate()
        } else if state == .statusPlaying {
            ProgressHUD.hideLoading(toView: self.view)
        } else if state == .statusPreparing {
            ProgressHUD.showLoading(toView: self.view)
        }
    }
    
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        self.tryReconnect()
    }
    func tryReconnect() {
        if  self.reconnectCount < 1 {
            reconnectCount += 1
            self.player?.play()
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionButtonAction() {
        _ = ShareView.show(atView: self.view, url: self.url!, avatar: self.play_img!, username: username!,type: "0")
        
    }
    
    deinit {
        print("fdfsdfsdfSD")
    }
    
}
