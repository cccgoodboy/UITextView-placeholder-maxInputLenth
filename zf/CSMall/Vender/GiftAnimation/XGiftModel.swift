//
//  XGiftModel.swift
//  XGiftAnimation
//
//  Created by sajiner on 2016/12/19.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

class XGiftModel: NSObject {

    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    var giftNum :String = ""
    
    init(senderName : String, senderURL : String, giftName : String, giftURL : String,giftNum :String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    self.giftNum = giftNum
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? XGiftModel else {
            return false
        }
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        return true
    }
}
