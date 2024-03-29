//
//  UITextView+YLTextVIew.m
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

#import "UITextView+YLTextView.h"
#import <objc/runtime.h>
@interface UITextView ()
@property (nonatomic,strong) UILabel *placeholderLabel;//占位符
@property (nonatomic,strong) UILabel *wordCountLabel;//计算字数
@property (nonatomic,strong) NSValue *oldFrame;//记录初始frame

@end
@implementation UITextView (YLTextView)

static NSString *PLACEHOLDLABEL = @"placelabel";
static NSString *PLACEHOLD = @"placehold";
static NSString *WORDCOUNTLABEL = @"wordcount";
static NSString *PLACEHOLDFONT = @"placeholdfont";
static NSString *LIMITFONT = @"limitfont";
static NSString *PLACEHOLDCOLOR = @"placeholdcolor";
static NSString *LIMITCOLOR = @"limitcolor";
static NSString *AUTOHEIGHT = @"autoheight";
static NSString *OLDFRAME = @"oldframe";
static NSString *INFOBLOCK = @"infoBlock";
static NSString *LIMITLENGTH = @"limitLengthKey";
static NSString *LIMITLINES = @"limitLinesKey";
static NSString *TEXT = @"text";

+ (void)load {
    // 系统方法layoutSubviews
    Method system_method_layoutSubviews = class_getInstanceMethod([self class], @selector(layoutSubviews));
    // 将要替换系统方法layoutSubviews
    Method my_method_layoutSubviews = class_getInstanceMethod([self class], @selector(yl_layoutSubviews));
    // 进行交换
    method_exchangeImplementations(system_method_layoutSubviews, my_method_layoutSubviews);
    
    // 系统方法 text
    Method system_method_text = class_getInstanceMethod([self class], @selector(setText:));
    // 将要替换系统方法 text
    Method my_method_text = class_getInstanceMethod([self class], @selector(yl_setText:));
    // 进行交换
    method_exchangeImplementations(system_method_text, my_method_text);
}

- (void)yl_layoutSubviews {
    self.bounces = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//获取frame
        if (self.limitLength && self.wordCountLabel) {
            /*
             *  避免外部使用了约束 这里再次更新frame
             */
            self.wordCountLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 20 + self.contentOffset.y, CGRectGetWidth(self.frame) - 7, 20);
        }
        if (self.placeholder && self.placeholderLabel) {
            CGRect rect = [self.placeholder boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.placeholdFont} context:nil];
            self.placeholderLabel.frame = CGRectMake(7, 7, rect.size.width, rect.size.height);
        }
        if ([self.autoHeight isEqual:@1]) {
            CGRect currentFrame = self.frame;
            if (!self.oldFrame) {
                self.oldFrame = [NSValue valueWithCGRect:currentFrame];
            }
        }
    });
}
// 重写setText
- (void)yl_setText:(NSString *)text {
    [self yl_setText:text];
    if (self.placeholder) {
        self.placeholder = self.placeholder;
    }
    if (self.limitLength) {
        self.limitLength = self.limitLength;
    }
}

