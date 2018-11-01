//
//  CEWebViewController.h
//  CrazyEstate
//
//  Created by sh-lx on 2017/3/13.
//  Copyright © 2017年 liangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEWebViewController : UIViewController

- (void)clickItem:(NSString *)zId;
//goodsDeatail
/*
 appShare分享
 appJumpGuige规格
 appJumpPinglun查看全部评价
 appJumpDianpu点击进入店铺详情
 appJumpGuanzhu店铺关注
 appJumpZhibo进入直播
 */
- (void)clickgoodsappShare;
- (void)clickgoodsappJumpGuige;
- (void)clickgoodsappJumpPinglun;
- (void)clickgoodsappJumpDianpu;
- (void)clickgoodsappJumpGuanzhu;
- (void)clickgoodsappJumpZhibo;
- (void)clickDiscountCoupon:(NSString *)loginState andDiscountCouponId:(NSString *)CouponId;
- (void)clickbanner:(NSString *)imgages andIndex:(NSString *) index;

- (void)webDidFish:(UIWebView *)web;

@end
