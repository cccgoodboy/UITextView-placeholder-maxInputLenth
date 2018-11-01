//
//  Mine.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/3.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import HandyJSON

//class Mine: NSObject {
//
//}
class BaseResponse<T:HandyJSON>: HandyJSON{
    var status:String?
    var error:String?
    var data:T?
    public required init() {}
}
class UserfollowModel: HandyJSON {
   var follow_id:String?        //关注id
    var member_id:String?
    var live_id:String?
    var merchants_name:String?
    var merchants_img:String?
    var merchants_content:String?
    var month_sales:String?
    public required init() {}

}
class UserCollection: HandyJSON {
    var goods_pc_price: String?
    var collection_id: String?
    var goods_origin_price: String?
    var goods_now_price: String?
    var goods_img: String?
    var goods_name: String?
    var goods_desc: String?
    var goods_id: String?
    var isSelected = false
    
    required init(){}
}
class AddressModel: HandyJSON {
    
    var address_city:String?
    var address_country:String?
    var address_detailed:String?
    var address_id:String?
    var address_latitude:String?
    var address_longitude:String?
    var address_mobile:String?
    var address_name:String?
    var address_province:String?
    var address_road:String?
    var address_zip_code:String?
    var create_time:String?
    var is_default:String?
    var is_delete:String?
    var member_id:String?
    var update_time:String?
    
    required init(){}
    
}
class MerchantsModel: HandyJSON {
    var member_id:String?//商户id
    var merchants_img:String?
    var live_id:String?
    var merchants_name:String?//名称
    var play_address:String?
    var room_id:String?
    var url:String?
    var img:String?
    var merchants_content:String?
    var total_sales:String?
    var fans_count:String?
    //    var merchants_id:String?
    //    var member_id:String?
    //    var live_id:String?//直播id
    //    var merchants_name:String?//店铺名称1
    //    var merchants_img:String?
    //    var merchants_star1:String?
    //    var merchants_star2:String?
    //    var merchants_star3:String?
    //    var merchants_type:String?
    //    var contact_mobile:String?//联系人电话
    //    var contact_name:String?//联系人姓名
    //    var merchants_address:String?//店铺地址
    //    var merchants_state:String?
    //    var merchants_province:String?
    //    var merchants_city:String?
    //    var merchants_country:String?
    //    var company_mobile:String?
    //    var company_name:String?
    //    var is_delete:String?
    //    var create_time:String?//2017-08-31 11:47:25.0
    //    var update_time:String?
    //    var apply_state:String?
    //    var pay_state:String?
    //    var refuse_remark:String?
    //    var hx_account:String?
    //    var hx_password:String?
    //    var hx_custom_id:String?
    //    var legal_img:String?//法人照片
    //    var legal_face_img:String?
    //    var legal_opposite_img:String?//法人身份证反面照
    //    var legal_hand_img:String?//法人手持身份证
    //    var business_img1:String?//营业执照1
    //    var business_img2:String?//营业执照2
    //    var business_img3:String?//营业执照3
    //    var merchants_position:String?//home
    
    required init(){}
}
class QueryLiveListByClassModel:HandyJSON{
    
    var member_id:String?
    var username:String?
    var city:String?
    var merchants_name:String?
    var merchants_img:String?
    var live_id:String?
    var play_img:String?
    var title:String?
    var goods_class:[GoodsClassModel]?

    required init(){}
}
class LiveListModel: HandyJSON {
    var live_id:String?
    var play_img:String?//直播标题
    var title:String?//直播标题
    var watch_nums:String?//观看数
    var username:String?
    var header_img:String?
    var member_id:String?//店铺名
    var merchants_name:String?//店铺名
    var room_id:String?
    var play_address:String?
    var address:String?
    var category_id:String?
    var date:String?
    var share_url:String?
    var play_address_m3u8:String?
    var signature:String?
    var fans_count:String?
    required init(){}

}
class LiveGoodsModel: HandyJSON {
    var live_goods_id: String? //直播商品id
    var is_top: String?  //1是置顶
    var goods_id: String?  //商品id
    var goods_name: String?
    var goods_img: String?
    var goods_origin_price: String?
    var goods_pc_price: String?
    var goods_now_price: String?
    
    required init(){}
}
class MerchantsInfoModel: HandyJSON {
    
