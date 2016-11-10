//
//  TalkfunUploadPrompt.m
//  CloudLive
//
//  Created by moruiwei on 16/11/8.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunUploadPrompt.h"
#import "NetworkStatusObserver.h"
@implementation TalkfunUploadPrompt

+(void)show
{
    //查看当前网络状态
    NSString * networkStr = [[NetworkStatusObserver defaultObserver] currentNetworkStatusDescription];
    
    if([networkStr isEqualToString:@"network.status.2g"]||[networkStr isEqualToString:@"network.status.3g"]||[networkStr isEqualToString:@"network.status.4g"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TalkfunUploadPrompt addUploadVideoTip:@"当前是流量模式,是否上传回放"];
        });
        
    }else if([networkStr isEqualToString:@"network.status.wifi"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TalkfunUploadPrompt addUploadVideoTip:@"是否上传本节课程回放"];
        });
        
    }else {
        
        NSLog(@"没有网络");
    }
}

+(void)addUploadVideoTip:(NSString*)describe
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:describe delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    [alertView show];
    
}
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    
}
@end
