//
//  SwitchLivingRoomViewController.swift
//  DragonVein
//
//  Created by apple on 2017/5/27.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class SwitchLivingRoomViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var cur_play_view: UIView!
    var pre_play_view: UIView!
    var start_point : CGPoint!
    
    var bgImg: UIImageView?
    
    let vc = WatchLiveViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cur_play_view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        pre_play_view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight))
        
        self.view.insertSubview(pre_play_view, at: 0)
        self.view.insertSubview(cur_play_view, belowSubview: pre_play_view)
        
        let img = UIImage(named: "bg.jpg")
        let bgView = UIImageView(image: img!)
        bgView.contentMode = .scaleAspectFill
        bgView.clipsToBounds = true
        bgImg = bgView
        bgView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        pre_play_view.addSubview(bgView)
        
        let blurEffrct = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffrct)
        visualEffectView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        visualEffectView.alpha = 1
        bgView.addSubview(visualEffectView)
        
        let panGesReg = UIPanGestureRecognizer(target: self, action: #selector(handlePanAction(panG:)))
        panGesReg.delegate = self
        self.view.addGestureRecognizer(panGesReg)
        
        vc.liveList = liveList[indexSeleced]
//        vc.promptInfo = promptInfo
        self.addChildViewController(vc)
        cur_play_view.addSubview(vc.view)
        vc.view.frame = view.bounds
    }
    func handlePanAction(panG: UIPanGestureRecognizer) {
        if liveList.count <= 1 {
            return
        }
        switch panG.state {
        case .began:
            start_point = panG.location(in: cur_play_view)
        case .ended:
            let finalY = cur_play_view.frame.origin.y
            if abs(finalY) > kScreenHeight/4 {
                if finalY < 0 {
                    self.indexSeleced! += 1
                    UIView.animate(withDuration: 0.25, animations: {
                        self.cur_play_view.frame = CGRect(x: 0, y: -kScreenHeight, width: kScreenWidth, height: kScreenHeight)
                        self.pre_play_view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                    }, completion: { (finished) in
                        self.panEnd()
                    })
                } else {
                    self.indexSeleced! -= 1
                    UIView.animate(withDuration: 0.25, animations: {
                        self.cur_play_view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
                        self.pre_play_view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                    }, completion: { (finished) in
                        self.panEnd()
                    })
                }
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.cur_play_view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                    if finalY < 0 {
                        self.pre_play_view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
                    } else {
                        self.pre_play_view.frame = CGRect(x: 0, y: -kScreenHeight, width: kScreenWidth, height: kScreenHeight)
                    }
                })
            }
        case .changed:
            let transation = panG.translation(in: cur_play_view)
            var center = cur_play_view.center
            center.y += transation.y
            cur_play_view.center = center
            let height_2 = kScreenHeight/2
            var frame = self.pre_play_view.frame
            var url = ""
            if center.y < height_2 {
                frame.origin.y = kScreenHeight - abs(height_2 - center.y)
                url = self.liveList[self.getIndex(interval: 1)].play_img!
            } else {
                frame.origin.y = -kScreenHeight + abs(height_2 - center.y)
                url = self.liveList[self.getIndex(interval: -1)].play_img!
            }
            self.pre_play_view.frame = frame
            bgImg?.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "bg.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        default:
            break
        }
        panG.setTranslation(CGPoint.zero, in: cur_play_view)
    }
    
    func getIndex() -> Int {
        if indexSeleced == liveList.count {
            indexSeleced = 0
        } else if indexSeleced < 0 {
            indexSeleced = liveList.count - 1
        }
        return indexSeleced
    }
    func getIndex(interval: Int) -> Int {
        let index = indexSeleced + interval
        if index == liveList.count {
            return 0
        } else if index < 0 {
            return liveList.count - 1
        }
        return index
    }
    func panEnd() {
        self.cur_play_view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.pre_play_view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
                
//                func preSwitch() {
//                    self.vc.switchoverLivingRoom(model: self.liveList[self.getIndex()], failure: {
//                        self.liveList.remove(at: self.indexSeleced)
//                        self.indexSeleced! -= 1
//                        preSwitch()
//                    })
//                }
//                preSwitch()
            }
        }
    }
    
    var promptInfo: String?
    var liveList: [LiveList]!
    var indexSeleced : Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    class func toWatch(from vc: UIViewController, lists: [LiveList], index: Int) {
        let model = lists[index]
        NetworkingHandle.fetchNetworkData(url: "Index/check_anchor_state", at: vc, params: ["user_id": model.user_id!], success: { (result) in
            NetworkingHandle.fetchNetworkData(url: "Index/into_live", at: vc, params: ["live_id": model.live_id!], success: { (result) in
                let data = result["data"] as? [String: String]
                let watch = SwitchLivingRoomViewController()
                watch.promptInfo = data?["prompt"]
                watch.liveList = lists
                watch.indexSeleced = index
                vc.navigationController?.pushViewController(watch, animated: true)
            })
        })
    }
}