    var is_follow:String? //1未关注 2关注 3自己
    var member_id:String?
    var merchants_img:String?
    var live_id:String?
    var merchants_name:String?
    var merchants_star1:String?
    var merchants_star2:String?
    var merchants_star3:String?
    var merchants_content:String?
    var apply_state:String?
    var assessment_count:String?
    var business_img:String?
    var business_img2:String?
    var business_img3:String?
    var business_number:String?
    var company_mobile:String?
    var company_name:String?
    var contact_mobile:String?
    var contact_name:String?
    var create_time:String?//开店时间
    var dashang_scale:String?
    var day_sales:String?
    var hx_account:String?
    var hx_custom_id:String?
    var hx_password:String?
    var is_delete:String?
    var is_tuijian:String?
    var last_login_date:String?
    var last_login_ip:String?
    var legal_face_img:String?
    var legal_hand_img:String?
    var legal_opposite_img:String?
    var merchants_address:String?//所在地区
    var login_times:String?
    var merchants_city:String?
    var merchants_qrcode:String?
    var merchants_country:String?
    var merchants_id:String?
    var merchants_position:String?
    var merchants_province:String?
    var merchants_state:String?
    var merchants_type:String?
    var month_sales:String?
    var operate_class:String?
    var pay_state:String?
    var platform_type:String?
    var refuse_remark:String?
    var sell_scale:String?
    var total_sales:String?
    var tv_id:String?
    var update_time:String?
    
    required init(){}
    
}
class MerchantsClassModel: HandyJSON {
    
    var class_id:String?
    var class_name:String?   //分类名
    var class_uuid:String?   //分类uuid
    
    required init(){}
}
class MerchantsClassGoodsModel: HandyJSON {
    var goods_id: String?
    var goods_name: String?
    var goods_img: String?
    var goods_origin_price: String?
    var goods_pc_price: String?
    var goods_now_price: String?
    var total_sales:String?
    var month_sales:String?
    var day_sales:String?
    
    required init(){}
}
class MerchantsGoodsListModel: HandyJSON {
    
    var goods_id:String?
    var goods_name:String?//手机
    var goods_img:String?//图片
    var goods_desc:String?//商品描述
    var goods_origin_price:String?//原价
    var goods_pc_price:String?//pc价
    var goods_now_price:String?//原价
    var total_sales:String?
    
    required init(){}
}
class MyCouponModel: HandyJSON {
    var id:String?
    var title:String?
    var img:String?
    var limit_value:String?
    var value:String?
    var start_time:String?
    var end_time:String?
    var type:String?
    var merchants_id:String?
    var name:String?
    var merchants_name:String?
    var merchants_img:String?
    required init(){}

}
class PlayBackListModel: HandyJSON {
    var title:String?
    var url:String?
    var play_img:String?
    var date:String?
    var play_number:String?

    required init(){}

}
class VideoListModel: HandyJSON {
   
    var title:String?
    var video_img:String?
    var url:String?
    var watch_nums:String?
    var video_id:String?
    var date:String?
    required init(){}
}
class  LiveInfoModel: HandyJSON {
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
        var share_url: String?
        var lebel : [String]?
        var livewindow_type: String?
        
        var qiniu_room_id: String?
        var qiniu_room_name: String?
        var qiniu_token: String?
        var video_id: String?
        var video_img: String?
        //    var is_type: String?
        //    var title: String?
        //    var video_id: String?
        //    var video_id: String?
        //    var video_id: String?
        //    var video_id: String?
    required init(){}

}
class BannerModel: HandyJSON {
    var b_img:String?
    var b_id:String?
    var url:String?
    var b_type:String?//1无跳转；2WEB链接；3分类；4商家；5商品；6优惠券
    var title:String?
    var jump:String?
    //    var banner_id:String?
    //    var banner_title:String?//标题
    //    var banner_img:String?//图片
    //    var banner_url:String?//链接地址
    //    var banner_type:String?//类型
    //    var banner_type_show:String?
    //    var banner_desc:String?//描述
    //    var create_time:String?//2016-09-05 16:40:39.0
    //    var sort:String?//权重
    //    var is_delete:String? //"0"
    //    var banner_position:String?//展示位置
    //    var banner_position_show:String?
    //    var goods_id:String?
    //    var goods_name:String?
    //    var goods_uuid:String?
    //    var goods_class_name:String?
    //    var chain_url:String?//外链链接
    
