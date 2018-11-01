//
//  Merchant_LivingVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/5.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh
class Merchant_LivingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var allDataArr: [PlayBackListModel] = []
    var liveModel = LiveInfoModel()
    var allPage = 1
    var merchants_id:String?
    var merchant =  MerchantsInfoModel()
  var playerCount = "0"
    @IBOutlet weak var livingTab: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        livingTab.register(UINib.init(nibName: "Merchant_LivingTabCell", bundle: nil), forCellReuseIdentifier: "Merchant_LivingTabCell")
        livingTab.register(UINib.init(nibName: "Merchant_LivingPlayTabCell", bundle: nil), forCellReuseIdentifier: "Merchant_LivingPlayTabCell")
        //购物车没有商品的页面
        self.livingTab.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
            self.loadLiving()
        })
        
        self.livingTab.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        self.livingTab.mj_header.beginRefreshing()
        
    }
    func loadLiving(){
        if merchants_id == nil{
            return
        }
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/merchants_info", at: self, params: ["merchants_id":merchants_id!], isShowHUD: false, isShowError: true, success: { (response) in
            
            self.merchant = MerchantsInfoModel.deserialize(from: response["data"] as? NSDictionary)!
        }) {
            
        }

        NetworkingHandle.fetchNetworkData(url: "/api/live/merchants_live", at: self, params: ["member_id":merchants_id ?? ""], hasHeaderRefresh: livingTab, success: { (response) in
            if let data = response["data"] as? NSDictionary{
                self.liveModel = LiveInfoModel.deserialize(from: data)!
            }
            self.livingTab.reloadData()

        }) {
        
        }
    }
    func loadData(page:Int){
        
        NetworkingHandle.fetchNetworkData(url: "/api/live/playback_list", at: self, params: ["member_id":merchants_id ?? "1","p":page], hasHeaderRefresh: livingTab, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["list"] as? NSArray{
                self.playerCount = (((response["data"] as?NSDictionary)?["count"]) ?? "0") as! String
                
                let list = [PlayBackListModel].deserialize(from: data) as! [PlayBackListModel]
                
                if list.count == 0{
                    self.livingTab.mj_footer.isHidden = true
                    self.livingTab.mj_footer.endRefreshing()
                }
                if page == 1 {
                    self.allDataArr.removeAll()
                }
                self.allDataArr += list
            }
            self.livingTab.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if section == 0{
            if liveModel.play_address == nil{
                return 0
            }else{
                return 1
            }
        }else{
            return allDataArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if  indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Merchant_LivingTabCell", for: indexPath) as! Merchant_LivingTabCell
            cell.backgroundColor = UIColor.clear
            cell.refershData(model:liveModel)
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Merchant_LivingPlayTabCell", for: indexPath) as! Merchant_LivingPlayTabCell
            cell.backgroundColor = UIColor.clear
            cell.refershData(model:allDataArr[indexPath.row])

            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return indexPath.section  == 0 ?  125 : 81
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return section  == 0 ?  CGFloat.leastNormalMagnitude : 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
          
            return UIView()
        }else{
            let header = UIView()
            header.backgroundColor = UIColor.white
            
            let lab = UILabel()
            lab.text = "\(NSLocalizedString("Hint_28", comment: "精 彩 回 放")) (\(playerCount))"
            lab.textAlignment = .center
            
            lab.font = UIFont.systemFont(ofSize: 14)
            header.addSubview(lab)
            
            lab.snp.makeConstraints { (make) in
                make.width.equalTo(147)
                make.height.equalToSuperview()
                make.top.equalToSuperview()
                make.centerX.equalTo(header)
            }
            let leftV = UIView()
            leftV.backgroundColor = RGBA(r: 255, g: 128, b: 0, a: 1)
            header.addSubview(leftV)
            leftV.snp.makeConstraints { (make) in
                make.right.equalTo(lab.snp.left).offset(-4)
                make.height.equalTo(1)
                make.width.equalTo(40)
                make.centerY.equalTo(header)
            }
            let rightV = UIView()
            rightV.backgroundColor = RGBA(r: 255, g: 128, b: 0, a: 1)
            header.addSubview(rightV)
            rightV.snp.makeConstraints { (make) in
                make.left.equalTo(lab.snp.right).offset(4)
                make.height.equalTo(1)
                make.width.equalTo(40)
                make.centerY.equalTo(header)
            }
            return header
        }
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let live =  LiveList()
            let model = liveModel
            //去看直播
            if model.live_id != ""{
                live.room_id = model.room_id
                live.user_id = merchants_id
                live.play_address = model.play_address_m3u8
                live.live_id = merchant.live_id
                live.play_img = model.play_img
                live.img = merchant.merchants_img
                live.share_url = model.share_url
                live.username = merchant.merchants_name
                WatchLiveViewController.toWatch(from: self, model: live)
            }
        }else{
            let playModel = allDataArr[indexPath.row]
            
            let vc = PlayVideoViewController()
            vc.username = playModel.title ?? ""
            
            vc.play_img = playModel.play_img 
            vc.url = playModel.url
            vc.type = 1
            self.navigationController?.pushViewController(vc, animated: true)

         
        }

    }
}

