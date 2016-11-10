//
//  AppDelegate.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/16.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

