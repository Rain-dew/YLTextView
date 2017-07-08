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

@interface UITextView (YLTextView)

/*
 * @param : placeholder 占位符         可与下面两个属性任意一个同时设置
 * @param : limitLength 需要限制的字数  优先级高于lines
 * @param : limitLines  需要限制的行数
 */
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,  copy) NSNumber *limitLength;
@property (nonatomic,  copy) NSNumber *limitLines;

/* ******特殊说明。如果你想对textView.text直接赋值*******
 *       请务必在对placehoulder和limitLength之前进行
 一旦你对text赋值了，你需要立马重新对placeholder赋值。
 *       格式： textView.text = @"请务必写在placeholder和limitLength之前";
 *             textView.placeholder = @"喜欢请Star";
 *             textView.limitLength = @20;//如果赋值长度大于此长度会被自动截断！
 */
@end
