//
//  LiveChatView.swift
//  MoDuLiving
//
//  Created by 梁毅 on 2017/2/28.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
protocol LiveChatViewDelegate: NSObjectProtocol {
    func liveChatView(_: LiveChatView, userId: String)
}
class LiveChatView: UIView {
    
    var dataSource: [Chat] = [Chat]()
    weak var delegate: LiveChatViewDelegate?
    
    var tableView: WZBGradualTableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    class func show(atView: UIView) -> LiveChatView {
        let view = Bundle.main.loadNibNamed("LiveChatView", owner: nil
            , options: nil)!.last as! LiveChatView
        view.tableView = WZBGradualTableView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 60.0/357*kScreenWidth, height: 140.0/667*kScreenHeight), direction: .bottom, gradualValue: 0.2)!
        view.addSubview(view.tableView!)
        view.tableView?.delegate = view
        view.tableView?.dataSource = view
        view.tableView?.register(UINib(nibName: "ChattingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChattingTableViewCell")
        view.tableView?.backgroundColor = UIColor.clear
        view.tableView?.separatorStyle = .none
        view.tableView?.estimatedRowHeight = 40
        view.tableView?.rowHeight = UITableViewAutomaticDimension
        view.tableView?.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        view.tableView?.showsHorizontalScrollIndicator = false
        atView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo(atView.snp.bottom).inset(70)
            make.left.equalTo(atView.snp.left).inset(15)
            make.right.equalTo(atView.snp.right).inset(60.0/357*kScreenWidth)
            make.height.equalTo(140.0/667*kScreenHeight)
        }
        return view
    }
    func tableViewReloadData(data: Chat) {
        dataSource.insert(data, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView?.insertRows(at: [indexPath], with: .top)
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
    }
}
extension LiveChatView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingTableViewCell", for: indexPath) as! ChattingTableViewCell
        cell.chat = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK:聊天用户昵称点击
        //        let model = dataSource[indexPath.row]
        //        if model.user_id == "-000" {
        //            return
        //        }
        //        //FIXME:TH等待数据
        ////        if model.user_id == DLUserInfoHandler.getIdAndToken()?.id {
        ////            ProgressHUD.showNoticeOnStatusBar(message: "你点的是自己哦！")
        ////            return
        ////        }
        //        self.delegate?.liveChatView(self, userId: model.user_id)
    }
}
class Chat: NSObject {
    var userName: String
    var content: String
    var user_id: String
    var grade: String
    var isEnterRoom: Bool
    var isAtOneself = false
    var atUserName: String?
    var isGiftInfo = false
    init(name: String, id: String, content: String, grade: String, isEnterRoom: Bool = false) {
        self.userName = name
        self.user_id = id
        self.content = content
        self.grade = grade
        self.isEnterRoom = isEnterRoom
    }
}
