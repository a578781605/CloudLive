//
//  TalkfunUploadListCell.m
//  CloudLive
//
//  Created by moruiwei on 16/11/3.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunUploadListCell.h"
#import "TalkfunScheduleButton.h"
#import "UIView+XMGExtension.h"
@interface TalkfunUploadListCell ()

@property (weak, nonatomic) IBOutlet TalkfunScheduleButton *UploadButton;
@property (strong, nonatomic) UIView *vc ;
@end
@implementation TalkfunUploadListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.vc = [[UIView alloc]init];
    self.vc.backgroundColor = UIColorFromRGBHex(0xd5d5d5);
    [self addSubview:self.vc];
    [self.UploadButton.layer setCornerRadius:19.0];
 
    
    
    
   self.historyVideoName = [[UILabel alloc]init];
   [self addSubview:self.historyVideoName ];

    self.historyVideoName.font = [UIFont boldSystemFontOfSize:15];
    
    self.VideoSizeLabel = [[UILabel alloc]init];
    [self addSubview:self.VideoSizeLabel ];
    self.VideoSizeLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    
    self.historyVideoName.textColor =  UIColorFromRGBHex(0x666666);
    self.VideoSizeLabel.textColor =  UIColorFromRGBHex(0xaaaaaa);
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat historyVideoNameX = self.UploadButton.frame.origin.x +self.UploadButton.frame.size.width +16;
    CGFloat  historyVideoNameY =  (self.frame.size.height -31) /2;
    CGFloat  historyVideoNameWidth = (self.frame.size.width * 4/5) -38 -32;
    CGFloat  historyVideoNameHeight = 31;
    
    self.historyVideoName.frame = CGRectMake(historyVideoNameX, historyVideoNameY,historyVideoNameWidth ,historyVideoNameHeight );
    
    
    
    CGFloat VideoSizeLabelX = self.historyVideoName.frame.origin.x +self.historyVideoName.frame.size.width +16;
    CGFloat VideoSizeLabelY = historyVideoNameY;
    CGFloat VideoSizeLabelWidth = self.frame.size.width *1/5;
    CGFloat VideoSizeLabelHeight = 31;
    self.VideoSizeLabel.frame = CGRectMake(VideoSizeLabelX,VideoSizeLabelY,VideoSizeLabelWidth , VideoSizeLabelHeight);
    
    

 
    self.vc.frame = CGRectMake(0,  self.frame.size.height-0.6, self.frame.size.width,0.6);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)uploadButtonClick:(UIButton *)sender {
    
    //上传 发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadButtonClick" object:self];
}


- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    
//    [information setObject:self.model.course_id forKey:@"course_id"];
//    [information setObject:self.model.course_name  forKey:@"course_name"];
    
    
  //直播名称
  self.historyVideoName.text =  dict [@"course_name"];
  
//视频 大小
self.VideoSizeLabel.text = @"1024M";

  
    CGFloat scheduleFloat = [dict [@"schedule"] intValue];
    
    [self.UploadButton drawProgress:scheduleFloat/100];
    
    //暂停显示图片
    if ([dict [@"pause"] isEqualToString:@"1"]) {
        [self.UploadButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        
    }else{//不是暂停就是显示百分比
        NSString *schedule =    dict [@"schedule"];
        int  temp = [schedule intValue];
        schedule = [[NSString stringWithFormat:@"%i",temp] stringByAppendingString:@"%"];
        
        [self.UploadButton setTitle:schedule forState:UIControlStateNormal];
    }
    
}
@end
