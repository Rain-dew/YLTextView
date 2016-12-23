//
//  UITextView+YLTextVIew.h
// QQ:896525689
// Email:zhangyuluios@163.com
//                 _
// /\   /\        | |
// \ \_/ / _   _  | |     _   _
//  \_ _/ | | | | | |    | | | |
//   / \  | |_| | | |__/\| |_| |
//   \_/   \__,_| |_|__,/ \__,_|
//
//  Created by shuogao on 16/9/9.
//  Copyright © 2016年 tangjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (YLTextView)

@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//限制字数

- (NSString *)yl_setText:(NSString *)text;

@end
