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
//  Created by 张雨露 on 16/9/9.
//  Copyright © 2016年 Raindew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textViewInfo)(NSString *text,CGSize textViewSize);

@interface UITextView (YLTextView)

@property (nonatomic,strong) NSString *placeholder;//占位符,可与下面属性任意一个同时设置

@property(nonatomic,  copy) NSNumber *limitLength;//需要限制的字数          优先级高于lines

@property(nonatomic,  copy) NSNumber *limitLines;//需要限制的行数

@property(nonatomic, strong) UIFont   *placeholdFont;//占位符文字          默认13号字体

@property(nonatomic, strong) UIFont   *limitPlaceFont;//行数、字数限制文字     默认13号字体

@property(nonatomic, strong) UIColor  *placeholdColor;//占位符文字颜色    默认灰色

@property(nonatomic, strong) UIColor  *limitPlaceColor;//行数、字数限制文字颜色 默认灰色

@property(nonatomic,   copy) NSNumber *autoHeight;//自动高度 默认不计算 设置@1自动计算高度

@property(nonatomic,   copy) textViewInfo infoBlock;//获取当前字数、当前高度的block

@end
