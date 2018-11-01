//
//  BaseViewController.swift
//  FYH
//
//  Created by 梁毅 on 2017/6/6.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
//    let imgBG = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
//        self.view.insertSubview(imgBG, at: 0)
//        imgBG.snp.makeConstraints { (make) in
//            make.edges.equalTo(0)
//        }
//        imgBG.image = #imageLiteral(resourceName: "icon_zhengtibg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
