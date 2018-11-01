//
//  HeartAnimationView.swift
//  YinBang
//
//  Created by zhengan88 on 16/10/16.
//  Copyright © 2016年 zhengan88. All rights reserved.
//

import UIKit

class HeartAnimationView: UIView {
    
    var strokeColor: UIColor?
    var fillColor: UIColor?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        strokeColor = UIColor.white
        fillColor = UIColor(red: CGFloat(Float(arc4random_uniform(255)) / 255.0), green: CGFloat(Float(arc4random_uniform(255)) / 255.0), blue: CGFloat(Float(arc4random_uniform(255)) / 255.0), alpha: 1.0)
        backgroundColor = UIColor.clear
        layer.anchorPoint = CGPoint(x: 0.5,y: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationInView(view: UIView) {
        
        let animationDuration: TimeInterval = 8
        let heartWidth: CGFloat = bounds.width
        let heartCenterX: CGFloat = center.x
        let viewHeight: CGFloat = view.bounds.height
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.curveEaseOut, animations: {
            //            self.transform = CGAffineTransformIdentity
            self.transform = CGAffineTransform.identity
            self.alpha = 0.9
        }) { (Bool) in
            
        }
        let i:Int = Int (arc4random_uniform(2))
        let rotationDirection: Int = (1 - (2 * i))
        let rotationFraction = arc4random_uniform(10)
        
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double(rotationDirection) * M_PI / (16 + Double(rotationFraction) * 0.2)))
        }
        
        let travelPath = UIBezierPath()
        travelPath.move(to: center)
        
        let endPoint = CGPoint(x: heartCenterX + CGFloat(rotationDirection * Int( arc4random_uniform(2 * UInt32(heartWidth)))), y: viewHeight / 6.0 + CGFloat(arc4random_uniform(UInt32(viewHeight) / 4)))
        
        let j: Int = Int(arc4random_uniform(2))
        let travelDirection: CGFloat = 1 - (2 * CGFloat(j))
        let x = (heartWidth / 2.0 + CGFloat(arc4random_uniform(2 * UInt32(heartWidth)))) * travelDirection
        let y = max(endPoint.y, max(CGFloat(arc4random_uniform(8 * UInt32(heartWidth))), heartWidth))
        
        let controlPoint1 = CGPoint(x: heartCenterX + x, y: viewHeight - y)
        let controlPoint2 = CGPoint(x: heartCenterX - 2 * x, y: y)
        
        travelPath.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        let keyAnimation = CAKeyframeAnimation(keyPath: "position")
        keyAnimation.path = travelPath.cgPath
        keyAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        keyAnimation.duration = animationDuration + Double(endPoint.y / viewHeight)
        layer.add(keyAnimation, forKey: "travelPath")
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        strokeColor?.setStroke()
        fillColor?.setFill()
        //        /**
        //         *  设置填充颜色
        //         */
        //        UIColor.white.setStroke()
        //        UIColor.randomColor().setFill()
        
        
        /**
         *  爱心间隙
         */
        let drawingPadding:CGFloat = 4.0
        
        /**
         *  一侧圆的半径
         *  @param rect
         *  @return 一侧圆的半径
         */
        let curveRadius = floor((rect.width - 2*drawingPadding) / 4.0)
        
        
        /**
         *  创建曲线
         */
        let heartPath = UIBezierPath()
        
        
        /**
         *  底部的小尖尖
         *  @param rect 底部尖尖的 X和Y
         *  @return 底部的小尖尖
         */
        let tipLocation = CGPoint(x: floor(rect.width / 2.0), y: rect.height - drawingPadding)
        heartPath.move(to: tipLocation)
        
        
        /**
         *  左侧半圆起始点
         *  @param drawingPadding 起始点X
         *  @param rect           起始点Y
         *  @return 左侧圆起始点
         */
        let topLeftCurveStart = CGPoint(x: drawingPadding, y: floor(rect.height / 2.4))
        
        
        /**
         *  添加底部尖尖到左侧圆起始点曲线
         *  @param topLeftCurveStart                         添加的点
         *  @param topLeftCurveStart.x                       控制点X
         *  @param topLeftCurveStart.y + curveRadius         控制点Y
         *  @return 添加底部尖尖到左侧圆起始点曲线
         */
        heartPath.addQuadCurve(to: topLeftCurveStart, controlPoint: CGPoint(x: topLeftCurveStart.x, y: topLeftCurveStart.y + curveRadius))
        
        
        /**
         *  添加左侧半圆起始点到终点圆弧
         *  @param topLeftCurveStart.x + curveRadius         左侧圆心X
         *  @param topLeftCurveStart.y                       左侧圆心Y
         *  @param curveRadius                               半径
         *  @param startAngle                                开始角度
         *  @param endAngle                                  结束角度
         *  @param clockwise                                 旋转方向
         *  @return 添加左侧圆起始点到终点圆弧
         */
        heartPath.addArc(withCenter: CGPoint(x: topLeftCurveStart.x + curveRadius, y: topLeftCurveStart.y), radius: curveRadius, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        
        
        
        
        /**
         *  右侧半圆弧起始点
         *  @param topLeftCurveStart.x + 2*curveRadius 右侧圆起始点X(注意:此处点的位置)
         *  @param topLeftCurveStart.y                 右侧圆起始点Y
         *  @return 右侧圆起始点
         */
        let topRightCurveStart = CGPoint(x: topLeftCurveStart.x + 2*curveRadius, y: topLeftCurveStart.y)
        
        
        
        
        /**
         *  添加右侧半圆起始点到终点圆弧
         *  @param topRightCurveStart.x + curveRadius          右侧圆心X
         *  @param topRightCurveStart.y                        右侧圆心Y
         *  @param curveRadius                                 半径
         *  @param startAngle                                  开始角度
         *  @param endAngle                                    结束角度
         *  @param clockwise                                   旋转方向
         *  @return 添加右侧半圆起始点到终点圆弧
         */
        heartPath.addArc(withCenter: CGPoint(x: topRightCurveStart.x + curveRadius, y: topRightCurveStart.y), radius: curveRadius, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        
        
        /**
         *  右侧半圆终点
         *  @param topLeftCurveStart.x + 4*curveRadius          右侧半圆的终点X
         *  @param topRightCurveStart.y                         右侧半圆的终点Y
         *  @return 右侧半圆终点
         */
        let topRightCurveEnd = CGPoint(x: topLeftCurveStart.x + 4*curveRadius, y: topRightCurveStart.y)
        
        
        /**
         *  右侧半圆终点到底部小尖尖曲线
         *  @param topRightCurveEnd.x                       控制点X
         *  @param topRightCurveEnd.y + curveRadius         控制点Y
         *  @return 右侧半圆终点到底部小尖尖
         */
        heartPath.addQuadCurve(to: tipLocation, controlPoint: CGPoint(x: topRightCurveEnd.x, y: topRightCurveEnd.y + curveRadius))
        
        
        heartPath.fill()
        heartPath.lineWidth = 1;
        heartPath.lineCapStyle = CGLineCap.round
        heartPath.lineJoinStyle = CGLineJoin.round
        heartPath.stroke()
        
    }
    
    
}
