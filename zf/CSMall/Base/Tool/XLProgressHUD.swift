//
//  XLProgressHUD.swift
//  XLProgressHUD
//
//  Created by yuanxiaolong on 16/6/1.
//  Copyright © 2016年 yuanxiaolong. All rights reserved.
//
import UIKit
import Foundation

// 总体
let proportionWidth:CGFloat     = 0.8     //80%的占比宽度
let proportionHeight:CGFloat    = 0.8     //80%的占比高度
let horizontalPadding:CGFloat   = 10.0
let verticalPadding:CGFloat     = 10.0
let cornerRadius:CGFloat        = 10.0
let opacity:CGFloat             = 0.7
let titleFontSize:CGFloat       = 16.0
let messageFontSize:CGFloat     = 16.0
let titleLines                  = 0
let messageLines                = 0
let fadeDuration:Double         = 0.2

let defaultPosition             = "center"


// 阴影
let shadowOpacity:Float         = 0.8
let shadowRadius:CGFloat        = 5.0
let shadowOffset                = CGSize(width: CGFloat(4.0), height: CGFloat(4.0))
var displayShadow               = true

// 图片
let imageViewWidth:CGFloat      = 20.0
let imageViewHeight:CGFloat     = 20.0
let bigImageViewWidth:CGFloat   = 30.0
let bigImageViewHeight:CGFloat  = 30.0

// 一直显示的View
let activityViewWidth:CGFloat   = 120
let activityViewHeight:CGFloat  = 100
let activityOpactity:CGFloat    = 0.7
var activityViewKey             = "activityViewKey"
let activityFontSize:CGFloat    = 14.0


extension UIView{
    
    // 只含有提示信息的提示
    public func showMessage(_ message:String?,interval:CGFloat,position:AnyObject){
        
        if let view = viewForMessage(nil, message: message, image: nil) {
            
            showView(view, interval: interval, point: position)
        }
        
    }
    
    
    // 含有提示信息和图片的提示
    public func showMessageAndImage(_ message:String?,image:UIImage?,interval:CGFloat,position:AnyObject){
        
        if let view = viewForMessage(nil, message: message, image: image) {
            
            showView(view, interval: interval, point: position)
        }
        
        
    }
    
    // 含有标题、信息和图片的提示
    public func showTitleMessageAndImage(_ title:String?,message:String?,image:UIImage?,interval:CGFloat,position:AnyObject){
        
        if let view = viewForMessage(title, message: message, image: image) {
            
            showView(view, interval: interval, point: position)
        }
        
    }
    
    // 含有提示信息的加载提示
    public func showLoadingTilteActivity(_ message:String,position:AnyObject?){
        
        activityView(message, position: position)
        
    }
    
    // 没有提示信息的加载提示
    public func showLoadingActivity(_ position:AnyObject?){
        
        activityView(nil, position: position)
        
    }
    
    // 隐藏提示
    public func hideActivity(){
        
        hideActivityView()
        
    }
    
