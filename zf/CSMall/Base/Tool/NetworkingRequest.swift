//
//  NetworkingRequest.swift
//  CrazyEstate
//
//  Created by Luiz on 2017/1/16.
//  Copyright © 2017年 liangyi. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
import SwiftyJSON
let currentVersion = Bundle.main.infoDictionary?[String(kCFBundleVersionKey)] as? String ?? "0"

class NetworkingHandle: NSObject {
    
    static var mainHost = BaseURL
    static func fetchTestNetworkData(url: String, at: UIResponder, params: Dictionary<String, Any> = [:], isAuthHide: Bool = true, isShowHUD: Bool = true, isShowError: Bool = true, hasHeaderRefresh: UIScrollView? = nil, success: @escaping (Dictionary<String, JSON>) -> (), failure: (() -> ())? = nil) {
        var params = params
        
        let languages = Locale.preferredLanguages.first
        
        if (languages?.contains("en"))!{//英文环境
            params["lang_type"] = "en"
        }else if (languages?.contains("zh"))!{
            params["lang_type"] = "cn"
        }else{
            params["lang_type"] = ""
        }
        
        if let m = CSUserInfoHandler.getIdAndToken() {
            params["uid"] = m.uid
            params["token"] = m.token
        }
        var atView: UIView
        if at is UIViewController {
            atView = (at as! UIViewController).view
        } else if at is UIView {
            if let vc = (at as? UIView)?.responderViewController() {
                atView = vc.view
            }
            atView = UIApplication.shared.keyWindow!
        } else {
            atView = UIApplication.shared.keyWindow!
        }
        print(params)
        if hasHeaderRefresh == nil, isShowHUD {
            ProgressHUD.showLoading(toView: atView)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("【请求URL】=======>\(mainHost)\(url)")
        Alamofire.request(mainHost + url, method: .post, parameters: params).responseString { (dataResponse) in
            
            let resultString:String = dataResponse.result.value!
            
            let cleanString = PhoneTool.clearString(base: resultString, clearSub: "（\"\"）")
            
            
            
            if let dataFromString = cleanString.data(using: .utf8, allowLossyConversion: false) {
                let json = try? JSON(data: dataFromString)
                
                success((json?.dictionaryValue)!)
            }
            
            
            
            
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            if let scrollView = hasHeaderRefresh {
//                scrollView.mj_header?.endRefreshing()
//                scrollView.mj_footer?.endRefreshing()
//            } else if isAuthHide, isShowHUD {
//                ProgressHUD.hideLoading(toView: atView)
//            }
//            print(dataResponse);
//            if let error = dataResponse.result.error {
//                if let status = dataResponse.response?.statusCode {
//                    if status != 200{
//                        print(url + "失败")
//                        ProgressHUD.showNoticeOnStatusBar(message: "\(status)-服务器访问失败")
//                    }
//                } else {
//                    ProgressHUD.showNoticeOnStatusBar(message: error.localizedDescription)
//                }
//                print(error);
//                failure?()
//            } else {
//                guard let json = dataResponse.result.value else {
//                    failure?()
//                    ProgressHUD.showNoticeOnStatusBar(message: "未知错误")
//                    return
//                }
//                print("==================接口数据++++++++++++++\n\(json)")
//                let result: Dictionary<String, Any> = json as! Dictionary
//                let code: String = (result["status"] as? String)!
//                if code == "ok" {
//                    if atView is UIWindow || atView.superview != nil {
//                        success(result)
//                    }
//                } else {
//                    switch code {
//                    case "error":
                        //
                        //                        if let a = result["data"] as? String{
                        //
                        //                            if a == "token failed"{
                        //                                CSUserInfoHandler.deleteUserInfo()
                        //                                //我被注释了
                        //                                let vc = UINavigationController.init(rootViewController: LoginViewController())
                        //
                        ////                                ObtainVC.getCurrentController()?.present(vc, animated: false, completion: nil)
                        //
                        //                                UIApplication.shared.keyWindow?.rootViewController = vc
                        //                            }
                        //                        }
//                        if let str = result["data"] as? String{
//                            ProgressHUD.showNoticeOnStatusBar(message: str)
//                        }
//
//                        break
//                    case "pending":
                        //ProgressHUD.showNoticeOnStatusBar(message: result["error"] as! String)
                        
//                        CSUserInfoHandler.deleteUserInfo()
//                        var vc = UIApplication.shared.keyWindow?.rootViewController
//                        if ((vc?.presentedViewController) != nil){
//                            vc = vc?.presentedViewController
//                        }
//                        let login = LoginViewController()
//                        login.loginType = LoginType.login_normal
//                        vc?.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
//                        break
//
//                    default:
//                        failure?()
//                        if isShowError {
//                            print(url + "失败")
//
//                            ProgressHUD.showMessage(message: result["data"] as? String ?? "未知错误")
//                        }
//                    }
//                }
//            }
        }
    }
    
    // POST 请求 Info
    static func fetchNetworkData(url: String, at: UIResponder, params: Dictionary<String, Any> = [:], isAuthHide: Bool = true, isShowHUD: Bool = true, isShowError: Bool = true, hasHeaderRefresh: UIScrollView? = nil, success: @escaping (Dictionary<String, Any>) -> (), failure: (() -> ())? = nil) {
        var params = params
        
        let languages = Locale.preferredLanguages.first
      
        if (languages?.contains("en"))!{//英文环境
            params["lang_type"] = "en"
        }else if (languages?.contains("zh"))!{
            params["lang_type"] = "cn"
        }else{
            params["lang_type"] = ""
        }
       
        if let m = CSUserInfoHandler.getIdAndToken() {
            params["uid"] = m.uid
            params["token"] = m.token
        }
        var atView: UIView
        if at is UIViewController {
            atView = (at as! UIViewController).view
        } else if at is UIView {
            if let vc = (at as? UIView)?.responderViewController() {
                atView = vc.view
            }
            atView = UIApplication.shared.keyWindow!
        } else {
            atView = UIApplication.shared.keyWindow!
        }
        print(params)
        if hasHeaderRefresh == nil, isShowHUD {
            ProgressHUD.showLoading(toView: atView)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("【请求URL】=======>\(mainHost)\(url)")
        Alamofire.request(mainHost + url, method: .post, parameters: params).responseJSON { (dataResponse) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let scrollView = hasHeaderRefresh {
                scrollView.mj_header?.endRefreshing()
                scrollView.mj_footer?.endRefreshing()
            } else if isAuthHide, isShowHUD {
                ProgressHUD.hideLoading(toView: atView)
            }
            print(dataResponse);
            if let error = dataResponse.result.error {
                if let status = dataResponse.response?.statusCode {
                    if status != 200{
                        print(url + "失败")
                        ProgressHUD.showNoticeOnStatusBar(message: "\(status)-服务器访问失败")
                    }
                } else {
                    ProgressHUD.showNoticeOnStatusBar(message: error.localizedDescription)
                }
                print(error);
                failure?()
            } else {
                guard let json = dataResponse.result.value else {
                    failure?()
                    ProgressHUD.showNoticeOnStatusBar(message: "未知错误")
                    return
                }
                print("==================接口数据++++++++++++++\n\(json)")
                let result: Dictionary<String, Any> = json as! Dictionary
                let code: String = (result["status"] as? String)!
                if code == "ok" {
                    if atView is UIWindow || atView.superview != nil {
                        success(result)
                    }
                } else {
                    switch code {
                    case "error":
//                        
//                        if let a = result["data"] as? String{
//                        
//                            if a == "token failed"{
//                                CSUserInfoHandler.deleteUserInfo()
//                                //我被注释了
//                                let vc = UINavigationController.init(rootViewController: LoginViewController())
//                            
////                                ObtainVC.getCurrentController()?.present(vc, animated: false, completion: nil)
//
//                                UIApplication.shared.keyWindow?.rootViewController = vc
//                            }
//                        }
                        if let str = result["data"] as? String{
                            ProgressHUD.showNoticeOnStatusBar(message: str)
                        }

                        break
                    case "pending":
                        //ProgressHUD.showNoticeOnStatusBar(message: result["error"] as! String)

                        CSUserInfoHandler.deleteUserInfo()
                        var vc = UIApplication.shared.keyWindow?.rootViewController
                        if ((vc?.presentedViewController) != nil){
                            vc = vc?.presentedViewController
                        }
                        let login = LoginViewController()
                        login.loginType = LoginType.login_normal
                        vc?.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
                        break

                    default:
                        failure?()
                        if isShowError {
                            print(url + "失败")

                            ProgressHUD.showMessage(message: result["data"] as? String ?? "未知错误")
                        }
                    }
                }
            }
        }
    }
    //上传单张图片
    static func uploadPicture(url:String, atVC: UIViewController, image: URL, isAuthHide: Bool = true, uploadSuccess: @escaping (_: Dictionary<String, Any>) -> (), failure: (() -> ())? = nil) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ProgressHUD.showLoading(toView: atVC.view)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image, withName: "img")
            
        }, to: URL(string:BaseURL + url)!, encodingCompletion: {
            (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if isAuthHide {
                        ProgressHUD.hideLoading(toView: atVC.view)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if response.response?.statusCode == 200 {
                        guard let json = response.result.value else {
                            ProgressHUD.showNoticeOnStatusBar(message: "未知错误")
                            failure?()
                            return
                        }
                        let result: Dictionary<String, Any> = json as! Dictionary
                        print(result)
                        let code: String = (result["status"] as? String)!
                        if code == "ok" {
                            if atVC.view.superview != nil {
                                uploadSuccess(result)
                            }
                        } else {
                            switch code {
                            case "pending":
                                ProgressHUD.showNoticeOnStatusBar(message: result["error"] as! String)
                                CSUserInfoHandler.deleteUserInfo()
                                var vc = UIApplication.shared.keyWindow?.rootViewController
                                if ((vc?.presentedViewController) != nil){
                                    vc = vc?.presentedViewController
                                }
                                let login = LoginViewController()
                                login.loginType = LoginType.login_normal
                                vc?.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)
                            default:
                                ProgressHUD.showMessage(message: result["data"] as! String)
                                failure?()
                            }
                        }
                    } else {
                        failure?()
                        ProgressHUD.showNoticeOnStatusBar(message: "\(String(describing: response.response?.statusCode))-服务器访问失败")
                    }
                })
                
            case .failure(let error):
                if isAuthHide {
                    ProgressHUD.hideLoading(toView: atVC.view)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                failure?()
                ProgressHUD.showNoticeOnStatusBar(message: error.localizedDescription)
            }
        })
    }
    

    // 多图
    static func uploadOneMorePicture(url: String, atVC: UIViewController, images: [URL], params: Dictionary<String, String> = [:], isAuthHide: Bool = true, uploadSuccess: @escaping (_: Dictionary<String, Any>) -> (), failure: (() -> ())? = nil) {
        
        var params = params
        if let m = CSUserInfoHandler.getIdAndToken() {
            params["uid"] = m.uid
            params["token"] = m.token
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ProgressHUD.showLoading(toView: atVC.view)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if images.count == 0 {
                ProgressHUD.showMessage(message: "请选择图片")
                return
            }
            for(index,value) in images.enumerated() {
                multipartFormData.append(value, withName: "img\(index + 1)")
            }
//            for (index, value) in images.enumerated() {
////                    multipartFormData.append(image, withName: "img")
//                let data = UIImageJPEGRepresentation(value, 0.65)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyyMMddHHmmssms"
//                let imgName = dateFormatter.string(from: Date()) + "\(index).png"
//                multipartFormData.append(data!, withName: "\(index)", fileName: imgName, mimeType: "image/png")
//            }
//            for (key, value) in params {
//                multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//            }
        }, to: URL(string: mainHost + url)!) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if isAuthHide {
                        ProgressHUD.hideLoading(toView: atVC.view)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if response.response?.statusCode == 200 {
                        guard let json = response.result.value else {
                            ProgressHUD.showNoticeOnStatusBar(message: "未知错误")
                            failure?()
                            return
                        }
                        let result: Dictionary<String, Any> = json as! Dictionary
                        print(result)
                        let code: String = (result["status"] as? String)!
                        if code == "ok" {
                            if atVC.view.superview != nil {
                                uploadSuccess(result)
                            }
                        } else {
                            switch code {
                            case "pending":
                                ProgressHUD.showNoticeOnStatusBar(message: result["error"] as! String)
                                CSUserInfoHandler.deleteUserInfo()
                                var vc = UIApplication.shared.keyWindow?.rootViewController
                                if ((vc?.presentedViewController) != nil){
                                    vc = vc?.presentedViewController
                                }
                                let login = LoginViewController()
                                login.loginType = LoginType.login_normal
                                vc?.present(UINavigationController.init(rootViewController: login), animated: false, completion: nil)

                            //                                UIApplication.shared.keyWindow?.rootViewController = LoginNavigationController.setup()
                            default:
                                ProgressHUD.showMessage(message: result["data"] as! String)
                                failure?()
                            }
                        }
                    } else {
                        failure?()
                        ProgressHUD.showNoticeOnStatusBar(message: "\(String(describing: response.response?.statusCode))-服务器访问失败")
                    }
                })
                
            case .failure(let error):
                if isAuthHide {
                    ProgressHUD.hideLoading(toView: atVC.view)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                failure?()
                ProgressHUD.showNoticeOnStatusBar(message: error.localizedDescription)
            }
        }
    }
    
    // 多图
    static func uploadBBOneMorePicture(url: String, atVC: UIViewController, images: [UIImage], params: Dictionary<String, String> = [:], isAuthHide: Bool = true, uploadSuccess: @escaping (_: Dictionary<String, Any>) -> (), failure: (() -> ())? = nil) {
        
//        var params = params
//        if let m = CSUserInfoHandler.getIdAndToken() {
//            params["uid"] = m.id
//            params["token"] = m.token
//        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ProgressHUD.showLoading(toView: atVC.view)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if images.count == 0 {
                ProgressHUD.showMessage(message: "请选择图片")
                return
            }
            for (index, value) in images.enumerated() {
                let data = UIImageJPEGRepresentation(value, 0.65)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyyMMddHHmmssms"
//                let imgName = dateFormatter.string(from: Date()) + "\(index).png"
                let imgName = "\(index).png"

                multipartFormData.append(data!, withName: "\(index)", fileName: imgName, mimeType: "image/png")
            }
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                
            }
        }, to: URL(string: mainHost + url)!) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if isAuthHide {
                        ProgressHUD.hideLoading(toView: atVC.view)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if response.response?.statusCode == 200 {
                        guard let json = response.result.value else {
                            ProgressHUD.showNoticeOnStatusBar(message: "未知错误")
                            failure?()
                            return
                        }
                        let result: Dictionary<String, Any> = json as! Dictionary
                        print(result)
                        let code: String = (result["status"] as? String)!
                        if code == "ok" {
                            if atVC.view.superview != nil {
                                uploadSuccess(result)
                            }
                        } else {
                            switch code {
                            case "pending":
                                ProgressHUD.showNoticeOnStatusBar(message: result["error"] as! String)
                                CSUserInfoHandler.deleteUserInfo()
                                EMClient.shared().logout(true)
//                                UIApplication.shared.keyWindow?.rootViewController = LoginNavigationController.setup()
                            default:
                                ProgressHUD.showMessage(message: result["error"] as! String)
                                failure?()
                            }
                        }
                    } else {
                        failure?()
                        ProgressHUD.showNoticeOnStatusBar(message: "\(String(describing: response.response?.statusCode))-服务器访问失败")
                    }
                })
                
            case .failure(let error):
                if isAuthHide {
                    ProgressHUD.hideLoading(toView: atVC.view)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                failure?()
                ProgressHUD.showNoticeOnStatusBar(message: error.localizedDescription)
            }
        }
    }
    
    class func download(model: LivingBGMModel, complete: @escaping ((LivingBGMModel)->())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let _ = Alamofire.download(model.path!) { (l, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            if response.statusCode == 200 {
            } else {
                ProgressHUD.showNoticeOnStatusBar(message: "\(String(describing: response.statusCode))-服务器访问失败")
            }
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsURL?.appendingPathComponent(response.suggestedFilename!)
            model.pathPostfix = response.suggestedFilename!
            SQLiteManager.manager.insert(model: model)
            complete(model)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
        }
        //        download.downloadProgress(queue: DispatchQueue.main, closure: progress)
    }
    
     
}

