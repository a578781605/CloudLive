//
//  TalkfungetCurrentDateString.h
//  CloudLive
//
//  Created by moruiwei on 16/9/12.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfungetCurrentDateString : NSObject
+ (instancetype)sharedinstance;
- (NSString *)getCurrentDateString;
@end
