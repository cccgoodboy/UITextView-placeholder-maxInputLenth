//
//  EvaluateGoodsViewController.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/23.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

let EvaluateGoodsSuccessNotification = "EvaluateGoodsSuccessNotification"

class EvaluateGoodsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var merchantModel: QueryOrderViewModel = QueryOrderViewModel()
    let tabheader = Bundle.main.loadNibNamed("EvaluateTableFooterView", owner: nil, options: nil)?.first as! EvaluateTableFooterView

    var goodsArr:[OrderGoodsBeansModel] = []
    var order_merchants_id: String?
    var submitArr: [SubcommentModel] = []
    var contentArr: [Any] = []
    var evaluateSuccess: (()->())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 220))
        tabheader.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 220)
        header.addSubview(tabheader)
        tabheader.model = merchantModel
        self.title = NSLocalizedString("Hint_59", comment: "评价")
        self.tableView.register(UINib(nibName:"EvaluateTableViewCell", bundle:nil), forCellReuseIdentifier: "EvaluateTableViewCell")
        tabheader.confirmSuccess = { logistics, serviceStart in
            self.confirm(serviceStart: serviceStart,logistics: logistics)
        }
        self.tableView.tableFooterView = header
    }
    func confirm(serviceStart:Int,logistics:Int){

        if self.submitArr.count == 0{
            ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_62", comment: "麻烦填写下评论啊亲"))
            return
        }
        
        for (index,m) in self.submitArr.enumerated() {
            
            if m.content?.characters.count == 0 || m.content == nil{
                m.content = ""
            }
            if index == self.submitArr.count - 1 {
                self.submitForm(serviceStart: serviceStart, logistics:logistics)
            }
    }
}
    func submitForm(serviceStart:Int,logistics:Int){
        
        if  goodsArr.count != submitArr.count{
            ProgressHUD.showMessage(message: NSLocalizedString("Hint_63", comment:"请将评论信息填写完整哦"))

            return
        }
        for m in self.submitArr{
            if m.content == nil{
                ProgressHUD.showMessage(message: NSLocalizedString("Hint_63", comment:"请将评论信息填写完整哦"))
                return
            }
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Order/comment_goods", at: self, params: ["order_merchants_id":self.order_merchants_id!,"express_mark":"\(logistics)","service_mark":"\(serviceStart)","content":submitArr.toJSONString() ?? ""], isAuthHide: true, isShowHUD: true, isShowError: true, hasHeaderRefresh: nil, success: { (reponse) in
            ProgressHUD.showSuccess(message: NSLocalizedString("Hint_64", comment: "评论成功"))
            self.evaluateSuccess?()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:EvaluateGoodsSuccessNotification), object: nil, userInfo: nil)
            self.navigationController?.popViewController(animated: true)
        }) { 
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateTableViewCell") as! EvaluateTableViewCell
        
        cell.tmodel = self.goodsArr[indexPath.section]
        cell.submitModel = { model in
            if self.submitArr.count == 0{
                self.submitArr.append(model)
            } else{
                var isHave = false
                for (index,m) in self.submitArr.enumerated() {
                    if m.order_goods_id! == model.order_goods_id!{
                        isHave = true
                        self.submitArr[index] = model
                    }
                }
                if isHave == false{
                    self.submitArr.append(model)
                }
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 233/375 * kScreenWidth
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.goodsArr.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#f1f5f6")
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.goodsArr.count - 1{
            return 0
        }else{
            return 5
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