func fetchVerificationCodeCountdown(button: UIButton, timeOut: Int) -> DispatchSourceTimer {
    var timeout = timeOut
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    timer.setEventHandler {
        if timeout <= 1 {
            timer.cancel()
            DispatchQueue.main.sync {
                button.setTitle("发送验证码", for: .normal)
                button.isEnabled = true
            }
        } else {
            DispatchQueue.main.sync {
                button.setTitle("\(timeout)秒后重发", for: .normal)
                button.isEnabled = false
            }
            timeout -= 1
        }
    }
    timer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
    timer.resume()
    
    return timer
}
func focusOtherPerson(viewResponder: UIResponder,other_id: String, btn: UIButton, type: String, focusCommpleted: (()->())?) {
    if CSUserInfoHandler.getIdAndToken()?.uid == other_id {
        ProgressHUD.showNoticeOnStatusBar(message: "不能关注自己哦！")
        return
    }
    let param = ["user_id2": other_id]//,"type": type]
    NetworkingHandle.fetchNetworkData(url: "api/live/follow", at: viewResponder, params: param, success: { (response) in
        btn.isSelected = !btn.isSelected
        focusCommpleted?()
    })
}

func pushToUserInfoCenter(atViewController vc: UIViewController, uId: String, name: String = "", isHasLive: Bool = false, liveUserName: String = "", isCurrentUserLiving: Bool = false) {
    //    if DLUserInfoHandler.getIdAndToken()?.id == uId {
    //        if vc.navigationController?.viewControllers.first is MineViewController {
    //            _ = vc.navigationController?.popToRootViewController(animated: true)
    //        } else {
    //        }
    //        return
    //    }
//        let targetVC = HisPersonalMemberCenterViewController()
//        targetVC.userId = uId
//        targetVC.isHasLive = isHasLive
//        targetVC.isCurrentUserLiving = isCurrentUserLiving
//        vc.navigationController?.pushViewController(targetVC, animated: true)
 

    
}

