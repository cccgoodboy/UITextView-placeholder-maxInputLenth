//
//  KindDescViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/31.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class KindDescViewController: UIViewController {
    var classModel:GoodsClassModel = GoodsClassModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var itemDescBtn: [UIButton]!
   
    @IBOutlet weak var priceLab: UILabel!
    var count = 0
    var type = "1"
    var selectedBtn: UIButton!
    var allPage:Int = 1
    var allData:[MerchantsGoodsListModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescBtn[0].setTitle(NSLocalizedString("Sorting", comment: "综合排序"), for: .normal)
        itemDescBtn[1].setTitle(NSLocalizedString("Sales", comment: "销量"), for: .normal)
        priceLab.text = NSLocalizedString("Price", comment: "价格")
        
        self.navigationItem.title = classModel.class_name
        self.tableView.register(UINib.init(nibName: "KindDescTableViewCell", bundle: nil), forCellReuseIdentifier: "KindDescTableViewCell")
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.allPage = 1
            self.loadData(page: self.allPage,searchStr:self.classModel.class_uuid!,type:self.type)
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.allPage += 1
            self.loadData(page: self.allPage,searchStr:self.classModel.class_uuid!,type:self.type)
        })

        self.tableView.mj_header.beginRefreshing()
        tableView.tableFooterView = UIView()
        for btn in itemDescBtn {
            btn.setTitleColor(themeColor, for: .selected)
        }
        self.itemDescBtn[0].isSelected = true
        selectedBtn = self.itemDescBtn[0]
    }
    func loadData(page:Int,searchStr:String,type:String){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/searchGoods", at: self, params: ["p":page,"class_uuid":searchStr,"type":type], hasHeaderRefresh: tableView, success: { (response) in
            if let data = (response["data"] as? NSDictionary)?["goodsBean"] as? NSArray{
                if self.allPage == 1{
                    self.allData.removeAll()
                }
                if data.count < 10{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.allData += [MerchantsGoodsListModel].deserialize(from: data) as! [MerchantsGoodsListModel]
            }
//            self.tableView.mj_footer.isAutomaticallyHidden =  true
            
            self.tableView.reloadData()
        }) {
            if self.allPage > 1 {
                self.allPage -= 1
            }
        }
    }
    @IBAction func itemClick(_ sender: UIButton) {
        
        if  sender.tag == 3{
            count += 1
            
            if count % 2 != 0 {
                sender.setImage(#imageLiteral(resourceName: "sahng"), for: .normal)
                
                type = "4"
            } else {
                sender.setImage(#imageLiteral(resourceName: "xia"), for: .normal)
                type = "3"
            }
            priceLab.textColor = themeColor

            selectedBtn.isSelected = false
            sender.isSelected = true
            selectedBtn = sender
            self.tableView.mj_header.beginRefreshing()
        }else{
            priceLab.textColor = UIColor.init(hexString: "9A9A9A")

            itemDescBtn[2].setImage(#imageLiteral(resourceName: "sousuo_moren"), for: .normal)
            if selectedBtn === sender {
                return
            }
            selectedBtn.isSelected = false
            sender.isSelected = true
            selectedBtn = sender
            if selectedBtn.tag == 1{
                type = "1"
            }else{
                type = "2"
            }
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
extension KindDescViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KindDescTableViewCell", for: indexPath) as! KindDescTableViewCell

        cell.model = self.allData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 103
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GoodsDetailVC()
        vc.goods_id = allData[indexPath.row].goods_id ?? "0"
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

