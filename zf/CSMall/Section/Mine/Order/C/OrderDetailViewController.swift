//
//  OrderDetailViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/14.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class OrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var middleBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    
    var order_merchants_id = "0"
    var order_State = ""
    var orderDetail:QueryOrderViewModel?
    var orderState = UILabel()
    var time = UILabel()
    var showTime = ""
    let tabheader = Bundle.main.loadNibNamed("ConfirAddress", owner: nil, options: nil)?.first as! ConfirAddress

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Hint_48", comment: "订单详情")
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: EvaluateGoodsSuccessNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: ApplicationGoodsSuccessNotification), object: nil)

        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 170))
        header.backgroundColor = UIColor.init(hexString: "FFE961")
       
        orderState.numberOfLines =  0
        orderState.textColor = UIColor.init(hexString: "C98000")
        orderState.font = UIFont.systemFont(ofSize: 15)
        orderState.frame = CGRect.init(x: 20, y: 15, width: kScreenWidth - 40, height: 36)
        orderState.text = NSLocalizedString("Hint_49", comment: "等待买家付款！")
        header.addSubview(orderState)
        
        time.numberOfLines =  0
        time.textColor = UIColor.init(hexString: "C98000")
        time.font = UIFont.systemFont(ofSize: 13)
        time.frame = CGRect.init(x: 20, y: 51, width: kScreenWidth - 40, height: 16)
