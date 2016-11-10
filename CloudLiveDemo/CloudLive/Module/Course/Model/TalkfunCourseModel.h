//
//  TalkfunCourseModel.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/25.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunCourseModel : NSObject

@property (nonatomic,copy) NSString *course_id;//课程ID
@property (nonatomic,copy) NSString *course_name;//课程名称
//@property (nonatomic,copy) NSString *create_date;//创建日期(格式：2015-09-01)
@property (nonatomic,copy) NSString *start_time;//开始时间(09-09 15:00)
@property (nonatomic,copy) NSString *end_time;//结束时间(09-09 17:00)
@property (nonatomic,copy) NSString *status;//状态：1为未到直播时间，2为在直播时间段内，3为已过直播时间

@end
