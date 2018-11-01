//
//  SettingViewController.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/4.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    let showData = [[["title":"个人资料","image":"wode_shezhi_ziliao"],["title":"修改登录密码","image":"wode_shezhi_xiugaimima"]],[["title":"地址管理","image":"wode_shezhi_dizhi"],["title":"清除缓存","image":"wode_shezhi_qinghuancun"]],[["title":"意见反馈","image":"wode_shezhi_yijianfankui"]]]

    let showData = [[["title":NSLocalizedString("Hint_206", comment: "个人资料"),"image":"wode_shezhi_ziliao"]],[["title":NSLocalizedString("Hint_207", comment: "地址管理"),"image":"wode_shezhi_dizhi"],["title":NSLocalizedString("Hint_209", comment: "清除缓存"),"image":"wode_shezhi_qinghuancun"]],[["title":NSLocalizedString("Hint_208", comment: "意见反馈"),"image":"wode_shezhi_yijianfankui"]]]
    @IBOutlet weak var setTab: UITableView!
   
    @IBAction func loginoutClick(_ sender: UIButton) {
        let alertController = UIAlertController(title: "提示", message: "是否确定退出登录", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
            DispatchQueue.main.async {
                CSUserInfoHandler.deleteUserInfo()
                self.tabBarController?.selectedIndex = 0
//                UIApplication.shared.keyWindow?.rootViewController = LoginNavigationController.setup()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        view.backgroundColor = setTab.backgroundColor
        setTab.register(UITableViewCell.self, forCellReuseIdentifier: "setCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return showData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return showData[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
//        cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "setCell")
        }
        cell?.accessoryType = .disclosureIndicator

        cell?.textLabel?.text = showData[indexPath.section][indexPath.row]["title"]
        cell?.imageView?.image = UIImage.init(named: showData[indexPath.section][indexPath.row]["image"]!)
        cell?.textLabel?.textColor = RGBA(r: 54, g: 54, b: 54, a: 1)
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.detailTextLabel?.textColor = RGBA(r: 153, g: 153, b: 153, a: 1)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)

//        cell?.detailTextLabel?.text = "aaa"
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            self.navigationController?.pushViewController(PersonalVC(), animated: false)
//            switch indexPath.row {
//            case 0:
//                self.navigationController?.pushViewController(PersonalVC(), animated: false)
//            default:
//                self.navigationController?.pushViewController(PersonalVC(), animated: false)
//            }
        }else if indexPath.section == 1{
            switch indexPath.row{
            case 0:
               let addressVc = AddressVC()
               addressVc.fromMine = true
               self.navigationController?.pushViewController(addressVc, animated: true)
            default:
                CacheTool.clearCache()
            }
            
        }else {
            self.navigationController?.pushViewController(FeedViewController(), animated: true)

            
        }
    }

    

}
