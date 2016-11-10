//
//  LiveViewController.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/17.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunCourseModel;
@interface TalkfunLiveViewController : UIViewController

//课程信息
@property (nonatomic,strong) TalkfunCourseModel * model;

//直播标题
@property (nonatomic,strong) NSString *Thetitle

;
@end
