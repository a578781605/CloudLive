//
//  TalkfunChatViewController.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunChatViewController : UIViewController

@property (nonatomic,copy) void (^chatBtnBlock)();
@property (nonatomic,assign) BOOL containsCamera;

@end
