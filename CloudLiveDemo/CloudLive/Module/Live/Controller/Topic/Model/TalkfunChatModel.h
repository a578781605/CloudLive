//
//  ModelChat.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunChatModel : NSObject

//头像
@property (nonatomic ,copy   ) NSString     *avatar;
@property (nonatomic ,strong ) NSDictionary *chat;

@property (nonatomic ,strong ) NSNumber     *gender;
@property (nonatomic ,copy   ) NSString     *msg;
@property (nonatomic ,copy   ) NSString     *nickname;
@property (nonatomic ,copy   ) NSString     *role;
@property (nonatomic ,strong ) NSNumber     *time;
@property (nonatomic ,copy   ) NSString     *sendtime;
@property (nonatomic ,copy   ) NSString     *uid;
@property (nonatomic ,copy   ) NSString     *vid;
@property (nonatomic ,copy   ) NSString     *isShow;
@property (nonatomic ,strong ) NSNumber     *amount;

@property (nonatomic ,copy   ) NSString     *starttime;

@property (nonatomic ,copy   ) NSString     *startTime;
@end
