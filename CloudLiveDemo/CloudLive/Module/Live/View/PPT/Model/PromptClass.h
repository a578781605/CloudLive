//
//  PromptClass.h
//  CloudLive
//
//  Created by moruiwei on 16/11/1.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromptClass : NSObject

+ (id)shared;
//是否还有次数
- (BOOL)residualFrequency:(NSString*)name;
//设置保存的次数
- (void)readFile:(NSString *)name  PromptNumber:(int)count;
@end
