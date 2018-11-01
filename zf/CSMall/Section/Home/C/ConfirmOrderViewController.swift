//
//  ConfirmOrderViewController.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/15.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import HandyJSON

enum ConfirmOrderType:Int {
    case One_Buy = 0
    case ShopCart_Buy = 1
}
class ConfirOrderPrice: HandyJSON {
 
    var member_id:String?
    var address_id:String?
    var deduct_integral_value:String?
    var coupon_ids:String?
    var orderBeans:[ConfirOrderBeansModel] = [ConfirOrderBeansModel]()
    required init(){}
}
class ConfirOrderBeansModel: HandyJSON {
    
    var merchants_id:String?//商家id
    var order_remark:String?//订单备注
    var order_type:String?//"goods:正常下单 group:团购下单",
    var orderGoodsBeans:[ConfirOrderGoodsBeansModel] = [ConfirOrderGoodsBeansModel]()
    // "member_group_id": "团购下单 需传值 用户开团主键",
    required init(){}
}
class ConfirOrderGoodsBeansModel: HandyJSON {
    var live_id = ""
    var seller = ""
    var goods_id:String?
    var specification_id:String?
    var goods_num:String?
    required init(){}
}

class ConfirmOrderViewController: UIViewController,ConfirAddressDelegate {
   
    var isLiving = 0//默认0没有直播 1在直播
    var live_id = ""
    var seller = ""
    
    var confirType: ConfirmOrderType!

    //购物车跳转过来
    var shopcar_ids = ""
    
    //单件购买
    var goods_num = "0"
    var specification_id = "0"
    var goods_id = "0"
    
    //优惠券id逗号
    var usecoupon_ids = ""
    //抵扣积分
    var deduct_integral_value = ""

    var address:AddressModel!
    var amount = ""//总价格

    @IBOutlet weak var confirmTab: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    
    let tabheader = Bundle.main.loadNibNamed("ConfirAddress", owner: nil, options: nil)?.first as! ConfirAddress
   
    let tabfooter = Bundle.main.loadNibNamed("ConfirCouponView", owner: nil, options: nil)?.first as! ConfirCouponView
    
    var comfirData:ConfirmGoodsInfoModel = ConfirmGoodsInfoModel()
    var conListData:[ConfirmGoodsInfoModel] = [ConfirmGoodsInfoModel]()//订单数据
    
