
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG

//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//
//  SingleClickHeartAnimationView.swift
//  FKDCClient
//
//  Created by 梁毅 on 2016/12/12.
//  Copyright © 2016年 liangyi. All rights reserved.
//

import UIKit

class SingleClickHeartAnimationView: UIView {
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.clear
            layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            drawLoveIn(rect)
        }
        
        fileprivate func drawLoveIn(_ rect:CGRect){
            /**
             *  设置填充颜色
             */
            UIColor.white.setStroke()
            UIColor.randomColor().setFill()
            
            
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
        
        
        func showAnimationWith(_ view: UIView){
            /// 父类的高度
            let viewHeight = view.frame.height
            /// 动画执行总时间
            let totleAnimationDuration:TimeInterval = 6
            /// 爱心的宽
            let loveWidth:CGFloat = bounds.width
            /// 爱心缩放起始比例
            transform = CGAffineTransform(scaleX: 0, y: 0)
            alpha = 0.0
            /**
             *  爱心在开始显示时的动画
             */
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
                self.alpha = 0.9
            }) { (_) -> Void in
                
            }
            /// 临时值 0 1
            let tempNumber = (CGFloat)(arc4random_uniform(2));
            /// 旋转方向值 -1 1
            let rotationDirectionNumber = (1 - 2 * (tempNumber))
            let rotationFraction = (CGFloat)(arc4random_uniform(10)); // 0 ~ 9
            
            /**
             *  在totleAnimationDuration时间内动画执行的角度
             */
            let temp = (CGFloat)(M_PI / (Double)(16 + rotationFraction * 0.2))
            UIView.animate(withDuration: totleAnimationDuration, animations: { () -> Void in
                self.transform = CGAffineTransform(rotationAngle: rotationDirectionNumber * temp)
            })
            
            let lovePath = UIBezierPath()
            lovePath.move(to: center)
            
            /**
             *  结束的顶部随机点
             */
            let number = UInt32(2 * loveWidth)
            let arc4random = (CGFloat)(arc4random_uniform(number))
            let arc4random_Y = (CGFloat)(arc4random_uniform(UInt32(viewHeight / 4.0)))
            let endarc4randomPoint = CGPoint(x: center.x + rotationDirectionNumber * arc4random, y: viewHeight / 6.0 + arc4random_Y)
            
            /**
             *  随机控制的点
             */
            let randomControl = (CGFloat)(arc4random_uniform(2));
            /// 方向值 -1 1
            let directionNumber = (1 - 2 * (randomControl))
            // 控制点 X 和 Y
            let xDelta = (CGFloat)(loveWidth / 2.0 + (CGFloat)(arc4random_uniform(UInt32( 2 * loveWidth)))) * directionNumber;
            let yDelta = max(endarc4randomPoint.y ,max((CGFloat)(arc4random_uniform(UInt32( 8 * loveWidth))), loveWidth));
            let controlPoint1 = CGPoint(x: center.x + xDelta, y: viewHeight - yDelta);
            let controlPoint2 = CGPoint(x: center.x - 2 * xDelta, y: yDelta);
            
            /**
             *  添加结束点和控制点画曲线
             */
            lovePath.addCurve(to: endarc4randomPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            
            /**
             *  创建帧动画
             */
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
            keyFrameAnimation.path = lovePath.cgPath
            
            /**
             *  timingFunction：速度控制函数，控制动画运行的节奏
             *  kCAMediaTimingFunctionLinear 匀速
             */
            keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            /**
             *  动画执行
             */
            keyFrameAnimation.duration = totleAnimationDuration + (TimeInterval)(endarc4randomPoint.y/viewHeight);
            layer.add(keyFrameAnimation, forKey: "positionOnPath")
            UIView.animate(withDuration: totleAnimationDuration, animations: { () -> Void in
                self.alpha = 0.0
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
            }) 
            
        }
        
}
