//
//  ShowAddressViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/22.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class ShowAddressViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var itemCityClick:((String)->())?
    let Pinyin = ["默认",   "A B C","D E F","G H I ","J K L ","M N O","P Q R","S T U","V W X","Y Z "]
    let searchPinyin = ["","A,B,C","D,E,F","G,H,I","J,K,L","M,N,O","P,Q,R","S,T,U","V,W,X","Y,Z"]
    var currentIndex = IndexPath.init(row: 0, section: 1)
    var city:[[CityModel]] = [[CityModel]]()
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.itemSize =  CGSize.init(width: (kScreenWidth - 40)/4, height: 30)
        title = "选择"
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        collectionView.register(UINib.init(nibName: "ShowKindCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowKindCollectionViewCell")
        for item in searchPinyin.enumerated(){
            city.append([CityModel]())
        }
        loadData(name:"")
    }
    func loadData(name:String){
        NetworkingHandle.fetchNetworkData(url: "/api/Home/city", at: self, params: ["name":name], hasHeaderRefresh: collectionView, success: { (response) in
            
            if let data = response["data"] as? NSArray{
                
//                for (index,item) in self.searchPinyin.enumerated(){
//                    if item == name{
                self.city[self.currentIndex.row] = [CityModel].deserialize(from: data)! as! [CityModel]
//                    }
//                }
            }
            self.collectionView.reloadData()
            
        }) {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  section == 0 ? Pinyin.count : city[currentIndex.row].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ShowKindCollectionViewCell", for: indexPath) as! ShowKindCollectionViewCell
        if indexPath.section == 0{
            cell.kindtitle.text = Pinyin[indexPath.row]

        }else{
            cell.kindtitle.text = city[currentIndex.row][indexPath.row].city
        }
        cell.kindtitle.minimumScaleFactor = 0.5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section ==  0{
            if currentIndex == indexPath{
                return
            }
            currentIndex = indexPath
            if city[currentIndex.row].count != 0{
                self.collectionView.reloadData()
            }else{
                loadData(name: searchPinyin[indexPath.row])
                
            }
        }else{
            self.itemCityClick?(city[currentIndex.row][indexPath.row].city ?? LocationManager.shared.city)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}
