//
//  WatchEndViewController.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/23.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import HandyJSON
class WatchEndViewController: UIViewController {

    @IBOutlet weak var merchantHome: UIButton!
    @IBOutlet weak var attentBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var watchNumber: UILabel!
    
    var liveId: String?
    var model: WatchEndLive?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        avatar.layer.cornerRadius = 89/2.0
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        
        NetworkingHandle.fetchNetworkData(url: "/api/live/live_end", at: self, params: ["live_id": liveId!], isShowHUD: false, isShowError: false, success: { (result) in
            if let data = result["data"] as? NSDictionary{
                let model = WatchEndLive.deserialize(from: data)
                self.model = model!
                self.avatar.sd_setImage(with: URL.init(string: model?.header_img ?? ""), placeholderImage: #imageLiteral(resourceName: "moren-2"))
                self.nickname.text = model?.username
                if model?.is_follow == "1" {
                    self.attentBtn.isSelected = false
                } else {
                    self.attentBtn.isSelected = true
                }
                if model?.is_anchor == "2" {
                    self.merchantHome.isHidden  = true
                    self.attentBtn.isHidden = true
                }else{
                    self.merchantHome.isHidden  = false
                    self.attentBtn.isHidden = false
                }
                self.watchNumber.text = (model?.watch_nums!)! + "人已看过"

            }
           
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func attentButtonAction(_ sender: UIButton) {
        if let m = model {
            focusOtherPerson(viewResponder: self, other_id: m.user_id!, btn: sender, type: m.is_follow!) {
                if m.is_follow == "1" {
                    m.is_follow = "2"
                } else {
                    m.is_follow = "1"
                }
            }
        }
    }
    @IBAction func toAnchorHomepageButtonAction(_ sender: UIButton) {
        let vc = MerchantViewController()
        vc.merchants_id = model?.user_id ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
class WatchEndLive: HandyJSON {
    var live_id:String?
    var user_id: String?
    var play_img: String?
    var title: String?
    var start_time: String?
    var end_time: String?
    var watch_nums: String?
    var header_img:String?
    var img: String?
    var username: String?
    var signature: String?
    var time: String?
    var is_follow: String?
    var is_anchor:String?
    required init(){}
}

