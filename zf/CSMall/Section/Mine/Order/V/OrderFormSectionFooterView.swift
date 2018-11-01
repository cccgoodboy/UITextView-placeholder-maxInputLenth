//
//  OrderFormSectionFooterView.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/4.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class OrderFormSectionFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var postage: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var middleBtn: UIButton!
    var target:GlobalOrderViewController!
    @IBOutlet weak var leftBtn: UIButton!
    var cancelOrderForm : ((OrdersMdoel)->())?
    var deleteOrderForm : ((OrdersMdoel)->())?
    var orvercancelOrderForm:((OrdersMdoel)->())?
    var confirmReceiveGoods : ((OrdersMdoel)->())?
    
    var model : OrdersMdoel!{
        willSet(m){
            postage.text = "\(PhoneTool.getCurrency())\(m.order_actual_price ?? "0")"
            price.text = "共计\(m.totalNum!)件商品   合计:"
            //1待支付；2待发货；3待收货；4待评价；5可删除订单
            if  m.order_state == "wait_pay" {//待支付
                rightBtn.setTitle("付款", for: .normal)
                middleBtn.setTitle("取消订单", for: .normal)
                leftBtn.setTitle("联系商家", for: .normal)

//                rightBtn.setImage(#imageLiteral(resourceName: "btn_fukuan2"), for:.normal)
//                middleBtn.setImage(#imageLiteral(resourceName: "btn_quxiao"), for: .normal)
//                leftBtn.setImage(#imageLiteral(resourceName: "btn_kefu"), for: .normal)
//                leftBtn.isHidden = false
            }
            else if  m.order_state == "wait_send" {//待发货
                rightBtn.setTitle("催单", for: .normal)
                middleBtn.setTitle("联系商家", for: .normal)
                leftBtn.isHidden = true

//                rightBtn.setImage(#imageLiteral(resourceName: "btn_queren2"), for: .normal)
//                middleBtn.setImage(#imageLiteral(resourceName: "btn_wuliu"), for: .normal)
//                leftBtn.setImage(#imageLiteral(resourceName: "btn_kefu"), for: .normal)
//                leftBtn.isHidden = false
            }
            else if  m.order_state == "wait_receive" {//待收货
                rightBtn.setTitle("确认收货", for: .normal)
                middleBtn.setTitle("查看物流", for: .normal)
                leftBtn.setTitle("联系商家", for: .normal)
                
//                rightBtn.setImage(#imageLiteral(resourceName: "btn_queren2"), for: .normal)
//                middleBtn.setImage(#imageLiteral(resourceName: "btn_wuliu"), for: .normal)
//                leftBtn.setImage(#imageLiteral(resourceName: "btn_kefu"), for: .normal)
//                leftBtn.isHidden = false
                
            }
            else if m.order_state == "wait_assessment" {//待评价
                rightBtn.setTitle("评价", for: .normal)
                middleBtn.setTitle("查看物流", for: .normal)
                leftBtn.setTitle("联系商家", for: .normal)
                
//                rightBtn.setImage(#imageLiteral(resourceName: "btn_pingjia2"), for: .normal)
//                middleBtn.setImage(#imageLiteral(resourceName: "btn_wuliu"), for: .normal)
//                leftBtn.setImage(#imageLiteral(resourceName: "btn_kefu"), for: .normal)
//                leftBtn.isHidden = false
                
            }
            else{
                rightBtn.setTitle("删除订单", for: .normal)

                leftBtn.isHidden = true
                middleBtn.isHidden = true
//                rightBtn.isHidden = true

            }

            
        }
    }
    var merchant: QueryOrderViewModel = QueryOrderViewModel()
    @IBAction func rightAction(_ sender: UIButton) {
        
        switch model.order_state! {
        case "wait_pay" ://待支付
            print("付款")
            let vc = UIAlertController.init(title: "请选择支付方式", message: "", preferredStyle: .actionSheet)
            let actionWX = UIAlertAction.init(title: "微信", style: .default) { (action) in
                NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping2", at: self, params: ["order_no": self.model.order_no!, "type": "wx"], isShowHUD: true, success: { (response) in
                    let data = response["data"] as! [String:AnyObject]
                    //TODO:添加支付

                    //                    Pingpp.createPayment(data as NSObject, appURLScheme: WXAppKey, withCompletion: { (result, error) in
//
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
                    
                })
            }
            let actionzfb = UIAlertAction.init(title: "支付宝", style: .default) { (action) in
                NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping2", at: self, params: ["order_no": self.model.order_no!,"type": "ali_app"], isShowHUD: true, success: { (response) in
                    if let data = response["data"] as? String{
                        AlipaySDK.defaultService().payOrder(data, fromScheme: "com.zhengan.zhongfeigou", callback: { (reult) in
                            
                            
                        })
                    }
                    //TODO:添加支付

                    //                    Pingpp.createPayment(data as NSObject, viewController: self.responderViewController(), appURLScheme: urlSchemes, withCompletion: { (str, error) in
//
//                    })
                }, failure: {
                    
                })
                
            }
            let paypal = UIAlertAction.init(title: "paypal", style: .default) { (action) in
                PayPalConfig.payPal.showPay(vc: self.target, amount: self.model.order_actual_price ?? "0", code: "USD", des: "中菲购")
            }
            
            let cancel = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: "取消"), style: .default) { (action) in
                
            }
            let languages = Locale.preferredLanguages.first
            
            if (languages?.contains("en"))!{//英文环境
                vc.addAction(paypal)
                vc.addAction(cancel)
            }else if (languages?.contains("zh"))!{
                vc.addAction(actionWX)
                vc.addAction(actionzfb)
                vc.addAction(cancel)
            }else{
                vc.addAction(paypal)
                vc.addAction(cancel)
            }
