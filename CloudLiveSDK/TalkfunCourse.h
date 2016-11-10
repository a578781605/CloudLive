//
//  TalkfunCourse.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TalkfunCourseStatus) {
    
    TalkfunCourseStatusNotInTime = 1,
    TalkfunCourseStatusInTime = 2,
    TalkfunCourseStatusEnd = 3
};

@interface TalkfunCourse : NSObject

//获取课程列表
- (void)getCourseList:(void (^)(id result))callback;

//添加课程
- (void)addCourse:(NSString *)courseName startTime:(NSString *)startTime endTime:(NSString *)endTime callback:(void (^)(id result))callback;

//验证账号是否在直播
- (void)verifyLivingOrNot:(void (^)(id result))callback;

@end
