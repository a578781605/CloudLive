//
//  CloudLiveSDK.h
//  CloudLiveSDK
//
//  Created by 孙兆能 on 2016/10/9.
//  Copyright © 2016年 孙兆能. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkfunLive.h"
#import "TalkfunUtils.h"
#import "TalkfunCourse.h"
#import "TalkfunSetting.h"
#import "TalkfunDocument.h"
#import "TalkfunCloudLive.h"
#import "TalkfunWhiteboard.h"

@interface CloudLiveSDK : NSObject

typedef NS_ENUM (NSInteger,TalkfunCode){
    TalkfunCodeSuccess = 0,
    TalkfunCodeInTheLive  = 204
};

extern NSString * const TalkfunCloudLiveSDKVersion;     //SDK版本

/**
 用户角色
 **/
extern NSString * const TalkfunMemberRoleSpadmin;       //超级管理员(老师)
extern NSString * const TalkfunMemberRoleAdmin;         //管理员(助教)
extern NSString * const TalkfunMemberRoleUser;          //普通用户(学生)
extern NSString * const TalkfunMemberRoleGuest;         //游客


//MARK:事件
/**
 *  系统事件
 */
extern NSString * const TALKFUN_EVENT_CONNECT;              //连接
extern NSString * const TALKFUN_EVENT_RECONNECT;            //重新连接
extern NSString * const TALKFUN_EVENT_RECONNECT_ATTEMPT;    //尝试重新连接
extern NSString * const TALKFUN_EVENT_DISCONNECT;           //断开
extern NSString * const TALKFUN_EVENT_ERROR;                //错误


/**
 *  用户事件
 */
extern NSString * const TALKFUN_EVENT_MEMBER_JOIN_ME;       //自己进入房间
extern NSString * const TALKFUN_EVENT_MEMBER_JOIN_OTHER;    //其他人进入房间
extern NSString * const TALKFUN_EVENT_CHAT_SENT;            //聊天信息
extern NSString * const TALKFUN_EVENT_QUESTION_ASK;         //提问信息
extern NSString * const TALKFUN_EVENT_QUESTION_REPLY;       //回复信息
extern NSString * const TALKFUN_EVENT_FLOWER_SEND;          //送花信息

/**
 *  广播事件
 */
extern NSString * const TALKFUN_NOTIFICATION_TOTAL_ONLINE;      //在线人数
extern NSString * const TALKFUN_NOTIFICATION_CHAT_SEND;         //聊天信息
extern NSString * const TALKFUN_NOTIFICATION_QUESTION_ASK;      //提问信息
extern NSString * const TALKFUN_NOTIFICATION_QUESTION_REPLY;    //回复信息
extern NSString * const TALKFUN_NOTIFICATION_FLOWER_SEND;       //送花信息

extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_START;       //文件下载开始
extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_PROGRESS;    //文件下载进度
extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_DONE;        //文件下载完毕
extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_FAIL;        //文件下载失败

extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_START;         //文件上传开始
extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_PROGRESS;      //文件上传进度
extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_DONE;          //文件上传成功
extern NSString * const TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_FAIL;          //文件上传失败

extern NSString * const TALKFUN_NOTIFICATION_WHITEBOARD_RELOAD;             //白板重新加载
extern NSString * const TALKFUN_NOTIFICATION_WHITEBOARD_COMMAND_SEND;       //白板命令发送


@end
