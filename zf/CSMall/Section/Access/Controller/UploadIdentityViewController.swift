//
//  UploadIdentityViewController.swift
//  CSLiving
//
//  Created by apple on 04/08/2017.
//  Copyright © 2017 taoh. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON
enum IdentifyType: Int {
    case showUpperBody = 0
    case UpperBody = 1
    case showPossession = 2
    case Possession = 3
    case showfronIdCard = 4
    case fronIdCard = 5
    case showbackIdCard = 6
    case backIdCard = 7
}
class ImgPathModel: HandyJSON {
    
    var merchants_img:String?
    var img_type:String?
    
    required init(){}
}

class UploadIdentityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var registerModel = RegisterInfoModel()
    
    var info = [ApplyInfo]()
    var shopInfo:CSUserInfoModel!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var personIdentifys = [UIImage]()
    var shopIdentifys = [UIImage]()
    var currentIndex = IndexPath()
    var userCommitImg:Bool = false //用户是否可以提交资料
    
    var params = [String:Any]()
    
    var images:[ImgPathModel] = [ImgPathModel]()//上传的图片参数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Businessentryapplication", comment: "商家入驻申请")
        collectionView.backgroundColor = UIColor.white
        
        self.personIdentifys = [UIImage.init(named: "1")!,
                                UIImage.init(named: "2")!,
                                UIImage.init(named: "3")!,
                                UIImage.init(named: "4")!,
                                UIImage.init(named: "5")!,
                                UIImage.init(named: "6")!,
                                UIImage.init(named: "7")!,
                                UIImage.init(named: "8")!]
        
        self.shopIdentifys = [UIImage.init(named: "9")!]
        
        collectionView.register(UINib.init(nibName: "UploadIdentifyCell", bundle: nil), forCellWithReuseIdentifier: "UploadIdentifyCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UploadHeaderView")
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize.init(width: (kScreenWidth - 70)/2, height: (kScreenWidth - 70)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return personIdentifys.count
        }else{// if section == 1
            return shopIdentifys.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 28, bottom: 12, right: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadIdentifyCell", for: indexPath) as! UploadIdentifyCell
        if indexPath.section == 0{
            cell.identifyImage.image = personIdentifys[indexPath.row]
        }else{
            cell.identifyImage.image = shopIdentifys[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return  CGSize.init(width: kScreenWidth, height: section == 0 ? 74 : 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header: UICollectionReusableView?
        header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader
            , withReuseIdentifier: "UploadHeaderView", for: indexPath)
        header?.backgroundColor = RGBA(r: 239, g: 239, b: 239, a: 1)
        
        for view in(header?.subviews)!{
            view.removeFromSuperview()
        }
        if indexPath.section == 0{
            let centerLab = UILabel()
            centerLab.text = NSLocalizedString("Uploadvoucher", comment: "上传凭证(可二选一)")
            centerLab.font = UIFont.systemFont(ofSize: 12)
            centerLab.textColor = UIColor.init(hexString: "#666666")
            header?.addSubview(centerLab)
            
            centerLab.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(160)
                make.top.equalTo(0)
                make.height.equalTo(32)
            }
            header?.addSubview(centerLab)
            let view = UIView()
            view.backgroundColor = UIColor.white
            header?.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.width.equalTo(kScreenWidth)
                make.top.equalTo(32)
                make.height.equalTo(44)
            }
            let showText = UILabel()
            showText.text = NSLocalizedString("UploadIDcard", comment:"上传身份证(请保持证件内容清晰可见)")
            showText.font = UIFont.systemFont(ofSize: 12)
            view.addSubview(showText)
            showText.textAlignment = .left
            showText.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(0)
                make.width.equalTo(305)
                make.height.equalTo(44)
            }
            header?.addSubview(centerLab)
        }else{
            
            let view = UIView()
            view.backgroundColor = UIColor.white
            header?.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.width.equalTo(kScreenWidth)
                make.top.equalTo(10)
                make.height.equalTo(44)
            }
            let showText = UILabel()
            showText.text = NSLocalizedString("UniqueIDcodeofcompany", comment: "上传三证合一照")
            showText.font = UIFont.systemFont(ofSize: 12)
            view.addSubview(showText)
            showText.textAlignment = .left
            showText.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(0)
                make.width.equalTo(kScreenWidth - 15)
                make.height.equalTo(44)
            }
        }
        return  header!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch IdentifyType.init(rawValue: indexPath.row)! {
            case .showUpperBody:
                print("我是展示:上半身照片")
                
            case .UpperBody:
                print("选择上半身照片")
                clickAvatar(indexPath:indexPath)
                
            case .showPossession:
                print("我是展示:选择手持照片")
            case .Possession:
                print("选择手持照片")
                clickAvatar(indexPath:indexPath)
                
            case .showfronIdCard:
                print("我是展示:选择正面照片")
            case .fronIdCard:
                print("选择正面照片")
                clickAvatar(indexPath:indexPath)
                
            case .showbackIdCard:
                print("我是展示:选择背面照片")
            case .backIdCard:
                print("选择背面照片")
                clickAvatar(indexPath:indexPath)
            }
        }
        if indexPath.section == 1 {
            print("选择企业证书")
            clickAvatar(indexPath:indexPath)
            
        }
        currentIndex = indexPath
        
    }
    
    //MARK: 点击事件
    func clickAvatar(indexPath:IndexPath) {//点击头像
        
        //        func clickAvatar() {//点击头像
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: NSLocalizedString("Uploadingfromthealbum", comment: "从相册上传"), style: .default, handler: { (acion) in
            self.openImagePickerController(sourceType: .photoLibrary,indexPath:indexPath)
        })
        let action2 = UIAlertAction(title: NSLocalizedString("takeaphoto", comment: "拍照"), style: .default, handler: { (acion) in
            self.openImagePickerController(sourceType: .camera,indexPath:indexPath)
        })
        let cancelAction = UIAlertAction(title:NSLocalizedString("Cancel", comment: "取消"), style: .cancel, handler:nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        //        }
        //        self.openImagePickerController(sourceType: .camera,indexPath:indexPath)
    }
    // 设置 imagePicker 导航栏
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:defaultFont(size: 16)]
        navigationController.navigationBar.barTintColor = themeColor
    }
    func openImagePickerController(sourceType :UIImagePickerControllerSourceType,indexPath:IndexPath) {
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            pickerVC.sourceType = sourceType
        }
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //            updateAvatarImage(img: image)
            let imgPath = image.saveToLocalTempFolder()
            if currentIndex.section == 0{
                personIdentifys[currentIndex.row] = UIImage.init(contentsOfFile: imgPath!)!
                
                if currentIndex.row == 1{
                    registerModel.legal_img = URL.init(fileURLWithPath: imgPath!)
                    uploadImg(type: "legal_img", imageurl: registerModel.legal_img!)
                }
                else if currentIndex.row == 3{
                    registerModel.legal_hand_img = URL.init(fileURLWithPath: imgPath!)
                    uploadImg(type: "legal_hand_img", imageurl: registerModel.legal_hand_img!)
                }
                else if currentIndex.row == 5{
                    registerModel.legal_face_img = URL.init(fileURLWithPath: imgPath!)
                    uploadImg(type: "legal_face_img", imageurl: registerModel.legal_face_img!)
                }
                else if currentIndex.row == 7{
                    registerModel.legal_opposite_img = URL.init(fileURLWithPath: imgPath!)
                    uploadImg(type: "legal_opposite_img", imageurl: registerModel.legal_opposite_img!)
                }
            }else{
                
                shopIdentifys[currentIndex.row] = UIImage.init(contentsOfFile: imgPath!)!
                
                if currentIndex.row == 0{
                    registerModel.business_img =  URL.init(fileURLWithPath: imgPath!)
                    uploadImg(type: "business_img", imageurl: registerModel.business_img!)
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commitClick(_ sender: UIButton) {
        //身份验证信息不为空,即通过
        if (registerModel.legal_img != nil && registerModel.legal_hand_img != nil && registerModel.legal_face_img != nil && registerModel.legal_opposite_img != nil) || registerModel.business_img != nil {
            
            params["contact_name"] = registerModel.contact_name
            params["contact_mobile"] = registerModel.contact_mobile
            params["merchants_name"] = registerModel.merchants_name
            params["business_number"] = registerModel.business_number
            params["merchants_address"] = registerModel.merchants_address
            params["merchants_province"] = registerModel.merchants_province
            params["merchants_city"] = registerModel.merchants_city
            params["merchants_country"] = registerModel.merchants_country
            //            params["json"] = images.toJSONString()!
            NetworkingHandle.fetchNetworkData(url: "/api/Merchant/sub_material", at: self, params: params, success: { (response) in
                let detail = ToApplyDetailViewController()
                detail.type = 1
                self.navigationController?.pushViewController(detail, animated: true)
            }) {
                
            }
        }else{
            ProgressHUD.showMessage(message:NSLocalizedString("Pleaseuploadthedocumentsasrequired", comment:  "请按照要求上传证件"))
        }
        
    }
    
    func  uploadImg(type:String,imageurl:URL){
        //FIXME:TH等待数据
        
        NetworkingHandle.uploadPicture(url:"/api/login/upload",atVC: self, image: imageurl, uploadSuccess:{(result) in
            if let urlData = result["data"] as? NSArray{
                self.params[type] = urlData.firstObject ?? ""
            }else{
                ProgressHUD.showMessage(message: NSLocalizedString("UploadError", comment: "上传出错了，请重新上传该图片"))
            }
        })
        
    }
    
}