#pragma mark -- set/get...

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, &PLACEHOLDLABEL, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, &PLACEHOLDLABEL);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, &PLACEHOLD, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setPlaceHolderLabel:placeholder];
}
- (NSString *)placeholder {
    return objc_getAssociatedObject(self, &PLACEHOLD);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (UILabel *)wordCountLabel {
    return objc_getAssociatedObject(self, &WORDCOUNTLABEL);
}
- (void)setWordCountLabel:(UILabel *)wordCountLabel {
    objc_setAssociatedObject(self, &WORDCOUNTLABEL, wordCountLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (NSNumber *)limitLength {
    return objc_getAssociatedObject(self, &LIMITLENGTH);
}
- (void)setLimitLength:(NSNumber *)limitLength {
    objc_setAssociatedObject(self, &LIMITLENGTH, limitLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
    [self setWordcountLable:limitLength];
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (NSNumber *)limitLines {
    return objc_getAssociatedObject(self, &LIMITLINES);
}
- (void)setLimitLines:(NSNumber *)limitLines {
    objc_setAssociatedObject(self, &LIMITLINES, limitLines, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setLimitPlaceFont:(UIFont *)limitPlaceFont {
    if (self.wordCountLabel) {
        self.wordCountLabel.font = limitPlaceFont;
    }
    objc_setAssociatedObject(self, &LIMITFONT, limitPlaceFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIFont *)limitPlaceFont {
    return objc_getAssociatedObject(self, &LIMITFONT) == nil ? [UIFont systemFontOfSize:13.] : objc_getAssociatedObject(self, &LIMITFONT);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setPlaceholdFont:(UIFont *)placeholdFont {
    if (self.placeholderLabel) {
        self.placeholderLabel.font = placeholdFont;
    }
    objc_setAssociatedObject(self, &PLACEHOLDFONT, placeholdFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIFont *)placeholdFont {
    return objc_getAssociatedObject(self, &PLACEHOLDFONT) == nil ? [UIFont systemFontOfSize:13.] : objc_getAssociatedObject(self, &PLACEHOLDFONT);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setPlaceholdColor:(UIColor *)placeholdColor {
    if (self.placeholderLabel) {
        self.placeholderLabel.textColor = placeholdColor;
    }
    objc_setAssociatedObject(self, &PLACEHOLDCOLOR, placeholdColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)placeholdColor {
    return objc_getAssociatedObject(self, &PLACEHOLDCOLOR) == nil ? [UIColor lightGrayColor] : objc_getAssociatedObject(self, &PLACEHOLDCOLOR);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setLimitPlaceColor:(UIColor *)limitPlaceColor {
    if (self.wordCountLabel) {
        self.wordCountLabel.textColor = limitPlaceColor;
    }
    objc_setAssociatedObject(self, &LIMITCOLOR, limitPlaceColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)limitPlaceColor {
    return objc_getAssociatedObject(self, &LIMITCOLOR) == nil ? [UIColor lightGrayColor] : objc_getAssociatedObject(self, &LIMITCOLOR);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setAutoHeight:(NSNumber *)autoHeight {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
    objc_setAssociatedObject(self, &AUTOHEIGHT, autoHeight, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSNumber *)autoHeight {
    return objc_getAssociatedObject(self, &AUTOHEIGHT);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setOldFrame:(NSValue *)oldFrame {
    objc_setAssociatedObject(self, &OLDFRAME, oldFrame, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSValue *)oldFrame {
    return objc_getAssociatedObject(self, &OLDFRAME);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)setInfoBlock:(textViewInfo)infoBlock {
    objc_setAssociatedObject(self, &INFOBLOCK, infoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (textViewInfo)infoBlock {
    return objc_getAssociatedObject(self, &INFOBLOCK);
}
#pragma mark -- 配置占位符标签

- (void)setPlaceHolderLabel:(NSString *)placeholder {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
    if (self.placeholderLabel) {
        [self.placeholderLabel removeFromSuperview];
    }
    /*
     *  占位字符
     */
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = self.placeholdFont;
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.placeholderLabel.textColor = self.placeholdColor;
    CGRect rect = [placeholder boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.placeholdFont} context:nil];
    self.placeholderLabel.frame = CGRectMake(7, 7, rect.size.width, rect.size.height);
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.hidden = self.text.length > 0 ? YES : NO;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.text.length,self.limitLength];
    
}

#pragma mark -- 配置字数限制标签

- (void)setWordcountLable:(NSNumber *)limitLength {
    if (self.wordCountLabel) {
        [self.wordCountLabel removeFromSuperview];
    }
    /*
     *  字数限制
     */
    self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame) - 7, 20)];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    self.wordCountLabel.textColor = self.limitPlaceColor;
    self.wordCountLabel.font = self.limitPlaceFont;
    self.wordCountLabel.backgroundColor = self.backgroundColor;
    if (self.text.length > [limitLength integerValue]) {
        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.text.length,limitLength];
    [self addSubview:self.wordCountLabel];
   
    self.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
}

#pragma mark -- NSNotification

- (void)textViewChanged:(NSNotification *)notification {
    NSInteger wordCount = self.text.length;
    if (self.placeholder) {
        self.placeholderLabel.hidden = YES;
        if (wordCount == 0) {
            self.placeholderLabel.hidden = NO;
        }
    }
    if (self.limitLength) {//字数限制
        if (wordCount > [self.limitLength integerValue]) {
            wordCount = [self.limitLength integerValue];
        }
        NSString *keyboardType = self.textInputMode.primaryLanguage;
        if ([keyboardType isEqualToString:@"zh-Hans"]) {//对简体中文做特殊处理>>>>高亮拼写问题
            UITextRange *range = [self markedTextRange];
            if (!range) {
                if (self.text.length > [self.limitLength intValue]) {
                    self.text = [self.text substringToIndex:[self.limitLength intValue]];
                    NSLog(@"已经是最大字数");
                }else {/*有高亮不做限制*/}
            }
        }else {
            if ([self.text length] > [self.limitLength intValue]) {
                self.text = [self.text substringToIndex:[self.limitLength intValue]];
                NSLog(@"已经是最大字数");
            }
        }
        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%@",(long)wordCount,self.limitLength];
    }else {
        if (self.limitLines) {//行数限制
            float limitHeight = self.font.lineHeight * [self.limitLines intValue];
            if ([self getTextContentSize].height > limitHeight) {
                while ([self getTextContentSize].height > limitHeight) {
                    self.text = [self.text substringToIndex:self.text.length - 1];
                }
                NSLog(@"已经是最大行数/n行数限制，没有做右下角label提示,若有此需求,联系我");
            }
            /*行数的限制，没有做右下角提示*/
        }
        
    }
    if (self.autoHeight) {
        CGSize size = [self getTextContentSize];
        CGRect oldRect = self.oldFrame.CGRectValue;
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, oldRect.size.height > size.height + 30 ? oldRect.size.height : size.height + 30);
        }];
        self.scrollEnabled = NO;
    }else {
        self.scrollEnabled = YES;
    }
    if (self.infoBlock) {
        self.infoBlock(self.text, self.frame.size);
    }
}
- (CGSize)getTextContentSize {
    return [self getStringPlaceSize:self.text textFont:self.font bundingSize:CGSizeMake(self.contentSize.width-10, CGFLOAT_MAX)];
}
- (CGSize)getStringPlaceSize:(NSString *)string textFont:(UIFont *)font bundingSize:(CGSize)boundSize {
    //计算文本高度
    NSDictionary *attribute = @{NSFontAttributeName:font};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [string boundingRectWithSize:boundSize options:option attributes:attribute context:nil].size;
    return size;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

@end
