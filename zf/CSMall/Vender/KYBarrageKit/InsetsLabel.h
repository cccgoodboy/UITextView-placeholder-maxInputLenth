//
//  InsetsLabel.h
//  CrazyEstate
//
//  Created by 梁毅 on 2017/2/19.
//  Copyright © 2017年 liangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
