//
//  LivingMoreItemView.swift
//  DragonVein
//
//  Created by Luiz on 2017/4/12.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class LivingMoreItemView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lianmai: UIButton!
    @IBOutlet weak var jingxiang: UIButton!
    @IBOutlet weak var meiyan: UIButton!
    
    var selectedItem: ((Int)->())?
    
    class func show(atView: UIView, isAuthLM: Bool, isOpenJX: Bool, selectedItem: @escaping ((Int)->())) -> LivingMoreItemView {
        let selfView = Bundle.main.loadNibNamed("LivingMoreItemView", owner: nil
            , options: nil)!.first as! LivingMoreItemView
        selfView.lianmai.isSelected = isAuthLM
        selfView.jingxiang.isSelected = isOpenJX
        selfView.selectedItem = selectedItem
        atView.addSubview(selfView)
        selfView.showTheView()
        return selfView
    }

    @IBAction func lianmaiButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.selectedItem?(1)
    }
    @IBAction func jingxiangButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.selectedItem?(2)
    }
    @IBAction func meiyanButtonAction(_ sender: UIButton) {
        dismiss()
        self.selectedItem?(3)
    }
    
    @IBAction func bmgButtonAction(_ sender: UIButton) {
        dismiss()
        self.selectedItem?(4)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0 , width: kScreenWidth, height: kScreenHeight)
        self.lianmai.setTitleColor(themeColor, for: .selected)
        self.jingxiang.setTitleColor(themeColor, for: .selected)
        self.backgroundView.layer.cornerRadius = 6
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissButtonAction))
        self.addGestureRecognizer(tap)
    }
    func dismissButtonAction() {
        self.dismiss()
    }
    
    private  func showTheView() {
        var frame = self.backgroundView.frame
        let oldFrame =  frame
        self.alpha = 0.1
        frame.origin.y = self.frame.size.height
        self.backgroundView.frame = frame
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.frame = oldFrame
            self.alpha = 1
        })
    }
    private func dismiss() {
        var frame = self.backgroundView.frame
        frame.origin.y += frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.frame = frame
            self.alpha = 0.1
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}
