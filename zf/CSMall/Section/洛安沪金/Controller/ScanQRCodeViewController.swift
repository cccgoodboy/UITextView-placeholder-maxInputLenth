//
//  ScanQRCodeViewController.swift
//  FYH
//
//  Created by sh-lx on 2017/7/7.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class ScanQRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,WKUIDelegate{
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var url = ""
    //    var web: WKWebView!
    //    var templeModel: temple_detailsModel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraPermissions()
    }
    // 相机权限
    func cameraPermissions(){
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            DispatchQueue.main.async(execute: { () -> Void in
                let alertController = UIAlertController(title: "相机访问受限",
                                                        message: "点击“设置”，允许访问您的相机",
                                                        preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                    (action) -> Void in
                    let url = URL(string: UIApplicationOpenSettingsURLString)
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:],
                                                      completionHandler: {
                                                        (success) in
                            })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
            
            
            //            return false
            
        }else {
            //            return true
        }
    }
    //    func authorize()->Bool{
    //        let status = PHPhotoLibrary.authorizationStatus()
    //
    //        switch status {
    //        case .authorized:
    //            return true
    //        case .notDetermined:
    //            // 请求授权
    //            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
    //                DispatchQueue.main.async(execute: { () -> Void in
    //                    _ = self.authorize()
    //                })
    //            })
    //        default: ()
    //        DispatchQueue.main.async(execute: { () -> Void in
    //            let alertController = UIAlertController(title: "照片访问受限",
    //                                                    message: "点击“设置”，允许访问您的照片",
    //                                                    preferredStyle: .alert)
    //            let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
    //            let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
    //                (action) -> Void in
    //                let url = URL(string: UIApplicationOpenSettingsURLString)
    //                if let url = url, UIApplication.shared.canOpenURL(url) {
    //                    if #available(iOS 10, *) {
    //                        UIApplication.shared.open(url, options: [:],
    //                                                  completionHandler: {
    //                                                    (success) in
    //                        })
    //                    } else {
    //                        UIApplication.shared.openURL(url)
    //                    }
    //                }
    //            })
    //            alertController.addAction(cancelAction)
    //            alertController.addAction(settingsAction)
    //
    //            self.present(alertController, animated: true, completion: nil)
    //        })
    //        }
    //        return false
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "扫一扫"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.clear
        //        self.web = WKWebView.init(frame: self.view.frame)
        //        self.view.addSubview(self.web)
        //        self.web.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            //1、设备输入流
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            
            //2、展示视图
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
            
            //3、边框
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor(hexString:"#DACAA5").cgColor
                qrCodeFrameView.layer.borderWidth = 2
                qrCodeFrameView.frame = CGRect(x: self.view.frame.width/2 - 150, y: self.view.frame.size.height/2 - 150, width: 300, height: 300)
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                url = metadataObj.stringValue
                captureSession?.stopRunning()
                captureSession = nil
                videoPreviewLayer?.removeFromSuperlayer()
                qrCodeFrameView?.removeFromSuperview()
                //                self.web.isHidden = false
                print("++++++++++++\(url)")
                //商品 http://dspx.tstmobile.com/mall_live/#/goodsDetails?goods_id=154
                if url.contains("http://dspx.tstmobile.com/mall_live/#/goodsDetails?goods_id"){
                    let sub = url.components(separatedBy: "=")
                    let vc = GoodsDetailVC()
                    vc.goods_id = sub.last ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
//
                
                
                //                let vc = LightOfferingsDetailVC()
                //                let model = LightOff()
                //                model.temple_id = sub.last?.components(separatedBy: "&").first?.components(separatedBy: "=").last
                //                vc.model = model
                //                vc.temple_runner_id = sub.last?.components(separatedBy: "&").last?.components(separatedBy: "=").last
                //                self.navigationController?.pushViewController(vc, animated: true)
                
                
                //                NetworkingHandle.fetchNetworkData(url: "Supply/temple_details2", at: self, params: ["temple_id":Int((sub.last?.components(separatedBy: "&").first?.components(separatedBy: "=").last)!)!], isAuthHide: true, isShowHUD: true, isShowError: true, hasHeaderRefresh: nil, success: { (response) in
                //                    let data = response["data"] as! [String:AnyObject]
                //                    self.templeModel = temple_detailsModel.modelWithDictionary(diction: data)
                //                    //            self.abbotBean = self.templeModel.abbotBean
                //
                //                    let vc = UIStoryboard.init(name: "LightStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ForlightSureTabVC") as! ForlightSureTabVC
                //                    vc.model = self.templeModel
                //                    vc.temple_runner_id = sub.last?.components(separatedBy: "&").last?.components(separatedBy: "=").last
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //
                //                }) {
                
                //                }
                //                //                self.web.load(URLRequest.init(url: URL(string:"https://www.baidu.com")!))
                //                return
            }
        }
    }
    deinit {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer?.removeFromSuperlayer()
        qrCodeFrameView?.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

