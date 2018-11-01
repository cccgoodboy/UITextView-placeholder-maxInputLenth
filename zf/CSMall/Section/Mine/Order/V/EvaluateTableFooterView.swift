//
//  EvaluateTableFooterView.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/23.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

class EvaluateTableFooterView: UIView {
    @IBOutlet weak var shopLab: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    var confirmSuccess: ((Int,Int)->())?
      var logisticsstars: TggStarEvaluationView!
      var servicestars: TggStarEvaluationView!
    @IBOutlet weak var submitBtn: UIButton!
    var model:QueryOrderViewModel!{
        willSet(m){
            merchant.sd_setImage(with: URL.init(string: m.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        }
    }
    
    @IBOutlet weak var merchant: UIImageView!
    

    var serviceStart =  5
    var logistics = 5
    @IBOutlet weak var logisticsView: UIView!
    @IBOutlet weak var serviceView: UIView!
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        self.confirmSuccess?(self.logistics,self.serviceStart)
        
    }
//    class func set()->EvaluateTabFooterView{
//        return Bundle.main.loadNibNamed("EvaluateTableFooterView", owner: self, options: nil)?.first as! EvaluateTabFooterView
//    }
    @IBOutlet weak var s_lab: UILabel!
    
    @IBOutlet weak var l_lab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        submitBtn.backgroundColor = themeColor
        
        logisticsstars = TggStarEvaluationView()
        logisticsstars.starCount = UInt(logistics)
        logisticsstars.frame = logisticsView.bounds
        logisticsstars.backgroundColor = UIColor.white
        logisticsstars.isTapEnabled = true
        logisticsstars.evaluateViewChooseStarBlock = { count in
            self.logistics = Int(count)
        }
        self.logisticsView.addSubview(logisticsstars)
        
        servicestars = TggStarEvaluationView()
        servicestars.starCount = UInt(logistics)
        servicestars.frame = logisticsView.bounds
        servicestars.backgroundColor = UIColor.white
        servicestars.isTapEnabled = true
        servicestars.evaluateViewChooseStarBlock = { count in
            self.serviceStart = Int(count)
        }
        self.serviceView.addSubview(servicestars)
        shopLab.text = NSLocalizedString("Hint_75", comment: "店铺评分")
        l_lab.text = NSLocalizedString("Hint_76", comment: "物流评分")
        s_lab.text = NSLocalizedString("Hint_77", comment: "服务评分")
        confirmBtn.setTitle(NSLocalizedString("Hint_78", comment: "确定"), for: .normal)
    }

}