//            let cancel = UIAlertAction.init(title: "取消", style: .default) { (action) in
//
//            }
//            vc.addAction(actionWX)
//            vc.addAction(actionzfb)
//            vc.addAction(cancel)
//
            responderViewController()?.present(vc, animated: true, completion: nil)
        case "wait_send" ://待发货

//            print("催单")
            NetworkingHandle.fetchNetworkData(url: "/api/Order/hurry_order", at: self, params: ["order_merchants_id":model.order_merchants_id!], success: { (result) in
                if let data = result["data"] as? String{
                    ProgressHUD.showMessage(message: data)
                }
            }, failure: {
            
            })
            
        case "wait_receive" ://待收货
            print("确认收货")
            
            NetworkingHandle.fetchNetworkData(url: "/api/Order/receiveOrder", at: self, params: ["order_merchants_id":model.order_merchants_id!], isAuthHide: true, isShowHUD: true, isShowError: true, hasHeaderRefresh: nil, success: { (response) in
                self.confirmReceiveGoods?(self.model)
                ProgressHUD.showSuccess(message: response["data"] as? String   ?? "已确认")
                
            }, failure: {
                
            })
        case "wait_assessment" ://待评价
            print("评价")
          let eva =  EvaluateGoodsViewController()
            eva.goodsArr = model.orderBeans!
            eva.merchantModel = merchant
            eva.order_merchants_id = model.order_merchants_id!
            responderViewController()?.navigationController?.pushViewController(eva, animated: true)
            case "end":
            
                NetworkingHandle.fetchNetworkData(url: "/api/Order/delOrder", at: self, params: ["order_merchants_id":model.order_merchants_id!], success: { (response) in
                    
                    if let show = response["data"] as? String{
                        ProgressHUD.showMessage(message: show)
                        self.model.isDelete = true
                        self.orvercancelOrderForm?(self.model)
                    }
                }, failure: { 
                    
                })
            
        default:
            print("")

        }
        
