//
//  TalkfunCourseResourse.h
//  CloudLive
//
//  Created by moruiwei on 16/11/4.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunCourseResourse : NSObject


//保存
+ (void)addList:(NSDictionary *)dict;

//读取
+ (NSMutableArray *)readList;

//删除指定 名字
+(void)removeList:(NSDictionary*)name;


@end
