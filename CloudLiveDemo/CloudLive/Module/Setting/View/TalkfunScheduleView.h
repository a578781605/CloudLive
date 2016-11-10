//
//  TalkfunScheduleView.h
//  CloudLive
//
//  Created by moruiwei on 16/11/4.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunScheduleView : UIView

@property (nonatomic, strong) UILabel *label;

- (void)drawProgress:(CGFloat )progress;
@end
