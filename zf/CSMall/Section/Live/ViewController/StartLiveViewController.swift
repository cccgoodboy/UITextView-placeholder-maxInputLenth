////
////  StartLiveViewController.swift
////  Duluo
////
////  Created by sh-lx on 2017/3/22.
////  Copyright © 2017年 tts. All rights reserved.
////

//FIXME:TH等待数据

//
//import UIKit
//import AVFoundation
//import IQKeyboardManagerSwift
//
//class StartLiveViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    @IBOutlet weak var address: UIButton!
//    @IBOutlet weak var liveTitle: UITextField!
//    @IBOutlet weak var labelBtn: UIButton!
//    @IBOutlet weak var startButton: UIButton!
//    
//    var labelArr: [String] = []
//    var img: UIImage?
//    var selectedBtn: UIButton?
//    
//    var model: StartLiving?
//    
//    var isGotoAuth = false
//
//    private lazy var session = AVCaptureSession()
//    private lazy var deviceInput: AVCaptureDeviceInput? = {
//        guard let device = AVCaptureDevice.devices().filter({ ($0 as AnyObject).position == .front })
//            .first as? AVCaptureDevice else {
//                return nil
//        }
//        do {
//            let input = try AVCaptureDeviceInput(device: device)
//            return input
//        } catch {
//            print("设备输入获取错误##### ", error)
//            return nil
//        }
//    }()
//    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        let layer = AVCaptureVideoPreviewLayer(session: self.session)
//        layer?.frame = UIScreen.main.bounds
//        return layer!
//    }()
//    
//    
//    func openSettings() {
//        let settingsURL: URL = URL(string: UIApplicationOpenSettingsURLString)!
//        UIApplication.shared.openURL(settingsURL)
//    }
//    /**
//     Check video authorization status
//     */
//    func checkVideoAuth() {
//        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
//        case .authorized://已经授权
//            self.start()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
//                self.checkVideoAuth()
//            })
//        case .denied:
//            deviceDisable(dis: "相机")
//        default:
//            break
//        }
//    }
//    func start() {
//        if !self.session.canAddInput(self.deviceInput) {
//            ProgressHUD.showNoticeOnStatusBar(message: "设备开启失败！")
//            return
//        }
//        self.session.addInput(self.deviceInput)
//        self.view.layer.insertSublayer(self.previewLayer, at: 0)
//        self.session.startRunning()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.checkVideoAuth()
//        
//        NetworkingHandle.fetchNetworkData(url: "User/is_this", at: self, params: ["version": currentVersion],  success: { (response) in
//            let data = response["data"] as! String
//            if data == "2" {
//                self.labelBtn.isHidden = false
//            } else {
//                self.labelBtn.isHidden = true
//            }
//        })
//        //FIXME:身份验证可以去掉，到时需要检查代码逻辑
//        //        NetworkingHandle.fetchNetworkData(url: "Index/is_user", at: self, success: { (result) in
////            let data = result["data"] as? String
////            if data != "2" {
////                LyAlertView.alert(atVC: self, message: "根据国家的相关法律法规，开启直播必须要进行实名认证审核，是否去认证？", ok: "现在去", okBlock: { 
////                    let vc = RealNameViewController()
////                    let model = PersonInfoModel()
////                    model.is_authen = data
////                    vc.model = model
////                    self.isGotoAuth = true
////                    vc.title = "认证"
////                    self.navigationController?.pushViewController(vc, animated: true)
////                }, cancelBlock: { 
////                    self.dismiss(animated: true, completion: nil)
////                })
////            } else {
////                self.startButton.isHidden = false
////            }
////        })
//        
//        LocationManager.shared.updateLocation()
//        
//        address.setTitle(LocationManager.shared.city, for: .normal)
//        
//        IQKeyboardManager.sharedManager().enable = true
//        IQKeyboardManager.sharedManager().enableAutoToolbar = true
//        
//        liveTitle.attributedPlaceholder = NSAttributedString(string: "请输入标题", attributes: [NSForegroundColorAttributeName: UIColor.white])
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        
//        if isGotoAuth {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func backAtion(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    @IBAction func uploadCoverButtonAction(_ sender: Any) {
//        avatarEditAction()
//    }
//    @IBAction func startLiveButtonAction(_ sender: Any) {
//        cameraAndMicrophoneAuth()
//    }
//    
//    @IBAction func shareButonAction(_ sender: UIButton) {
//        if selectedBtn == sender {
//            sender.isSelected = !sender.isSelected
//            return
//        }
//        selectedBtn?.isSelected = false
//        sender.isSelected = true
//        selectedBtn = sender
//    }
//    @IBAction func labelChoiceButtonAction(_ sender: UIButton) {
//        let labelVC = LabelChoiceViewController()
//        labelVC.labelChoiceSuccess = { [unowned self] labels in
//            self.labelArr = labels
//            self.labelBtn.setTitle(labels.joined(separator: ","), for: .normal)
//        }
//        self.navigationController?.pushViewController(labelVC, animated: true)
//    }
//    
//    func deviceDisable(dis: String) {
//        let alertVC = UIAlertController(title: nil, message: "请在iPhone的\"设置-隐私-\(dis)\"选项中，允许龙脉直播访问您的\(dis)。", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "去设置", style: .default, handler: { [unowned self] (alertAction) in
//            self.openSettings()
//        })
//        let cancel = UIAlertAction(title: "取消", style: .default, handler: { [unowned self] (alertAction) in
//            self.dismiss(animated: true, completion: nil)
//        })
//        alertVC.addAction(cancel)
//        alertVC.addAction(ok)
//        self.present(alertVC, animated: true, completion: nil)
//    }
//
//    
//    func cameraAndMicrophoneAuth() {
//        func microphoneAuthorization() {
//            switch PLMediaStreamingSession.microphoneAuthorizationStatus() {
//            case .authorized:
//                self.loadData()
//            case .notDetermined:
//                PLMediaStreamingSession.requestMicrophoneAccess(completionHandler: { (granted) in
//                    microphoneAuthorization()
//                })
//            default:
//                deviceDisable(dis: "麦克风")
//            }
//        }
//        switch PLMediaStreamingSession.cameraAuthorizationStatus() {
//        case .authorized:
//            microphoneAuthorization()
//        case .notDetermined:
//            PLMediaStreamingSession.requestCameraAccess(completionHandler: { (granted) in
//                self.cameraAndMicrophoneAuth()
//            })
//        default:
//            deviceDisable(dis: "相机")
//        }
//    }
//    func loadData() {
//
//        func intoRoom(_ result: Dictionary<String, Any>) {
//            let dic = result["data"] as! [String: AnyObject]
//            self.model = StartLiving.modelWithDictionary(diction: dic)
//            
//            self.previewLayer.removeFromSuperlayer()
//            self.session.removeInput(self.deviceInput)
//            self.deviceInput = nil
//            
//            self.shareButton()
//        }
//        
//        let log = LocationManager.shared.log
//        let lag = LocationManager.shared.lag
//        
//        var params = ["log": log, "lag": lag, "title": liveTitle.text!, "livewindow_type": "1"]
//        let label = labelArr.joined(separator: ",")
//        if label.isEmpty == false {
//            params["lebel"] = label
//        }
//        guard let image = img else {
//            NetworkingHandle.fetchNetworkData(url: "Index/start_live", at: self, params: params, success: { (result) in
//                intoRoom(result)
//            })
//            return
//        }
////        NetworkingHandle.uploadPicture(url: "Index/start_live", atVC: self, image: image, params: params, uploadSuccess: { (result) in
////            intoRoom(result)
////        })
//    }
//    func returnApp() {
//        if model != nil {
//            let vc = LivingViewController()
//            vc.startLiving = model
//            vc.dismissLive = { [unowned self] in
//                self.backAtion(UIButton())
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        NotificationCenter.default.removeObserver(self)
//    }
//    func shareButton() {
//        guard let sender = selectedBtn, sender.isSelected else {
//            let vc = LivingViewController()
//            vc.startLiving = model
//            vc.dismissLive = { [unowned self] in
//                self.backAtion(UIButton())
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//            return
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(returnApp), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
//        if sender.tag == 100 {
//            shareAction(type: .wechatTimeLine)
//        }else if sender.tag == 102 {
//            shareAction(type: .wechatSession)
//        }else if sender.tag == 103 {
//            shareAction(type: .sina)
//        }else if sender.tag == 101 {
//            shareAction(type: .QQ)
//        }else if sender.tag == 104 {
//            shareAction(type: .qzone)
//        }
//    }
//    func shareAction(type: UMSocialPlatformType) {
//        //FIXME:TH等待数据
////        let object = UMShareWebpageObject()
//////        let userInfo = DLUserInfoHandler.getUserBaseInfo()
////        object.webpageUrl = model?.url
////        object.title = "嘿！你的好友「" + userInfo.name + "」正在直播"
////        object.descr = "这么多人在强势围观" + userInfo.name + "难道想在直播间里搞事情？"
////        let data: Data = try! Data.init(contentsOf: URL(string: userInfo.img)!)
////        let image = UIImage(data:data, scale: 1.0)
////        object.thumbImage = image
////        
////        let messageObject = UMSocialMessageObject(mediaObject: object)
////        
////        UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: self) { (data, error) in
////        }
//    }
//
//    // 修改头像
//    func avatarEditAction() {
//        self.imageChoiseType(type: 1)
//    }
//    func imageChoiseType(type: Int)  {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        if type == 0 {
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePicker.sourceType = .camera
//            }
//        } else {
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                imagePicker.sourceType = .photoLibrary
//            } else {
//                ProgressHUD.showNoticeOnStatusBar(message: "相册不能用")
//            }
//        }
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//    // MARK: - UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        img = info[UIImagePickerControllerOriginalImage] as? UIImage
//    }
//    // 设置 imagePicker 导航栏
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        navigationController.navigationBar.tintColor = UIColor.white
//        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:defaultFont(size: 16)]
//        navigationController.navigationBar.barTintColor = themeColor
//    }
//}
//class StartLiving: KeyValueModel {
//    var nums: String?
//    var push_flow_address: String?
//    var play_address: String?
//    var room_id: String?
//    var ID: String?
//    var money: String?
//    var url: String?
//    var live_id: String?
//    var time: String?
//    var qrcode_path: String?
//    var start_time: String?
//    
//    var qiniu_room_id: String?
//    var qiniu_room_name: String?
//    var qiniu_token: String?
//    var is_wheat: String?
//}
