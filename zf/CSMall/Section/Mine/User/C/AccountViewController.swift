
//
//  AccountViewController.swift
//  Duluo
//
//  Created by 梁毅 on 2017/3/21.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import StoreKit
class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var tableView: UITableView!
    
    var remainingSum = "0"
    var priceArr: [PriceListModel] = []
    var productIDs: Array<String?> = []
    
    var person = PersonInfoModel()
    var money: String = ""
    var meters: String = ""
    var price_list_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的账户"

        requestPriceList()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "充值记录", target: self, action:  #selector(rightBarButtonItemaAction))
        //        let dic = [NSForegroundColorAttributeName:UIColor.black]
        //        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
        tableView.register(UINib(nibName: "MyDiamondTableViewCell", bundle: nil), forCellReuseIdentifier: "MyDiamondTableViewCell")
        tableView.register(UINib(nibName: "MyDiamondRemainTableViewCell", bundle: nil), forCellReuseIdentifier: "MyDiamondRemainTableViewCell")
        
        self.tableView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.separatorColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        self.tableView.register(MyDiamondTableViewCell.self, forCellReuseIdentifier: "cell")
        
        SKPaymentQueue.default().add(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(paySuccess), name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payfail), name: NSNotification.Name(rawValue: "payFail"), object: nil)
        
    }
    //MARK: 点击事件
    func rightBarButtonItemaAction() {
        let vc = DiamondRechargeRecordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func paySuccess() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rechargeSuccess"), object: nil, userInfo: nil)

        ProgressHUD.showSuccess(message: "支付成功！")
//        self.requestMyDiamond()
        requestPriceList()
    }
    func payfail() {
        ProgressHUD.showMessage(message: "支付失败")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        SKPaymentQueue.default().remove(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "paySuccess"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "payFail"), object: nil)
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            let payment = SKPayment(product: response.products[0] as SKProduct)
            SKPaymentQueue.default().add(payment)
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                ProgressHUD.showSuccess(message: "购买成功")
                ProgressHUD.hideLoading(toView: self.view)
                let param = ["price_list_id":self.price_list_id]
                NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/apple_recharge", at: self, params: param, success: { (response) in
//                    self.requestMyDiamond()
                    self.requestPriceList()
                })
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                ProgressHUD.showMessage(message: "取消支付")
                ProgressHUD.hideLoading(toView: self.view)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return priceArr.count
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 37
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            let label = UILabel()
            label.text = "充值"
            label.textColor = UIColor(hexString: "#aaaaaa")
            label.font = UIFont.systemFont(ofSize: 16)
            view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(view.snp.centerY)
                make.left.equalTo(15)
            })
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyDiamondRemainTableViewCell", for: indexPath) as! MyDiamondRemainTableViewCell
            cell.remianBtn.setTitle(remainingSum, for: .normal)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDiamondTableViewCell", for: indexPath) as! MyDiamondTableViewCell
        cell.priceListModel = priceArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let versionKey = String(kCFBundleVersionKey)
        let currentVersion = Bundle.main.infoDictionary?[versionKey] as! String
        print(" 当前版本号为：\(currentVersion)")
        let param = ["version": currentVersion]
        NetworkingHandle.fetchNetworkData(url: "/api/User/is_this", at: self, params: param, isShowHUD: false, success: { (response) in
            let data = response["data"] as! String
            if data == "1" {
                self.applePayment(indexPath: indexPath)
            } else {
                let vc = UIAlertController(title: "选择充值方式", message: nil, preferredStyle: .actionSheet)
                let wx = UIAlertAction(title: "微信", style: .default) { (alert) in
                    let param = ["type": "wx", "price_list_id": self.priceArr[indexPath.row].price_list_id!]
                    NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping", at: self, params: param,  success: { (response) in
                        let data = response["data"] as! [String: AnyObject]
                        //TODO:添加支付

                        //                        Pingpp.createPayment(data as NSObject!, viewController: self, appURLScheme: WXAppKey, withCompletion: { (str, error) in
////                            self.requestMyDiamond()
//                            self.requestPriceList()
//                        })
                        let pay =  PayReq()
                        pay.partnerId = data["partnerid"] as! String//"10000100"
                        pay.prepayId =  data["prepayid"] as! String//"1101000000140415649af9fc314aa427"
                        pay.package = data["package"] as! String//"Sign=WXPay"
                        pay.nonceStr = data["noncestr"] as! String//"a462b76e7436e98e0ed6e13c64b4fd1c"
                        pay.timeStamp = UInt32(data["timestamp"] as! String)! // 1397527777
                        pay.sign = data["sign"] as! String//"582282D72DD2B03AD892830965F428CB16E7A256"
                        WXApi.send(pay)
                    })
                }
                let alipay = UIAlertAction(title: "支付宝", style: .default) { (alert) in
                    let param = ["type": "ali_app", "price_list_id": self.priceArr[indexPath.row].price_list_id!]
                    NetworkingHandle.fetchNetworkData(url: "/api/Pingxx/ping", at: self, params: param,  success: { (response) in
                        if let data = response["data"] as? String{
                            AlipaySDK.defaultService().payOrder(data, fromScheme: "com.zhengan.zhongfeigou", callback: { (reult) in
                                self.paySuccess();            
                            })
                        }                        //TODO:添加支付

                        //                        Pingpp.createPayment(data as NSObject!, viewController: self, appURLScheme: urlSchemes, withCompletion: { (str, error) in
//
//                        })
                    })
                }
                let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                vc.addAction(wx)
                vc.addAction(alipay)
                vc.addAction(cancel)
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    // 内购
    func applePayment(indexPath: IndexPath) {
        let model = self.priceArr[indexPath.row]
        if model.sign == nil || model.sign == "" {
            ProgressHUD.showNoticeOnStatusBar(message: "开发中。。。")
            return
        }
        self.meters = model.diamond!
        self.money = model.price!
        self.price_list_id = model.price_list_id!
        
        if SKPaymentQueue.canMakePayments() {
            ProgressHUD.showLoading(toView: self.view, message: "购买中..")
            let productIdentifiers = NSSet(array: [model.sign!])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject> as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    //MARK: MyDiamondTableViewCellDelegate
    func diamondTableViewCell(cell: MyDiamondTableViewCell, didSelectPurchase row: Int) {
        let model = priceArr[row]
        print((model.price)!)
    }
    //MARK: 网络请求
//    func requestMyDiamond() { //获取我的余额
//        NetworkingHandle.fetchNetworkData(url: "/api/live/get_money", at: self, isAuthHide: false, isShowHUD: false, success: { (response) in
//            self.remainingSum = (response["data"] as! [String:Any])["money"] as! String
//            self.person.money = self.remainingSum
//            self.tableView.reloadData()
//        })
//    }
    func requestPriceList() { //获取价格列表
        NetworkingHandle.fetchNetworkData(url: "/api/User/price_list", at: self,isShowError: false, success: { (response) in
            let data = response["data"] as! [String:AnyObject]
            self.remainingSum = data["amount"] as! String
            self.person.money = self.remainingSum

            self.priceArr = PriceListModel.modelsWithArray(modelArray: data["list"] as! [[String : AnyObject]]) as! [PriceListModel]
            self.tableView.reloadData()
        })
    }
    
}
