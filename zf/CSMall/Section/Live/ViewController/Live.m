//
//  Live.m
//  DragonVein
//
//  Created by 梁毅 on 2017/4/12.
//  Copyright © 2017年 tts. All rights reserved.
//

#import "Live.h"

@implementation Live
- (void)initView:(PLMediaStreamingSession *)session {
    session.rtcMixOverlayRectArray = [NSArray arrayWithObjects:[NSValue valueWithCGRect:CGRectMake(244, 448, 108, 192)], [NSValue valueWithCGRect:CGRectMake(244, 256, 108, 192)], nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
