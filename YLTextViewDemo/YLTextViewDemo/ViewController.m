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
    textView.frame = CGRectMake(0, 0, 203, 120);
    textView.center = self.view.center;
    textView.font = [UIFont systemFontOfSize:17];
    
//    textView.text = @"我是一段很长的字符串，很长很长真的很长";
    textView.placeholder = @"我是一个占位符";
//    textView.limitLength = @10;
    textView.placeholdColor = [UIColor redColor];
    textView.limitPlaceColor = [UIColor redColor];
    textView.placeholdFont = [UIFont systemFontOfSize:17];
    textView.limitPlaceFont = [UIFont systemFontOfSize:17];
//    textView.autoHeight = @1;
    textView.limitLines = @2;//行数限制优先级低于字数限制
    textView.infoBlock = ^(NSString *text, CGSize textViewSize) {
        NSLog(@"当前文字: %@   当前高度:%lf",text,textViewSize.height);
    };
    
    [self.view addSubview:textView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
