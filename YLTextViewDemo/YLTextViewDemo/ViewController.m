//
//  ViewController.m
//  YLTextViewDemo
//
//  Created by 张雨露 on 2016/12/23.
//  Copyright © 2016年 张雨露. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+YLTextView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0, 0, 200, 120);
    textView.center = self.view.center;
//    textView.font = [UIFont systemFontOfSize:17];
    
//    textView.text = @"请写在自定义属性前面，如果长度大于limitLength设置长度会被自动截断。";
    textView.placeholder = @"我是一个占位符";
    textView.limitLength = @20;
    textView.placeholdColor = [UIColor redColor];
    textView.limitPlaceColor = [UIColor redColor];
    textView.placeholdFont = [UIFont systemFontOfSize:14];
    textView.limitPlaceFont = [UIFont systemFontOfSize:17];
    //    textView.limitLines = @4;//行数限制优先级低于字数限制
    [self.view addSubview:textView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
