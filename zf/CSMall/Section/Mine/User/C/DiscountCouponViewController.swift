//
//  DiscountCouponViewController.swift
//  CSMall
//
//  Created by taoh on 2017/9/22.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class DiscountCouponViewController: PageViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    var selectedBtn: UIButton!
    var line: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的优惠券"
        selectedBtn = btn1

        line = UILabel(frame: CGRect(x: 0, y: 45, width: kScreenWidth/3, height: 2))
        line.backgroundColor = UIColor(hexString: "BD151D")
        view.addSubview(line)

        
        buttonArray = [btn1, btn2, btn3]
        
        let vc1 = DiscountCouponDetailViewController()
        vc1.couponType = .DiscountCoupon_NotUse

        let vc2 = DiscountCouponDetailViewController()
        vc2.couponType = .DiscountCoupon_HavedUse
        
        let vc3 = DiscountCouponDetailViewController()
        vc3.couponType = .DiscountCoupon_OutOfDate
        
        var frame = self.view.bounds
        frame.origin.y = 46
        frame.size.height -= frame.origin.y
        pageViewController.view.frame = frame
        viewControllerArray = [vc1, vc2, vc3]
        pageViewController.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)

    }
    @IBAction func buttonAction(_ sender: UIButton) {
        selectedViewController(atButton: sender)
    }
    
    override func viewControllerTransition(toIndex index: Int) {
        let btn = self.buttonArray[index]
        
        if selectedBtn === btn {
            return
        }
        var frame = line.frame
        frame.origin.x = CGFloat(index) * kScreenWidth/3
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.line.frame = frame
        }
        selectedBtn.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
  
}
