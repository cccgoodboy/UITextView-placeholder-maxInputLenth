//
//  ShoppingCartVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/7/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class ShoppingCartVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var shopCarCollect:UICollectionView!
    var shopNotCart:[MerchantsGoodsListModel] = [MerchantsGoodsListModel]() //购物车中无效商品
    
    @IBAction func deleteClick(_ sender: UIButton) {
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var shopCartTab: UITableView!
    var shopValidCart:[ShopCarsModel] = [ShopCarsModel]()//有效商品
    var shopNoValidCart:[ShopCarBeanModel] = [ShopCarBeanModel]() //购物车中无效商品
    
    @IBOutlet weak var selectAll: UIButton!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    var isEdit = false
    
    var edit:UIBarButtonItem!
    var valid_count = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteBtn.isHidden = !isEdit

        shopCartTab.register(UINib.init(nibName: "ShopCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopCartTableViewCell")
        shopCartTab.register(UINib.init(nibName: "ShopCartHeadView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ShopCartHeadView")
        
        let mess = UIBarButtonItem.init(image: #imageLiteral(resourceName: "xiaoxi"), style: .done, target: self, action: #selector(messClick))
        edit =  UIBarButtonItem(title: NSLocalizedString("Edit", comment: "编辑"), target: self, action: #selector(ShoppingCartVC.editAction))
        self.navigationItem.rightBarButtonItems = [mess,edit]
        
        self.emptyShopCar()
        
        self.shopCartTab.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadShopCartNum()
            self.loadShopCartData()
        })
        self.shopCartTab.mj_header.beginRefreshing()
        
        self.shopCarCollect.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadShopCartNum()
            self.loadShopCartData()
            self.loadEmptyData()
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        loadShopCartData()
    }
    
    func emptyShopCar(){
        shopCarCollect = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kContentHeight), collectionViewLayout: UICollectionViewFlowLayout())
        shopCarCollect.backgroundColor = UIColor.white
        view.addSubview(shopCarCollect)
        
        shopCarCollect.delegate = self
        shopCarCollect.dataSource = self
        
        shopCarCollect.register(UINib.init(nibName: "EmptyShopView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EmptyShopView")
        shopCarCollect.register(UINib.init(nibName: "ShoppingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShoppingCollectionViewCell")
    }
    
    func messClick(){
        let message = MessageViewController()
        self.navigationController?.pushViewController(message, animated: true)
    }
    func editAction(){
        
        isEdit = !isEdit
        edit.title = isEdit ? NSLocalizedString("Hint_43", comment: "完成") : NSLocalizedString("Edit", comment: "编辑")
        deleteBtn.isHidden = !isEdit
    }
    
    func loadShopCartData(){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/getShopCars", at: self, hasHeaderRefresh: shopCartTab, success: { (response) in
            
            self.shopCartTab.mj_header.endRefreshing()
            self.shopValidCart.removeAll()
            self.shopNoValidCart.removeAll()
            //底部数据清空
            self.sureBtn.setTitle("结算", for: .normal)
            self.selectAll.isSelected = false
            self.totalPrice.text = "¥0.00"
            if let data = response["data"] as? NSDictionary{
                
                if let valid = data["valid_data"] as? NSArray{
                    
                    self.shopValidCart = [ShopCarsModel].deserialize(from: valid) as! [ShopCarsModel]
                }
                
                if let novalid = data["no_valid_data"] as? NSArray{
                    
                    self.shopNoValidCart = [ShopCarBeanModel].deserialize(from: novalid) as! [ShopCarBeanModel]
                }
                if self.shopValidCart.count == 0 && self.shopNoValidCart.count == 0{
                    //购物车没有商品的页面
                    self.shopCarCollect.isHidden = false
                    self.shopCarCollect.mj_header.beginRefreshing()
                    
                }else{
                    self.shopCarCollect.isHidden = true
                }
                
                self.shopCartTab.reloadData()
            }
        }, failure: {
        })
        
    }
    func loadEmptyData()  {
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/maybeEnjoy", at: self, hasHeaderRefresh: shopCarCollect, success: { (response) in
            if let data = response["data"] as?  NSDictionary{
                if let goods = data["goods"] as? NSArray{
                    self.shopNotCart = [MerchantsGoodsListModel].deserialize(from: goods) as! [MerchantsGoodsListModel]
                    self.shopCarCollect.reloadData()
                }
            }
        }) {
            
        }
    }
    func loadShopCartNum(){
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/getShopCarCount", at: self, success: { (response) in
            if let data = response["data"] as? String{
                self.valid_count = data
                if data == "0"{
                    self.navigationItem.title = NSLocalizedString("Shoppingcart", comment: "购物车")
                    
                }else{
                    self.navigationItem.title = "\(NSLocalizedString("Shoppingcart", comment: "购物车"))(\(self.valid_count))"
                    
                }
            }

        }) {
            
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shopNotCart.count
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{// 11:14
        
        return CGSize.init(width: (kScreenWidth - 1)/2, height: 254/185*(kScreenWidth - 1)/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 1, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCollectionViewCell", for: indexPath) as! ShoppingCollectionViewCell
        cell.refershData(model:shopNotCart[indexPath.row])
        return  cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return  CGSize.init(width: kScreenWidth, height: 266/375*kScreenWidth + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EmptyShopView", for: indexPath) as! EmptyShopView
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = GoodsDetailVC()
        vc.goods_id = shopNotCart[indexPath.row].goods_id ?? "0"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectAllClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        for index in shopValidCart.indices {
            for item in (shopValidCart[index].goods?.indices)! {
                shopValidCart[index].goods?[item].isSelected = sender.isSelected
            }
        }
        
        
        if sender.isSelected{
            
            for index in shopValidCart.indices {
                for item in (shopValidCart[index].goods?.indices)! {
                    
                    shopValidCart[index].goods?[item].isSelected = true
                }
            }
            self.sureBtn.setTitle("结算(\(valid_count))", for: .normal)
            var sum = 0.00
            
            for m  in self.shopValidCart.indices{
                
                for n  in (self.shopValidCart[m].goods?.indices)!{
                    if self.shopValidCart[m].goods?[n].isSelected == true{
                        sum = sum + Double((self.shopValidCart[m].goods?[n].goods_now_price)!)! *
                            Double((self.shopValidCart[m].goods?[n].goods_num)!)!
                        
                    }
                }
            }
            let t = String(format: "%.2f", sum)
            self.totalPrice.text = "¥\(t)"
            
            self.shopCartTab.reloadData()
            
            
        }else{
            
            for m  in self.shopValidCart.indices{
                
                for n  in (self.shopValidCart[m].goods)!.indices{
                    (self.shopValidCart[m].goods)![n].isSelected = false
                }
            }
            self.totalPrice.text = "¥0.00"
            
            sureBtn.setTitle("结算", for: .normal)
            self.shopCartTab.reloadData()
            
        }
    }
    //去结算
    @IBAction func sureClick(_ sender: UIButton) {
        
        var str = ""

        for m in shopValidCart.indices {
            let goods = shopValidCart[m].goods!
            for n in goods.indices {
                if goods[n].isSelected {
                    str += ",\((shopValidCart[m].goods?[n].car_id)!)"
                }
            }
        }
        if str == ""{
            ProgressHUD.showMessage(message: "请选择商品")
            return
        }
        
        let car_ids = (str.substingInRange(r: 1..<str.characters.count))!
       
        if sender.titleLabel?.text! ==  "删除"{
            
            NetworkingHandle.fetchNetworkData(url: "/api/Mall/delShopCar", at: self, params: ["car_ids":car_ids], success: { (response) in
                ProgressHUD.showMessage(message: response["data"] as! String)
               
                self.loadShopCartData()
                
            }, failure: {
                
            })
        }
        else{
//            print("去结算")
           let com = ConfirmOrderViewController()
            com.confirType = ConfirmOrderType.ShopCart_Buy
            com.shopcar_ids = car_ids
            self.navigationController?.pushViewController(com, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension ShoppingCartVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return shopNoValidCart.count != 0 ? shopValidCart.count + 1 : shopValidCart.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if   shopNoValidCart.count != 0 && section  == shopValidCart.count{
            
            return shopNoValidCart.count
        }else{
            return  shopValidCart[section].goods?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShopCartHeadView") as! ShopCartHeadView
        view.backgroundColor = UIColor.white
        if section == shopValidCart.count {
            view.btnWidth.constant = 20
            view.merchantImgWidth.constant = 0
            view.selectMerchantBtn.isHidden = true
            view.titleLab.text = "失效宝贝（\(shopNoValidCart.count)）件"
            view.cleanNoValidBtn.isHidden = false
            view.btnClickBlock = {
                // () in 无参数可以省略
                NetworkingHandle.fetchNetworkData(url: "/api/Mall/delInvalidShopCar", at: self, success: { (response) in
                    if let data = response["data"] as? String{
                        ProgressHUD.showMessage(message: data)
                    }
                    self.shopCartTab.mj_header.beginRefreshing()
                }, failure: {
                })
            }
        }else{
            
            view.headerbtnClickBlock = {(button) in
                button.isSelected = !button.isSelected
                self.shopValidCart[section].goods!.forEach { $0.isSelected = button.isSelected}
              
                var sum = 0.00
                
                for m  in self.shopValidCart.indices{
                    
                    for n  in (self.shopValidCart[m].goods?.indices)!{
                        if self.shopValidCart[m].goods?[n].isSelected == true{
                            sum = sum + Double((self.shopValidCart[m].goods?[n].goods_now_price)!)! *
                                Double((self.shopValidCart[m].goods?[n].goods_num)!)!
                            
                            
                        }
                    }
                }
                var selectNum = 0
                var totalgoodsNum = 0
                for index  in self.shopValidCart.indices {
                    for m in (self.shopValidCart[index].goods)! {
                        if m.isSelected{
                            selectNum += 1
                        }
                        totalgoodsNum += 1
                    }
                }
                if selectNum == 0 {
                    self.sureBtn.setTitle("结算", for: .normal)
                }
                else {
                    self.sureBtn.setTitle("结算(\(selectNum))", for: .normal)
                }
                self.selectAll.isSelected = selectNum < totalgoodsNum ? false : true
                let t = String(format: "%.2f", sum)
                self.totalPrice.text = "¥\(t)"

                self.shopCartTab.reloadData()
            }
            
            let goods = shopValidCart[section].goods!
            view.selectMerchantBtn.isSelected = goods.filter { $0.isSelected }.count == goods.count
            view.btnWidth.constant = 40
            view.merchantImgWidth.constant = 30
            view.selectMerchantBtn.isHidden = false
            view.merchantImg.sd_setImage(with:URL.init(string: shopValidCart[section].merchants_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
            view.titleLab.text = shopValidCart[section].merchants_name
            view.cleanNoValidBtn.isHidden = true
            
        }
        
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "EFEFF4")
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCartTableViewCell", for: indexPath) as! ShopCartTableViewCell
        cell.clickGoods = { (model,button) in
            
            var selectNum = 0
            var totalgoodsNum = 0
            
            for index  in self.shopValidCart.indices {
                
                for m in (self.shopValidCart[index].goods)! {
                    if m.isSelected{
                        selectNum += 1
                    }
                    totalgoodsNum += 1
                }
            }
            
            if selectNum == 0 {
                self.sureBtn.setTitle("结算", for: .normal)
            }
            else {
                self.sureBtn.setTitle("结算(\(selectNum))", for: .normal)
            }
            
            self.selectAll.isSelected = selectNum < totalgoodsNum ? false : true
            
            if button.isSelected {
                
                let  data = self.shopValidCart[indexPath.section]
                data.goods![indexPath.row].isSelected = true
                
                var sum = 0.00
                
                for m  in self.shopValidCart.indices{
                    
                    for n  in (self.shopValidCart[m].goods?.indices)!{
                        
                        if self.shopValidCart[m].goods?[n].isSelected == true{
                            
                            sum = sum + Double((self.shopValidCart[m].goods?[n].goods_now_price)!)! *
                                Double((self.shopValidCart[m].goods?[n].goods_num)!)!
                        }
                    }
                }
                let t = String(format: "%.2f", sum)
                self.totalPrice.text = "¥\(t)"
                self.shopCartTab.reloadData()
                return
            }
            else{
                let  data = self.shopValidCart[indexPath.section]
                data.goods![indexPath.row].isSelected = false
                
                var sum = 0.00
                
                for m  in self.shopValidCart.indices{
                    
                    for n  in (self.shopValidCart[m].goods?.indices)!{
                        if self.shopValidCart[m].goods?[n].isSelected == true{
                            
                            sum = sum + Double((self.shopValidCart[m].goods?[n].goods_now_price)!)! *
                                Double((self.shopValidCart[m].goods?[n].goods_num)!)!
                        }
                        
                    }
                }
                let t = String(format: "%.2f", sum)
                self.totalPrice.text = "¥\(t)"
                self.shopCartTab.reloadData()
                return
            }
        }
        cell.changeNum = { num in
            
            var sum = 0.00
            
            for m  in self.shopValidCart.indices{
                
                for n  in (self.shopValidCart[m].goods?.indices)!{
                    if self.shopValidCart[m].goods?[n].isSelected == true{
                        
                        sum = sum + Double((self.shopValidCart[m].goods?[n].goods_now_price)!)! *
                            Double((self.shopValidCart[m].goods?[n].goods_num)!)!
                    }
                }
            }
            let t = String(format: "%.2f", sum)
            self.totalPrice.text = "¥\(t)"
        }
        
        if indexPath.section == shopValidCart.count{
            
            cell.model = shopNoValidCart[indexPath.row]
            cell.novalidLab.isHidden = false
            cell.markBtn.isHidden = true
            cell.pricesymbol.isHidden = true
            cell.priceLab.text = "宝贝已不能购买，请联系卖家"
            cell.priceLab.font = UIFont.systemFont(ofSize: 12)
            cell.addBtn.isHidden = true
            cell.reduceBtn.isHidden = true
            cell.numLab.isHidden = true
        }else{
            
            cell.model = shopValidCart[indexPath.section].goods?[indexPath.row]
            cell.novalidLab.isHidden = true
            cell.markBtn.isHidden = false
            cell.pricesymbol.isHidden = false
            cell.addBtn.isHidden = false
            cell.reduceBtn.isHidden = false
            cell.numLab.isHidden = false
            cell.priceLab.font = UIFont.systemFont(ofSize: 14)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section  == shopValidCart.count { //无效商品

            let vc = GoodsDetailVC()
            vc.goods_id = shopNoValidCart[indexPath.row].goods_id ?? "0"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = GoodsDetailVC()
            vc.goods_id = shopValidCart[indexPath.section].goods![indexPath.row].goods_id ?? "0"
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
}

