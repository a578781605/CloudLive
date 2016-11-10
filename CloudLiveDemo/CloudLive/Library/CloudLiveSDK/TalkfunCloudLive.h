//
//  TalkfunCloudLiveLogin.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/18.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunCloudLive : NSObject

//获取user information(已经登录才有）
- (NSDictionary *)getUser;

//获取ID（登录过才有）
- (NSString *)getID;

//是否是登录状态
- (BOOL)isLogin;

//根据用户名和密码登录，callback返回登录信息
//(返回的@"code"为0即登录成功。若不为0，返回的@"msg"会包含错误的信息)
- (void)login:(NSString *)username password:(NSString *)password callback:(void (^)(id result))callback;

//根据token自动登录
- (void)autoLogin:(NSString *)token callback:(void (^)(id result))callback;

//退出登录
- (void)logout;

@end
