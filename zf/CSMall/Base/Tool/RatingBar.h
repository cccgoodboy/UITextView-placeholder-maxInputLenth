//
//  RatingBar.h
//  MyRatingBar
//
//  Created by Leaf on 14-8-28.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
@class RatingBar;
@protocol RatingBarDelegate <NSObject>

- (void)SelectStarNumber:(NSInteger)starNumber andView:(RatingBar*)view;
@end

@interface RatingBar : UIView
@property (nonatomic, assign)id <RatingBarDelegate> stardelegate;
@property (nonatomic,assign) NSInteger starNumber;
/*
 *调整底部视图的颜色
 */
@property (nonatomic,strong) UIColor *viewColor;

/*
 *是否允许可触摸
 */
@property (nonatomic,assign) BOOL enable;
@end
