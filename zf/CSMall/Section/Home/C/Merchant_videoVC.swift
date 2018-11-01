//
//  Merchant_videoVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/5.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh
import ZFDownload
class Merchant_videoVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate {
    var allPage = 1
    var allDataArr: [VideoListModel] = []
    var merchants_id:String?
    var playerView:ZFPlayerView!
    @IBOutlet weak var videoTab: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTab.estimatedRowHeight = 220
        videoTab.rowHeight = UITableViewAutomaticDimension
        videoTab.register(UINib.init(nibName: "Merchant_videoTabCell", bundle: nil), forCellReuseIdentifier: "Merchant_videoTabCell")
        videoTab.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        videoTab.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        self.videoTab.mj_header.beginRefreshing()
        
        setupViews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerView.resetPlayer()
    }
    func setupViews(){
        playerView = ZFPlayerView.shared()
        playerView.delegate = self
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        playerView.cellPlayerOnCenter = false
        playerView.stopPlayWhileCellNotVisable =  true//到不可见区域暂停
        playerView.hasPreviewView = false
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
         playerView.stopPlayWhileCellNotVisable = true
        
    }
    func loadData(page:Int){
        
        NetworkingHandle.fetchNetworkData(url: "/api/live/video_list", at: self, params: ["mid":merchants_id ?? "1","p":page], hasHeaderRefresh: videoTab, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["list"] as?NSArray{
                
                let list = [VideoListModel].deserialize(from: data) as! [VideoListModel]
                
                if list.count == 0{
                    self.videoTab.mj_footer.isHidden = true
                    self.videoTab.mj_footer.endRefreshing()
                }
                if page == 1 {
                    self.allDataArr.removeAll()
                }
                self.allDataArr += list
            }
            self.videoTab.reloadData()
        }) {
            self.allPage = max(1, self.allPage - 1)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return allDataArr.count
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Merchant_videoTabCell", for: indexPath) as! Merchant_videoTabCell
        cell.backgroundColor = UIColor.clear
        cell.refershData(model: allDataArr[indexPath.section])
        
        cell.playClickBlock = {playMdoel in
            let playerModel = ZFPlayerModel()
            playerModel.title = playMdoel.title ?? ""
            playerModel.videoURL =  URL.init(string:playMdoel.url!)
            playerModel.placeholderImage = #imageLiteral(resourceName: "moren-2")
            playerModel.placeholderImageURLString = playMdoel.video_img!
            playerModel.scrollView = self.videoTab
            playerModel.indexPath = indexPath
//              playerModel.resolutionDic    = dic; // 赋值分辨率字典
            playerModel.fatherViewTag =  cell.img.tag // player的父视图tag
            self.playerView.playerControlView(nil, playerModel: playerModel) // 设置播放控制层和model
            self.playerView.hasDownload = true// 下载功能
            self.playerView.autoPlayTheVideo()        // 自动播放
            
            
            NetworkingHandle.fetchNetworkData(url: "/api/live/play_video", at: self, params: ["video_id":playMdoel.video_id ?? ""], isShowHUD: false, isShowError: true, success: { (response) in
                playMdoel.watch_nums = "\(Int(playMdoel.watch_nums!)! + 1)"
                cell.num.text = playMdoel.watch_nums
            }, failure: {
                
            })
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 352
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func zf_playerDownload(_ url: String!) {
        ZFDownloadManager.shared().downFileUrl(url, filename: "", fileimage: nil)
        ZFDownloadManager.shared().maxCount = 4
    }
}

