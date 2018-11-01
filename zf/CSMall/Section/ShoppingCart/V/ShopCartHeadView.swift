//
//  ShopCartHeadView.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/15.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ShopCartHeadView: UITableViewHeaderFooterView {
    
    
    var model: [ShopCarBeanModel]!{
        willSet(m){
            
        }
    }
    //声明一个属性btnClickBlock，type为闭包可选类型
    //闭包类型：()->() ，无参数，无返回值
    var btnClickBlock:(()->())?;

    var headerbtnClickBlock:((UIButton)->())?;

 
    @IBAction func selectMerchantClick(_ sender: UIButton) {
        

//        for index in model.indices{
//            model[index].isSelected = !model[index].isSelected
//            sender.isSelected = model[index].isSelected
//        }

        self.headerbtnClickBlock?(sender)

    }
    @IBOutlet weak var cleanNoValidBtn: UIButton!

    @IBAction func cleanNoValidClick(_ sender: UIButton) {
        
        if self.btnClickBlock != nil {
            //点击按钮执行闭包
            //注意：属性btnClickBlock是可选类型，需要先解包
            self.btnClickBlock!();
        }
        
    }
    @IBOutlet weak var selectMerchantBtn: UIButton!
    @IBOutlet weak var merchantImg: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var merchantImgWidth: NSLayoutConstraint!
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    
 

    
}
