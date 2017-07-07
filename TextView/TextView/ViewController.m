//
//  ViewController.m
//  TextView
//
//  Created by 初程程 on 2017/7/6.
//  Copyright © 2017年 初程程. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+Placeholder.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textFiled = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
    textFiled.backgroundColor = [UIColor grayColor];
    textFiled.placeholder = @"444444";
    textFiled.placeholderColor = [UIColor redColor];
    textFiled.maxInputLength = 30;
    [self.view addSubview:textFiled];
    NSLog(@"%@",textFiled.placeholder);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
