//
//  LiveRoomChatView.swift
//  DragonVein
//
//  Created by sh-lx on 2017/3/29.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class LiveRoomChatView: UIView, UITextFieldDelegate {
    
    static var inputViewHeight: CGFloat = 52
    
    var sendBtn: UIButton!
    var textField: UITextField!
    var swithBtn: UIButton!
    var inputBgView: UIView!
    
    var clickSend: ((String, Bool)->())?
    
    class func show(atView: UIView, send: ((String, Bool)->())?) -> LiveRoomChatView {
        let view = LiveRoomChatView(frame: UIScreen.main.bounds)
        view.clickSend = send
        atView.addSubview(view)
        return view
    }
    
    private override init(frame: CGRect) {
       super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        let disBtn = UIButton(frame: frame)
        self.addSubview(disBtn)
        disBtn.addTarget(self, action: #selector(LiveRoomChatView.dismissAction), for: .touchUpInside)
        
        let inputView = UIView(frame: CGRect(x: 0, y: frame.height, width: self.bounds.width, height: LiveRoomChatView.inputViewHeight))
        inputBgView = inputView
        
        inputView.backgroundColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.9)
        self.addSubview(inputView)
        
        let swith = UIButton()
        swith.setImage(#imageLiteral(resourceName: "danmu-on"), for: .selected)
        swith.setImage(#imageLiteral(resourceName: "danmu-off"), for: .normal)
        swith.addTarget(self, action: #selector(LiveRoomChatView.swithButtonAction(btn:)), for: .touchUpInside)
        inputView.addSubview(swith)
        swithBtn = swith
        swith.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputView.snp.centerY).inset(3)
            make.left.equalTo(15)
            make.width.equalTo(52)
        }
        
        sendBtn = UIButton()
        sendBtn.isEnabled = false
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitle("发送", for: .disabled)
        sendBtn.setTitleColor(themeColor, for: .normal)
        sendBtn.titleLabel?.font = defaultFont(size: 16)
        sendBtn.addTarget(self, action: #selector(LiveRoomChatView.sendButtonAction(btn:)), for: .touchUpInside)
        sendBtn.setTitleColor(UIColor(hexString: "#999999"), for: .disabled)
        inputView.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputView.snp.centerY)
            make.right.equalTo(-15)
            make.height.equalTo(36)
            make.width.equalTo(40)
        }
        
        textField = UITextField()
        textField.delegate = self
        textField.returnKeyType = .send
        textField.enablesReturnKeyAutomatically = true
        textField?.attributedPlaceholder = NSAttributedString(string: "和大家说点什么", attributes: [NSForegroundColorAttributeName: UIColor(hexString: "#999999")])
        textField.font = defaultFont(size: 16)
        textField?.textColor = UIColor(hexString: "#999999")
        inputView.addSubview(textField!)
        textField?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(inputView.snp.centerY)
            make.left.equalTo(swith.snp.right).inset(-16)
            make.height.equalTo(36)
            make.right.equalTo(sendBtn.snp.left).inset(-10)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveRoomChatView.textFieldTextDidChange(noti:)), name: Notification.Name.UITextFieldTextDidChange, object: textField)
    }
    func textFieldTextDidChange(noti: Notification) {
        let tf = (noti.object as! UITextField)
        if tf.text?.characters.count == 0 {
            sendBtn.isEnabled = false
        } else {
            sendBtn.isEnabled = true
        }
    }
    func swithButtonAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
    func sendButtonAction(btn: UIButton) {
        clickSend?(textField.text!, swithBtn.isSelected)
        textField.text = ""
        if swithBtn.isSelected {
            textField?.resignFirstResponder()
        }
        btn.isEnabled = false
    }
    func dismissAction() {
        textField?.resignFirstResponder()
        self.isHidden = true
        textField.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonAction(btn: sendBtn)
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
