//
//  LyAlertView.swift
//  CrazyEstate
//
//  Created by Luiz on 2017/2/20.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import SnapKit
class LyAlertView: UIView {
    
    var contentView: UIView!
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    var cancelBtn: UIButton!
    var okBtn: UIButton!
    var line: UIView!
    
    var cancelBlock: (() ->())?
    var okBlock: (() ->())?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor(hexString: "171A1D").withAlphaComponent(0.4)
        
        let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        window.addSubview(self)
        
        setupSubviews()
    
        self.alpha = 0.1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })
    }
    func setupSubviews() {
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 4
        self.addSubview(contentView)
        
        line = UIView()
        line.backgroundColor = UIColor(hexString: "#D8D8D8")
        contentView.addSubview(line)
        
        titleLabel = UILabel()
        titleLabel.font = defaultFont(size: 14)
        titleLabel.textColor = UIColor(hexString: "#292F36")
        
        messageLabel = UILabel()
        messageLabel.font = defaultFont(size: 14)
        messageLabel.textColor = UIColor(hexString: "#292F36")
        messageLabel.numberOfLines = 3
        
        
        cancelBtn = UIButton()
        cancelBtn.titleLabel?.font = defaultFont(size: 14)
        cancelBtn.setTitleColor(UIColor(hexString: "#292F36"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(LyAlertView.cancelButtonAction), for: .touchUpInside)
        
        okBtn = UIButton()
        okBtn.titleLabel?.font = defaultFont(size: 14)
        okBtn.setTitleColor(UIColor(hexString: "#292F36"), for: .normal)
        okBtn.addTarget(self, action: #selector(LyAlertView.okButtonAction), for: .touchUpInside)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(okBtn)
        
        contentView.snp.makeConstraints { [unowned self] (make) in
            make.leading.equalTo(self.snp.leading).inset(60)
            make.trailing.equalTo(self.snp.trailing).inset(60)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).inset(15)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(-15)
            make.leading.equalTo(contentView.snp.leading).inset(15)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).inset(-15)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(1)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).inset(15)
            make.top.equalTo(line.snp.bottom).inset(-10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.height.equalTo(36)
        }
        okBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(cancelBtn.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
            make.height.equalTo(36)
        }
    }
    func cancelButtonAction() {
        dismiss()
        self.cancelBlock?()
    }
    func okButtonAction() {
        dismiss()
        self.okBlock?()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.1
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

    class func alert(atVC: UIViewController? = nil, title: String = "提示", message: String, cancel: String = "取消", ok: String, okBlock: @escaping () -> (), cancelBlock: (() -> ())? = nil) {
        if atVC == nil {
            let alert = LyAlertView()
            alert.titleLabel.text = title
            alert.messageLabel.text = message
            alert.cancelBlock = cancelBlock
            alert.cancelBtn.setTitle(cancel, for: .normal)
            alert.okBtn.setTitle(ok, for: .normal)
            alert.okBlock = okBlock
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ok, style: .default) { (action) in
            okBlock()
        }
        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { (action) in
            cancelBlock?()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        atVC?.present(alert, animated: true, completion: nil)
    }
}
