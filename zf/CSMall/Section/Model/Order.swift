//
//  Order.swift
//  CSMall
//
//  Created by 梁毅 on 2017/8/2.
//  Copyright © 2017年 taoh. All rights reserved.
//

import UIKit
import HandyJSON

class Order: HandyJSON {

    required init(){}
}
class OrderListModel: HandyJSON{
    var id: String?
    var order_no: String?
    var paid: String?
    var phone: String?
    var deduction: String?
    var score: String?
    var state: String?
    var type: String?
    var has_postage: String?
    var postage: String?
    var item: NSNumber?
    var isCancel = false
    var order_detail: [GoodsCartModel]?
    required init(){}
    
}
class GoodsCartModel: HandyJSON {
    var id: String?
    var goods_id: String?
    var number: String?
    var is_check: String?
    var kinds_id: String?
    var kinds_id2: String?
    var name: String?
    var thumb: String? //缩略图
    var img: String? //原图
    var price: String?
    var sale_price: String? //单价
    var stock: String?
    var kinds1: String?
    var kinds2: String?
    var kinds: String?
    var kinds_detail: [GoodsCartKindDetailModel]?
    required init(){}
}
class GoodsCartKindDetailModel: HandyJSON{
    var kind_detail: String?
    var kind: String?
    required init(){}
}


class OrdersMdoel: HandyJSON {
    
    var order_merchants_id:String?
    var order_no:String?
    var totalNum:String?
    var merchants_id:String?
    var order_actual_price:String?
    var merchants_name:String?
    var order_state:String?
    var merchants_img:String?
    var order_id:String?
    var isCancel = false
    var isDelete = false
    var logistics_no:String?//物流单号
    var logistics_pinyin:String?
    var contact_mobile:String?
    var orderBeans:[OrderGoodsBeansModel]?
//    var order_id:String?
//    var merchants_id:String?
//    var member_id:String?
//    var order_no:String?
//    var address_id:String?
//    var address_mobile:String?
//    var address_name:String?
//    var address_province:String?
//    var address_city:String?
//    var address_country:String?
//    var address_detailed:String?
//    var address_road:String?
//    var address_zip_code:String?
//    var address_longitude:String?
//    var address_latitude:String?
//    var order_total_price:String?
//    var order_actual_price:String?
//    var order_state:String?
//    var order_remark:String?
//    var is_deduct_integral:String?
//    var deduct_integral_value:String?
//    var deduct_integral_price:String?
//    var deduct_integral_percent:String?
//    var custom_remark:String?
//    var create_time:String?
//    var pay_time:String?
//    var is_delete:String?
//    var pay_way:String?
//    var assessment_time:String?
//    var cancel_time:String?
//    var member_group_id:String?
//    var pay_charge:String?
//    var pay_no:String?
//    var send_time:String?
//    var ping_no:String?
//    var receive_time:String?
////    var addressBean:
//    var orderGoodsBeans:[OrderGoodsBeansModel]?

    required init(){}
}

class OrderGoodsBeansModel: HandyJSON {
    var goods_id:String?
    var goods_num:String?
    var goods_name:String?
    var goods_img:String?
    var specification_id:String?
    var specification_ids:String?
    var specification_names:String?
    var specification_price:String?
    var specification_img:String?
    var order_goods_id:String?
     var has_refund:String?//1有售后；0没有
    required init(){}

}

class QueryOrderViewModel: HandyJSON {
    var order_merchants_id:String?
    var order_id:String?
    var pay_no:String?  //支付单号
    var merchants_id:String?
    var order_actual_price:String? //实际支付
    var merchants_name:String?
    var create_time:String?
    var pay_time:String?//支付时间
    var receive_time:String?
    var send_time:String?
    var order_remark:String?
    var deduct_integral_value:String?  //积分
    var order_no:String?  //订单号
    var totalNum:String?   //订单商品总数
    var order_state:String?
    var merchants_img:String?
    var address:AddressModel?
    var has_refund:String?//1有售后；0没有
    var logistics_no:String?//物流单号
    var logistics_pinyin:String?
    var orderBeans:[OrderGoodsBeansModel]?

    required init(){}

}
class RefundGoodsModel:HandyJSON{
 
    var order_goods_id:String?
    var goods_id:String?
    var goods_num:String?//最大数量
    var goods_name:String?
    var goods_img:String?
    var specification_id:String?
    var specification_names:String?
    var specification_price:String?
    var has_refund:String?
    var refund_price:String?//退换货商品单价

    var num = "1" //默认用户退货一件
    required init(){}
}
class OrderRefundReason:HandyJSON{
    var refund_reason_id:String?
    var reason_name:String?
    var create_time:String?
    var is_delete:String?
    var sort:String?
    var selected = false
    required init(){}
    
}
struct ApplyRefundModel:HandyJSON {
    var order_goods_id:String?
    var order_merchants_id:String?
    var refund_count = "1"
    var refund_type = "1"  //1换货2退货
    var refund_reason:String?//退换货原因
    var refund_Id:String? //退货原因的id

    var refund_desc:String?//退换货具体原因
    var refund_img:String?//逗号隔开
    var refund_price = "0.00" //退换货商品单价
    var refund_selectNum = true
}
class LogisticsModel: HandyJSON {
    var EBusinessID: String?
    var ShipperCode: String?
    // var Success: String?
    var LogisticCode: String?
    var State: String?
    var Traces: [TracesModel]?
    required init(){}
}
class TracesModel: HandyJSON{
    var isCurrentState = false
    var AcceptTime: String?
    var AcceptStation: String?
    required init(){}

}
class SystemMessageModel: HandyJSON {
    var message:String?
    var order_id:String?
    var intime:String?
    var title:String?
    var goods:GoodsModel?
    required init(){}
}
class GoodsModel:HandyJSON{
    var order_goods_id:String?
    var order_id:String?
    var order_merchants_id:String?
    var goods_id:String?
    var merchants_id:String?
    var goods_num:String?
    var goods_name:String?
    var goods_img:String?
    var specification_id:String?
    var specification_ids:String?
    var specification_names:String?
    var specification_stock:String?
    var specification_img:String?
    var specification_price:String?
    var is_delete:String?
    var create_time:String?
    var update_time:String?
    var goods_group_id:String?
    var group_specification_id:String?
    var group_price:String?
    var group_stock:String?
    var goods_welfare_id:String?
    var welfare_id:String?
    var welfare_percent_value:String?
    var is_give_integral:String?
    var give_integral_value:String?
    var has_refund:String?
    var order_no:String?
    required init(){}

}