//        time.text = "14分钟59秒后未支付，订单将自动关闭！"
        header.addSubview(time)
        header.addSubview(tabheader)
        tabheader.frame = CGRect.init(x: 0, y: 80, width: kScreenWidth, height: 90)
        tabheader.noAddressView.isHidden = true
        tableView.tableHeaderView = header
        tabheader.rightBtn.isHidden = true
        tableView.register(UINib.init(nibName: "OrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTableViewCell")
        tableView.register(UINib.init(nibName: "OrderDetailTimeCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTimeCell")
        tableView.register(UINib.init(nibName: "ConfirHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ConfirHeaderView")
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadData()
        })
        loadData()
    }
    func updateUI(){
          loadData()
    }
    func loadData(){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Order/queryOrderView", at: self, params: ["order_merchants_id":order_merchants_id], hasHeaderRefresh: tableView, success: { (response) in
            if let data = response["data"]  as? NSDictionary{
            
                self.orderDetail = QueryOrderViewModel.deserialize(from: data)
                self.tabheader.refershData(model: (self.orderDetail?.address)!)
                self.setUpViewData()
                self.tableView.reloadData()
            }
        }) { 
            
        }
        if order_State == "wait_pay"{
            NetworkingHandle.fetchNetworkData(url: "/api/Order/cancelTime", at: self, params: ["order_merchants_id":order_merchants_id], hasHeaderRefresh: tableView, success: { (response) in
                if let data = response["data"]  as? String{
                    self.showTime = data                    
                }
            }) {
            }
        }
    }
    func setUpViewData() {
        
        if orderDetail != nil{
            if orderDetail?.order_state == "wait_pay"{
                rightBtn.setTitle(NSLocalizedString("Hint_47", comment: "付款"), for: .normal)
                middleBtn.setTitle(NSLocalizedString("Hint_51", comment: "取消订单"), for: .normal)
                leftBtn.setTitle(NSLocalizedString("Hint_46", comment: "联系商家"), for: .normal)
                orderState.text = NSLocalizedString("Hint_49", comment: "等待买家付款！")//"等待买家付款！"
                time.text = "\(showTime)\(NSLocalizedString("Hint_50", comment: "后未支付，订单将自动关闭！"))"
            }else if orderDetail?.order_state == "wait_send"{
                rightBtn.setTitle(NSLocalizedString("Hint_52", comment: "催单"), for: .normal)
                middleBtn.setTitle(NSLocalizedString("Hint_46", comment: "联系商家"), for: .normal)
                leftBtn.isHidden = false
                orderState.text = NSLocalizedString("Hint_53", comment: "等待商家发货")
                time.text = NSLocalizedString("Hint_54", comment: "您的商品打包中，请耐心等候哦")
            }else if orderDetail?.order_state == "wait_receive"{
                rightBtn.setTitle(NSLocalizedString("Hint_55", comment: "确认收货"), for: .normal)
                middleBtn.setTitle(NSLocalizedString("Hint_56", comment: "查看物流"), for: .normal)
                leftBtn.setTitle(NSLocalizedString("Hint_46", comment: "联系商家"), for: .normal)
                orderState.text = NSLocalizedString("Hint_57", comment: "商家已发货")
                time.text = NSLocalizedString("Hint_58", comment: "您的商品已搭载火箭飞速向您赶来了哦～")

            }else if orderDetail?.order_state == "wait_assessment"{
                rightBtn.setTitle(NSLocalizedString("Hint_59", comment: "评价"), for: .normal)
                middleBtn.setTitle(NSLocalizedString("Hint_56", comment: "查看物流"), for: .normal)
                leftBtn.setTitle(NSLocalizedString("Hint_46", comment: "联系商家"), for: .normal)
                orderState.text = NSLocalizedString("Hint_45", comment: "交易成功")
                time.text = NSLocalizedString("Hint_60", comment: "买家已确认收货")
            }
        
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
     
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
         return orderDetail?.orderBeans?.count ?? 0
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 40 :CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if orderDetail == nil{
            return CGFloat.leastNormalMagnitude
        }
        if indexPath.section == 0{
        
            if orderDetail!.order_state == "wait_assessment" || orderDetail!.order_state == "end" {
                return 160
            }else{
                return 126
            }
        }else{
            if orderDetail != nil {
                return OrderDetailTimeCell.getCellHeight(model: orderDetail!)
            }else{
                return 0
            }
        }
      
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
        
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConfirHeaderView") as! ConfirHeaderView
            view.nameLab.text = orderDetail?.merchants_name ?? ""
            view.img.sd_setImage(with: URL.init(string: orderDetail?.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            return view
        }else{
            return UIView()
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell", for: indexPath) as! OrderDetailTableViewCell
            if orderDetail != nil{
                
                if orderDetail!.order_state == "wait_assessment" || orderDetail!.order_state == "end" {
                    cell.serviceBtn.isHidden = false
                }else{
                    cell.serviceBtn.isHidden = true
                }
                cell.model = (orderDetail?.orderBeans?[indexPath.row])!
            }
            cell.serviceClickBlock = {model in
                if self.orderDetail != nil{
                    let  application = ApplicationForDrawbackViewController()
                    application.order_merchants_id = (self.orderDetail?.order_merchants_id)!
                    application.order_goods_id = model.order_goods_id!
                    self.navigationController?.pushViewController(application, animated: false)
                }else{
                    self.loadData()
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTimeCell", for: indexPath) as! OrderDetailTimeCell
            if orderDetail != nil{
                cell.refershData(model:orderDetail!)
            }
            return cell
        }
    }
    
    
    @IBAction func leftACtion(_ sender: Any) {
    }
    
    @IBAction func middleAction(_ sender: Any) {
        if orderDetail != nil{

        switch (orderDetail?.order_state)! {
        case "wait_pay" ://待支付  取消订单
            NetworkingHandle.fetchNetworkData(url: "/api/Order/cancelOrder", at: self, params: ["order_merchants_id":orderDetail!.order_merchants_id!], success: { (response) in
                
                if let show = response["data"] as? String{
                    ProgressHUD.showMessage(message: show)
//                    self.model.isCancel = true
//                    self.cancelOrderForm?(self.model)
                    self.navigationController?.popViewController(animated: true)
                }
            }, failure: {
                
            })
        case "wait_send" ://待发货  联系商家
            
            print("")
//            NetworkingHandle.fetchNetworkData(url: "/api/Order/return_order", at: self, success: { (response) in
////                
//            })
            
        case "wait_receive" : //待收货  查看物流
            
            let vc = CheckLogisticsViewController()
            vc.goods_image = orderDetail?.orderBeans?.first?.goods_img ?? ""
            vc.goods_number = orderDetail?.totalNum ?? "0"
            vc.order_number = orderDetail?.order_no ?? ""
            vc.logistics_no = orderDetail?.logistics_no ?? "0"
            vc.logistics_pinyin = orderDetail?.logistics_pinyin ?? "0"
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case "wait_assessment" ://待评价 查看物流
            let vc = CheckLogisticsViewController()
            vc.goods_image = orderDetail?.orderBeans?.first?.goods_img ?? ""

            vc.goods_number = orderDetail?.totalNum ?? "0"
            vc.order_number = orderDetail?.order_no ?? ""

            vc.logistics_no = orderDetail?.logistics_no ?? "0"
            vc.logistics_pinyin = orderDetail?.logistics_pinyin ?? "0"
            self.navigationController?.pushViewController(vc, animated: true)

            break
        default:
            print("")
            }
        }
    }
    @IBAction func rightAction(_ sender: Any) {
        if orderDetail != nil{

        switch (orderDetail!.order_state)! {
        case "wait_pay" ://待支付
            print("付款")
            //            let vc = UIAlertController.init(title: "请选择支付方式", message: "", preferredStyle: .actionSheet)
            //            let actionWX = UIAlertAction.init(title: "微信", style: .default) { (action) in
            //                NetworkingHandle.fetchNetworkData(url: "Pingxx/bookPing", at: self, params: ["book_id": model.book_id!, "type": "wx"], isShowHUD: true, success: { (response) in
            //                    let data = response["data"] as! [String:AnyObject]
            //                    Pingpp.createPayment(data as NSObject, appURLScheme: "wxf27a06796405c589", withCompletion: { (result, error) in
            //
            //                    })
            //                }, failure: {
            //
            //                })
            //            }
            //            let actionzfb = UIAlertAction.init(title: "支付宝", style: .default) { (action) in
            //                NetworkingHandle.fetchNetworkData(url: "Pingxx/bookPing", at: self, params: ["book_id": model.book_id!,"type": "alipay"], isShowHUD: true, success: { (response) in
            //                    let data = response["data"] as! [String:AnyObject]
            //                    Pingpp.createPayment(data as NSObject, viewController: self, appURLScheme: "com.fayuanhui.mobile", withCompletion: { (str, error) in
            //
            //                    })
            //                }, failure: {
            //
            //                })
            //
            //            }
            //            let cancel = UIAlertAction.init(title: "取消", style: .default) { (action) in
            //
            //            }
            //            vc.addAction(actionWX)
            //            vc.addAction(actionzfb)
            //            vc.addAction(cancel)
        //            self.present(vc, animated: true, completion: nil)
        case "wait_send" ://待发货
            
            print("催单")
            
        case "wait_receive" ://待收货
            print("确认收货")
            
            NetworkingHandle.fetchNetworkData(url: "/api/Order/receiveOrder", at: self, params: ["order_merchants_id":orderDetail!.order_merchants_id!], isAuthHide: true, isShowHUD: true, isShowError: true, hasHeaderRefresh: nil, success: { (response) in
//                self.confirmReceiveGoods?()
                ProgressHUD.showSuccess(message: response["data"] as? String   ?? NSLocalizedString("Hint_61", comment: "已确认"))
                self.loadData()
            }, failure: {
                
            })
            break
        case "wait_assessment" ://待评价
            if (orderDetail != nil){
                let eva =  EvaluateGoodsViewController()
                eva.merchantModel  = orderDetail!
                eva.goodsArr = orderDetail!.orderBeans!
                eva.order_merchants_id = orderDetail?.order_merchants_id!
                self.navigationController?.pushViewController(eva, animated: true)
            }else{
                 loadData()
            }
        case "end":
            
            NetworkingHandle.fetchNetworkData(url: "/api/Order/delOrder", at: self, params: ["order_merchants_id":orderDetail!.order_merchants_id!], success: { (response) in
                
                if let show = response["data"] as? String{
                    ProgressHUD.showMessage(message: show)
//                    self.model.isDelete = true
//                    self.orvercancelOrderForm?(self.model)
                    self.navigationController?.popViewController(animated: true)

                }
            }, failure: {
                
            })
            
        default:
            print("")
            
        }
        }
    }

}
