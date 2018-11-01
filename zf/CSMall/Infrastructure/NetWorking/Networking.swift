////
////  Networking.swift
////  Post
////
////  Created by 蜡笔小姜和畅畅 on 2017/8/6.
////  Copyright © 2017年 蜡笔小姜和畅畅. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import HandyJSON
//
//let baseUrl = "http://cs.tstweiguanjia.com/"
//
//class NormalResult: HandyJSON {
//    var data: Any?
//    var status: String?
//    var total: Int?
//    var error: String?
//    required init() {}
//}
//
//enum DataType: String {
//    case Dic
//    case Arr
//}
//
//public struct Mapper {
//    let path: String
//    let dataType: DataType
//}
//
//public struct Resource {
//    let path: String
//    let method : HTTPMethod = .post
//    let requestBody: [String:Any]
//    let headers : [String:String] = [:]
//}
//
//public enum Reason: Error {
//    case CouldNotParseJSON
//    case NoSuccessStatusCode(statusCode: Int)
//}
//
//struct APIRequest<T:HandyJSON> {
//    
//    
//    mutating func request(baseURL: String = baseUrl, resource: Resource, mapper: Mapper = Mapper(path: "", dataType: .Dic), failure: @escaping (Reason) -> (), success: @escaping (T) -> ()) -> DataRequest {
//        let url = URL.init(string: baseURL.appending(resource.path))
//       
//        var  params:[String:Any]  = resource.requestBody
//        if  let  m = ManageUserInfo.getIdAndToken() {
//            params["id"] = m.id
//            params["token"] = m.token
//        }
//        return Alamofire.request(url!, method: resource.method, parameters: params, encoding: URLEncoding.default, headers: resource.headers).responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//
//                if mapper.path == "" {
//                    
//                    switch mapper.dataType {
//                    case .Dic:
//                        
//                        
//                        
//                        if let result = JSONDeserializer<T>.deserializeFrom(dict: value as? NSDictionary) {
//                            success(result)
//                        }else {
//                            
//                            failure(Reason.CouldNotParseJSON)
//                        }
//                        
//                    case .Arr:
//                        
//                        print("解析成数组")
//                    }
//                    
//                }else {
//                    
//                    switch mapper.dataType {
//                    case .Dic:
//                        
//                        if let result = JSONDeserializer<T>.deserializeFrom(dict: value as? NSDictionary, designatedPath: mapper.path) {
//                            success(result)
//                        }else {
//                            failure(Reason.CouldNotParseJSON)
//                        }
//                        
//                    case .Arr:
//                        
//                        print("解析成数组")
//                    }
//                }
//                
//            case .failure(_):
//                
//                
//                failure(Reason.NoSuccessStatusCode(statusCode: (response.response?.statusCode)!))
//                
//                if response.response?.statusCode == 500{
//                    ProgressHUD.showNoticeOnStatusBar(message: "未知错误\((response.response?.statusCode)!)")
//                }
//            }
//            
//            
//        }
//    }
//    
//
//  
//}

