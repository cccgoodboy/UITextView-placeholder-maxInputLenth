//
//  LiveGoosListViewController.swift
//  CSLiving
//
//  Created by taoh on 2017/10/15.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class LiveGoosListViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    var livesId:String!
    var isLiving = 0 // 0默认不在直播 1在直播
    var seller = ""
    
    @IBOutlet weak var topview: UIView!
    //删除列表
    @IBAction func deleteClick(_ sender: UIButton) {
        
        
//        NetworkingHandle.fetchNetworkData(url: "/api/merchant/delAllGoods", at: self, params: ["live_id":livesId!], success: { (response) in
//            if let data = response["data"] as? String{
//                ProgressHUD.showMessage(message: data)
//                self.dismiss(animated: true, completion: nil)
//            }
//        }) {
//
//        }

    }
    //提交

    @IBOutlet weak var listTab: UITableView!
    @IBAction func dismissClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var listgoods:[LiveGoodsModel] = [LiveGoodsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        listTab.tableFooterView = UIView()
        let maskPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 44), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 10, height: 10))
        let masklayer = CAShapeLayer()
        masklayer.frame = topview.bounds
        masklayer.path = maskPath.cgPath
        topview.layer.mask = masklayer
        self.modalPresentationStyle = .custom
        listTab.register(UINib.init(nibName: "LiveGoodsListTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveGoodsListTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        loadData()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func loadData(){
        NetworkingHandle.fetchNetworkData(url: "/api/merchant/live_goods", at: self, params: ["live_id":livesId!],isShowHUD:false, success: { (response) in
            if let data = response["data"] as? NSArray{
                self.listgoods = [LiveGoodsModel].deserialize(from: data) as! [LiveGoodsModel]
                self.listTab.reloadData()
            }
        }) {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listgoods.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveGoodsListTableViewCell", for: indexPath) as! LiveGoodsListTableViewCell
        cell.topClick  = { model in
            let vc = GoodsDetailVC()
            vc.isLiving = 1
            vc.live_id = self.livesId
            vc.seller = self.seller
            vc.goods_id = self.listgoods[indexPath.row].goods_id ?? "0"
            vc.skip = "live"
            self.present(NavigationController(rootViewController: vc), animated: false, completion: nil)

        }
//        cell.deleteClick = { model in
//
//            self.loadData()
//
//        }
        if listgoods.count != 0{
            cell.model = listgoods[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = GoodsDetailVC()
        vc.goods_id = listgoods[indexPath.row].goods_id ?? "0"
        vc.skip = "live"
        vc.isLiving = 1
        vc.live_id = self.livesId
        vc.seller = self.seller
        self.present(NavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    
}
