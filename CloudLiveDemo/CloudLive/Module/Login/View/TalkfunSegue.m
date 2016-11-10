//
//  TalkfunSegue.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunSegue.h"
#import "TalkfunLoginViewController.h"

@implementation TalkfunSegue


- (void)perform
{
    
    TalkfunLoginViewController *current = (TalkfunLoginViewController *)self.sourceViewController;
    
    BOOL autoLogin = YES;
    if (current.autoLogin == NO) {
        autoLogin = NO;
    }
    
    UIViewController *next = self.destinationViewController;
    
    [current.navigationController pushViewController:next animated:!autoLogin];
    
}

@end
