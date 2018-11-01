//
//  XGiftChannelView.swift
//  XGiftAnimation
//
//  Created by sajiner on 2016/12/19.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import Kingfisher

enum XGiftChannelState {
    case idle, animating, willEnd, endAnimating
}

class XGiftChannelView: UIView {

    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: XDigitLabel!
    
    fileprivate var currentNumber = 0
    fileprivate var cacheNumber = 0
    var state: XGiftChannelState = .idle
    
    var complectionCallback: ((XGiftChannelView)->())?
    
    var giftModel: XGiftModel? {
        didSet {
            guard let giftModel = giftModel else { return }
            iconImageView.kf.setImage(with: URL(string: giftModel.senderURL))
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = giftModel.giftName
            giftImageView.kf.setImage(with: URL(string:  giftModel.giftURL))
            digitLabel.text = "x\(giftModel.giftNum)"

            state = .animating
            self.performAnimation()
        }
    }
}

//MARK: - 对外开放的方法
extension XGiftChannelView {
    class func loadFromNib() -> XGiftChannelView {
        return Bundle.main.loadNibNamed("XGiftChannelView", owner: nil, options: nil)?.first as! XGiftChannelView
    }
    
    func addOnceToCache() {
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cacheNumber += 1
        }
    }
}

//MARK: - 执行动画
extension XGiftChannelView {
    fileprivate func performAnimation() {
//        digitLabel.text = "x1"
//        digitLabel.text = " x\(currentNumber) "
        digitLabel.alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = 0
            self.alpha = 1.0
        }, completion: { (isFinished) in
            self.performDigitAnimation()
        })
    }
    
    fileprivate func performDigitAnimation() {
        currentNumber += 1
//        digitLabel.text = " x\(currentNumber) "
        digitLabel.showDigitAnimation({
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3)
            }
        })
    }
    
    @objc fileprivate func performEndAnimation() {
        state = .endAnimating
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { (isFinished) in
            self.currentNumber = 0
            self.giftModel = nil
            self.frame.origin.x = -self.bounds.width
            self.digitLabel.alpha = 0
            self.state = .idle
            self.cacheNumber = 0
            
            if let complectionCallback = self.complectionCallback {
                complectionCallback(self)
            }
        })
    }
}

//MARK: - 设置界面
extension XGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.clear.cgColor
    }
}
