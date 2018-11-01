//
//  OrderViewController.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/5/17.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class OrderViewController: PageViewController {

    
    @IBOutlet weak var allOrderBtn: UIButton!
   
    @IBOutlet weak var prepareToPayBtn: UIButton!
    
    @IBOutlet weak var prepareToSendBtn: UIButton!//待发货
    
    @IBOutlet weak var prepareToReceiveBtn: UIButton!
    
    @IBOutlet weak var prepareToTalkBtn: UIButton!
    
    @IBOutlet weak var bottomLine: UILabel!
    
    var sliderLine : UILabel!
    var selectedBtn: UIButton!
    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allOrder = GlobalOrderViewController()
        let prepareToPay = GlobalOrderViewController()
        let prepareToSend = GlobalOrderViewController()

        let prepareToReceive = GlobalOrderViewController()
        let prepareToTalk = GlobalOrderViewController()
       
        allOrder.doType = 0
        prepareToPay.doType = 1
        prepareToSend.doType = 2
        prepareToReceive.doType = 3
        prepareToTalk.doType = 4
        
        self.viewControllerArray = [allOrder, prepareToPay,prepareToSend, prepareToReceive, prepareToTalk]
        
        self.buttonArray = [allOrderBtn, prepareToPayBtn,prepareToSendBtn, prepareToReceiveBtn, prepareToTalkBtn]
        
        var frame = self.view.bounds
        frame.origin.y = 45
        frame.size.height -= 45
        pageViewController.view.frame = frame
        pageViewController.setViewControllers([self.viewControllerArray[type]], direction: .forward, animated: true, completion: nil)
        
        if self.type == 0{
            self.allOrderBtn.isSelected = true
            selectedBtn = self.allOrderBtn
            self.title = NSLocalizedString("Hint_44", comment: "全部")
        } else if self.type == 1 {
            self.prepareToPayBtn.isSelected = true
            selectedBtn = self.prepareToPayBtn
            self.title = NSLocalizedString("Pendingpayment", comment: "待付款")
            
        } else if self.type == 2 {
            self.prepareToSendBtn.isSelected = true
            selectedBtn = self.prepareToSendBtn
            self.title = NSLocalizedString("Waitingfordelivery", comment: "待发货")
            
        } else if self.type == 3 {
            self.prepareToReceiveBtn.isSelected = true
            selectedBtn = self.prepareToReceiveBtn
            self.title = NSLocalizedString("Waitingforreceipt", comment: "待收货")
            
        } else if self.type == 4{
            self.prepareToTalkBtn.isSelected = true
            selectedBtn = self.prepareToTalkBtn
            self.title = NSLocalizedString("Waitingforevaluation", comment: "待评价")
        }
        self.sliderLine = UILabel()
        self.sliderLine.frame = CGRect(x: kScreenWidth/5 * CGFloat(self.type), y: 42, width: kScreenWidth/5, height: 2)
        self.sliderLine.backgroundColor = UIColor(hexString: "E53D3D")
        self.view.addSubview(self.sliderLine)

    prepareToPayBtn.setTitle(NSLocalizedString("Pendingpayment", comment: "待付款"), for: .normal)
        
        allOrderBtn.setTitle(NSLocalizedString("Hint_44", comment: "全部"), for: .normal)
    prepareToSendBtn.setTitle(NSLocalizedString("Waitingfordelivery", comment: "待发货"), for: .normal)

    prepareToReceiveBtn.setTitle(NSLocalizedString("Waitingforreceipt", comment: "待收货"), for: .normal)
        prepareToTalkBtn.setTitle(NSLocalizedString("Waitingforevaluation", comment: "待评价"), for: .normal)
        // Do any additional setup after loading the view.
    }
 
    @IBAction func btnCliked(_ sender: UIButton) {
        if sender.tag == 0 {
            self.title = NSLocalizedString("Hint_44", comment: "全部")
        }
        else if sender.tag == 1 {
            self.title = NSLocalizedString("Pendingpayment", comment: "待付款")
        }
        else if sender.tag == 2 {
            self.title = NSLocalizedString("Waitingfordelivery", comment: "待发货")
        }

        else if sender.tag == 3 {
            self.title = NSLocalizedString("Waitingforreceipt", comment: "待收货")
        }
        else if sender.tag == 4 {
            self.title = NSLocalizedString("Waitingforevaluation", comment: "待评价")
        }
        UIView.animate(withDuration: 0.1) {
            self.sliderLine.frame = CGRect(x: sender.frame.origin.x, y: 42, width: sender.frame.size.width, height: 2)
        }
        self.selectedViewController(atButton: sender )
    }
    // 重写父类刷新按钮方法
    override func viewControllerTransition(toIndex index: Int) {
        
        let btn = self.buttonArray[index]
        UIView.animate(withDuration: 0.1) {
            self.sliderLine.frame = CGRect(x: btn.frame.origin.x, y: 42, width: btn.frame.size.width, height: 2)
        }
        self.title = btn.titleLabel?.text

        if selectedBtn === btn {
            
            return
        }
        selectedBtn.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.reset()
        self.navigationController?.navigationBar.isHidden = false
//    self.navigationController?.navigationBar.backgroundColor  = UIColor.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
