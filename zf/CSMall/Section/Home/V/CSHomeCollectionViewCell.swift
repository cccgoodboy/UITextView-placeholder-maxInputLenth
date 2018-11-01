//
//  CSHomeCollectionViewCell.swift
//  CSMall
//
//  Created by taoh on 2017/11/24.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class CSHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var isLiveLab: UILabel! //是否直播中
    
    @IBOutlet weak var h_mimg: UIImageView!
    @IBOutlet weak var liveState: UIView!
    @IBOutlet weak var h_addressimg: UIImageView!
    @IBOutlet weak var h_mnameLab: UILabel!
    @IBOutlet weak var h_maddress: UILabel!
    @IBOutlet weak var h_mtitle: UILabel!
    @IBOutlet weak var h_mtype: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        isLiveLab.backgroundColor = themeColor
        
    }
    func refershData(data:QueryLiveListByClassModel){
        
        isLiveLab.isHidden = data.live_id == "0" ? true : false
        liveState.isHidden = data.live_id == "0" ? true : false
        h_mtitle.isHidden = data.live_id == "0" ? true : false
        if data.live_id != "0"{
            h_mtitle.text = data.title
        }else{
            h_mtitle.text = ""
        }
        var str = ""
        h_maddress.text = data.city ?? ""
        if data.goods_class != nil{
            for item in (data.goods_class?.enumerated())!{
                
                str += "#\(item.element.class_name ?? "") "
            }
        }
        if data.city == ""{
            h_addressimg.isHidden = true
        }else{
             h_addressimg.isHidden = false
        }
        h_mtype.text = str
        h_mnameLab.text = data.merchants_name
        h_mimg.sd_setImage(with:URL.init(string:data.merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
    }
  

}
