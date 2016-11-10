//
//  TalkfunSettingBeautyCell.m
//  CloudLive
//
//  Created by 孙兆能 on 2016/10/17.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunSettingBeautyCell.h"
#import "AppDelegate.h"

@implementation TalkfunSettingBeautyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSNumber * number = [UserDefaults objectForKey:@"beauty"];
    if (!number) {
        self.beautySwitch.on = YES;
    }
    else
    {
        self.beautySwitch.on = [number boolValue] ? YES : NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)beautyBtnClicked:(UISwitch *)sender {
    
    [UserDefaults setObject:@(sender.on) forKey:@"beauty"];
    [UserDefaults synchronize];
}

@end
