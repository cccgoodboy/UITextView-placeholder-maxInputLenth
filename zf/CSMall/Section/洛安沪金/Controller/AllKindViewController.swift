//
//  AllKindViewController.swift
//  CSMall
//
//  Created by taoh on 2017/10/30.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import MJRefresh

class AllKindViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var rightFaildView: UIView!
    
    @IBOutlet weak var leftFaildView: UIView!
    
    var ancesData:[GoodsClassModel] = [GoodsClassModel] ()
    var currentIndex = 0
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var lastPath = IndexPath.init(row: 0, section: 0)//当前选中的cell的indexPath

    var tabDataArr:[GoodsClassModel] = [GoodsClassModel] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        navigationBtn()
        tableView.register(UINib(nibName: "AllKindTableViewCell", bundle: nil), forCellReuseIdentifier: "AllKindTableViewCell")
        
        collectionView.register(UINib.init(nibName: "GoodKindViewheader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodKindViewheader")
        collectionView.register(UINib(nibName: "AllKindCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllKindCollectionViewCell")
        collectionView.register(UINib.init(nibName: "AllKindCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AllKindCollectionReusableView")
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let w = (kScreenWidth * 3/4) - 10*2
//        layout.itemSize = CGSize(width: w/3 - 1, height: w/3*3/5 + 30)

        layout.itemSize = CGSize(width: w/3 - 1, height: w/3 + 30)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.fetchData()
        
        self.leftFaildView.isHidden = true
        self.rightFaildView.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    func navigationBtn(){
        let control = UIControl()
        if  #available(iOS 11, *){
            control.frame = CGRect.init(x: -navigationBarTitleViewMargin(), y: 0, width: 70, height: 44)
            control.extendRegionType = ExtendRegionType.ClickExtendRegion
        }else{
            control.frame = CGRect.init(x: -20, y: 0, width: 70, height: 44)
        }
        
//        let lab =  UILabel( )
//        lab.text =  LocationManager.shared.city//"新疆维吾尔自治区"
//        lab.textAlignment = .center
//        lab.textColor = UIColor.white
//        lab.adjustsFontSizeToFitWidth = true
//        lab.frame =  CGRect.init(x:control.frame.origin.x, y: 10, width: control.frame.size.width, height: 20)
//        lab.font = UIFont.systemFont(ofSize: 14)
//        lab.minimumScaleFactor  = 0.5
//        control.addSubview(lab)
//
//        let img = UIImageView()
//        img.image = #imageLiteral(resourceName: "more_up")
//        img.contentMode = .scaleAspectFit
//        if  #available(iOS 11, *){
//            img.frame = CGRect.init(x: control.frame.origin.x, y: 30, width: control.frame.size.width, height: 7)
//        }else{
//            img.frame = CGRect.init(x: control.frame.origin.x, y: 30, width: control.frame.size.width, height: 7)
//        }
//        control.addTarget(self, action: #selector(selectAddress(sender:)), for: .touchUpInside)
//        control.addSubview(img)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: control)
//        let rightBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "saoyisao"), style: .done, target: self, action: #selector(scanner))
//        self.navigationItem.rightBarButtonItem = rightBtn
        
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.setImage(#imageLiteral(resourceName: "dianpu_sousuo"), for: .normal)
        searchBtn.setTitle(NSLocalizedString("Pleaseentertheproducttosearch", comment: "请输入需要搜索的内容"), for: .normal)
        searchBtn.setTitleColor(UIColor(hexString: "#999999"), for: .normal)
        searchBtn.layer.cornerRadius = 15
        searchBtn.contentVerticalAlignment = .center
        searchBtn.contentHorizontalAlignment = .left
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.backgroundColor =  RGBA(r: 251, g:251, b: 251, a: 0.6)
        if #available(iOS 11, *){
            searchBtn.frame = CGRect.init(x: 0, y: 5, width: kScreenWidth  - 50, height: 30)
        }else{
            searchBtn.frame = CGRect.init(x: 0, y: 5, width: kScreenWidth  - 50, height: 30)
        }
        searchBtn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        self.navigationItem.titleView = searchBtn
        
    }
    func searchClick(){
//        let search =  SearchShopViewController()
//        self.navigationController?.pushViewController(search, animated: true)
        self.navigationController?.pushViewController(SearchGoodsViewController(), animated: true)
    }
    @IBAction func letftFaildClick(_ sender: UIButton) {
        self.fetchData()
    }
    @IBAction func rightFaildClick(_ sender: UIButton) {
        let model = tabDataArr[lastPath.row]
        loadData(class_id: model.class_uuid ?? "")
    }
    func fetchData() {
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/parent_class", at: self, isShowHUD: true, isShowError: true, success: { (response) in
            self.leftFaildView.isHidden = true
            self.rightFaildView.isHidden = true

            if let currentData = response["data"] as? NSArray{
                self.tabDataArr = [GoodsClassModel].deserialize(from: currentData) as! [GoodsClassModel]
            }
            self.tableView.reloadData()
            let model = self.tabDataArr[self.currentIndex]
            self.loadData( class_id: model.class_uuid!)
        }) {
            //失败页面
            self.leftFaildView.isHidden = false
            self.rightFaildView.isHidden = true

        }
    }
    func loadData(class_id:String){
        
        let param = ["class_uuid":class_id]
        NetworkingHandle.fetchNetworkData(url: "/api/Mall/seed_class", at: self,params: param,hasHeaderRefresh:collectionView, success:  { (response) in
            self.leftFaildView.isHidden = true
            self.rightFaildView.isHidden = true

            if let currentData = response["data"] as? NSArray{
                self.ancesData = [GoodsClassModel].deserialize(from: currentData) as! [GoodsClassModel]
                self.collectionView.reloadData()
            }
        }){
            self.leftFaildView.isHidden = true
            self.rightFaildView.isHidden = false

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllKindTableViewCell", for: indexPath) as! AllKindTableViewCell
        
        let model = tabDataArr[indexPath.row]
        cell.titleLab.text = model.class_name
//        cell.titleBtn.setTitle(model.class_name, for: UIControlState.normal)
        if lastPath == indexPath {
//            cell.titleLab.isSelected = true
            cell.titleLab.textColor = UIColor.red
//            cell.titleLab?.font = UIFont.systemFont(ofSize: 15)
//            cell.titleBtn.setTitleColor(UIColor.red, for: .normal)
//            cell.titleBtn.titleLabel?.font =
        }else{
//            cell.titleBtn.isSelected = false
//            cell.titleBtn.setTitleColor(UIColor.black, for: .normal)
            cell.titleLab.textColor = UIColor.black
            cell.titleLab?.font = UIFont.systemFont(ofSize: 14)

//            cell.titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabDataArr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lastPath != indexPath{
            lastPath = indexPath
            self.currentIndex = indexPath.row
            let model = tabDataArr[indexPath.row]
            loadData(class_id: model.class_uuid ?? "")

            tableView.reloadData()
        }
        print("lastPath == \(lastPath)++ indexPath == \(indexPath)")

        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return ancesData.count

    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ancesData[section].san.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllKindCollectionViewCell", for: indexPath) as! AllKindCollectionViewCell
//        cell.backgroundColor = UIColor.red
        
        let model = ancesData[indexPath.section].san[indexPath.row]
        cell.refershData(model: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return  CGSize.init(width: kScreenWidth, height: section == 0 ? 120/375*kScreenWidth + 44 : 44)
    }
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //AllKindCollectionReusableView
        
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AllKindCollectionReusableView", for: indexPath) as! AllKindCollectionReusableView
//        header.backgroundColor = UIColor.red
        if indexPath.section == 0{
            header.imageHeight.constant = 120/375*kScreenWidth
        }else{
            header.imageHeight.constant = 0
        }
        
        let model = self.tabDataArr[self.currentIndex]
        header.kindImageView.sd_setImage(with: URL.init(string: model.template_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
        header.titleLab.text = model.class_name ?? ""
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GoodKindViewheader", for: indexPath) as! GoodKindViewheader
//        header.leftkindView.isHidden = true
//        header.rightkindView.isHidden = true
//        header.kind.isHidden = true
//        if tabDataArr.count > 0{
//            header.banner.sd_setImage(with: URL.init(string: tabDataArr[lastPath.row].template_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
//        }
//        header.viewheight.constant = 0
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = KindDescViewController()
        vc.classModel = ancesData[indexPath.section].san[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func searchButtonAction() {
        print("搜索法物")
        
    }
    
}
