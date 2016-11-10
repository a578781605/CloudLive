//
//  uploadVideoTipView.m
//  CloudLive
//
//  Created by moruiwei on 16/10/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "uploadVideoTipView.h"

@interface uploadVideoTipView ()

@end

@implementation uploadVideoTipView

+ (instancetype)customViwe
{
    uploadVideoTipView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    headerView.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1];
  headerView.layer.cornerRadius = 8;
    headerView.UploadVideoNowLabel.layer.cornerRadius = 4;
     headerView.LaterUploadVdeoLabel.layer.cornerRadius = 4;
    
    
    headerView.UploadVideoNowLabel.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    headerView.LaterUploadVdeoLabel.backgroundColor=  [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    return headerView;
}
- (IBAction)UploadVideoNow:(UIButton *)sender {
    
    [self removeFromSuperview];
}

- (IBAction)LaterUploadVdeo:(UIButton *)sender {
     [self removeFromSuperview];
}



@end
