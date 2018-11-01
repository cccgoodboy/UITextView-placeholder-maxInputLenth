//
//  ClickWebViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/21.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ClickWebViewController: CEWebViewController {

    @IBOutlet weak var webview: UIWebView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest.init(url:URL.init(string: self.url)!)
        self.webview.loadRequest(request)

        webview.delegate = self as? UIWebViewDelegate
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refershData()
    }
    
    override func clickDiscountCoupon(_ loginState: String!, andDiscountCouponId CouponId: String!) {
        if loginState == "0"{
            let login = LoginViewController()
            login.loginType = LoginType.login_normal
            
            self.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
        }else{//用户领取优惠券
            
            NetworkingHandle.fetchNetworkData(url: "/api/User/draw_coupon", at: self, params: ["coupon_id":CouponId], success: { (response) in
                self.refershData()

            }, failure: {
                
            })
            
        }
    }
    func refershData(){
        if (CSUserInfoHandler.getIdAndToken()?.token ?? "") != ""{
            let arr = url.components(separatedBy: "?")
            var secondStr = ""
            if (arr.last?.contains("uid="))!{
                secondStr = "uid=\((CSUserInfoHandler.getIdAndToken()?.uid)!)&token=\((CSUserInfoHandler.getIdAndToken()?.token)!)"
            }
            let str = "\(arr.first!)?\(secondStr)"
            let request = URLRequest.init(url:URL.init(string: str)!)
            self.webview.loadRequest(request)
            
        }
    }
}

