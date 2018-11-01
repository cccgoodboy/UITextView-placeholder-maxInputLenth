//
//  LyeCustomGestureRecognizer.swift
//  Demo
//
//  Created by Luiz on 2017/4/14.
//  Copyright © 2017年 lye. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class LyeCustomGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delegate = self
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        } else {
            return true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = (touches as NSSet).anyObject() as! UITouch
        let nowLocation = touch.location(in: self.view)
        let preLocation = touch.previousLocation(in: self.view)
        
        //获取两个手指的偏移量
        let offsetX = nowLocation.x - preLocation.x
        let offsetY = nowLocation.y - preLocation.y
        
        let frame = self.view!.frame
        var origin = frame.origin
        origin.x += offsetX
        origin.y += offsetY
        
        if origin.x < 0 {
            origin.x = 0
        } else if origin.x > kScreenWidth - frame.width {
            origin.x = kScreenWidth - frame.width
        }
        if origin.y < 0 {
            origin.y = 0
        } else if origin.y > kScreenHeight - frame.height {
            origin.y = kScreenHeight - frame.height
        }
        self.view?.frame.origin = origin
    }
}
