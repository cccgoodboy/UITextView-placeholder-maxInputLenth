//
//  LiveModel.swift
//  CSLiving
//
//  Created by taoh on 2017/9/21.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit

class sysMessageModel: KeyValueModel {
    
    var message_id: String?
    var content: String?
    var time: String?
    var date: String?
    
    
}

class LiveList: KeyValueModel {
    var is_follow: String?  //是否关注   1：未关注  2：已关注
    var live_id: String?
    var live_store_id: String?
    var user_id: String?
    var play_img: String?
    var title: String?
    var push_flow_address: String?
    var play_address: String?
    var play_address_m3u8: String?
    var room_id: String?
    var watch_nums: String?
    var light_up_count: String?
    var date: String?
    var sheng: String?
    var shi: String?
    var qu: String?
    var img: String?
    var play_number: String?
    var username: String?
    var is_type: String?
    var money: String?
    var hx_username: String?
    var sex: String?
    var grade: String?
    var get_money: String?
//    var url: String?
    var lebel : [String]?
    var livewindow_type: String?
    
    var qiniu_room_id: String?
    var qiniu_room_name: String?
    var qiniu_token: String?
    var video_id: String?
    var video_img: String?
    var share_url:String?
    //    var is_type: String?
    //    var title: String?
    //    var video_id: String?
    //    var video_id: String?
    //    var video_id: String?
    //    var video_id: String?
}
class PriceListModel: KeyValueModel{
    var price_list_id: String?
    var price: String?
    var diamond: String?
    var zeng: String?
    var sign: String?

}
class PersonInfoModel: KeyValueModel {
    var address : String?
    var alias : String?
    var area : String?
    var autograph : String?
    var banned_dis : String?
    var banned_end_time : String?
    var banned_start_time : String?
    var birth_day : String?
    var city : String?
    var company : String?
    var count1 : String?
    var count2 : String?
    var count3 : String?
    var del_time : String?
    var duty : String?
    var experience : String?
    var fans_count : String?
    var follow_count : String?
    var get_money : String?
    var grade : String?
    var hx_password : String?
    var hx_username : String?
    var id : String?
    var img : String?
    var intime : String?
    var is_authen : String?
    var is_banned : String?
    var is_del : String?
    var is_fans : String?
    var is_remind : String?
    var is_stop : String?
    var is_titles : String?
    var is_tuijian : String?
    var is_wheat : String?
    var mark : String?
    var top: [ContributionModel]?
    var money : String?
    // var openid : String?
    var phone : String?
    var province : String?
    // var pwd : String?
    //  var qq_openid : String?
    var score : String?
    var sex : String?
    // var titles_dis : String?
    //  var titles_end_time : String?
    //  var titles_start_time : String?
    //token = 59339c25492fd;
    var type : String?
    //  var uptime : String?
    var url : String?
    var user_id : String?
    var username : String?
    var video_count : String?
    var weibo : String?
    var zan : String?
}
class ContributionModel: KeyValueModel {
    var hx_password: String?
    var hx_username: String?
    var img : String?
    var jewel :String?
    var ranking : String?
    var sex : String?
    var user_id : String?
    var username : String?
    var type: String?
}
class HisInfo: KeyValueModel {
    var user_id: String?
    var token: String?
    var phone: String?
    var pwd: String?
    var img: String?
    var sex: String?
    var type: String?
    var username: String?
    var company: String?
    var duty: String?
    var autograph: String?
    var id: String?
    var intime: String?
    var uptime: String?
    var is_del: String?
    var del_time: String?
    var alias: String?
    var hx_username: String?
    var hx_password: String?
    var province: String?
    var city: String?
    var area: String?
    var address: String?
    var zan: String?
    var openid: String?
    var qq_openid: String?
    var weibo: String?
    var money: String?
    var get_money: String?
    var url: String?
    var is_fans: String?
    var give_count: String?
    var grade: String?
    var birth_day: String?
    var follow: String?
    var follow_to: String?
    var video_count: String?
    var live_count: String?
    var is_live: String?
    var is_authen: String? //是否实名认证     -1 ：未认证     1：审核中   2：已认证成功  3：认证失败
    var is_follow: String? //是否关注    2：已关注  1：未关注
}

