//
//  LivingEndViewController.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/23.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class LivingEndViewController: UIViewController {

    @IBOutlet weak var watchNumber: UILabel!
    
    var liveId: String?
    var urls: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkingHandle.fetchNetworkData(url: "Index/end_live", at: self, params: ["live_id": liveId!], success: { (result) in
            let model = AnchorLiveEndModel.modelWithDictionary(diction: result["data"] as! [String : AnyObject])
            self.urls = model.url
            self.watchNumber.text = model.watch_nums
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        if urls == nil || urls == "" {
            ProgressHUD.showNoticeOnStatusBar(message: "直播时间太短，不能分享")
            return
        }
        if sender.tag == 1000 {
            shareAction(type: .wechatTimeLine)
        } else if sender.tag == 1001 {
            shareAction(type: .wechatSession)
        } else if sender.tag == 1002 {
            shareAction(type: .sina)
        } else if sender.tag == 1003 {
            shareAction(type: .QQ)
        } else if sender.tag == 1004 {
            shareAction(type: .qzone)
        } else {
            UIPasteboard.general.string = self.urls
            ProgressHUD.showSuccess(message: "已复制到剪切板")
        }
    }
    //FIXME:TH等待数据
    func shareAction(type: UMSocialPlatformType) {
//        let object = UMShareWebpageObject()
//        object.webpageUrl = self.urls
//        let userInfo = DLUserInfoHandler.getUserBaseInfo()
//        object.title = "你丑你先睡，我美我直播！"
//        object.descr = "「" + userInfo.name + "」正在直播，快来一起看~"
//        let data: Data = try! Data.init(contentsOf: URL(string: userInfo.img)!)
//        let image = UIImage(data:data, scale: 1.0)
//        object.thumbImage = image
//        
//        let messageObject = UMSocialMessageObject(mediaObject: object)
//        
//        UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: self) { (data, error) in
//            if error == nil {
//                ProgressHUD.showSuccess(message: "分享成功！！！")
//            } else {
//                ProgressHUD.showMessage(message: "分享失败")
//            }
//        }
    }

    @IBAction func backButtonAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: -- model
class AnchorLiveEndModel: KeyValueModel {
    var live_id: String?
    var user_id: String?
    var play_img: String?
    var title: String?
    var start_time: String?
    var end_time: String?
    var watch_nums: String?
    var share: String?
    var img: String?
    var username: String?
    var company: String?
    var duty: String?
    var autograph: String?
    var id: String?
    var beat: String?
    var time: String?
    var get_fire: String?
    var url: String?
}
