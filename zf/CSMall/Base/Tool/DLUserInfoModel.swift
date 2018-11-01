//
//  DLUserInfoModel.swift
//  Duluo
//
//  Created by sh-lx on 2017/3/20.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit
import HandyJSON
class CSUserInfoModel:  HandyJSON{
    var ID:String?
    var address:String?
    var alias:String?
    var app_token:String?
    var area:String?
    var b_diamond:String?
    var banned_dis:String?
    var banned_end_time:String?
    var banned_start_time:String?
    var birth_day:String?
    var category_id:String?
    var city:String?
    var del_time:String?
    var e_ticket:String?
    var experience:String?
    var grade:String?
    var header_img:String?//头像
    var hx_password:String?
    var hx_username:String?
    var img:String?
    var intime:String?
    var is_banned:String?
    var is_del:String?
    var is_fans:String?
    var is_remind:String?
    var is_show:String?
    var is_wheat:String?
    var lag:String?
    var log:String?
    var member_id:String?//uid
    var pc_token:String?
    var phone:String?
    var phpqrcode:String?
    var province:String?
    var pwd:String?
    var qq_openid:String?
    var recommend_id:String?
    var sex:String?
    var signature:String?
    var type:String?
    var uptime:String?
    var url:String?
    var username:String?
    var uuid:String?
    var wo_openid:String?
    var wx_openid:String?
    var zan:String?
    var is_follow:String?// 1 未关注 2关注  3自己
    var pay_state:String? //0未支付  1已付款
    var apply_state:String?
    var wait_count:String?//待付款数量
    var seed_count:String?//待发货数量
    var receive_count:String?//带收货数量
    var assessment_count:String?//带评价数量
    var returns_count:String?////售后数量
    var give_count:String? // 用户送出
    var get_count:String?//主播得到
    required init(){}
}


class CSUserInfoHandler: NSObject {
    class func saveUserInfo(model: CSUserInfoModel) {
        UserDefaults.standard.set(model.member_id, forKey: "member_id")//uid
        UserDefaults.standard.set(model.app_token, forKey: "app_token")
        UserDefaults.standard.set(model.header_img, forKey: "header_img")
        UserDefaults.standard.set(model.sex, forKey: "sex")
        UserDefaults.standard.set(model.username, forKey: "username")
        UserDefaults.standard.set(model.hx_username, forKey: "hx_username")
        UserDefaults.standard.set(model.hx_password, forKey: "hx_password")
        UserDefaults.standard.set(model.phone, forKey: "phone")
        UserDefaults.standard.set(model.signature, forKey: "signature")
        UserDefaults.standard.set(model.pay_state, forKey: "pay_state")
        UserDefaults.standard.set(model.apply_state, forKey: "apply_state")
        UserDefaults.standard.set(model.signature, forKey: "signature")

        //        UserDefaults.standard.set(model.cash_pledge, forKey: "cash_pledge")
        //        UserDefaults.standard.set(model.merchantsBean?.merchants_id, forKey: "merchants_id")
        //        if model.type == "" {
        //            model.type = "1"
        //        }
        //        UserDefaults.standard.set(model.hx_username, forKey: "hx_username")
        //        UserDefaults.standard.set(model.hx_password, forKey: "hx_password")
        //        UserDefaults.standard.set(model.alias, forKey: "alias")
        //
        //        UserDefaults.standard.set(model.token, forKey: "token")
        //        UserDefaults.standard.set(model.user_id, forKey: "user_id")
        //        UserDefaults.standard.set(model.grade, forKey: "grade")
        //        UserDefaults.standard.set(model.username, forKey: "username")
        //        UserDefaults.standard.set(model.sex, forKey: "sex")
        //        UserDefaults.standard.set(model.img, forKey: "img")
        //        UserDefaults.standard.set(model.type, forKey: "type")
        //        UserDefaults.standard.set(model.phone, forKey: "phone")
        //        UserDefaults.standard.set(model.happy_lot, forKey: "happy_lot")
        
        //我被注释了
        //        EMClient.shared().login(withUsername: model.hx_username!, password: model.hx_password!, completion: { str, error in
        //            EMClient.shared().options.isAutoLogin = true
        //        })
        //
        //        JPUSHService.setAlias(model.alias!, callbackSelector: nil, object: nil)
    }
    class func saveUserSexState(sexState: String) {
        UserDefaults.standard.set(sexState, forKey: "member_sex")
    }
    
    
    class func update(name: String? = nil, img: String? = nil, grade: String? = nil,phone:String? = nil, happy_lot: String? = nil) {
        
