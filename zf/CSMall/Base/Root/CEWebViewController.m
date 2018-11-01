//
//  CEWebViewController.m
//  CrazyEstate
//
//  Created by sh-lx on 2017/3/13.
//  Copyright © 2017年 liangyi. All rights reserved.
//

#import "CEWebViewController.h"
//#import <SVProgressHUD/SVProgressHUD.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface CEWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) JSContext *context;

@end

@implementation CEWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark web view 代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [SVProgressHUD dismiss];
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __block typeof(self) weakSelf = self;
    self.context[@"addSubView"] = ^(NSString *vid) {
        
        [weakSelf clickItem:vid];
    };
 

    self.context[@"appShare"] = ^{
        [weakSelf clickgoodsappShare];
    };
    self.context[@"appJumpGuige"] = ^{
        [weakSelf clickgoodsappJumpGuige];
    };
    self.context[@"appJumpPinglun"] = ^{
        [weakSelf clickgoodsappJumpPinglun];
    };
    self.context[@"appJumpDianpu"] = ^{
        [weakSelf clickgoodsappJumpDianpu];
    };
    self.context[@"appJumpGuanzhu"] = ^{
        [weakSelf clickgoodsappJumpGuanzhu];
    };
    self.context[@"appJumpZhibo"] = ^{
        [weakSelf clickgoodsappJumpZhibo];
    };
    
    self.context[@"appcoupon"] = ^(NSString* couponId,NSString* loginState){
        [weakSelf clickDiscountCoupon:loginState andDiscountCouponId:couponId];
        
    };
    self.context[@"appviewbanner"] = ^(NSString *images, NSString *index){
        [weakSelf clickbanner:images andIndex:index];
    };

    [self webDidFish:webView];

//    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    // 打印异常
//    self.context.exceptionHandler =
//    ^(JSContext *context, JSValue *exceptionValue)
//    {
//        context.exception = exceptionValue;
//        NSLog(@"%@", exceptionValue);
//    };
//    
//    // 以 JSExport 协议关联 native 的方法
//    self.context[@"native"] = self;
//    
//    __weak typeof(self) weakSelf = self;
//    weakSelf.context[@"addSubView"] =
//    ^(int goods_id)
//    {
//        //        NSLog(@"%@",goods_id);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //            ShopItemDetailViewController *vc = [[ShopItemDetailViewController alloc] init];
//            //            vc.good_id = goods_id;
//            //            vc.hidesBottomBarWhenPushed = YES;
//            //            [weakSelf.navigationController pushViewController:vc animated:YES];
//        });
//    };
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