    // 控件显示（控件显示停留时间与动画）
    fileprivate func showView(_ view:UIView,interval:CGFloat,point:AnyObject){
        
        view.center = centerPointForPositon(view, point: point)
        view.alpha = 0.0
        addSubview(view)
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: fadeDuration,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: {
                                     view.alpha = 1.0
            }) { (finished) in
                
                UIView.animate(withDuration: fadeDuration,
                                           delay: Double(interval),
                                           options: UIViewAnimationOptions.curveEaseIn,
                                           animations: {
                                            view.alpha = 0.0
                    }, completion: { (finished) in
                        view.removeFromSuperview()
                        self.isUserInteractionEnabled = true
                })
                
        }
        
    }
    
    // 设置控件位置
    fileprivate func centerPointForPositon(_ view:UIView,point:AnyObject?) -> CGPoint{
        
        if point is String {
            
            let pointStr = point as! String
            if pointStr == "top" {
                
                return CGPoint(x: bounds.size.width * 0.5, y: view.bounds.size.height * 0.5 + verticalPadding)
            }else if pointStr == "bottom" {
                
                return CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height - view.bounds.size.height * 0.5 - verticalPadding - 60)
                
            }else{
                
                return CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
            }
            
        }else if point is NSValue{
            
            return point!.cgPointValue
        }else{
            
            return centerPointForPositon(view, point: defaultPosition as AnyObject?)
        }
        
    }
    
    // 创建有时间间隔显示的控件
    fileprivate func viewForMessage(_ title:String?,message:String?,image:UIImage?) ->UIView?{
        
        if title == nil && message == nil && image == nil {
            return nil
        }
        
        var titleLabel:UILabel?
        var messageLabel:UILabel?
        var imageView:UIImageView?
        let showView = UIView()
        showView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin,
                                     UIViewAutoresizing.flexibleRightMargin,
                                     UIViewAutoresizing.flexibleTopMargin,
                                     UIViewAutoresizing.flexibleBottomMargin]
        showView.layer.cornerRadius = cornerRadius
        
        // 阴影设置
        if displayShadow {
            showView.layer.shadowColor = UIColor.black.cgColor
            showView.layer.shadowOpacity = shadowOpacity
            showView.layer.shadowRadius = shadowRadius
            showView.layer.shadowOffset = shadowOffset
            
        }
        showView.backgroundColor = UIColor.black.withAlphaComponent(opacity)
        
        var imageWidth:CGFloat = 0.0, imageHeight:CGFloat = 0.0, imageTop:CGFloat = 0.0
        
        // imageView的创建与 size设置
        if image != nil {
            imageView = UIImageView()
            imageView?.image = image
            imageView?.contentMode = UIViewContentMode.scaleAspectFit
            imageView?.frame = CGRect(x: horizontalPadding, y: verticalPadding, width: imageViewWidth, height: imageViewHeight)
            imageWidth = (imageView?.bounds)!.width
            imageHeight = (imageView?.bounds)!.height
            imageTop = verticalPadding
        }
        
        var titleWidth:CGFloat = 0.0, titleHeight:CGFloat = 0.0, titleTop:CGFloat = 0.0
        
        // titleLabel的创建与 size设置
        if title != nil {
            
            titleLabel = UILabel()
            titleLabel?.numberOfLines = titleLines
            titleLabel?.font = UIFont.boldSystemFont(ofSize: titleFontSize)
            titleLabel?.textAlignment = NSTextAlignment.left
            titleLabel?.textColor = UIColor.white
            titleLabel?.backgroundColor = UIColor.clear
            titleLabel?.alpha = 1.0
            titleLabel?.text = title
            
            let maxTitleSize = CGSize(width: bounds.width * proportionWidth - imageWidth, height: bounds.height * proportionHeight)
            let titleStr = title! as NSString
            
            let expextesTitleSize = titleStr.boundingRect(with: maxTitleSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: (titleLabel?.font)!], context: nil)
            titleLabel?.frame = CGRect(x: 0.0, y: 0.0, width: expextesTitleSize.width, height: expextesTitleSize.height)
            titleWidth = (titleLabel?.bounds)!.width
            titleHeight = (titleLabel?.bounds)!.height
            titleTop = verticalPadding
            
        }
        
        // messsageLabel的创建与 size设置
        if message != nil {
            
            messageLabel = UILabel()
            messageLabel?.numberOfLines = messageLines
            messageLabel?.font = UIFont.systemFont(ofSize: messageFontSize)
            messageLabel?.textAlignment = NSTextAlignment.center
            messageLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            messageLabel?.textColor = UIColor.white
            messageLabel?.backgroundColor = UIColor.clear
            messageLabel?.alpha = 1.0
            messageLabel?.text = message
            
            let maxMessageSize = CGSize(width: bounds.width * proportionWidth - imageWidth, height: bounds.height * proportionHeight)
            let messageStr = message! as NSString
            
            let expextesMessageSize = messageStr.boundingRect(with: maxMessageSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: (messageLabel?.font)!], context: nil)
            messageLabel?.frame = CGRect(x: 0.0, y: 0.0, width: expextesMessageSize.width, height: expextesMessageSize.height)
            
        }
        
        var messageWidth:CGFloat = 0.0, messageHeight:CGFloat = 0.0, messageLeft:CGFloat = 0.0, messageTop:CGFloat = 0.0,messageX:CGFloat = 0.0,messageY:CGFloat = 0.0
        
        if title == nil && image != nil{
            imageWidth = bigImageViewWidth
            imageHeight = bigImageViewHeight
        }
        
        if messageLabel != nil {
            
            messageWidth = (messageLabel?.bounds)!.width
            messageHeight = (messageLabel?.bounds)!.height
            messageX = horizontalPadding
            messageY = imageTop + imageHeight + verticalPadding
            messageTop = messageY
            messageLeft = messageLeft + horizontalPadding
            
        }
        
        let showWidth = max(imageWidth + titleWidth + horizontalPadding + 2 * horizontalPadding, messageWidth + 2 * horizontalPadding)
        let showHeight = messageTop + messageHeight + verticalPadding
        showView.frame = CGRect(x: 0.0, y: 0.0, width: showWidth, height: showHeight)
        
        var imageViewX:CGFloat = 0.0
        
        if title == nil && image != nil{
            imageViewX = (showWidth - imageWidth) * 0.5
            
        }else if image != nil{
            imageViewX = (showWidth - imageWidth - titleWidth - horizontalPadding) * 0.5
        }
        
        // 重新设置相应控件的frame
        if imageView != nil {
            imageView?.frame = CGRect(x: imageViewX, y: verticalPadding, width: imageWidth, height: imageHeight)
            showView.addSubview(imageView!)
            
        }
        
        if titleLabel != nil {
            let titleLabelX = imageViewX + imageWidth + horizontalPadding
            titleLabel?.frame = CGRect(x: titleLabelX, y: titleTop, width: titleWidth, height: titleHeight)
            showView.addSubview(titleLabel!)
            
        }
        
        if messageLabel != nil {
            
            messageLabel?.frame = CGRect(x: messageX, y: messageY, width: messageWidth, height: messageHeight)
            showView.addSubview(messageLabel!)
            
        }
        
        return showView
    }
    
    // 创建一直显示的View
    fileprivate func activityView(_ text:String?,position:AnyObject?){
        
        let existingActivityView = objc_getAssociatedObject(self, &activityViewKey)
        if existingActivityView == nil {
            return
        }
        
        isUserInteractionEnabled = false
        
        let activityView = UIView()
        activityView.frame = CGRect(x: 0.0, y: 0.0, width: activityViewWidth, height: activityViewHeight)
        activityView.center = centerPointForPositon(activityView, point: position)
        activityView.backgroundColor = UIColor.black.withAlphaComponent(activityOpactity)
        activityView.alpha = 0.0
        activityView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin,
                                         UIViewAutoresizing.flexibleRightMargin,
                                         UIViewAutoresizing.flexibleTopMargin,
                                         UIViewAutoresizing.flexibleBottomMargin]
        activityView.layer.cornerRadius = cornerRadius
        
        if displayShadow {
            activityView.layer.shadowColor = UIColor.black.cgColor
            activityView.layer.shadowOpacity = shadowOpacity
            activityView.layer.shadowRadius = shadowRadius
            activityView.layer.shadowOffset = shadowOffset
            
        }
        
        var indicViewCenterY = activityView.bounds.height * 0.5
        
        if text != nil {
            
            indicViewCenterY = activityView.bounds.height * 0.5 - 10
            let label = UILabel()
            label.frame = CGRect(x: 0.0, y: activityView.bounds.height - 30, width: activityView.bounds.width, height: 20)
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: activityFontSize)
            activityView.addSubview(label)
        }
        
        let indicView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicView.center = CGPoint(x: activityView.bounds.size.width * 0.5, y: indicViewCenterY)
        activityView.addSubview(indicView)
        indicView.startAnimating()
        
        objc_setAssociatedObject(self, &activityViewKey, activityView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        addSubview(activityView)
        
        UIView.animate(withDuration: fadeDuration, delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { 
                                    activityView.alpha = 1.0
            },
                                   completion: nil)
        
    }
    
    // 移除一直显示的View
    fileprivate func hideActivityView(){
        
        let existingActivityView = objc_getAssociatedObject(self, &activityViewKey)
        if existingActivityView != nil {
            
            UIView.animate(withDuration: fadeDuration,
                                       delay: 0.0,
                                       options: [UIViewAnimationOptions.curveEaseIn,UIViewAnimationOptions.beginFromCurrentState],
                                       animations: { 
                                        (existingActivityView as! UIView).alpha = 0.0
                                        
                }, completion: { (finished) in
                    
                    (existingActivityView as! UIView).removeFromSuperview()
                    objc_setAssociatedObject(self, &activityViewKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    self.isUserInteractionEnabled = true
            })
        }
    }
}
