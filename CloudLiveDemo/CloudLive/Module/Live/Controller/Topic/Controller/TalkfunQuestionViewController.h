//
//  TalkfunQuestionViewController.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunQuestionModel;
@interface TalkfunQuestionViewController : UIViewController

@property (nonatomic,copy) void (^replyBtnBlock)(TalkfunQuestionModel *model);

@end