    required init(){}
}
class ShowGoodsClassModel: HandyJSON {
    var live_class_id:String?
    var tag:String?
    var img:String?
    var is_del:String?
    var intime:String?
    required init(){}

}
class GoodsClassModel:HandyJSON{
    var class_id:String?
    var class_name:String?
    var class_desc:String?
    var class_img:String?
    var class_color:String?
    var class_uuid:String?
    var template_img:String?
    var san:[GoodsClassModel] = [GoodsClassModel]()
    required init(){}
}
class CityModel: HandyJSON {
    var city:String?
    var shouzimu:String?
       required init(){}
}
class CommentDescModel: HandyJSON {
    var comment_desc:String? //评价
    var mark:String? //星级
    var img:[String] = [String]()
    var username:String?
    var header_img:String?
    var create_time:String?
    required init(){}

}
class ShowGoodsKindClassModel: HandyJSON {
//    var class_id:String?
//    var class_name:String?
//    var class_desc:String?
//    var class_img:String?
//    var class_color:String?
//    var class_uuid:String?
//    var template_img:String?
    var id:String?
    var class_uuid:String?
    var img:String?
    var title:String?
    var sort:String?
    var create_time:String?
    var update_time:String?
    var is_delete:String?
    var status:String?
    var type:String?
    var jump:String?

    required init(){}

}
//class MaybeEnjoyModel:HandyJSON{//
//    var goods_id:String?
//    var goods_name:String?
//    var goods_img:String?
//    var goods_origin_price:String?
//    var goods_pc_price:String?
//    var goods_now_price:String?
//    var total_sales:String?
//    var month_sales:String?
//    var day_sales:String?
//    required init(){}
//}
class DressModel:HandyJSON{
    var dress_id:String?
    var title:String?
    var width:String?
    var height:String?
    var img:String?
    var type:String?//跳转类型 跳转页：1无跳转；2web;3分类页；4商家；5商品；6标签
    var layout:String?
    var sort:String?
    var color:String?
    var create_time:String?
    var update_time:String?
    var is_delete:String?
    var status:String?
    var jump:String?
    var pid:String?
    var seedBeans:[DressModel]?
    required init(){}
}
class RecommendClassModel: HandyJSON {
    var class_color:String?
    var class_id:String?
    var class_name:String?
    var class_desc:String?
    //    var class_state:String?
    var class_img:String?
    //    var class_url:String?
    //    var parent_id:String?
    var class_uuid:String?
    //    var class_parent_uuid:String?
    //    var sort:String?
    //    var create_time:String?
    //    var update_time:String?
    //    var is_delete:String?
    //    var is_recommend:String?
    var template_img:String?//推荐分类图片
    var show_goods:[MerchantsGoodsListModel]?
    
    required init(){}
}


//商品----商品列表
class SearchGoodsListModel: HandyJSON {
    var assessment_count:String?
    var class_uuid:String?
    var collection_id:String?
    var create_time:String?
    var day_sales:String?
    var distributor_id:String?
    var goods_desc:String?
    var goods_id:String?
    var goods_ids:String?
    var goods_img:String?
    var goods_name:String?
    var goods_now_price:String?
    var goods_num:String?
    var goods_origin_price:String?
    var goods_pc_price:String?
    var goods_position:String?
    var goods_star1:String?
    var goods_star2:String?
    var goods_star3:String?
    var goods_state:String?//状态 0：下架 1:上架
    var goods_stock:String?
    var goods_url:String?//web链接
    var is_delete:String?
    var merchants_id:String?
    var month_sales:String?
    var total_sales:String?
    var update_time:String?
    var is_stop:String? //1商品已下架；2正常
    var goodsGroupBeans:[GoodsGroupBeansModel]?
    var goodsImgBeans:[GoodsImgBeansModel]?
    var goodsSpecificationBeans:[SpecificationBeansModel]?
    //    var specificationBeans:[GoodsSpecificationBeansModel]?
    var welfareBeans:[WelfareBeansModel]?
    var memberGroupBeans:[MemberGroupBeansModel]?
    var member_group_count:String?
    var is_collect:String?//1收藏；2未收藏
    var url:String?
    var video_img:String?
    var video_type:String? //1是有视频
    var imgs:[String]?
    required init(){}
}
class GoodsGroupBeansModel: HandyJSON {
    var create_time:String?
    var goods_group_id:String?
    var goods_id:String?
    var group_name:String?
    var group_need_count:String?
    var group_need_time:String?
    var group_price:String?
    var is_delete:String?
    var sort:String?
    var specification_id:String?
    var update_time:String?
    //    var :String?
    //    var :String?
    required init(){}
}
class GoodsImgBeansModel: HandyJSON {
    