import SQLite

struct SQLiteManager {
    
    private var db: Connection!
    private let tableName = Table("LvingMusic") //表名
    private let id = Expression<Int64>("id")      //主键
    private let songName = Expression<String>("songName")  //列表1
    private let singer = Expression<String>("singer") //列表2
    private let pathPostfix = Expression<String>("pathPostfix") //列表3
    private let time = Expression<String>("time") //列表4
    
    static var manager = SQLiteManager()
    
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3(filePath: String = "/Documents")  {
        
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        do {
            db = try Connection(sqlFilePath)
            try db.run(tableName.create { t in
                t.column(id, primaryKey: true)
                t.column(songName)
                t.column(pathPostfix)
                t.column(singer)
                t.column(time)
            })
        } catch { print(error) }
    }
    
    //插入数据
    func insert(model: LivingBGMModel){
        do {
            let insert = tableName.insert(songName <- model.song_name!, singer <- model.singer!, pathPostfix <- model.pathPostfix!, time <- model.time!)
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    //读取数据
    func readData() -> [LivingBGMModel] {
        var dataArr: [LivingBGMModel] = []
        for model in try! db.prepare(tableName) {
            let m = LivingBGMModel()
            m.dbId = model[id]
            m.singer = model[singer]
            m.song_name = model[songName]
            m.time = model[time]
            m.pathPostfix = model[pathPostfix]
            dataArr.append(m)
        }
        return dataArr
    }
    
    //更新数据
    //    func updateData(dbId: Int64, old_name: String, new_name: String) {
    //        let currUser = tableName.filter(id == dbId)
    //        do {
    //            try db.run(currUser.update(name <- name.replace(old_name, with: new_name)))
    //        } catch {
    //            print(error)
    //        }
    //
    //    }
    
    //删除数据
    func delData(dbId: Int64) {
        let currUser = tableName.filter(id == dbId)
        do {
            try db.run(currUser.delete())
        } catch {
            print(error)
        }
    }
}


