//
//  UIView+UIColorToCGColor.m
//  Onthecollar
//
//  Created by CuiFeng on 15/10/27.
//  Copyright © 2015年 Stoney. All rights reserved.
//

#import "UIView+UIColorToCGColor.h"

@implementation UIView (UIColorToCGColor)

- (void)setBorderColorUIColor:(UIColor *)borderColorUIColor {
    self.layer.borderColor = borderColorUIColor.CGColor;
}

- (UIColor *)borderColorUIColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


@end
