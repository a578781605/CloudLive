//
//  AppDelegate.m
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/16.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "AppDelegate.h"
#import "TalkfunLiveViewController.h"
#import "NetworkStatusObserver.h"
#import <Bugly/Bugly.h>
#import "UMMobClick/MobClick.h"
//#import "WXApi.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "AFNetworking.h"
#define iOS8  ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

@interface AppDelegate ()
@property(nonatomic,strong)NSString*releaseNotes;

@property(nonatomic,strong)NSString*trackViewUrl;
@end

@implementation AppDelegate

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //接收类型不一致请替换一致text/html或别的
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                              @"image/jpeg",
                                                              @"image/png",
                                                              @"application/octet-stream",@"text/html",
                                                              nil];
    }
    return _manager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugly startWithAppId:@"900055479"];
    UMConfigInstance.appKey = @"58195746e88bad62960011d1";
    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
    
    [[NetworkStatusObserver defaultObserver] startNotifier];

    
    #pragma mark - 版本更新检测
       [self checkForUpdate];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}
#pragma mark - 版本更新检测
- (void)checkForUpdate {
    // 本地版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //商店版本
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleId=%@",@"com.talk-fun.SDKDemo"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        if ([responseDict[@"resultCount"] integerValue] == 0) {
            return;
        }
        // 商店版本
        NSString *storeVersion = [(NSArray *)responseDict[@"results"] firstObject][@"version"];
        // 更新内容
        self.releaseNotes = [(NSArray *)responseDict[@"results"] firstObject][@"releaseNotes"];
        // 商店链接
        self.trackViewUrl = [(NSArray *)responseDict[@"results"] firstObject][@"trackViewUrl"];
        
//        NSLog(@"\n\nappVersion = %@\nstoreVersion = %@\ntrackViewUrl = %@ @\trackViewUrl = %@ ",appVersion, storeVersion, self.trackViewUrl,self.releaseNotes);
        
        [self compareString:appVersion string:storeVersion];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
}

- (void)compareString:(NSString *)appVersion string:(NSString *)storeVersion {
    NSArray *currentVersionStr = [self makeArray:[appVersion componentsSeparatedByString:@"."]];
    NSArray *newVersionStr = [self makeArray:[storeVersion componentsSeparatedByString:@"."]];
    if ([newVersionStr[0] integerValue] > [currentVersionStr[0] integerValue]) {
        [self alertUpdateVC:storeVersion];
    }else if ([newVersionStr[0] integerValue] == [currentVersionStr[0] integerValue]) {
        if ([newVersionStr[1] integerValue] > [currentVersionStr[1] integerValue]) {
            [self alertUpdateVC:storeVersion];
        }else if ([newVersionStr[1] integerValue] == [currentVersionStr[1] integerValue]) {
            if ([newVersionStr[2] integerValue] > [currentVersionStr[2] integerValue]) {
                [self alertUpdateVC:storeVersion];
            }
        }
    }
}
- (void)alertUpdateVC:(NSString *)storeVersion {
    NSString *title = [NSString stringWithFormat:@"检测到新版本:%@",storeVersion];
    
    if (iOS8) {
  
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:self.releaseNotes preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:updateAction];
        
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:self.releaseNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alertView show];
        
        
    }
}
- (NSArray *)makeArray:(NSArray *)array {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    // 两位数字的版本号前面加0
    for (NSInteger i = 0; i < 3 - array.count; i ++) {
        [arr addObject:@"0"];
    }
    
    return arr;
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
    }
}
@end
