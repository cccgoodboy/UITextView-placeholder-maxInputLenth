//
//  MineCollectionReusableView.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class MineCollectionReusableView: UICollectionReusableView {

    @IBAction func headClick(_ sender: UIButton) {
        responderViewController()?.navigationController?.pushViewController(PersonalVC(), animated: true)
    }
    @IBOutlet weak var m_headImg: UIImageView!//头像
    @IBOutlet weak var m_name: UILabel!//叶倩倩
    @IBOutlet weak var m_sexLab: UIImageView!// icon_woman man xinbie
    
    @IBOutlet weak var sendDiamond: UILabel!
    @IBOutlet weak var m_qianming: UILabel!//签名
    @IBOutlet weak var m_socre: UILabel!//200000积分
    @IBOutlet weak var m_addressLab: UILabel!//地址
    //查看用户积分 eg 地址：上海市 上海 浦东新区
    
    @IBOutlet weak var m_wait_pay: UILabel!
    
    @IBOutlet weak var m_wait_send: UILabel!
    @IBOutlet weak var m_wait_receive: UILabel!
    @IBOutlet weak var m_wait_assessment: UILabel!
    
    @IBOutlet weak var m_service: UILabel!  //售后
    @IBAction func m_lookscoreClick(_ sender: UIButton) {
        
        
    }
    
    @IBAction func itemClick(_ sender: UIButton) {
        
        if sender.tag == 5{//售后
            self.responderViewController()?.navigationController?.pushViewController(ReimburseViewController(), animated: true)

        
        }else{
            let vc = OrderViewController()
            vc.type = sender.tag
            self.responderViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func reloadUSerData(model:CSUserInfoModel){
        m_headImg.sd_setImage(with: URL.init(string: model.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        m_name.text = model.username
        if model.sex == "1"{
            m_sexLab.image = #imageLiteral(resourceName: "man")
        }else if model.sex == "2"{
            m_sexLab.image = #imageLiteral(resourceName: "icon_woman")
        }else{
            m_sexLab.image = #imageLiteral(resourceName: "xinbie")
        }
        m_qianming.text = model.signature
//        m_socre.text = "\(model. ?? "0")积分"
//        sendDiamond.text = "送出\(model.give_count ?? "")钻石"
        sendDiamond.isHidden = true
        m_addressLab.text = model.address
        if Int(model.wait_count ?? "0") == 0{//待付款
            m_wait_pay.isHidden = true
        }else{
            m_wait_pay.isHidden = false

            m_wait_pay.text = model.wait_count ?? "0"
        }
        if Int(model.seed_count ?? "0") == 0{//待发货
            m_wait_send.isHidden = true
        }else{
            m_wait_send.isHidden = false

            m_wait_send.text = model.seed_count ?? "0"
        }
        if Int(model.receive_count ?? "0") == 0{//带收货
            m_wait_receive.isHidden = true
        }else{
            m_wait_receive.isHidden = false

            m_wait_receive.text = model.receive_count ?? "0"
        }
        if Int(model.assessment_count ?? "0") == 0{//待评价
            m_wait_assessment.isHidden = true
        }else{
            m_wait_assessment.isHidden = false

            m_wait_assessment.text = model.assessment_count ?? "0"
        }
        if Int(model.returns_count ?? "0") == 0{//待评价
            m_service.isHidden = true
        }else{
            m_service.isHidden = false

            m_service.text = model.returns_count ?? "0"
        }
        
    }
    @IBOutlet weak var hint1: UILabel!
   
    @IBOutlet weak var hint2: UILabel!//待发货
    @IBOutlet weak var hint3: UILabel!//待收货
    @IBOutlet weak var hint4: UILabel!//待评价
    @IBOutlet weak var hint5: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hint1.text = NSLocalizedString("Pendingpayment", comment: "待付款")
        hint2.text = NSLocalizedString("Waitingfordelivery", comment: "待发货")
        hint3.text = NSLocalizedString("Waitingforreceipt", comment: "待收货")
        hint4.text = NSLocalizedString("Waitingforevaluation", comment: "待评价")
        hint5.text = NSLocalizedString("Refund", comment: "退款售后")
    }
    
}
