//
//  BBSAddPhotoView.swift
//  FKDCClient
//
//  Created by 曾觉新 on 2017/2/26.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

protocol BBSAddPhotoViewDelegate {
    func bbsAddPhotoView(addPhotoView: BBSAddPhotoView, clickButton index:Int)
}

class BBSAddPhotoView: UIView {
    
    var myDelegate: BBSAddPhotoViewDelegate?
    
    var addButton: UIButton!
    var imagesData: [UIImage] = []
    var namesArr: [String] = []
    
    
    private let butWidth = (kScreenWidth - 30 - 5 * 3.0) / 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initViews() {
        addButton = UIButton(type: .custom)
        addButton.tag = 100
        addButton.frame = CGRect(x: 0, y: 0, width: butWidth, height: butWidth)
        addButton.setImage(UIImage(named: "tuikuang_shch"), for: .normal)
        addButton.addTarget(self, action: #selector(clickButton(sender: )), for: .touchUpInside)
        self.addSubview(addButton)
        
    }
    
    func addPhoto(image: UIImage, name: String) {
        imagesData.append(image)
        namesArr.append(name)
        updateLayout()
    }
    
    
    func removePhoto(index: Int) {
        imagesData.remove(at: index)
//        namesArr.remove(at: index)
        updateLayout()
    }
    
    func clickButton(sender: UIButton) {
        myDelegate?.bbsAddPhotoView(addPhotoView: self, clickButton: sender.tag)
        
    }
    func clickImage(sender: UITapGestureRecognizer) {
        let v = sender.view
        removePhoto(index: (v?.tag)!)
    }
    
    
    
    
    func updateLayout() {
        
        for v in self.subviews {
            if ((v as? UIImageView) != nil) {
                v.removeFromSuperview()
            }
        }
        
        let butGap: CGFloat = 5
        
        imagesData.enumerateKeysAndObjects { (obj, idx) in
            let columnIndex = idx % 4
            let rowIndex = idx / 4
            let imageView = UIImageView(frame: CGRect(x: CGFloat(columnIndex) * (butWidth + butGap), y: CGFloat(rowIndex) * (butWidth + butGap), width: butWidth, height: butWidth))
            imageView.image = obj
            imageView.tag = idx
            imageView.isUserInteractionEnabled = true
            self.addSubview(imageView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickImage(sender:)))
            imageView.addGestureRecognizer(tap)
        }
        if imagesData.count == 9 {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
        
        
        let a = imagesData.count % 4
        let b = imagesData.count / 4
        addButton.frame = CGRect(x: CGFloat(a) * (butWidth + butGap), y: CGFloat(b) * (butWidth + butGap), width: butWidth, height: butWidth)
        
        self.snp.updateConstraints { (make) in
            make.height.equalTo(addButton.frame.size.height + addButton.frame.origin.y)
        }
    }
    
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
