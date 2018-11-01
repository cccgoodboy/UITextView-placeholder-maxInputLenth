//
//  OpenPlatformManager.swift
//  MoDuLiving
//
//  Created by 曾觉新 on 2017/3/13.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit

//class OpenPlatformManager: NSObject {
//    
//    
//    static var shareInstance: OpenPlatformManager {
//        struct Static {
//            static let instance: OpenPlatformManager = OpenPlatformManager()
//        }
//        return Static.instance
//    }
//    private override init() {}
//    
//    
//    
//    func openPlatformLogin(type: UMSocialPlatformType, success: @escaping (Dictionary<String, Any>) -> ()) {
//        print(type)
//        
//        UMSocialManager.default().getUserInfo(with: type, currentViewController: nil, completion: {(result, error) in
//            if error == nil {
//                let resp: UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse;
//                self.bindOpenPlatform(platformType: type, resp: resp, success: success)
//            }
//        })
//    }
//    
//    func openPlatformShare(type: UMSocialPlatformType, success: @escaping (Dictionary<String, Any>) -> ()) {
//        let messageObject: UMSocialMessageObject = UMSocialMessageObject()
//        let shareObject :UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: "111", descr: "222", thumImage: UIImage(named: "Invitation-weibo"))
//        shareObject.webpageUrl = "http://www.baidu.com"
//        
//        messageObject.shareObject = shareObject
//        messageObject.text = "文本"
//        
//        UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: nil, completion: {(result, error) in
//            
//            
//        })
//    }
//    
//    
//    
//    
//    private func bindOpenPlatform(platformType: UMSocialPlatformType, resp: UMSocialUserInfoResponse, success: @escaping (Dictionary<String, Any>) -> ()) {//绑定第三方账号
//        var type = "1"
//        
//        switch platformType {
//        case .QQ:
//            type = "2"
//        case .wechatSession:
//            type = "1"
//        case .sina:
//            type = "3"
//        default:
//            break
//        }
//        var openid = resp.uid
//        if openid == nil || openid?.characters.count == 0 {
//            openid = resp.openid
//        }
//        let params: [String : AnyObject] = ["type" : type as AnyObject,
//                                            "openid": openid as AnyObject]
////        NetworkingHandle.fetchNetworkData(url: "/User/bound", at: self, params: params,  success: { (response) in
////            success(response)
////        })
//       
//    }
//    
//    
//}
