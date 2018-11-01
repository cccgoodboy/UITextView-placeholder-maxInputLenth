//
//  GoodsDetailVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/8.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    //懒加载tableview
    private lazy var tableViewMain :UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: kScreenHeight - 64), style: UITableViewStyle.plain)
    
    //懒加载数据源-可变数组用Var，类型自动推导,数组字典都用[]
    private lazy var dataSouce :[String] = [String]()
    private lazy var start :[Int] = [2,3,4,1,0,3,5,4]
    private lazy var image:[[String]] =
        [[],
         ["photo.jpg","photo.jpg"],
         ["photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg"],
         ["photo.jpg","photo.jpg","photo.jpg","photo.jpg"],
         ["photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg"],["photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg"],["photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg"],["photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg","photo.jpg"]]
   
    var allDataArr: [CommentDescModel] = []
    var allPage = 1
    var goodsId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //数据
        self.dataSouce += ["我就两个字","中新网4月17日电  据韩联社报道，韩国海洋水产部(简称“海水部”)“世越号”现场处理本部和负责世越号船体清理工作的韩国打捞局(Korea Salvage)为方便搜寻失踪者遗体的工作人员开展工作已于17日完成护栏安装，预计失踪者遗体搜寻工作有望于18日正式启动","这是第三个","3月28日，在将“世越”号船体运往木浦新港前，工作人员也同样在半潜船甲板上发现过动物尸骨。本月2日，工作人员曾在半潜船甲板上发现9块动物尸骨、“世越”号船长李某的护照及手提包、信用卡、圆珠笔等物品，但截至目前仍未发现9名失踪者的遗体。","","2014年4月16日，“世越”号在全罗南道珍岛郡附近水域沉没，共致295人遇难，迄今仍有9人下落不明，遇难者大多是学生。","世越”号在全罗南道珍岛郡附近水域沉没","体清理工作的韩国打捞局(Korea Salvage)为方便搜寻失踪者遗体的工作人员开展工作已于17日完成护栏安装，预计失踪者遗体搜寻工作有望于18日正式启动"]
        tableViewMain.tableFooterView = UIView()
        //创建UI
        self.createUI()
        
        self.tableViewMain.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.allPage = 1
            self.loadData(page: self.allPage)
        })
        
        self.tableViewMain.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.allPage += 1
            self.loadData(page: self.allPage)
        })
        
        self.tableViewMain.mj_header.beginRefreshing()
        
        
    }
    func loadData(page:Int){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/goods_comment", at: self, params: ["goods_id":goodsId,"p":page], hasHeaderRefresh: tableViewMain, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["comment"] as? NSArray{
                
                let list = [CommentDescModel].deserialize(from: data) as! [CommentDescModel]
                
                if list.count == 0{
                    self.tableViewMain.mj_footer.isHidden = true
                    self.tableViewMain.mj_footer.endRefreshing()
                }
                if page == 1 {
                    self.allDataArr.removeAll()
                }
                self.title = "\(NSLocalizedString("Hint_38", comment: "全部评论"))（\((response["data"] as? [String:Any])?["count"] ?? "0")）"
                self.allDataArr += list
            }
            self.tableViewMain.reloadData()
        }) {
            self.allPage =  self.allPage - 1
        }
        
    }
        

    func createUI(){
        //标题
        self.title = "\(NSLocalizedString("Hint_38", comment: "全部评论"))（0）"
        //tableview
        self.view.addSubview(tableViewMain)
        //去分割线
        //        tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(CommentTabCell.self , forCellReuseIdentifier: "CommentTabCell")
        
        //开启自动计算高度
        //【重点】注意千万不要实现行高的代理方法，否则无效：heightForRowAt
        tableViewMain.estimatedRowHeight = 44//预估高度，随便设置
        tableViewMain.rowHeight = UITableViewAutomaticDimension
    }
    
    
    //代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CommentTabCell") as! CommentTabCell
        //cell样式，取消选中
        cell.selectionStyle = .none
        //传值
        cell.getTitle(model:allDataArr[indexPath.row])
//        cell.getTitle(contain: allDataArr[indexPath.row],index:start[indexPath.row],image:image[indexPath.row])
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
