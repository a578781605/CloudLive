//
//  TalkfunCourseWareModel.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/29.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunCourseWareModel : NSObject
//data:@[@{@"id":string,@"name":string,@"thumbnail":string},...]
@property (nonatomic,copy) NSString * ID;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * thumbnail;

@end
