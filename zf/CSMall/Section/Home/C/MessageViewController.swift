//
//  MessageViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/17.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class MessageViewController: PageViewController {
    
    @IBOutlet weak var systemBtn: UIButton!
    
    @IBOutlet weak var orderBtn: UIButton!
    
    
    @IBOutlet weak var bottomLine: UILabel!
    
    var sliderLine : UILabel!
    var selectedBtn: UIButton!
    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    systemBtn.setTitle(NSLocalizedString("Hint_210", comment: "系统消息"), for: .normal)
        
    orderBtn.setTitle(NSLocalizedString("Hint_211", comment: "订单消息"), for: .normal)
        
        type = 0
        let system = MessagDetailViewController()
        let order = MessagDetailViewController()
 
        
        system.doType = 0
        order.doType = 1

        
        self.viewControllerArray = [system, order]
        
        self.buttonArray = [systemBtn, orderBtn]
        self.title = NSLocalizedString("Hint_27", comment: "平台消息")
        var frame = self.view.bounds
        frame.origin.y = 45
        frame.size.height -= 45
        pageViewController.view.frame = frame
        pageViewController.setViewControllers([self.viewControllerArray[type]], direction: .forward, animated: true, completion: nil)
        
        if self.type == 0{
            self.systemBtn.isSelected = true
            selectedBtn = self.systemBtn
            
        } else if self.type == 1 {
            self.orderBtn.isSelected = true
            selectedBtn = self.orderBtn
            
        }
        self.sliderLine = UILabel()
        self.sliderLine.frame = CGRect(x: kScreenWidth/2 * CGFloat(self.type), y: 42, width: kScreenWidth/2, height: 2)
        self.sliderLine.backgroundColor = UIColor(hexString: "E53D3D")
        self.view.addSubview(self.sliderLine)
        
    }
    
    @IBAction func btnCliked(_ sender: UIButton) {
       
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
        self.navigationController?.navigationBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
