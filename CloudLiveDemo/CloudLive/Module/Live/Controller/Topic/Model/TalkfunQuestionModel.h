//
//  ModelQuestion.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunReplyModel : NSObject
//{
//    avatar = "http://static-1.talk-fun.com/open/cooperation/default/live-pc/css/img/main/admin.png";
//    content = 0000;
//    nickname = "\U52a9\U6559";
//    qid = 177854;
//    question =     {
//        avatar = "http://static-1.talk-fun.com/open/cooperation/default/live-pc/css/img/main/admin.png";
//        content = 12312;
//        "course_id" = 0;
//        liveid = 1291908;
//        nickname = "\U52a9\U6559";
//        qid = 177852;
//        replies = 0;
//        replyId = 0;
//        role = admin;
//        sn = 1;
//        startTime = 0;
//        status = 0;
//        time = 1473064608;
//        uid = "open_100217";
//        xid = 1230199;
//    };
//    replies = "<null>";
//    replyId = 177852;
//    role = admin;
//    time = 1473064689;
//    uid = "open_100217";
//    xid = 1230199;
//}
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,strong) NSNumber *qid;
@property (nonatomic,copy) NSString *replies;
@property (nonatomic,strong) NSNumber *replyId;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,strong) NSNumber *time;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,strong) NSNumber *xid;


@end

@interface TalkfunQuestionModel : NSObject

@property (nonatomic ,copy ) NSString *avatar;
@property (nonatomic ,copy ) NSString *content;
@property (nonatomic ,strong ) NSNumber *localInsert;
@property (nonatomic ,copy ) NSString *nickname;
@property (nonatomic ,strong ) NSNumber *qid;

@property (nonatomic ,copy ) NSString *replies;
@property (nonatomic ,strong ) NSNumber *replyId;
@property (nonatomic ,copy ) NSString *sn;
@property (nonatomic ,copy ) NSString *role;

@property (nonatomic ,strong ) NSNumber *time;
@property (nonatomic ,copy ) NSString *uid;
@property (nonatomic ,strong ) NSNumber *xid;

@property (nonatomic,strong) NSArray<TalkfunReplyModel *> *answer;

//{
//    avatar = "http://static-1.talk-fun.com/open/cooperation/default/live-pc/css/img/main/admin.png";
//    content = 12312;
//    localInsert = 0;
//    nickname = "\U52a9\U6559";
//    qid = 177852;
//    role = admin;
//    sn = 1;
//    time = 1473064608;
//    uid = "open_100217";
//    xid = 1230199;
//}




@end
