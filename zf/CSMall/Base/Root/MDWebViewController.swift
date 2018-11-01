
//
//  MDWebViewController.swift
//  Duluo
//
//  Created by 梁毅 on 2017/3/22.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import WebKit

class MDWebViewController: BaseViewController, UIWebViewDelegate {
    
    var webView:WKWebView!

    var webType = 1
    var url: String!
    var isShare = ""
//    var shareView = ShareView()
    var isSelected = false
//    var law:LawDescModel?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
//        if isShare != ""{
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "btn_fenxiang2"), style: .plain, target: self, action: #selector(MDWebViewController.share))
//            
//            NetworkingHandle.fetchNetworkData(url: "Home/law_xq", at: self, params: ["law_id":isShare],  success: { (response) in
//                self.law = LawDescModel.modelWithDictionary(diction: response[
//                    "data"] as! [String : AnyObject])
//            }, failure: { 
//                
//            })
//        }

        webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kContentHeight))
        webView.backgroundColor = UIColor.clear
//
        ProgressHUD.showLoading(toView: self.view)
        if url != ""{
            webView.load(URLRequest(url: URL(string: url!)!))

        }
    }
//    func share() {
//        isSelected = !isSelected
//        
//        if isSelected{
//            
//            shareView = ShareView.show(atView: self.view, url:url, avatar: law?.law_img ?? "", username: law?.law_title ?? "", describe: "高端大气上档次，精美绝伦世无双")
//            shareView.dismissFinish = { [unowned self] in
//                self.isSelected = !self.isSelected
//            }
//        } else{
//            shareView.dismiss()
//        }
//        
//    }

  
    // web delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ProgressHUD.hideLoading(toView: self.view)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ProgressHUD.hideLoading(toView: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
//    override func appJumpFawuRush(_ zId: String) {
//        print(zId)
////        ProgressHUD.showMessage(message: zId)
//        if zId == "undefined" || zId.isEmpty {
//            //            ProgressHUDManager.showWithInfoStatus(status: "原文地址失效")
//            return
//        }
//        if zId.contains("http") {
//            UIApplication.shared.openURL(URL(string: zId)!)
//            return
//        }
//        DispatchQueue.main.async {
//            let vc = UIStoryboard.init(name: "AncestrallnstruumentStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AncestrallnstrumentsDetailVC") as!AncestrallnstrumentsDetailVC
//            vc.goodId = zId
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//    }

}
