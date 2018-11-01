//
//  PersonTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/10/18.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet var phone: UILabel!
    @IBOutlet var name: UITextField!
    
    @IBOutlet weak var realSexTitleLab: UILabel!
    @IBOutlet weak var phoneTitleLab: UILabel!
    @IBOutlet weak var sexTtileLab: UILabel!
    @IBOutlet var sexLab: UILabel!
    var usermodel:CSUserInfoModel! {
        willSet(m){
            phone.text = m.phone
            name.text = m.username
            if m.sex == "1"{
                sexLab.text = "男"
            }
            else if m.sex == "2"{
                sexLab.text = "女"
            }else{
                sexLab.text = "未公开"
            }
        }
    }
    @IBAction func selectSex(sender: AnyObject) {
        

        
      let alert =  UIAlertController.init(title: "请选择性别", message: "", preferredStyle: .actionSheet)
        let sexf = UIAlertAction.init(title: "女", style: .default) { (alert) in
            self.sexLab.text = "女"
            self.usermodel.sex = "2"
        }
        let sexm = UIAlertAction.init(title: "男", style: .default) { (alert) in
            self.sexLab.text = "男"
            self.usermodel.sex = "1"
        }
        let sexc = UIAlertAction.init(title: "取消", style: .default) { (alert) in
            
        }
        alert.addAction(sexf)
        alert.addAction(sexm)
        alert.addAction(sexc)

        responderViewController()?.present(alert, animated: true, completion: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
            phoneTitleLab.text = NSLocalizedString("Hint_213", comment: "手机号码")
       
       sexTtileLab.text = NSLocalizedString("Hint_214", comment: "昵称")
        
       realSexTitleLab.text = NSLocalizedString("Hint_215", comment: "性别")
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(noti:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    func textFieldDidChange(noti:NSNotification){

        usermodel.username = name.text
    }
    
//    func refershData(model:CSUserInfoModel){
//
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
