
//
//  MDWebViewController.swift
//  Duluo
//
//  Created by 梁毅 on 2017/3/22.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class MDWebViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var bottomBtnheight: NSLayoutConstraint!
    
 
    var type = 0 // 1商家认证， 0正常
    @IBOutlet weak var webView: UIWebView!

    var url: String!
    var isShare = ""

    var isSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.backgroundColor = UIColor.clear
        ProgressHUD.showLoading(toView: self.view)
        if url != ""{
            webView.loadRequest(URLRequest(url: URL(string: url!)!))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomBtn.backgroundColor = themeColor
        if type == 1{
            bottomBtn.isHidden = false
            bottomBtnheight.constant = 45
        }else{
            bottomBtn.isHidden = true
            bottomBtnheight.constant = 0
        }
    }
    @IBAction func bottomBtnClick(_ sender: UIButton) {
        
     let  userInfo = CSUserInfoHandler.getUserInfo()
        if (userInfo?.pay_state ?? "") == "1"{//已认证（审核通过并且付了费）
            self.navigationController?.pushViewController(ToApplyDetailViewController(), animated: false)
        }else{
            if (userInfo?.apply_state ?? "") == "0"{//未认证
                let apply = ToApplyViewController()
                apply.info = userInfo
                self.navigationController?.pushViewController(apply, animated: false)
            }else{
                self.navigationController?.pushViewController(ToApplyDetailViewController(), animated: false)
            }
        }
    
    }
    // web delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ProgressHUD.hideLoading(toView: self.view)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ProgressHUD.hideLoading(toView: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
 

}