    var create_time:String?
    var goods_id:String?
    var goods_img:String?
    var goods_img_id:String?
    var is_delete:String?
    var sort:String?
    var update_time:String?
    required init(){}
}
class GoodsSpecificationBeansModel: HandyJSON {
    var create_time:String?
    var goods_group_id:String?
    var goods_id:String?
    var group_price:String?
    var group_specification_id:String?
    var group_stock:String?
    var parent_id:String?
    var specification_id:String?
    var specification_ids:String?
    var specification_img:String?
    var specification_names:String?
    var specification_price:String?
    var specification_sales:String?
    var specification_state:String?
    var specification_stock:String?
    var update_time:String?
    required init(){}
}
class SpecificationBeansModel: HandyJSON {
    //    var create_time:String?
    //    var is_delete:String?
    //    var parent_id:String?
    var specificationBeans:[SpecificationBeansModel]?
    var specification_id:String?
    var specification_value:String?
    //    var update_time:String?
    
    required init(){}
}

class WelfareBeansModel: HandyJSON {
    var create_time:String?
    var finish_join_count:String?
    var goods_id:String?
    var goods_welfare_state:String?
    var is_delete:String?
    var percent_value:String?
    var update_time:String?
    var welfare_desc:String?
    var welfare_end_time:String?
    var welfare_finish_price:String?
    var welfare_id:String?
    var welfare_img:String?
    var welfare_name:String?
    var welfare_need_price:String?
    var welfare_start_time:String?
    var welfare_state:String?
    required init(){}
}
class MemberGroupBeansModel: HandyJSON {
    var create_time:String?
    var end_time:String?
    var goods_group_id:String?
    var goods_id:String?
    var group_need_count:String?
    var group_need_time:String?
    var group_now_count:String?
    var group_state:String?
    var is_delete:String?
    var memberBean:MemberBeanModel?
    var member_group_id:String?
    var member_id:String?
    var qrcode_img:String?
    var update_time:String?
    
    required init(){}
    
    
}
class MemberBeanModel: HandyJSON {
    var distributor_id:String?
    var fill_invitation_code:String?
    var hx_account:String?
    var hx_nick_name:String?
    var hx_password:String?
    var invitation_code:String?
    var is_delete:String?
    var member_account:String?
    var member_age:String?
    var member_birthday:String?
    var member_create_time:String?
    var member_head_image:String?
    var member_id:String?
    var member_nick_name:String?
    var member_open_id:String?
    var member_password:String?
    var member_pay_password:String?
    var member_phone:String?
    var member_real_name:String?
    var member_sex:String?
    var member_token:String?
    var member_type:String?
    var member_update_time:String?
    var merchantsBean:MerchantsBeanModel?
    var merchants_id:String?
    var room_id:String?
    var tengxun_im_account:String?
    
    required init(){}
    
}
class MerchantsBeanModel: HandyJSON {
    var apply_state:String?
    var assessment_count:String?
    var business_img1:String?
    var business_img2:String?
    var business_img3:String?
    var company_mobile:String?
    var company_name:String?
    var contact_mobile:String?
    var contact_name:String?
    var create_time:String?
    var hx_account:String?
    var hx_custom_id:String?
    var hx_password:String?
    var is_delete:String?
    var legal_face_img:String?
    var legal_hand_img:String?
    var legal_img:String?
    var legal_opposite_img:String?
    var live_id:String?
    var member_id:String?
    var merchants_address:String?
    var merchants_city:String?
    var merchants_country:String?
    var merchants_id:String?
    var merchants_img:String?
    var merchants_name:String?
    var merchants_position:String?
    var merchants_province:String?
    var merchants_star1:String?
    var merchants_star2:String?
    var merchants_star3:String?
    var merchants_state:String?
    var merchants_type:String?
    var pay_state:String?
    var refuse_remark:String?
    var update_time:String?
    required init(){}
    
}
class ShopCarsModel: HandyJSON {
    
    var merchants_id:String?
    var merchants_name:String?
    var merchants_img:String?
    var goods:[ShopCarBeanModel]?
    
    required init(){}
}

class ShopCarBeanModel: HandyJSON {
    
    var car_id:String?
    var specification_id:String?
    var goods_name:String?
    var goods_num:String?
    var goods_img:String?
    var specification_names:String?
    var goods_origin_price:String?
    var goods_pc_price:String?
    var goods_now_price:String?
    var goods_id:String?
    var seller:String?
    var live_id:String?
    var isSelected = false
    
