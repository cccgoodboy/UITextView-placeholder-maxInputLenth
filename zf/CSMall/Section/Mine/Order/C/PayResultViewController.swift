//
//  PayResultViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/7.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit


class PayResultViewController: UIViewController {
    var result = 0 //0 成功  1失败
    @IBOutlet weak var showText2: UILabel!
    
    @IBOutlet weak var showText1: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    
    var payWay = ""
    var payStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "fanhui_bai"), style: .done, target: self, action: #selector(back))
    }
    func updateUI(){
        if result == 0{
            showText1.isHidden = true
            showText2.text = NSLocalizedString("Hint_65", comment: "恭喜您！支付成功了哟~")
            showText2.textColor =  themeColor
            payBtn.setTitle(NSLocalizedString("Hint_66", comment: "查看订单"), for: .normal)
            payBtn.backgroundColor = themeColor
        }else{
            showText1.isHidden = false
            showText1.text = NSLocalizedString("Hint_67", comment: "对不起！支付失败了！")
            showText2.text = NSLocalizedString("Hint_68", comment: "请检查您的网络或稍后再尝试")
            showText2.textColor =  themeColor
            showText1.textColor =  themeColor
            payBtn.setTitle(NSLocalizedString("Hint_69", comment: "继续付款"), for: .normal)
            payBtn.backgroundColor = UIColor.red
        }

    }
    func back(){

        navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func itemClick(_ sender: UIButton) {
        
        if result == 0{
            let tabBarController = navigationController?.tabBarController
//            if tabBarController?.selectedIndex == 4 {
//                if let controller = navigationController?.viewControllers[1] {
//                    navigationController?.popToViewController(controller, animated: true)
//                    tabBarController?.selectedIndex = 3
//                    let
//
//                }
//            }
//            else {
                navigationController?.popToRootViewController(animated: false)
                tabBarController?.selectedIndex = 3
                
                if let navController = tabBarController?.viewControllers?[3] as? UINavigationController {
//                    let controller = OrderViewController()
//                    controller.type = 0
//                    controller.hidesBottomBarWhenPushed = true
//                    navController.pushViewController(controller, animated: false)
                    let vc = OrderViewController()
                    vc.type = 2
                    navController.pushViewController(vc, animated: true)

//                }
                
            }
        }else{
            
            if payWay == "alipay"{
                NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping1", at: self, params: ["order_no": payStr,"type": "ali_app"], isShowHUD: true, success: { (response) in
                    if let data = response["data"] as? String{
                        AlipaySDK.defaultService().payOrder(data, fromScheme: "com.zhengan.zhongfeigou", callback: { (reult) in
                            
                            
                        })
                    }
                    //TODO:添加支付

                    //                    Pingpp.createPayment(data as NSObject, viewController: self, appURLScheme: urlSchemes, withCompletion: { (str, error) in
//                        self.updateUI()
//                    })
                }, failure: {
                          self.updateUI()
                })
            }else{
                NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping1", at: self, params: ["order_no": payStr, "type": "wx"], isShowHUD: true, success: { (response) in
                    let data = response["data"] as! [String:AnyObject]
                    //TODO:添加支付

//                    Pingpp.createPayment(data as NSObject, appURLScheme: WXAppKey, withCompletion: { (result, error) in
//                              self.updateUI()
//                    })
                    let pay =  PayReq()
                    pay.partnerId = data["partnerid"] as! String//"10000100"
                    pay.prepayId =  data["prepayid"] as! String//"1101000000140415649af9fc314aa427"
                    pay.package = data["package"] as! String//"Sign=WXPay"
                    pay.nonceStr = data["noncestr"] as! String//"a462b76e7436e98e0ed6e13c64b4fd1c"
                    pay.timeStamp = UInt32(data["timestamp"] as! String)! // 1397527777
                    pay.sign = data["sign"] as! String//"582282D72DD2B03AD892830965F428CB16E7A256"
                    WXApi.send(pay)
                    
                }, failure: {
                          self.updateUI()
                })
            }
        }
        
    }
}
