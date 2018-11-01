//
//  LivingBGMViewController.swift
//  Duluo
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import MJRefresh

protocol LivingBGMViewControllerDelegate {
    func livingBGMViewController(_ vc: LivingBGMViewController, model: LivingBGMModel)
}

class LivingBGMViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, LivingBGMTableViewCellDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var choiceness: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isDownloading = false
    
    var myArr: [LivingBGMModel] = []
    var dataArr: [LivingBGMModel] = []
    var searchArr: [LivingBGMModel] = []
    
    var isShowNetworkingData = true
    var isShowSearchData = false
    
    var page = 1
    
    var delegate: LivingBGMViewControllerDelegate?
    
    class func show(atVC: UIViewController) -> LivingBGMViewController {
        let vc = LivingBGMViewController()
        atVC.addChildViewController(vc)
        atVC.view.addSubview(vc.view)
        vc.view.frame = atVC.view.bounds
        vc.showTheView()
        return vc
    }
    private func showTheView() {
        var frame = self.view.frame
        let oldFrame =  frame
        self.view.alpha = 0.1
        frame.origin.y = self.view.frame.size.height
        self.view.frame = frame
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = oldFrame
            self.view.alpha = 1
        })
    }
    private func dismiss() {
        var frame = self.view.frame
        frame.origin.y += frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = frame
            self.view.alpha = 0.1
        }) { (finished) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.setSearchFieldBackgroundImage(getImage(color: UIColor(hexString: "3c4856"), height: 29), for: .normal)
        let tf = searchBar.value(forKey: "_searchField") as? UITextField
        let btn = searchBar.value(forKey: "cancelButton") as! UIButton
        btn.setTitleColor(UIColor.white, for: .normal)
        tf?.font = defaultFont(size: 14)
        tf?.textColor = UIColor(hexString: "#7b868d")
        tf?.layer.cornerRadius = 15
        tf?.layer.masksToBounds = true
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "LivingBGMTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            if self.isShowSearchData == false && self.isShowNetworkingData == false {
                self.myArr = SQLiteManager.manager.readData()
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                return
            }
            self.page = 1
            self.loadData()
        })
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.page += 1
            self.loadData()
        })
        footer?.setTitle("", for: .noMoreData)
        footer?.setTitle("", for: .idle)
        tableView.mj_footer = footer
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    func loadData() {
        var param: Dictionary<String, Any> = ["page": page, "pagesize": 10]
        if isShowSearchData {
            param["keyworks"] = searchBar.text!
        }
        NetworkingHandle.fetchNetworkData(url: "Index/music_list", at: self, params: param, hasHeaderRefresh: tableView, success: { [unowned self] result in
            let data = result["data"] as! [[String: AnyObject]]
            let list = LivingBGMModel.modelsWithArray(modelArray: data) as! [LivingBGMModel]
            if self.page == 1 {
                if self.isShowSearchData {
                    self.searchArr.removeAll()
                } else {
                    self.dataArr.removeAll()
                }
            }
            if list.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.compareArr(list: list)
        }) { [unowned self] in
            if self.page > 1 {
                self.page -= 1
            }
        }
    }
    func compareArr(list: [LivingBGMModel]) {
        for model in SQLiteManager.manager.readData() {
            for m in list {
                if model.singer == m.singer && model.song_name == m.song_name && model.time == m.time {
                    m.pathPostfix = model.pathPostfix
                    m.dbId = model.dbId
                }
            }
        }
        if self.isShowSearchData {
            self.searchArr += list
        } else {
            self.dataArr += list
        }
        
        self.tableView.reloadData()
    }
    // search bar 代理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isShowSearchData = true
        searchBar.resignFirstResponder()
        tableView.mj_header.beginRefreshing()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if isShowSearchData {
            isShowSearchData = false
            tableView.reloadData()
            return
        }
        dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func choicenessButtonAction(_ sender: UIButton) {
        isShowNetworkingData = true
        sender.isSelected = true
        myBtn.isSelected = false
        tableView.mj_footer.isHidden = false
        self.tableView.reloadData()
    }
    @IBAction func myButtonAction(_ sender: UIButton) {
        isShowNetworkingData = false
        sender.isSelected = true
        choiceness.isSelected = false
        tableView.mj_footer.isHidden = true
        self.myArr = SQLiteManager.manager.readData()
        self.tableView.reloadData()
    }
    
    // table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowSearchData {
            return searchArr.count
        }
        if isShowNetworkingData {
            return dataArr.count
        }
        return myArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LivingBGMTableViewCell
        cell.delegate = self
        if isShowSearchData {
            cell.model = searchArr[indexPath.row]
        } else if isShowNetworkingData {
            cell.model = dataArr[indexPath.row]
        } else {
            cell.model = myArr[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isShowSearchData == false && isShowNetworkingData == false {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [unowned self] (action, index) in
            self.deleteNativeData(index: index.row)
        }
        return [deleteAction]
    }
    // cell 代理
    func livingBGM(_ view: LivingBGMTableViewCell, model: LivingBGMModel, selectBtn: UIButton?) {
        if selectBtn != nil {
            if isDownloading {
                ProgressHUD.showNoticeOnStatusBar(message: "还有未完成的下载")
                return
            }
            selectBtn?.isEnabled = false
            isDownloading = true
            NetworkingHandle.download(model: model, complete: { [unowned self] m in
                DispatchQueue.main.async {
                    model.pathPostfix = m.pathPostfix
                    model.isDownloading = false
                    self.myArr.append(m)
                    self.isDownloading = false
                    selectBtn?.isEnabled = true
                    selectBtn?.isSelected = true
                    print(selectBtn as Any)
                }
            })
        } else {
            self.delegate?.livingBGMViewController(self, model: model)
            dismiss()
        }
    }
    func deleteNativeData(index: Int) {
        guard let dbId = myArr[index].dbId else {
            ProgressHUD.showNoticeOnStatusBar(message: "未知错误")
            return
        }
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentsURL?.appendingPathComponent(myArr[index].pathPostfix!)
        do { try FileManager.default.removeItem(at: fileURL!) } catch {
            ProgressHUD.showNoticeOnStatusBar(message: "删除失败")
            return
        }
        SQLiteManager.manager.delData(dbId: dbId)
        for value in dataArr {
            if value.dbId == dbId {
                value.pathPostfix = nil
                value.dbId = nil
                break
            }
        }
        for value in searchArr {
            if value.dbId == dbId {
                value.pathPostfix = nil
                value.dbId = nil
                break
            }
        }
        myArr.remove(at: index)
        tableView.reloadData()
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
class LivingBGMModel: KeyValueModel {
    var music_id: String?
    var path: String?
    var song_name: String?
    var singer: String?
    var time: String?
    var size: String?
    
    var dbId: Int64?
    var pathPostfix: String?
    var isDownloading = false
}

func getImage(color: UIColor, height: CGFloat) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}
