//
//  AddShopCartViewController.swift
//  CSMall
//
//  Created by 梁毅 on 2017/9/12.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

enum ShowAddShopCartType : Int{

    case ShopCart = 0
    case Buy = 1
    case GoodsDetail = 2 // 两个都显示

}



class AddShopCartViewController: UIViewController ,MWPhotoBrowserDelegate {
   
    
    var isLiving = 0 // 默认0，普通购买 1 直播间过来的加入购物车
    var live_id = ""//直播id
    var seller = "" //销售者（主播id）
    var imagePhoto :[MWPhoto] = [MWPhoto]()
    var tempCell:AddGoodsCartCollectionViewCell!

    @IBOutlet weak var oneBtn: UIButton!
    
    @IBOutlet weak var buyBtn: UIButton!//立即购买
    
    @IBOutlet weak var addShopCart: UIButton!
    var currentImg:String?
    
    @IBAction func addShopCartClick(_ sender: UIButton) {

        guigeStr = ""
        for m in itemCSArr.indices{
            if itemCSArr[m].specification_id == nil{
                guigeStr = " \(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
                ProgressHUD.showMessage(message:NSLocalizedString("Hint_03", comment: "请选择") + guigeStr )
                return
            }
        }
        
        if specification_stock == "0"{
            ProgressHUD.showMessage(message: NSLocalizedString("Hint_04", comment: "抱歉该商品已售完"))
            return
        }
        
        for m in itemCSArr.indices{
            confirspecification_names += "\(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误")):\(itemCSArr[m].specification_value ?? ""),"
        }
        if confirspecification_names == ""{
            
            confirspecification_names = NSLocalizedString("Hint_06", comment: "无规格")
        }
        if  sender.tag == 100{ //加入购物车
            if isLiving == 1{
                NetworkingHandle.fetchNetworkData(url: "/api/Mall/insertShopCar", at: self, params: ["goods_id":goodsModel.goods_id!,"specification_id":specification_id,"goods_num":numTf.text!,"seller":seller,"live_id":live_id],  success: { (response) in
                    
                    ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_05", comment: "添加成功！商品已在购物车了哦，亲~"))
                    
                })
                
            }else{
                NetworkingHandle.fetchNetworkData(url: "/api/Mall/insertShopCar", at: self, params: ["goods_id":goodsModel.goods_id!,"specification_id":specification_id,"goods_num":numTf.text!],  success: { (response) in
                    
                    ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_05", comment: "添加成功！商品已在购物车了哦，亲~"))
                    
                })
            }
           

        }else{ // 101 立即购买
            changeParams?(specification_id,numTf.text!)

        }

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var numTf: UILabel!
    @IBOutlet weak var layout: UICollectionViewLeftAlignedLayout!
    @IBOutlet weak var imgBg: UIImageView!
    
    @IBOutlet weak var addCollect: UICollectionView!
    
    @IBOutlet weak var bgview: UIView!
    
    var showType:ShowAddShopCartType = .ShopCart
    var goodsModel:SearchGoodsListModel!

    @IBOutlet weak var showText: UILabel!//请选择：。。
    
    @IBOutlet weak var priceLab: UILabel!//￥2000.00
    @IBOutlet weak var storeNumLab: UILabel!//库存 件
    var guigeStr = ""
    var confirspecification_names = ""//确认订单需要显示的规格信息
    var guigeId = ""//规格组合id
    var specification_id = ""//规格关联id
    var specification_stock = "0" //库存
    var goodsPrice = "0"
    
    var itemCSArr:[SpecificationBeansModel] = [SpecificationBeansModel]()
    
    var changeParams:((String,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBg.isUserInteractionEnabled = true
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(imgBgTouch))
        imgBg.addGestureRecognizer(tapOne)
        self.modalPresentationStyle = .custom
        
        self.layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        self.layout.minimumLineSpacing = 5
        self.layout.minimumInteritemSpacing = 5
        self.addCollect.allowsMultipleSelection =  true
        self.addCollect.register(UINib.init(nibName: "AddGoodsCartCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddGoodsCartCollectionViewCell")
        self.addCollect.register(UINib.init(nibName: "AddGoodsCartCollectionReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "AddGoodsCartCollectionReusableView")

        bgview.layer.shadowColor = UIColor.black.cgColor
        bgview.layer.shadowOpacity = 1
        bgview.layer.shadowRadius = 8
        bgview.layer.shadowOffset = CGSize.init(width: 0, height: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if showType == .Buy{
            oneBtn.backgroundColor = UIColor.init(hexString: "FF3A3B")
            oneBtn.setTitle(NSLocalizedString("Hint_07", comment: "立即购买"), for: .normal)
        }else{
            oneBtn.backgroundColor = UIColor.init(hexString: "FFAA45")
            oneBtn.setTitle(NSLocalizedString("Hint_08", comment: "加入购物车"), for: .normal)
        }
        
        if showType == .Buy || showType == .ShopCart{
            addShopCart.isHidden =  true
            buyBtn.isHidden = true
            
        }else{
            addShopCart.isHidden =  false
            buyBtn.isHidden = false

        }
        
        super.viewWillAppear(animated)
        imgBg.sd_setImage(with:URL.init(string: goodsModel.goods_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        self.currentImg = goodsModel.goods_img ?? ""
        specification_stock = goodsModel.goods_stock ?? "0"
        goodsPrice = goodsModel.goods_now_price ?? "0"
        storeNumLab.text = "\(NSLocalizedString("Hint_02", comment: "库存"))\(specification_stock)"
        self.addCollect.reloadData()
        
        for index in (goodsModel.goodsSpecificationBeans?.indices)! {
            guigeStr += " \((goodsModel.goodsSpecificationBeans?[index].specification_value)!)"
            itemCSArr.append(SpecificationBeansModel())
            
            let defaultSelectCell = IndexPath(row: 0, section:index)
            self.addCollect!.selectItem(at: defaultSelectCell, animated: true, scrollPosition: UICollectionViewScrollPosition.left)
            
            itemCSArr[index] = (goodsModel.goodsSpecificationBeans![index].specificationBeans?[0])!
            
        }
        
        //所有的规格都选择完成了
        for m in itemCSArr.indices{
            if itemCSArr[m].specification_id == nil{
                return
            }
        }
        
        guigeStr = ""
        guigeId = ""
        for m in itemCSArr.indices{
            guigeStr +=  " \(itemCSArr[m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
            guigeId += ",\(itemCSArr[m].specification_id!)"
        }
        showText.text = NSLocalizedString("Hint_09", comment: "已选") + guigeStr
        
        let param = guigeId.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
        if guigeId == ""{
            return
        }
        priceLab.text = ""
        storeNumLab.text = ""
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/get_specification", at: self, params: ["specification_ids":param,"goods_id":goodsModel.goods_id ?? ""], isShowHUD: false, success: { (response) in
            
            if let data = response["data"] as? [String:Any]{
                
                self.storeNumLab.text = "\(NSLocalizedString("Hint_02", comment: "库存"))：\(data["specification_stock"] ?? "0")\(NSLocalizedString("Hint_10", comment: "件"))"
                self.priceLab.text = "\(PhoneTool.getCurrency())\(data["specification_sale_price"] ?? "0")"
                self.imgBg.sd_setImage(with:URL.init(string:((data["specification_img"] ?? "" ) as? String)!), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                self.currentImg = data["specification_img"] as? String
                
                self.specification_id = "\(data["specification_id"] as? String ?? "0")"
                self.specification_stock = data["specification_stock"] as? String ?? "0"
                self.goodsPrice = data["specification_sale_price"] as? String ?? "0"
                if self.specification_stock == "0"{
                    self.numTf.text = "0"
                }else{
                    self.numTf.text = "1"
                }
            }
        })
        
        
        showText.text = NSLocalizedString("Hint_03", comment: "请选择") + guigeStr
        if goodsModel.goodsSpecificationBeans?.count == 0{
            showText.text = NSLocalizedString("Hint_11", comment: "规格：无")
        }
        
        
    }
    func imgBgTouch(){
        showPhotoBrown()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func dismisClick(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(imagePhoto.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < self.imagePhoto.count{
            
            return imagePhoto[Int(index)]
        }
        return nil
    }
    func showPhotoBrown(){
        DispatchQueue.main.async {
            let images:[String] = [self.currentImg ?? ""]
            let mphoto = MWPhotoBrowser.init(delegate: self)
            mphoto?.displayActionButton =  false
            self.imagePhoto.removeAll()
            for i in images.indices{
                if self.goodsModel != nil{

                    //banner图视频展示
                    if self.goodsModel.video_type == "1"{
                        if i == 0{
                            let video = MWPhoto.init(url: URL.init(string: images[i]))
                            video?.videoURL = URL.init(string: self.goodsModel.url!)
                            self.imagePhoto.append(video!)
                            mphoto?.autoPlayOnAppear = true
                        }else{
                            self.imagePhoto.append(MWPhoto.init(url: URL.init(string: images[i])) )
                        }
                    }else{
                        print(images[i])
                        self.imagePhoto.append(MWPhoto.init(url: URL.init(string: images[i])) )
                    }

                }
            }
            mphoto?.setCurrentPhotoIndex(UInt(0))
           let nav = UINavigationController.init(rootViewController: mphoto!)
            self.present(nav, animated: false, completion: nil)
//            self.navigationController?.pushViewController(mphoto!, animated: true)
        }
    }

    @IBAction func sureClick(_ sender: UIButton) {
        
        guigeStr = ""
        for m in itemCSArr.indices{
            if itemCSArr[m].specification_id == nil{
                guigeStr = " \(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
                ProgressHUD.showMessage(message:NSLocalizedString("Hint_03", comment: "请选择") + guigeStr )
                return
            }
        }
        
        if specification_stock == "0"{
            
            ProgressHUD.showMessage(message: NSLocalizedString("Hint_04", comment: "抱歉该商品已售完"))
            return
        }
        
        for m in itemCSArr.indices{
            confirspecification_names += "\(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误")):\(itemCSArr[m].specification_value ?? ""),"
        }
        if confirspecification_names == ""{
        
            confirspecification_names = NSLocalizedString("Hint_06", comment: "无规格")
        }

        if showType == .ShopCart {
            if isLiving == 1{
                NetworkingHandle.fetchNetworkData(url: "/api/Mall/insertShopCar", at: self, params: ["goods_id":goodsModel.goods_id!,"specification_id":specification_id,"goods_num":numTf.text!,"seller":seller,"live_id":live_id],  success: { (response) in
                    
                    ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_05", comment: "添加成功！商品已在购物车了哦，亲~"))
                    
                })
                
            }else{
                NetworkingHandle.fetchNetworkData(url: "/api/Mall/insertShopCar", at: self, params: ["goods_id":goodsModel.goods_id!,"specification_id":specification_id,"goods_num":numTf.text!],  success: { (response) in
                    
                    ProgressHUD.showNoticeOnStatusBar(message: NSLocalizedString("Hint_05", comment: "添加成功！商品已在购物车了哦，亲~"))
                    
                })
            }

        }else{
        
            changeParams?(specification_id,numTf.text!)
        
        }
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func reduceClick(_ sender: UIButton) {
        
        guigeStr = ""
        for m in itemCSArr.indices{
            if itemCSArr[m].specification_id == nil{
                guigeStr = " \(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
                ProgressHUD.showMessage(message:NSLocalizedString("Hint_03", comment: "请选择") + guigeStr )
                return
            }
        }
        if specification_stock == "0"{
            ProgressHUD.showMessage(message:NSLocalizedString("Hint_04", comment: "抱歉该商品已售完"))
            return
        }
      
        if  Int(self.numTf.text!) == 1{
            ProgressHUD.showMessage(message: NSLocalizedString("Hint_12", comment: "商品不能少于一件"))
            return
        }
        self.numTf.text = "\(Int(self.numTf.text!)! - 1)"
        
    }
    
    @IBAction func addClick(_ sender: UIButton) {
       
        guigeStr = ""
        for m in itemCSArr.indices{
            if itemCSArr[m].specification_id == nil{
                guigeStr = " \(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
                ProgressHUD.showMessage(message:NSLocalizedString("Hint_03", comment: "请选择") + guigeStr )
                return
            }
        }
        if specification_stock == "0"{
            ProgressHUD.showMessage(message: NSLocalizedString("Hint_04", comment: "抱歉该商品已售完"))
            return
        }
        if specification_stock == self.numTf.text!{
            ProgressHUD.showMessage(message:NSLocalizedString("Hint_13", comment:  "库存不足"))
            return
        }
        
        self.numTf.text = "\(Int(self.numTf.text!)! + 1)"
        
    }
}
extension AddShopCartViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddGoodsCartCollectionViewCell", for: indexPath) as! AddGoodsCartCollectionViewCell
        cell.model = goodsModel.goodsSpecificationBeans![indexPath.section].specificationBeans?[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return (goodsModel.goodsSpecificationBeans![section].specificationBeans?.count)!
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return goodsModel.goodsSpecificationBeans!.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AddGoodsCartCollectionReusableView", for: indexPath) as! AddGoodsCartCollectionReusableView
        view.kinds.text = goodsModel.goodsSpecificationBeans![indexPath.section].specification_value
        return view
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: kScreenWidth, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if tempCell == nil{
            tempCell = Bundle.main.loadNibNamed("AddGoodsCartCollectionViewCell", owner: nil, options: nil)?.first as! AddGoodsCartCollectionViewCell
        }
        tempCell.model = goodsModel.goodsSpecificationBeans![indexPath.section].specificationBeans?[indexPath.row]
        return tempCell.sizeForCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        for itemIndexPath in collectionView.indexPathsForSelectedItems!{
//            if itemIndexPath.section ==
            if itemIndexPath.section == indexPath.section && indexPath.item != itemIndexPath.item{
                if(indexPath.section < itemCSArr.count){
                    itemCSArr[indexPath.section] = (goodsModel.goodsSpecificationBeans![indexPath.section].specificationBeans?[indexPath.row])!
                    //                selectCSArr[indexPath.section] = "1"
                    DispatchQueue.main.async(execute: {
                        
                        if let cell = collectionView.cellForItem(at: itemIndexPath) as? AddGoodsCartCollectionViewCell{
                            
                            cell.didntselectLab()
                            
                            collectionView.deselectItem(at: itemIndexPath, animated: true)
                        }
                    })
                    
//                    let cell = collectionView.cellForItem(at: itemIndexPath) as! AddGoodsCartCollectionViewCell
                    
                    
                }
                
           break
            }
        
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showText.text = ""
//        if indexPath.section >= itemCSArr.count {
//            return
//        }
//        if (goodsModel.goodsSpecificationBeans![indexPath.section].specificationBeans?.count)! >= indexPath.row {
//            return
//        }
        itemCSArr[indexPath.section] = (goodsModel.goodsSpecificationBeans![indexPath.section].specificationBeans?[indexPath.row])!
//        selectCSArr[indexPath.section] = "1"

        //提示用户规格是否选择完成了
        guigeStr = ""
        for m in itemCSArr.indices{
            if  itemCSArr[m].specification_id == nil {
                if(m < goodsModel.goodsSpecificationBeans?.count ?? 0){
                    guigeStr +=  " \(goodsModel.goodsSpecificationBeans![m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
                }
                
            }
        }

        
        let cell = collectionView.cellForItem(at: indexPath) as! AddGoodsCartCollectionViewCell
        cell.didselectLab()

        //所有的规格都选择完成了
        for m in itemCSArr.indices{
            if itemCSArr[m].specification_id == nil{
                return
            }
        }
        
        guigeStr = ""
        guigeId = ""
        for m in itemCSArr.indices{
            guigeStr +=  " \(itemCSArr[m].specification_value ?? NSLocalizedString("Hint_01", comment: "此处规格参数有误"))"
            guigeId += ",\(itemCSArr[m].specification_id!)"
        }
        
        
       let param = guigeId.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
        if guigeId == ""{
            return
        }
        self.priceLab.text = ""
        self.storeNumLab.text = ""
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/get_specification", at: self, params: ["specification_ids":param,"goods_id":goodsModel.goods_id ?? ""], isShowHUD: false, success: { (response) in
            self.showText.text = NSLocalizedString("Hint_09", comment: "已选") + self.guigeStr
            if let data = response["data"] as? [String:Any]{

                self.storeNumLab.text = "\(NSLocalizedString("Hint_02", comment: "库存"))：\(data["specification_stock"] ?? "0")\(NSLocalizedString("Hint_10", comment: "件"))"
                
                
                self.priceLab.text =
                "\(PhoneTool.getCurrency())\(data["specification_sale_price"] ?? "0")"
                self.imgBg.sd_setImage(with:URL.init(string:(data["specification_img"] ?? "") as! String), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                self.currentImg = data["specification_img"] as? String
                self.specification_id = "\(data["specification_id"] as? String ?? "0")"
                self.specification_stock = data["specification_stock"] as? String ?? "0"
                self.goodsPrice = data["specification_sale_price"] as? String ?? "0"
                if self.specification_stock == "0"{
                  
                    self.numTf.text = "0"
                }else{
                    self.numTf.text = "1"
                }
            }
        })
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let predicate = NSPredicate.init(format: "section == %d",indexPath.section)
        
        let filterResult = (collectionView.indexPathsForSelectedItems! as NSArray).filtered(using: predicate)

        if filterResult.count <= 1{
            return false
        }
        return true
    }

    
}