    var remarkData:[String] = [String]()
    var  payStr = ""//支付提交的字符串
    var payWay = "wx"
    var coupon = CouponBeanModel()//用户选择的优惠券
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Hint_14", comment: "确认订单")
        loadData()
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 90))
        tabheader.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 90)
        header.addSubview(tabheader)
        
        tabheader.delegate = self
        confirmTab.tableHeaderView = header
        
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 85))
    
        tabfooter.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 85)

        footer.addSubview(tabfooter)
        tabfooter.scoreClickBlock = { btn in
            if btn.isSelected == true {
                self.deduct_integral_value = self.comfirData.deduct_integral_value!
            }else{
                self.deduct_integral_value = self.comfirData.deduct_integral_value!
            }
        }
        tabfooter.discountClickBlock = { btn in
            if self.comfirData.coupon != nil{
                let vc = SelectCouponViewController()
                vc.coupons = self.comfirData.coupon!
                vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
                vc.modalTransitionStyle = .crossDissolve
                vc.couponSelectBlock = {model in
                    self.tabfooter.discountLab.text = "\(PhoneTool.getCurrency())\(model.value ?? "")"
                    self.coupon = model
                }
                self.navigationController?.present(vc, animated: false, completion: nil)
            }
        }
        confirmTab.tableFooterView = footer
        
        confirmTab.register(UINib.init(nibName: "ConfirmOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmOrderTableViewCell")
        confirmTab.register(UINib.init(nibName: "ConfirHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ConfirHeaderView")
        confirmTab.register(UINib.init(nibName: "ConfirFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ConfirFooterView")
        
        NotificationCenter.default.addObserver(self, selector: #selector(paySuccess), name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payfail), name: NSNotification.Name(rawValue: "payFail"), object: nil)

    }
    func loadData(){
        var params = [String:Any]()
        
        if confirType == ConfirmOrderType.One_Buy{
            params = ["goods_id":goods_id,"goods_num":goods_num ,"specification_id":specification_id]
            
            NetworkingHandle.fetchNetworkData(url: "/api/Order/confirmGoodsInfo", at: self, params: params, success: { (response) in
                
                if let comfir = response["data"] as? NSDictionary{
                    self.comfirData = ConfirmGoodsInfoModel.deserialize(from: comfir)!
//                    if (self.comfirData.coupon?.count)! > 0{
//                        self.tabfooter.discountBtn.contentHorizontalAlignment = .right
                        
//                        self.tabfooter.discountBtn.setTitle("", for: .normal)
//                        self.tabfooter.discountBtn.setImage(#imageLiteral(resourceName: "dianpu_xiangqing_xiayibu"), for: .normal)
//                    }else{
//                        self.tabfooter.discountBtn.setTitle("无可使用优惠券", for: .normal)
//                        self.tabfooter.discountBt n.setImage(UIImage.init(), for: .normal)
//                    }
                    if self.comfirData.deduct_value == "0"{
                        self.tabfooter.scoreBtn.isHidden = true
                        
                        self.tabfooter.scoreLab.text = "\(PhoneTool.getCurrency())0.00"
                    }else{
                        self.tabfooter.scoreBtn.isHidden = false
                        self.tabfooter.scoreLab.text = "\(NSLocalizedString("Hint_15", comment: "可以使用"))\(self.comfirData.deduct_integral_value ?? "0")\(NSLocalizedString("Hint_16", comment: "抵扣"))\(self.comfirData.deduct_value ?? "0")"
                    }
                }
                if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                    
                    self.conListData = [ConfirmGoodsInfoModel].deserialize(from: data) as! [ConfirmGoodsInfoModel]
                    
                    for index in self.conListData.indices{
                        print(index)
                        self.remarkData.append("")
                    }
                    
                    
                        
                    self.confirmTab.reloadData()
                }
                if let data = (response["data"] as? NSDictionary)?["amount"] as? String{
                    
                    self.amount = data
                    self.totalPrice.text = "\(PhoneTool.getCurrency())\(self.amount)"
                }
            }, failure: {
                
            })

        }else{
            params = ["car_ids":shopcar_ids]
            NetworkingHandle.fetchNetworkData(url: "/api/Order/confirmOrderInfo", at: self, params: params, success: { (response) in
                
                if let comfir = response["data"] as? NSDictionary{
                    self.comfirData = ConfirmGoodsInfoModel.deserialize(from: comfir)!
//                    if (self.comfirData.coupon?.count)! > 0{
//                        self.tabfooter.discountBtn.contentHorizontalAlignment = .right
//                        
//                        self.tabfooter.discountBtn.setTitle("", for: .normal)
//                        self.tabfooter.discountBtn.setImage(#imageLiteral(resourceName: "dianpu_xiangqing_xiayibu"), for: .normal)
//                    }else{
////                        self.tabfooter.discountBtn.setTitle("无可使用优惠券", for: .normal)
//                    }
                    if self.comfirData.deduct_value == "0"{
                        self.tabfooter.scoreBtn.isHidden = true
                        self.tabfooter.scoreLab.text = "\(PhoneTool.getCurrency())0.00"
                    }else{
                        self.tabfooter.scoreBtn.isHidden = false
                        self.tabfooter.scoreLab.text = "\(NSLocalizedString("Hint_15", comment: "可以使用"))\(self.comfirData.deduct_integral_value ?? "0")\(NSLocalizedString("Hint_16", comment: "抵扣"))\(self.comfirData.deduct_value ?? "0")"

                    }
                }
                if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                    
                    self.conListData = [ConfirmGoodsInfoModel].deserialize(from: data) as! [ConfirmGoodsInfoModel]
                    for index in self.conListData.indices{
                        print(index)
                        self.remarkData.append("")
                    }
                   
                    self.confirmTab.reloadData()
                }
                if let data = (response["data"] as? NSDictionary)?["amount"] as? String{
                    
                    self.amount = data
                    self.totalPrice.text = data
                }
            }, failure: {
                
            })
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        NetworkingHandle.fetchNetworkData(url: "/api/Address/queryAddressList", at: self, isShowHUD: false, isShowError: true,  success: { (response) in
            
            if let data = response["data"] as? NSArray {
                
                if data.count == 0{
                    self.address = AddressModel()
                    self.tabheader.haveAddressView.isHidden = true
                    self.tabheader.noAddressView.isHidden = false

                }
                else if data.count == 1{
                    self.address = AddressModel.deserialize(from: data.firstObject as? NSDictionary)
                    self.tabheader.haveAddressView.isHidden = false
                    self.tabheader.noAddressView.isHidden = true

                }
                else if data.count > 1{
                     print(self.address)
                    
                    if self.address?.address_id == nil{
                       
                        self.address = AddressModel.deserialize(from: data.firstObject as? NSDictionary)
                    }
                    self.tabheader.haveAddressView.isHidden = false
                    self.tabheader.noAddressView.isHidden = true

                }
                if self.address != nil{
                    
                    self.tabheader.refershData(model: self.address)
                }
            }
        }) {
            
        }
        
    }
    
    @IBAction func commitClick(_ sender: UIButton) {
     
        if address.address_id == nil{
            ProgressHUD.showMessage(message: NSLocalizedString("Hint_17", comment: "请选择收货地址"))
            return
        }
        
        let orderPrice =  ConfirOrderPrice()// 1
       
        orderPrice.address_id = address.address_id
        orderPrice.member_id = CSUserInfoHandler.getIdAndToken()?.uid
        orderPrice.deduct_integral_value = deduct_integral_value
        if  coupon.id != nil{
            usecoupon_ids = coupon.id!
        }
        orderPrice.coupon_ids = usecoupon_ids

        for m in  conListData.indices{
            
            let orderBeans = ConfirOrderBeansModel()// 2
            orderBeans.merchants_id = conListData[m].merchants_id
            orderBeans.order_type = "goods"
            orderBeans.order_remark = self.remarkData[m]
            
            for n in (conListData[m].goods?.indices)! {
                
                
                let conlistgoods = conListData[m].goods?[n]
                let orderGoodsBeans = ConfirOrderGoodsBeansModel()// 3
                if isLiving == 1{
                    orderGoodsBeans.live_id = live_id
                    orderGoodsBeans.seller = seller
                }
                if confirType == ConfirmOrderType.ShopCart_Buy{
                    
                    orderGoodsBeans.live_id = self.conListData[m].goods?[n].live_id ?? ""
                    orderGoodsBeans.seller = self.conListData[m].goods?[n].live_id ?? ""

                }

                orderGoodsBeans.goods_id = conlistgoods?.goods_id
                orderGoodsBeans.specification_id = conlistgoods?.specification_id
                orderGoodsBeans.goods_num = conlistgoods?.goods_num
                orderBeans.orderGoodsBeans.append(orderGoodsBeans)
            }

            orderPrice.orderBeans.append(orderBeans)
        }
        print(orderPrice.toJSONString()!)

        var  parames: [String:Any] = [String:Any]()
        if confirType == ConfirmOrderType.One_Buy{
            parames = ["json":orderPrice.toJSONString()!]
        }else{
            parames = ["json":orderPrice.toJSONString()!,"car_ids":shopcar_ids]

        }
        
        NetworkingHandle.fetchNetworkData(url: "/api/Order/insertMallOrder", at: self, params: parames, success: { (response) in
        
            if let data = response["data"] as? [String:Any]{
                //order_id
                //order_no
                self.pay(orderNo:data["order_no"] as! String)
                self.payStr = data["order_no"] as! String
            }
        }, failure: {
    
        })
        
    }
    func pay(orderNo:String){
    
        let vc = UIAlertController.init(title: NSLocalizedString("Pleasechoosethewayofpayment", comment: "请选择支付方式"), message: "", preferredStyle: .actionSheet)
        let actionWX = UIAlertAction.init(title: NSLocalizedString("WeChat", comment: "微信"), style: .default) { (action) in
            self.payWay = "wx"
            NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping1", at: self, params: ["order_no": orderNo, "type": "wx"], isShowHUD: true, success: { (response) in
                let data = response["data"] as! [String:AnyObject]
                //TODO:添加支付

                //                Pingpp.createPayment(data as NSObject, appURLScheme: WXAppKey, withCompletion: { (result, error) in
//
//                })
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
        let actionzfb = UIAlertAction.init(title:  NSLocalizedString("Alipay", comment: "支付宝"), style: .default) { (action) in
            self.payWay = "alipay"
            NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping1", at: self, params: ["order_no": orderNo,"type": "ali_app"], isShowHUD: true, success: { (response) in
                if let data = response["data"] as? String{
                    AlipaySDK.defaultService().payOrder(data, fromScheme: "com.zhengan.zhongfeigou", callback: { (reult) in
                        self.paySuccess()
                        
                    })
                }
              
                //TODO:添加支付
                //                Pingpp.createPayment(data as NSObject, viewController: self, appURLScheme: urlSchemes, withCompletion: { (str, error) in
//
//                })
               
                
            }, failure: {
                
            })
            
        }
        let paypal = UIAlertAction.init(title: "paypal", style: .default) { (action) in
            PayPalConfig.payPal.showPay(vc: self, amount: self.amount, code: "USD", des: "中菲购")
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
//        vc.addAction(actionWX)
//        vc.addAction(actionzfb)
//        vc.addAction(cancel)
        
        self.present(vc, animated: true, completion: nil)
        
    }
    func paySuccess() {
        let pay = PayResultViewController()
        pay.result = 0
        pay.payWay = payWay
        pay.payStr = payStr
        self.navigationController?.pushViewController(pay, animated: false)
//        if self.type == "1"{
//            let vc = OrderFormPaySuccessViewController()
//            vc.totalPrice = String(format:"%.2f",(self.totalPrice!.toDouble()!))
//            vc.orderid = self.order_id
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//        else if self.type == "5"{
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "referJiFu"), object: nil, userInfo: nil)
//            self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
//            //            ProgressHUD.showSuccess(message: "支付成功！")
//        }
//        else {
//            let vc = ConsecrateLampPaySuccessViewController()
//            //            if  self.type == "2" || self.type == "4" {
//            //                vc.vctype = "1"
//            //            }else{
//            //                vc.vctype = "2"
//            //            }
//            vc.orderId = self.supply_id
//            if self.type == "2"{
//                vc.vctype = "2"
//            }else if self.type == "4"{
//                vc.vctype = "1"
//            }else {
//                vc.vctype = "3"
//            }
//            //            vc.location = self.locationArr
//            vc.totalPrice = String(format:"%.2f",(self.totalPrice!.toDouble()!))
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        
    }
    func payfail() {
        
        let pay = PayResultViewController()
        pay.result = 1
        pay.payWay = payWay
        pay.payStr = payStr
        self.navigationController?.pushViewController(pay, animated: false)

        //        if self.type == "5"{
        //            self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
        //            ProgressHUD.showSuccess(message: "支付成功！")
        //        }
        ProgressHUD.showMessage(message: NSLocalizedString("Hint_18", comment: "支付失败,请重新支付"))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func citemClick(view: ConfirAddress){
        
        let  vc = AddressVC()
        vc.changeAddress = {(addmodel) in
            self.address = addmodel
            self.confirmTab.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConfirmOrderViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return  conListData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conListData[section].goods!.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConfirHeaderView") as! ConfirHeaderView
        header.backgroundColor = UIColor.white
        header.img.sd_setImage(with: URL.init(string: conListData[section].merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        header.nameLab.text = conListData[section].merchants_name ?? ""
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConfirFooterView") as! ConfirFooterView
        if conListData.count > 0 {
            footer.c_numLab.text = "\(NSLocalizedString("Hint_19", comment: "共计"))\(conListData[section].totalNum ?? "0")\(NSLocalizedString("Hint_20", comment: "件商品"))    "
            footer.price.text = "\(NSLocalizedString("Hint_21", comment: "小计"))\(PhoneTool.getCurrency())\(conListData[section].totalPrice ?? "")"
        }
        footer.textChange = { str in
            self.remarkData[section] = str
        }
        //如果需要隐藏,使用优惠券
//        footer.btnClickBlock = {
//
//
//        }
        return footer
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 125
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmOrderTableViewCell", for: indexPath) as! ConfirmOrderTableViewCell
        if conListData.count > 0 {
            cell.refershData(model:(conListData[indexPath.section].goods?[indexPath.row])!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
}
