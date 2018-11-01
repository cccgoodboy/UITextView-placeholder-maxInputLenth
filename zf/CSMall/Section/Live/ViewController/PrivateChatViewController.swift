//
//  PrivateChatViewController.swift
//  MoDuLiving
//
//  Created by Luiz on 2017/2/27.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import MJRefresh

let naviHeight = 640/750 * kScreenWidth
var differValue: CGFloat = 49

class PrivateChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isCurrentUserLiving = false
    var isShowAnchor = true
    
    var liveList = LiveList()
    var chatDataArr: [PrivateChatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.title = "私信"
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "PrivateChatAnchorTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivateChatAnchorTableViewCell")
        self.loadData()
    }
    func getUserHxIdFrom(model: EMConversation) -> String {
        if model.latestMessage.direction == EMMessageDirectionSend {
            return model.latestMessage.to
        }
        return model.latestMessage.from
    }
    
    func loadData() {
        ProgressHUD.showMessage(message: "暂不支持")
        return
        
        func refresh() {
            if isShowAnchor, !isCurrentUserLiving {
                let mdoel = PrivateChatModel(name: liveList.username!, img: liveList.img!, content: "你好，我是主播[" + liveList.username! + "]，来和我聊天吧", id: liveList.user_id!, chatId: liveList.hx_username!, sex: liveList.sex!)
                mdoel.isHiddenBtn = false
                chatDataArr.insert(mdoel, at: 0)
            }
            tableView.reloadData()
        }
        func getContent(m: EMConversation) -> String {
            if m.latestMessage == nil {
                return "有新消息"
            }
            let type = m.latestMessage.body.type
            var content = "有新消息"
            if type  == EMMessageBodyTypeText {
                let messageBody = m.latestMessage.body as! EMTextMessageBody
                content = messageBody.text
            } else if type  == EMMessageBodyTypeImage {
                content = "图片消息"
            } else if type  == EMMessageBodyTypeVoice {
                content = "语音消息"
            } else if type  == EMMessageBodyTypeVideo {
                content = "视频信息"
            } else if type  == EMMessageBodyTypeLocation {
                content = "位置信息"
            }
            return content
        }
        let list = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        chatDataArr.removeAll()
        isShowAnchor = true
        var i = 0
        if list.count == 0 {
            refresh()
        }
        for m in list {
            if m.latestMessage != nil, m.type == EMConversationTypeChat {
                NetworkingHandle.fetchNetworkData(url: "Index/get_user_info", at: self, params: ["hx_username":getUserHxIdFrom(model: m)], success: { (result) in
                    let data = result["data"] as! [String: String]
                    
                    let name = data["username"] ?? ""
                    let id = data["user_id"] ?? ""
                    
                    if id == self.liveList.user_id {
                        self.isShowAnchor = false
                    }
                    let mdoel = PrivateChatModel(name: name, img: data["img"]!, content: getContent(m: m), time: self.timeStampToString(timeStamp: TimeInterval(m.latestMessage.timestamp/1000)), id: id, chatId: m.conversationId, sex: data["sex"]!)
                    mdoel.unreadCount = Int(m.unreadMessagesCount)
                    mdoel.timestamp = m.latestMessage.timestamp - 1488439927871
                    self.chatDataArr.append(mdoel)
                    
                    i += 1
                    if i == list.count {
                        refresh()
                    }
                    
                }, failure: {
                    i += 1
                    if i == list.count {
                        refresh()
                    }
                })
                
            } else {
                i += 1
                if i == list.count {
                    refresh()
                }
            }
        }
    }
    
    
    func timeStampToString(timeStamp: TimeInterval) -> String {
        let nowTimeInterval = Date().timeIntervalSince1970
        let interval = nowTimeInterval - timeStamp
        if interval < 60 {
            return "刚刚"
        }
        if interval < 60*60 {
            return "\(Int(floor(interval/60)))分钟前"
        }
        if interval < 60*60*24 {
            return "\(Int(floor(interval/60/60)))小时前"
        }
        if interval < 60*60*24*30  {
            return "\(Int(floor(interval/60/60/24)))天前"
        }
        if interval < 60*60*24*30*12  {
            return "\(Int(floor(interval/60/60/24/30)))个月前"
        }
        return "一年前"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func show(atVC: UIViewController, atView: UIView, isCurrentUserLiving: Bool = false) -> PrivateChatViewController {
        let selfVC = PrivateChatViewController()
        selfVC.isCurrentUserLiving = isCurrentUserLiving
        if isCurrentUserLiving {
            differValue = 0
        } else {
            differValue = 49
        }
        let btn = UIButton()
        btn.addTarget(selfVC, action: #selector(PrivateChatViewController.dismissAction(btn:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - naviHeight)
        atVC.view.addSubview(btn)
        
        let nav = PrivateChatNavigationController(rootViewController: selfVC)
        atVC.addChildViewController(nav)
        atVC.view.addSubview(nav.view)
        
        let view = nav.view
        view?.isHidden = false
        var frame = view?.frame
        let oldFrame = frame
        frame?.origin.y = nav.view.frame.size.height
        view?.frame = frame!
        UIView.animate(withDuration: 0.25, animations: {
            view?.frame = oldFrame!
        })
        return selfVC
    }
    
    //MARK: - table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateChatAnchorTableViewCell", for: indexPath) as! PrivateChatAnchorTableViewCell
        cell.model = chatDataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = chatDataArr[indexPath.row]
//        if model.isHiddenBtn == false {
//            return
//        }
        
        model.unreadCount = 0
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let chatController = DirectChatViewController(conversationChatter: model.chatId, conversationType: EMConversationTypeChat)
        chatController?.img = model.img
        chatController?.usernameTHEY = model.name
        chatController?.userId = model.id
        chatController?.isCustomNav = true
        self.navigationController?.pushViewController(chatController!, animated: true)
    }
    
    
    func dismissAction(btn: UIButton) {
        
        btn.removeFromSuperview()
        
        let view = self.navigationController?.view
        var frame = view?.frame
        frame?.origin.y += (frame?.size.height)!
        UIView.animate(withDuration: 0.25, animations: {
            view?.frame = frame!
        }) { (finished) in
            self.navigationController?.view.removeFromSuperview()
            self.navigationController?.removeFromParentViewController()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
class PrivateChatNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        var frame = self.view.frame
        frame.origin.y = frame.size.height - naviHeight
        frame.size.height = naviHeight + differValue
        self.view.frame = frame
        self.navigationBar.tintColor = themeColor
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: themeColor, NSFontAttributeName: defaultFont(size: 16)]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController.navigationItem.backBarButtonItem = backItem
        super.pushViewController(viewController, animated: animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class PrivateChatModel: NSObject {
    var name: String
    var img: String
    var content: String
    var time: String
    var id: String
    var chatId: String
    var sex: String
    var unreadCount = 0
    var isHiddenBtn = true
    var timestamp: Int64 = 0
    init(name: String, img: String, content: String, time: String = "", id: String, chatId: String, sex: String) {
        self.name = name
        self.img = img
        self.content = content
        self.time = time
        self.id = id
        self.chatId = chatId
        self.sex = sex
    }
}
