//
//  SelectCouponViewController.swift
//  CSMall
//
//  Created by taoh on 2017/11/27.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SelectCouponViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var coupons = [CouponBeanModel]()
    @IBOutlet weak var tableView: UITableView!
    var couponSelectBlock:((CouponBeanModel)->())?

    @IBAction func sureClick(_ sender: UIButton) {
        for item in coupons.enumerated(){
            if item.element.isSeleted == true{
                self.couponSelectBlock!(item.element)
            }         
        }
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func dismissClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "SelectCouponTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectCouponTableViewCell")
         self.modalPresentationStyle = .custom

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return coupons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCouponTableViewCell", for: indexPath) as! SelectCouponTableViewCell
        cell.model = coupons[indexPath.row]
        cell.selectClickBlock = { model ,sender in
            for item in self.coupons.enumerated(){
                if item.element.id == model.id {
                    model.isSeleted =  sender.isSelected
                }else{
                    item.element.isSeleted = false
                }
                self.tableView.reloadData()
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
