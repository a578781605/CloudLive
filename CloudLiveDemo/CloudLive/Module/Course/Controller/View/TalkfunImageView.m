//
//  TalkfunImageView.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunImageView.h"

@implementation TalkfunImageView

- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imageName
{
    if (self = [super init]) {
        self.frame = frame;
        self.image = [UIImage imageNamed:imageName];
    }
    return self;
}

@end