    required init(){}
}
//确认订单
class ConfirmGoodsInfoModel: HandyJSON {
    
    var merchants_id:String?
    var merchants_name:String?
    var merchants_img:String?
    var goods:[ShopCarBeanModel]?
    var coupon:[CouponBeanModel]?
    var totalPrice:String?
    var totalNum:String?
     
    var deduct_integral_value:String?//抵扣是可以使用的积分值，使用积分下单回传
    var deduct_value:String?//使用积分可抵扣的金额
    required init(){}
}
class CouponBeanModel:HandyJSON{
    var end_time:String?
    var id:String?
    var img:String?
    var limit_value:String?
    var merchants_id:String?
    var merchants_img:String?
    var merchants_name:String?
    var name:String?
    var start_time:String?
    var title:String?
    var type:String?
    var value:String?
    var isSeleted = false

    required init(){}
}
class StuRecharageRecordModel:HandyJSON  {
    var amount:String?//金额
    var uptime:String?//时间
    var pay_type:String?//途径
    var meters:String?  //充值钻石
    var title:String?
    required init(){}
}
class RfundOrderModel:HandyJSON{
    var refund_id:String?
    var member_id:String?
    var order_merchants_id:String?
    var merchants_id:String?
    var order_no:String?//原订单
    var order_goods_id:String?
    var refund_type:String?
    var refund_no:String?
    var refund_count:String? //数量
    var refund_reason:String?//原订单
    var refund_desc:String?
    var refund_img:String? //图片
    var refund_state:String?  //wait_review：等待审核  accept:接受 refuse：拒绝  end:退款成功
    var refund_price:String?//退款金额
    var refund_reason_id:String?
    var reason_name:String?
    var create_time:String?//申请时间
    var update_time:String?
    var is_delete:String?
    var logistics_no:String?
    var logistics_name:String?
    var logistics_pinyin:String?
    var merchants_name:String?//店铺名
    var merchants_img:String?
    var goods_name:String?
    var goods_img:String?
    var specification_names:String?
    var specification_price:String?//单价
    var refund_actual_price:String? //退款总价格
    required init(){}
}
class OtherInfoModel:HandyJSON{//other center
    var ID:String?
    var address:String?
    var alias:String?
    var amount:String?
    var app_token:String?
    var area:String?
    var b_diamond:String?
    var banned_dis:String?
    var banned_end_time:String?
    var banned_start_time:String?
    var birth_day:String?
    var category_id:String?
    var city:String?
    var collection:String?
    var del_time:String?
    var e_ticket:String?
    var experience:String?
    var follow:String?
    var follow_to:String?
    var give_count:String?
    var grade:String?
    var header_img:String?
    var hx_password:String?
    var hx_username:String?
    var img:String?
    var intime:String?
    var is_banned:String?
    var is_del:String?
    var is_fans:String?
    var is_follow:String?
    var is_live:String?
    var is_recommend:String?
    var is_remind:String?
    var is_show:String?
    var is_wheat:String?
    var lag:String?
    var live_count:String?
    var live_tag:String?
    var log:String?
    var member_id:String?
    var mlive_id:String?
    var password:String?
    var pc_token:String?
    var phone:String?
    var phpqrcode:String?
    var province:String?
    var qq_openid:String?
    var recommend_id:String?
    var sex:String?
    var signature:String?
    var sort:String?
    var type:String?
    var uptime:String?
    var url:String?
    var username:String?
    var uuid:String?
    var wo_openid:String?
    var wx_openid:String?
    var zan:String?

    required init(){}
}
class OtherlivelistModel: HandyJSON {
    var ID:String?
    var b_diamond:String?
    var city:String?
    var collection:String?
    var date:String?
    var grade:String?
    var e_ticket:String?
    var header_img:String?
    var hx_username:String?
    var intime:String?
    var is_audit:String?
    var is_del:String?
    var is_tuijian:String?
    var lebel:String?
    var live_id:String?
    var live_store_id:String?
    var live_time:String?
    var livewindow_type:String?
    var play_img:String?
    var play_number:String?
    var province:String?
    var room_id:String?
    var sex:String?
    var signature:String?
    var stream_key:String?
    var title:String?
    var url:String?
    var user_id:String?
    var username:String?
    var zan:String?

    required init(){}

}

