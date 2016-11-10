//
//  TalkfungetCurrentDateString.m
//  CloudLive
//
//  Created by moruiwei on 16/9/12.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfungetCurrentDateString.h"

@implementation TalkfungetCurrentDateString
+ (instancetype)sharedinstance {
    static TalkfungetCurrentDateString *s_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[self alloc] init];
        
    });
    return s_instance;
}
- (NSString *)getCurrentDateString
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval delta = [zone secondsFromGMTForDate:[NSDate date]];
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] + delta];
    NSString *dateString = [[string componentsSeparatedByString:@"."]objectAtIndex:0];
    return dateString;
}

@end
