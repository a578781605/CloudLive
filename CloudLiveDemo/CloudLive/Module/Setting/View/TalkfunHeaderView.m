//
//  HeaderView.m
//  CloudLive
//
//  Created by moruiwei on 16/10/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunHeaderView.h"

#import "UIView+XMGExtension.h"


@interface TalkfunHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *PromptLabel;
@property (strong, nonatomic) UIView *vc ;
@property (weak, nonatomic) IBOutlet UIView *splitLine1;

@property (weak, nonatomic) IBOutlet UIView *splitLine2;
@property (weak, nonatomic) IBOutlet UIView *synopsis;

@property (weak, nonatomic) IBOutlet UILabel *synopsistext;

@property (weak, nonatomic) IBOutlet UIView *synopsisView;

@property(strong,nonatomic)UILabel *LiveName;

@property(strong,nonatomic)UILabel *VideoSize;
@property (weak, nonatomic) IBOutlet UISwitch *historyVideoSwitch;

@end
@implementation TalkfunHeaderView
/** 如果这个控件不是通过xib、storyboard创建，初始化时肯定会调用这个方法 */



+ (instancetype)customViwe
{
    TalkfunHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];

    headerView.height = 60+40+44+0.6+2;
    headerView.PromptLabel.font = [UIFont systemFontOfSize:16];
    [headerView.PromptLabel setTextColor:UIColorFromRGBHex(0x333333)];
    return headerView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.vc = [[UIView alloc]init];
    self.vc.backgroundColor = UIColorFromRGBHex(0xd5d5d5);
    self.splitLine1.backgroundColor = UIColorFromRGBHex(0xd5d5d5);
    self.splitLine2.backgroundColor = UIColorFromRGBHex(0xd5d5d5);
    
    self.synopsis.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
    [self.synopsistext setTextColor:UIColorFromRGBHex(0xaaaaaa)];
    [self addSubview:self.vc];
    
    
    self.LiveName = [[UILabel alloc]init];
    self.LiveName.text = @"直播名称";
    self.LiveName.font = [UIFont boldSystemFontOfSize:15];
    [self.synopsisView  addSubview:self.LiveName];
    [self.LiveName setTextColor:UIColorFromRGBHex(0x333333)];
    self.VideoSize = [[UILabel alloc]init];
    self.VideoSize.text = @"大小";
     self.VideoSize.font = [UIFont boldSystemFontOfSize:15];
    [self.synopsisView  addSubview:self.VideoSize];
     [self.VideoSize setTextColor:UIColorFromRGBHex(0x333333)];
    
    
    
    NSNumber * number = [UserDefaults objectForKey:@"historyVideo"];
    if (!number) {
        self.historyVideoSwitch.on = YES;
    }
    else
    {
        self.historyVideoSwitch.on = [number boolValue] ? YES : NO;
    }
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.vc.frame = CGRectMake(0,  self.frame.size.height-0.6, self.frame.size.width,0.6);
    
    CGFloat LiveNameX = 16+38+16 ;
    CGFloat LiveNameY = (self.synopsisView.frame.size.height -31) /2;
    CGFloat LiveNameWidth =   (self.synopsisView.frame.size.width * 4/5) -38 -32;
    CGFloat LiveNamHeighe = 31;
    
    self.LiveName.frame = CGRectMake(LiveNameX, LiveNameY, LiveNameWidth, LiveNamHeighe);
    
    
    
    
    CGFloat VideoSizeX =  LiveNameX + LiveNameWidth +16;
    CGFloat VideoSizeY = LiveNameY;
    CGFloat VideoSizeWidth = self.synopsisView.frame.size.width *1/5;
    CGFloat VideoSizeHeighe = 31;
    self.VideoSize.frame = CGRectMake(VideoSizeX, VideoSizeY, VideoSizeWidth, VideoSizeHeighe);
    
}

- (IBAction)historyVideo:(UISwitch *)sender {
    
    [UserDefaults setObject:@(sender.on) forKey:@"historyVideo"];
    [UserDefaults synchronize];
}


@end
