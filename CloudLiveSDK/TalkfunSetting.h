//
//  TalkfunSetting.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/19.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunSetting : NSObject

//清除缓存
- (void)clearCache;

//获取缓存大小
- (NSInteger)getCacheSize;

@end
