//
//  HaveNetwork.m
//  Kongfu
//
//  Created by ZA on 2017/5/17.
//  Copyright © 2017年 邵杰. All rights reserved.
//

#import "HaveNetwork.h"
#import "Reachability.h"

@implementation HaveNetwork
+ (BOOL) isHaveNetwork
{
    //Reachability.h 并不是ASI自己写的，而是苹果在官方文档中的文件，用于判断网络，网上有很多这样的示例，很少有全面的，都是简单的判断网络，并且还有错误的或者是旧版本
    
    //简单的判断网络如何判断 Name中写你自己服务器的地址，当然也可以百度的，主要用于判断与你服务器是否可以连接，比如服务器崩溃，就不可连接
    // Create zero addy
    Reachability * re = [ Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([re currentReachabilityStatus] == ReachableViaWiFi || [re currentReachabilityStatus] == ReachableViaWWAN) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL) isWIFI{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reach currentReachabilityStatus];

    if (status == ReachableViaWWAN) {
        return false;
    }else{
        return YES;
    }
}

@end