//        } else if model.state == "1" {
////            let vc = SelectPayWayViewController()
////            vc.payType = "1"
////            vc.amount = model.paid
////            vc.order_no = model.order_no
////            self.responderViewController()?.navigationController?.pushViewController(vc, animated: true)
//        } else if model.state == "4" {
////           let vc = EvaluateGoodsViewController()
////            vc.order_id = model.order_no
////            vc.goodsArr = model.order_detail!
////           self.responderViewController()?.navigationController?.pushViewController(vc, animated: true)
//        } else if model.state == "5" {
//          
//            print("******" + self.model.order_no!)
//            NetworkingHandle.fetchNetworkData(url: "/mall/del_order", at: self, params: ["order_no": self.model.order_no!], isAuthHide: true, isShowHUD: true, isShowError: true, hasHeaderRefresh: nil, success: { (response) in
//                self.deleteOrderForm?(self.model)
//
//            }, failure: { 
//                
//            })
////            NetworkingHandle.fetchNetworkData(url: "/mall/del_order", at: self, success: { (response) in
////                self.deleteOrderForm?(self.model)
////                print("删除订单")
////            })
//           
//        }
    }

    @IBAction func middleAction(_ sender: UIButton) {
        
        switch model.order_state! {
        case "wait_pay" ://待支付  取消订单
        NetworkingHandle.fetchNetworkData(url: "/api/Order/cancelOrder", at: self, params: ["order_merchants_id":model.order_merchants_id!], success: { (response) in
            
            if let show = response["data"] as? String{
            ProgressHUD.showMessage(message: show)
                self.model.isCancel = true
                self.cancelOrderForm?(self.model)

            }
         }, failure: { 
            
        })
        case "wait_send" ://待发货  联系商家
            sender.isEnabled = false
            self.perform(#selector(changeMiddleButtonStatus), with: nil, afterDelay: 2.0)

            print("客服")
            if  self.model.contact_mobile != nil  && self.model.contact_mobile != ""{
                let str = String(format:"telprompt://%@",(model.contact_mobile)!)
                UIApplication.shared.openURL(URL(string:str )!)
                
            }else{
                ProgressHUD.showMessage(message: "抱歉，暂时联系不了")
                
            }

            
        case "wait_receive" ://待收货  查看物流

            let vc = CheckLogisticsViewController()
            vc.goods_image = model.orderBeans?.first?.goods_img ?? ""

            vc.goods_number = model.totalNum ?? "0"
            vc.order_number = model.order_no ?? ""
            vc.logistics_no = model.logistics_no ?? "0"
            vc.logistics_pinyin = model.logistics_pinyin ?? "0"
            self.responderViewController()?.navigationController?.pushViewController(vc, animated: true)
            break
            
        case "wait_assessment" ://待评价 查看物流
            let vc = CheckLogisticsViewController()
            vc.goods_image = model.orderBeans?.first?.goods_img ?? ""

            vc.goods_number = model.totalNum ?? "0"
            vc.order_number = model.order_no ?? ""

            vc.logistics_no = model.logistics_no ?? "0"
            vc.logistics_pinyin = model.logistics_pinyin ?? "0"
            self.responderViewController()?.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            print("")
            
        }
    }
    func changeMiddleButtonStatus(){
        
        middleBtn.isEnabled = true

    }
    @IBAction func leftACtion(_ sender: UIButton) {
        sender.isEnabled = false
        self.perform(#selector(changeButtonStatus), with: nil, afterDelay: 2.0)

//        switch model.order_state! {
//        case "wait_pay" ://待支付  联系商家
//            
//            print("")
//            
//        case "wait_send" ://待发货
//            
//            print("联系商家")
//            
//        case "wait_receive" ://待收货
//            print("联系商家")
//            
//        case "wait_assessment" ://待评价
//            print("联系商家")
//            
//        default:
//            print("")
//            
//        }
//        ContactUsViewController.contactCustomerServiceVC(from: self.responderViewController()!)
//        print("客服")
        
        
        if  self.model.contact_mobile != nil  && self.model.contact_mobile != ""{
                let str = String(format:"telprompt://%@",(model.contact_mobile)!)
                UIApplication.shared.openURL(URL(string:str )!)
           
        }else{
            ProgressHUD.showMessage(message: "抱歉，暂时联系不了")

        }

    }
    func   changeButtonStatus(){
        leftBtn.isEnabled = true
    }
    
    
}
