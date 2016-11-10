//
//  RemoveHighlightedButton.m
//  CloudLive
//
//  Created by moruiwei on 16/9/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "RemoveHighlightedButton.h"

@implementation RemoveHighlightedButton
//** init方法内部会自动调用initWithFrame:方法 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTintColor:[UIColor clearColor]];

        self.userInteractionEnabled = NO;

        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.backgroundColor = [UIColor clearColor];
    
        self.layer.cornerRadius = 6;
    }
    return self;
}
@end
