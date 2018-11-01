//
//  AddressVC.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/3.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class AddressVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,AddressTableViewCellDelegate {
    
    @IBOutlet weak var addressBtn: UIButton!
    var changeAddress:((AddressModel)->Void)?
    @IBOutlet weak var addressTab: UITableView!
    var address:[AddressModel] = [AddressModel]()
    var fromMine:Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addressBtn.setTitle(NSLocalizedString("Addnewaddress", comment: "添加新地址"), for: .normal)
        addressBtn.backgroundColor = themeColor
        title = NSLocalizedString("Myaddress", comment: "我的地址")
        loadData()
        addressTab.register(UINib.init(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(refershdata), name: NSNotification.Name(rawValue: "addSuccess"), object: nil)
    }
    func refershdata(){
        loadData()
    }
    func loadData(){
        
        NetworkingHandle.fetchNetworkData(url: "/api/Address/queryAddressList", at: self, isShowHUD: false, isShowError: true,  success: { (response) in
            
            if let data = response["data"] as? NSArray {
                
                self.address = [AddressModel].deserialize(from: data)! as! [AddressModel]
                self.addressTab.reloadData()
            }
        }) {
            
        }
    }
   

    func numberOfSections(in tableView: UITableView) -> Int {
        return address.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.delegate = self
        cell.refershData(address:address[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fromMine! {
            return
        }
        changeAddress?(address[indexPath.section])
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addAddressClick(_ sender: UIButton) {
        
        let vc = AddAdressVC()
        vc.addressType = 0
        vc.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.5)
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func adefaultAddressClick(sender: UIButton, cell: AddressTableViewCell) {
        let index = addressTab.indexPath(for: cell)
        ProgressHUD.showLoading(toView: self.view)
        NetworkingHandle.fetchNetworkData(url: "/api/Address/saveDefaultAddress", at: self, params: ["address_id":address[(index?.section)!].address_id ?? ""], success: { (response) in
            
            ProgressHUD.showMessage(message: "默认地址设置成功")
            
            
            self.loadData()
        }) {
            
        }
    }
    func adeleteClick(sender: UIButton, cell: AddressTableViewCell) {
        let index = addressTab.indexPath(for: cell)

        let alert = UIAlertController.init(title: "", message: "确定要删除改地址吗？", preferredStyle: .alert)
        let action  = UIAlertAction.init(title: "取消", style: .cancel) { (a) in
            
        }
        let sureaction  = UIAlertAction.init(title: "确定", style: .destructive) { (a) in
            NetworkingHandle.fetchNetworkData(url: "/api/Address/delAddress", at: self, params: ["address_id": self.address[(index?.section)!].address_id ?? ""], success: { (result) in
                ProgressHUD.showMessage(message: "删除成功")
                self.loadData()

            })
            
        }
        alert.addAction(action)
        alert.addAction(sureaction)
        self.present(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

