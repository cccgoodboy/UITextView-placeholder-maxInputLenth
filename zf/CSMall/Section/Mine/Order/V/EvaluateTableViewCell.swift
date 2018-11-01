//
//  EvaluateTableViewCell.swift
//  BaiShiXueYiLiving
//
//  Created by sh-lx on 2017/6/23.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import HandyJSON
class EvaluateTableViewCell: UITableViewCell,UITextViewDelegate,HXPhotoViewDelegate{
    @IBOutlet weak var goodsImage: UIImageView!

    @IBOutlet weak var starView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addPhotoView: UIView!
    
    @IBOutlet weak var placeHolderLab: UILabel!
    var onePhotoView:HXPhotoView!
    var oneManager:HXPhotoManager!
//    var addBtn:UIButton!
    var stars: TggStarEvaluationView!
    var imagesData: [UIImage] = []
    
    let model = SubcommentModel()
    
    var submitModel: ((SubcommentModel)->())?
    var tmodel:OrderGoodsBeansModel!{
        willSet(m){
            model.goods_id = m.goods_id
            model.order_goods_id = m.order_goods_id
            self.goodsImage.sd_setImage(with: URL.init(string: m.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        }
    }
    var currentModel: SubcommentModel = SubcommentModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
        oneManager = HXPhotoManager.init(type: HXPhotoManagerSelectedTypePhoto)
        oneManager.maxNum = 3
        oneManager.photoMaxNum = 3
        oneManager.showDeleteNetworkPhotoAlert = false
        oneManager.style = HXPhotoAlbumStylesWeibo
        onePhotoView = HXPhotoView.init(frame: CGRect.init(x: 0, y: 3, width: kScreenWidth - 30, height: 60) , with: oneManager)
        onePhotoView.lineCount = 6
        onePhotoView.delegate = self
        
        addPhotoView.addSubview(onePhotoView)
      placeHolderLab.text = NSLocalizedString("Hint_80", comment: "请输入对该商品的评价")

    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0{
            self.placeHolderLab.isHidden = false
        }else{
            self.placeHolderLab.isHidden = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.model.content = textView.text
        self.model.goods_id = self.tmodel.goods_id
        self.model.order_goods_id = self.tmodel.order_goods_id
        self.submitModel?(model)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        stars = TggStarEvaluationView()
        stars.starCount = UInt(self.model.mark)
        stars.frame = CGRect(x: 0, y: (60 - 45)/2, width:240, height: 45)
        stars.backgroundColor = UIColor.white
        stars.isTapEnabled = true
        stars.evaluateViewChooseStarBlock = { count in
            self.model.mark = Int(count)
            self.model.goods_id = self.tmodel.goods_id
            self.model.order_goods_id = self.tmodel.order_goods_id
            self.submitModel?(self.model)
        }
        self.starView.addSubview(stars)
    
    }
    func photoView(_ photoView: HXPhotoView!, changeComplete allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        

        if photos.count == 0{
            return
        }else{
            ProgressHUD.showLoading(toView: self, message: NSLocalizedString("Hint_79", comment: "加载中。。。"))
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
                                self.model.img = ""
                                self.model.thumb = ""
                                for str in imgArr{
                                    self.model.img = self.model.img! + str + ","
                                }
                                let index = self.model.img.index(self.model.img.endIndex, offsetBy: -1)
                                self.model.img = self.model.img.substring(to: index)
                                self.model.goods_id = self.tmodel.goods_id
                                self.model.order_goods_id = self.tmodel.order_goods_id
                                self.submitModel?(self.model)
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

    }
    
}

class SubcommentModel: HandyJSON {
    var goods_id : String!
    var order_goods_id:String?//订单商品ID可能相同，他唯一
    var mark = 5
    var content: String!
    var img: String!
    var thumb: String?
    required init(){}
}
