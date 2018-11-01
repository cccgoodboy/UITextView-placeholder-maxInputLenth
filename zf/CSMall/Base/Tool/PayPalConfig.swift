//
//  PayPalConfig.swift
//  CSMall
//
//  Created by 初程程 on 2018/9/16.
//  Copyright © 2018年 taoh. All rights reserved.
//

import UIKit

class PayPalConfig: NSObject,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
    }
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]) {
        
    }
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable : Any]) {
        
    }
    
    override init() {
        config = PayPalConfiguration()
        super.init()
    }
    static var payPal = PayPalConfig()
    var config:PayPalConfiguration
    func showPay(vc:UIViewController,amount:String,code:String,des:String) -> Void {
        let payMent = PayPalPayment()
        let amountNum = NSDecimalNumber(string: amount)
        payMent.amount = amountNum
        payMent.currencyCode = code
        payMent.shortDescription = des
        let paymentViewController = PayPalPaymentViewController(payment: payMent, configuration: config, delegate: self)
        vc.present(paymentViewController!, animated: true, completion: nil)
    }
}
