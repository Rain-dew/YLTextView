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
    textView.frame = CGRectMake(0, 0, 200, 150);
    textView.center = self.view.center;
//    textView.text = @"请写在自定义属性前面，如果长度大于limitLength设置长度会被自动截断。";
    textView.placeholder = @"欢迎star";
    textView.limitLength = @20;
    [self.view addSubview:textView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
