//
//  PersonalVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/4.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class PersonalVC:UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ALiImageReshapeDelegate {
    var model = CSUserInfoHandler.getUserInfo()
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var personTab: UITableView!
    
    @IBAction func commitClick(_ sender: UIButton) {
        
        NetworkingHandle.fetchNetworkData(url: "/api/user/edit_user", at: self, params: ["header_img":model?.header_img ?? "","username":model?.username ?? "","sex":model?.sex ?? "" ,"signature":model?.signature ?? ""], hasHeaderRefresh: personTab, success: { (response) in
            ProgressHUD.showMessage(message: "修改成功")
            self.navigationController?.popToRootViewController(animated: true)
        }) {
        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人资料"
        saveBtn.backgroundColor = themeColor
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        personTab.tableFooterView = UIView()
        personTab.register(UINib.init(nibName: "SignTableViewCell", bundle: nil), forCellReuseIdentifier: "SignTableViewCell")
        personTab.register(UINib.init(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonTableViewCell")
        personTab.register(UITableViewCell.self, forCellReuseIdentifier: "headImgCell")
    }
    var params:[String:String] = [String:String]()

    fileprivate lazy var userImage : UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = true
//        imageView.kf.setImage(with:  URL(string:BaseImgURL + (self.model?.head_path)!))
        return imageView
        
    }()
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0{
            return 80
        }
        else if indexPath.section == 1{
            return 132
        }else{
            return 150
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headImgCell", for: indexPath)
            if params.count != 0 && params.allKeys().contains("header_img"){
                userImage.sd_setImage(with: URL.init(string:params["header_img"] ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }else{
                userImage.sd_setImage(with: URL.init(string: model?.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            }
            cell.textLabel?.font = CommonFontSize
            cell.textLabel?.textColor = CommonTextColor
            cell.textLabel?.text = NSLocalizedString("Hint_212", comment: "头像")
            cell.addSubview(userImage)
            userImage.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(10)
                make.width.height.equalTo(60)
            })
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
            if model != nil{
                cell.usermodel = model!
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignTableViewCell", for: indexPath) as! SignTableViewCell
            if model != nil{
                cell.model = model!
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            clickAvatar()
        }
    }
    //MARK: 点击事件
    func clickAvatar() {//点击头像
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "从相册上传", style: .default, handler: { (acion) in
            self.openImagePickerController(sourceType: .photoLibrary)
        })
        let action2 = UIAlertAction(title: "拍照", style: .default, handler: { (acion) in
            self.openImagePickerController(sourceType: .camera)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    // 设置 imagePicker 导航栏
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:defaultFont(size: 16)]
        navigationController.navigationBar.barTintColor = themeColor
    }
    func openImagePickerController(sourceType :UIImagePickerControllerSourceType) {
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            pickerVC.sourceType = sourceType
        }
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imageReshaperControllerDidCancel(_ reshaper: AliImageReshapeController!) {
        reshaper.dismiss(animated: true, completion: nil)
    }
    //MARK: -- ALiImageReshapeDelegate 设置比例裁剪图片
    func imageReshaperController(_ reshaper: AliImageReshapeController!, didFinishPickingMediaWithInfo image: UIImage!) {
        
        let imgPaths = image.saveToLocalTempFolder()
        print(URL.init(fileURLWithPath: imgPaths!))
        NetworkingHandle.uploadPicture(url:"/api/login/upload",atVC: self, image: URL.init(fileURLWithPath: imgPaths!), uploadSuccess:{(result) in
            if let data = result["data"] as? NSArray{
                self.model?.header_img = data.firstObject as? String ?? ""
                self.userImage.sd_setImage(with: URL.init(string: self.model?.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                self.personTab.reloadSections(IndexSet.init(integer: 0), with: .none)
            }
        })
        reshaper.dismiss(animated: true, completion: nil)
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let ali = AliImageReshapeController()
            ali.sourceImage = image
            ali.reshapeScale = 1 //裁剪比例
            ali.delegate = self
            picker.pushViewController(ali, animated: true)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