        //        if let n = name {
        //            UserDefaults.standard.set(n, forKey: "username")
        //        }
        //        if let i = img {
        //            UserDefaults.standard.set(i, forKey: "img")
        //        }
        //        if let g = grade {
        //            UserDefaults.standard.set(g, forKey: "grade")
        //        }
        //        if let h = happy_lot {
        //            UserDefaults.standard.set(h, forKey: "happy_lot")
        //        }
        
    }
    class func getUserInfo() -> CSUserInfoModel? {
        if UserDefaults.standard.object(forKey: "member_id") == nil {
            return nil
        }
        let model = CSUserInfoModel()
        model.member_id = UserDefaults.standard.object(forKey: "member_id") as? String ?? ""
        model.header_img = UserDefaults.standard.object(forKey: "header_img") as? String ?? ""
        model.app_token = UserDefaults.standard.object(forKey: "app_token") as? String ?? ""
        model.sex = UserDefaults.standard.object(forKey: "sex") as? String ?? ""
        model.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        model.hx_username = UserDefaults.standard.object(forKey: "hx_username") as? String ?? ""
        model.hx_password = UserDefaults.standard.object(forKey: "hx_password") as? String ?? ""
        model.phone = UserDefaults.standard.object(forKey: "phone") as? String ?? ""
        model.signature = UserDefaults.standard.object(forKey: "signature") as? String ?? ""
        model.pay_state = UserDefaults.standard.object(forKey: "pay_state") as? String ?? ""
        model.apply_state = UserDefaults.standard.object(forKey: "apply_state") as? String ?? ""
        model.signature = UserDefaults.standard.object(forKey: "signature") as? String ?? ""

//        UserDefaults.standard.set(model.pay_state, forKey: "pay_state")
//        UserDefaults.standard.set(model.apply_state, forKey: "apply_state")
        //        model.hx_account = UserDefaults.standard.object(forKey: "hx_account") as? String ?? ""
        //        model.hx_nick_name = UserDefaults.standard.object(forKey: "hx_nick_name") as? String ?? ""
        //        model.hx_pass = UserDefaults.standard.object(forKey: "hx_pass") as? String ?? ""
        //        model.merchantsBean?.merchants_id = UserDefaults.standard.object(forKey: "merchants_id") as? Int ?? 0
        //        model.user_id = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        //        model.grade = UserDefaults.standard.object(forKey: "grade") as? String ?? ""
        //        model.sex = UserDefaults.standard.object(forKey: "sex") as? String ?? ""
        //        model.img = UserDefaults.standard.object(forKey: "img") as? String ?? ""
        //        model.isConfirmSex = UserDefaults.standard.object(forKey: "isConfirmSex") as? String ?? ""
        //        model.phone = UserDefaults.standard.object(forKey: "phone") as? String ?? ""
        //        model.happy_lot = UserDefaults.standard.object(forKey: "happy_lot") as? String ?? "0"
        
        
        return model
    }
    class func getIdAndToken() -> (uid:String, token: String)? {
        if UserDefaults.standard.object(forKey: "app_token") == nil {
            return nil
        }
        let token = UserDefaults.standard.object(forKey: "app_token") as? String ?? ""
        let uid = UserDefaults.standard.object(forKey: "member_id") as? String ?? ""
        //        let merchants_account_id = UserDefaults.standard.object(forKey: "merchants_account_id") as? String ?? ""
        return (uid, token)
    }
    class func getUserBaseInfo() -> (id: String, name: String, img: String){//, grade: String, type: String) {
        let name = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        let member_id = UserDefaults.standard.object(forKey: "member_id") as? String ?? ""
        let img = UserDefaults.standard.object(forKey: "header_img") as? String ?? ""
        //        let garde = UserDefaults.standard.object(forKey: "grade") as? String ?? "1"
        //        let type = UserDefaults.standard.object(forKey: "type") as? String ?? ""
        return (member_id, name, img)//, garde, type)
    }
    class func getUserHXInfo() -> (name: String, pw: String)? {
        if UserDefaults.standard.object(forKey: "hx_username") == nil {
            return nil
        }
        let hx_username = UserDefaults.standard.object(forKey: "hx_username") as? String ?? ""
        let hx_password = UserDefaults.standard.object(forKey: "hx_password") as? String ?? ""
        return (hx_username, hx_password)
    }
    class func deleteUserInfo() {
        //        isAuthen = false
        UserDefaults.standard.removeObject(forKey: "app_token")
        //        UserDefaults.standard.removeObject(forKey: "isConfirmSex")
        JPUSHService.deleteAlias({ (resultCode, str, code) in
            
        }, seq: 0)
        //        JPUSHService.setAlias(nil, callbackSelector: nil, object: nil)
        EMClient.shared().logout(true) { (error) in
            print(error as Any)
        }
    }
    
}
struct RegisterInfoModel:HandyJSON { //商家注册信息
    var merchants_id:Int!//    商家id
    var merchants_account_id:String?
    var contact_name:String?//姓名
    var contact_mobile:String?//联系电话
    var merchants_name:String? //店铺名称
    var merchants_address:String?//详细地址
    var business_number:String?//营业执照编号
    var legal_img:URL?//正面照 legal_img
    
    var legal_hand_img:URL?//手持身份证  legal_hand_img
    
    var legal_face_img:URL?//身份证正面照 legal_face_img
    
    var legal_opposite_img:URL?//反面照 legal_opposite_img
    
    var business_img:URL?//企业三证
    
    
    var apply_state:String? // 0 未认证 ,1审核中 2 审核通过 3拒绝
    var deposit:String?
 
    var member_id:String?
    var pay_state:String?
    
    var merchants_province:String?
    var merchants_city:String?
    var merchants_country:String?
}
struct RegisterModel:HandyJSON { //商家注册信息
    var merchants_id:Int!//    商家id
    var merchants_account_id:String?
    var contact_name:String?//姓名
    var contact_mobile:String?//联系电话
    var merchants_name:String? //店铺名称
    var merchants_address:String?//详细地址
     var business_number:String?//营业执照编号
    var legal_img:String?//正面照 legal_img
    
    var legal_hand_img:String?//手持身份证  legal_hand_img
    
    var legal_face_img:String?//身份证正面照 legal_face_img
    
    var legal_opposite_img:String?//反面照 legal_opposite_img
    
    var business_img:String?//企业三证
    
    
    var apply_state:String? // 0 未认证 ,1审核中 2 审核通过 3拒绝
    var deposit:String?
    var member_id:String?
    var pay_state:String?
    
    var merchants_province:String?
    var merchants_city:String?
    var merchants_country:String?
}
struct CompanyInfoModel:HandyJSON {
    var tel:String?
}
