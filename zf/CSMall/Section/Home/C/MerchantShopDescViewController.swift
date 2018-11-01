//
//  MerchantShopDescViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/14.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class MerchantShopDescViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate{

    @IBOutlet weak var tabView: UITableView!
    var merchantInfo = MerchantsInfoModel()
    var imageData:MWPhoto!
    var liveModel:LiveListModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if merchantInfo.member_id != nil{
            imageData = MWPhoto.init(url:URL.init(string:merchantInfo.business_img ?? "" ))
        }
        title = NSLocalizedString("Hint_22", comment: "店铺简介")
        tabView.estimatedRowHeight = 100
        tabView.rowHeight = UITableViewAutomaticDimension

        tabView.register(UINib.init(nibName: "ShopTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopTableViewCell")
        tabView.register(UINib.init(nibName: "ShowDescLabTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowDescLabTableViewCell")
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: "origalCell")
        if merchantInfo.live_id != "0"{
            NetworkingHandle.fetchNetworkData(url: "/api/Live/live_info", at: self, params: ["live_id":merchantInfo.live_id!], hasHeaderRefresh: tabView, success: { (response) in
                if let data = response["data"] as? NSDictionary{
                    self.liveModel = LiveListModel.deserialize(from: data)
                    self.tabView.reloadData()
                }
            }) {
                
            }
        }
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 3 ? 3 : 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
 
        return merchantInfo.merchants_id != nil ? 5 : 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let  cell  = tableView.dequeueReusableCell(withIdentifier: "ShopTableViewCell", for: indexPath) as! ShopTableViewCell
            cell.model = merchantInfo
            if liveModel?.live_id != nil{
                 cell.livemodel = liveModel
            }
            return cell
            
        }else if indexPath.section == 1{
            let  cell  = tableView.dequeueReusableCell(withIdentifier: "ShowDescLabTableViewCell", for: indexPath) as! ShowDescLabTableViewCell
            cell.model = merchantInfo
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "origalCell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            
            if indexPath.section == 2{
                cell.textLabel?.text = "\(NSLocalizedString("Hint_23", comment: "商家电话"))    \(merchantInfo.contact_mobile ?? "")"
                cell.accessoryType = .disclosureIndicator

            }else if indexPath.section == 3{
                cell.accessoryType = .none

                if indexPath.row == 0{
                    let str = "\(NSLocalizedString("ShopName", comment: "店铺名称"))    \(merchantInfo.merchants_name ?? "")"
                    cell.textLabel?.attributedText = str.stringToAttributedColor(startColor:UIColor.init(hexString: "989898"),string:str,ranStr:"\(merchantInfo.merchants_name ?? "")")

                }else if indexPath.row == 1{
                    let str = "\(NSLocalizedString("Hint_24", comment: "所在地区"))    \(merchantInfo.merchants_address ?? "")"
                    cell.textLabel?.attributedText = str.stringToAttributedColor(startColor:UIColor.init(hexString: "989898"),string:str,ranStr:"\(merchantInfo.merchants_address ?? "")")
                }else{
                    let str = "\(NSLocalizedString("Store time", comment: "开店时间"))    \(merchantInfo.create_time ?? "")"
                    cell.textLabel?.attributedText = str.stringToAttributedColor(startColor:UIColor.init(hexString: "989898"),string:str,ranStr:"\(merchantInfo.create_time ?? "")")
                }
            }else{
                cell.textLabel?.text = NSLocalizedString("Hint_26", comment: "查看执照资质")
                cell.accessoryType = .disclosureIndicator
            }
          
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if merchantInfo.merchants_id != nil || merchantInfo.contact_mobile != nil {
                
                if merchantInfo.contact_mobile != ""{
                    let str = String(format:"telprompt://%@",(merchantInfo.contact_mobile)!)
                    UIApplication.shared.openURL(URL(string:str )!)
                }else{
                    ProgressHUD.showMessage(message: NSLocalizedString("Notconnected", comment: "抱歉，暂时联系不了"))

                }
            }else{
                
            }
        }
        if indexPath.section == 4{
            
//            if
            
            let browser = MWPhotoBrowser.init(delegate: self)
            browser?.setCurrentPhotoIndex(0)
            self.navigationController?.pushViewController(browser!, animated: false)
        }
    }
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
      
        return 1
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
      
        return imageData
    }
}
