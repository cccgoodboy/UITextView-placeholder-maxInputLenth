//
//  AnchorBeautifyView.swift
//  MoDuLiving
//
//  Created by 梁毅 on 2017/2/27.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

protocol AnchorBeautifyViewDelegate {
    func anchorBeautifyView(_ view: AnchorBeautifyView, changeValue value: Float, index: Int)
}

class AnchorBeautifyView: UIView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var beautify: UISlider!
    @IBOutlet weak var red: UISlider!
    @IBOutlet weak var origin: UIButton!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    var beautyValue: Float = 0
    var volume: Float = 0
    
    var delegate: AnchorBeautifyViewDelegate?
    var isMusic = false
    
    class func show(atView: UIView, beautifyValue: Float, volume: Float, accompany: Float, isMusic: Bool = false) -> AnchorBeautifyView {
        let toolBarView = Bundle.main.loadNibNamed("AnchorBeautifyView", owner: nil
            , options: nil)!.first as! AnchorBeautifyView
        toolBarView.beautify.value = beautifyValue
        toolBarView.red.value = accompany
        toolBarView.volume = volume
        toolBarView.beautyValue = beautifyValue
        atView.addSubview(toolBarView)
        toolBarView.showTheView()
        toolBarView.showType(isMusic: isMusic)
        return toolBarView
    }
    func showType(isMusic: Bool) {
        self.isMusic = isMusic
        if isMusic {
            origin.isSelected = false
            
            img1.image = #imageLiteral(resourceName: "yinliang")
            beautify.value = volume
            
//            red.isHidden = false
//            img2.isHidden = false
        } else {
            origin.isSelected = true
            
            img1.image = #imageLiteral(resourceName: "mohu")
            
            beautify.value = beautyValue
//            red.isHidden = true
//            img2.isHidden = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0 , width: kScreenWidth, height: kScreenHeight)
        self.topView.layer.cornerRadius = 6
    }
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss()
    }

    private  func showTheView() {
        var frame = self.backView.frame
        let oldFrame =  frame
        self.alpha = 0.1
        frame.origin.y = self.frame.size.height
        self.backView.frame = frame
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.frame = oldFrame
            self.alpha = 1
        })
    }
    private func dismiss() {
        var frame = self.backView.frame
        frame.origin.y += frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.frame = frame
            self.alpha = 0.1
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    @IBAction func sliderValueChangeAction(_ sender: UISlider) {
        var index = 0
        if sender == red {
            index = 1
        }
        delegate?.anchorBeautifyView(self, changeValue: sender.value, index: index)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if !isMusic {
            return
        }
        let vc = self.responderViewController()!
        let targetVC = LivingBGMViewController.show(atVC: vc)
        targetVC.delegate = vc as? LivingBGMViewControllerDelegate
        self.dismiss()
    }
    
}
