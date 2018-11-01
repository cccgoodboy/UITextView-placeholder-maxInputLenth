//
//  LiveRoomMemberView.swift
//  MoDuLiving
//
//  Created by sh-lx on 2017/3/7.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

let reloadChatRoomMemberNotifiction = "reloadChatRoomMemberNotifiction"

class LiveRoomMemberView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var dataArr: [ChatRoomMember] = []
    
    var liveId: String?
    var roomId: String?
    var memberNumber: ((Int) -> ())?
    
    //更改
    var page = 1
    var isLoading = false

//    var timer: DispatchSourceTimer!
    
    var isCurrentUserLiving: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.minimumInteritemSpacing = 6
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WatchLiveMemberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveRoomMemberView.reloadMemberView), name: Notification.Name.init(reloadChatRoomMemberNotifiction), object: nil)
    }
    class func show(liveId: String, isCurrentUserLiving: Bool, roomId: String, memberNumber: ((Int) -> ())?) -> LiveRoomMemberView {
        let view = LiveRoomMemberView()
        view.memberNumber = memberNumber
        view.liveId = liveId
        view.roomId = roomId
        view.reloadMemberView()
        view.isCurrentUserLiving = isCurrentUserLiving
//        var timeout = 10
//        view.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//        view.timer.setEventHandler {
//            if timeout <= 1 {
//                view.timer.cancel()
//            } else {
//                DispatchQueue.main.sync {
//                    if view.superview == nil {
//                        view.timer.cancel()
//                    } else {
//                        view.reloadMemberView()
//                    }
//                }
//                timeout -= 1
//            }
//        }
//        view.timer.scheduleRepeating(deadline: .now(), interval: .seconds(60))
//        view.timer.resume()

        return view
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: 获取房间人列表
    func loadMemeberData(live_id: String) {
        isLoading = true
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        print(version,"444444444444")
        let param = ["live_id": live_id,"p": page, "pagesize": 8, "version": "1.4.1"] as [String : Any]
        NetworkingHandle.fetchNetworkData(url: "/api/live/show_viewer", at: self, params: param, isShowHUD: false, isShowError: false, success: { (result) in
            let data = result["data"] as! [String: AnyObject]
            let list = ChatRoomMember.modelsWithArray(modelArray: data["list"] as! [[String : AnyObject]]) as! [ChatRoomMember]
            if self.page == 1 {
                self.dataArr.removeAll()
            }
            self.dataArr += list
            self.memberNumber?(Int(data["count"] as! String)!)
            self.collectionView.reloadData()
            self.isLoading = false
        })
    }
  
    // 刷新观看人列表
    func reloadMemberView() {
        page = 1
        loadMemeberData(live_id: liveId!)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x + scrollView.bounds.width - scrollView.contentSize.width > -6, isLoading == false {
            loadMoreData()
        }
    }
    func loadMoreData() {
        self.page += 1
        loadMemeberData(live_id: liveId!)
    }
    
    // collection 数据源
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WatchLiveMemberCollectionViewCell
//        cell.avatar.kf.setImage(with: URL(string: dataArr[indexPath.row].header_img!))
cell.avatar.sd_setImage(with: URL(string: dataArr[indexPath.row].header_img!), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        return cell
    }
    // collection 代理
    
 //MARK:直播间用户点击
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        model.live_id = liveId
        model.roomId = roomId
        if CSUserInfoHandler.getIdAndToken()?.uid == model.member_id {
            ProgressHUD.showNoticeOnStatusBar(message: "你点的是自己哦！")
        } else {
            NetworkingHandle.fetchNetworkData(url: "/api/live/other_center", at: self, params: ["user_id":model.member_id!], success: { (response) in
                if let  data = response["data"] as? NSDictionary{
                    model.follow_count = data["follow"]  as? String
                    model.give_count = data["give_count"] as? String
                    _ = WatchUserInfo.show(atView: (self.responderViewController()?.view)!, model: model, isCurrentUserLiving: self.isCurrentUserLiving)
                    
                }
            }, failure: {
                
            })

//            _ = WatchUserInfo.show(atView: (self.responderViewController()?.view)!, model: model, isCurrentUserLiving: isCurrentUserLiving)
        }
    }
    
    deinit {
//        self.timer.cancel()
    }
}
class ChatRoomMember: KeyValueModel {
//    var autograph: String?
//    var fans_count: String?
//    var follow_count: String?
//    var get_money: String?
//    var give_count: String?
//    var grade: String?
//    var hx_password: String?
//    var hx_username: String?
//    var id: String?
//    var img: String?
//    var intime: String?
//    var is_banned: String?
//    var is_follow: String?
//    var is_management: String?
//    var money: String?
//    var user_id: String?
//    
    var live_id: String?
    var roomId: String?
//
//    var sex: String?
//    var city: String?
//    
//    var username: String?
    
    var ID:String?
    var address:String?
    var alias:String?
    var app_token:String?
    var area:String?
    var b_diamond:String?
    var banned_dis:String?
    var banned_end_time:String?
    var banned_start_time:String?
    var birth_day:String?
    var category_id:String?
    var city:String?
    var del_time:String?
    var e_ticket:String?
    var experience:String?
    var fans_count:String?
    var follow_count:String?
    var give_count:String?
    var grade:String?
    var header_img:String?
    var hx_password:String?
    var hx_username:String?
    var intime:String?
    var is_banned:String?
    var is_del:String?
    var is_fans:String?
    var is_follow:String?
    var is_remind:String?
    var is_show:String?
    var is_wheat:String?
    var lag:String?
    var log:String?
    var member_id:String?
    var pc_token:String?
    var phone:String?
    var phpqrcode:String?
    var province:String?
    var pwd:String?
    var qq_openid:String?
    var recommend_id:String?
    var sex:String?
    var signature:String?
    var uptime:String?
    var url:String?
    var username:String?
    var uuid:String?
    var wo_openid:String?
    var wx_openid:String?
    var zan:String?


    
}
