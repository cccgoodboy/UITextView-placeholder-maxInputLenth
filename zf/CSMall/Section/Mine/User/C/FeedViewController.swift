//
//  FeedViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/19.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var placeholder: UILabel!
    
    @IBOutlet weak var sureBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = themeColor.cgColor
        sureBtn.backgroundColor = themeColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.textViewNotifition(noti:)), name: NSNotification.Name.UITextViewTextDidChange, object: textView)
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [FeedViewController.self]
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    

    func textViewNotifition(noti: Notification) {
        let textVStr = textView.text!
        if textVStr.characters.count > 0 {
            placeholder.isHidden = true
        } else {
            placeholder.isHidden = false
        }
        if (textVStr.characters.count > 500) {
            let str = textVStr.substring(to: textVStr.at(500))
            textView.text = str
        }
        count.text = "\(textView.text.characters.count)/500"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if textView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).characters.count <= 15 {
            ProgressHUD.showNoticeOnStatusBar(message: "内容不能少于15个字)")
            return
        }
        NetworkingHandle.fetchNetworkData(url: "/api/User/feedback", at: self, params: ["content":self.textView.text], isShowHUD: true, success: { (response) in
            ProgressHUD.showMessage(message: "提交成功")
            self.textView.resignFirstResponder()
            self.navigationController?.popViewController(animated: true)
        }) {
            
        }
    }
    
}
