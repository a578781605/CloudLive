//
//  TalkfunLabel.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/23.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunLabel.h"

@implementation TalkfunLabel

- (id)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment
{
    if (self = [super init]) {
        self.frame = frame;
        self.text = text;
        self.font = font;
        self.textColor = textColor;
        self.textAlignment = textAlignment;
    }
    return self;
}

@end
