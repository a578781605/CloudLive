//
//  TalkfunButton.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunButton.h"

@implementation TalkfunButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor target:(id)target selector:(SEL)selector
{
    if (self = [super init]) {
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:BlueColor forState:UIControlStateNormal];
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
        if ([target respondsToSelector:selector]) {
            [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor hightlightTitleColor:(UIColor *)hightlightTitleColor font:(UIFont *)font image:(UIImage *)image target:(id)target selector:(SEL)selector
{
    if (self = [super init]) {
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = font;
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setTitleColor:hightlightTitleColor forState:UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateNormal];
        if ([target respondsToSelector:selector]) {
            [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

@end
