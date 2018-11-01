//
//  ApplicationForDrawbackTableViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/9/29.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ApplicationForDrawbackTableViewCell: UITableViewCell,HXPhotoViewDelegate {
    var onePhotoView:HXPhotoView!
    var oneManager:HXPhotoManager!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var showReason: UITextField!
    @IBOutlet weak var reason: UITextView!
    @IBOutlet weak var applyPrice: UILabel!
    var selectBtn:UIButton = UIButton()
    var itemClick:((UIButton,ApplyRefundModel)->())?
    var textDesc:((ApplyRefundModel)->())?
    @IBAction func applyTypeClick(_ sender: UIButton) {
        if sender.tag == 10088{
            itemClick?(sender,model)
        }else{
            if selectBtn === sender {
                return
            }
            selectBtn.isSelected = false
            sender.isSelected = true
            selectBtn = sender
            if sender.tag == 10086{
                model.refund_type  = "1"
                applyPrice.text = String.init(format: "%.2f",Double(model.refund_count)! * Double(model.refund_price)!)
            }else{
                model.refund_type  = "2"
                applyPrice.text = "0.00"
            }
            itemClick?(sender,model)
            
        }
        //        10086 我要退款（未收到货）
        //        10087 我要退货（已收到货）
        //  10088 退款原因
        
    }
    var model:ApplyRefundModel!{
        willSet(m){
            if m.refund_selectNum {
                if m.refund_type == "1"{
                    applyPrice.text = String.init(format: "%.2f",Double(m.refund_count)! * Double(m.refund_price)!)
                }
            }
            showReason.text = m.refund_reason ?? ""
            reason.text = m.refund_desc ?? ""
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textViewNotifition(noti:)), name: NSNotification.Name.UITextViewTextDidChange, object: reason)
        
        oneManager = HXPhotoManager.init(type: HXPhotoManagerSelectedTypePhoto )
        oneManager.maxNum = 3
        oneManager.photoMaxNum = 3
        oneManager.showDeleteNetworkPhotoAlert = false
        oneManager.style = HXPhotoAlbumStylesWeibo
        onePhotoView = HXPhotoView.init(frame: CGRect.init(x: 0, y: 3, width: kScreenWidth - 30, height: 60) , with: oneManager)
        onePhotoView.lineCount = 6
        onePhotoView.delegate = self
        
        photoView.addSubview(onePhotoView)
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    func textViewNotifition(noti: Notification) {
        let textVStr = reason.text!
        if textVStr.characters.count > 0 {
            placeholder.isHidden = true
            model.refund_desc = textVStr
            
            textDesc?(model)
            
        } else {
            placeholder.isHidden = false
        }
        
        if (textVStr.characters.count > 500) {
            let str = textVStr.substring(to: textVStr.at(500))
            reason.text = str
        }
    }
    
    func photoView(_ photoView: HXPhotoView!, changeComplete allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        
        if photos.count == 0{
            return
        }else{
            ProgressHUD.showLoading(toView: self, message: "加载中。。。")
            DispatchQueue.global().async {
                var imageURLs = [URL]()
                
                HXPhotoTools.getImageForSelectedPhoto(photos!, type: HXPhotoToolsFetchOriginalImageTpe) { (image:[UIImage]!) in
                    for item in image{
                        
                        if let filePath = item.imageCompress(forWidth: min(item.size.width, 600)).saveToLocalTempFolder(withCompressionQuality: 1.0) {
                            let fileURL = URL(fileURLWithPath: filePath)
                            imageURLs.append(fileURL)
                            
                        }
                    }
                    DispatchQueue.main.async {
                        ProgressHUD.hideLoading(toView: self)
                        NetworkingHandle.uploadOneMorePicture(url: "/api/login/upload", atVC: self.responderViewController()!, images: imageURLs, uploadSuccess: { (reponse) in
                            if let info = reponse["data"] as? NSArray{
                                let imgArr = info as! [String]
                                self.model.refund_img = ""
                                for str in imgArr{
                                    self.model.refund_img = self.model.refund_img! + str + ","
                                }
                                let index = self.model.refund_img?.index((self.model.refund_img?.endIndex)!, offsetBy: -1)
                                self.model.refund_img = self.model.refund_img?.substring(to: index!)
                                self.model.order_goods_id = self.model.order_goods_id
                                
                                self.textDesc?(self.model)
                            }
                        })
                    }
                }
                
            }
        }
        
    }
    
    func photoView(_ photoView: HXPhotoView!, updateFrame frame: CGRect) {
        onePhotoView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: frame.size.height)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

