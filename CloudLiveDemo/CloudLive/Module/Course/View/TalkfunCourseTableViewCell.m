//
//  TalkfunCourseTableViewCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunCourseTableViewCell.h"
#import "TalkfunCourseModel.h"

@interface TalkfunCourseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation TalkfunCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.getInLiveBtn.layer.borderColor = BlueColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(TalkfunCourseModel *)model
{
    self.courseName.text = model.course_name;
    
    if ([[model.start_time componentsSeparatedByString:@" "].firstObject isEqualToString:[model.end_time componentsSeparatedByString:@" "].firstObject]) {
        model.end_time = [model.end_time componentsSeparatedByString:@" "].lastObject;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",model.start_time,model.end_time];
    
    self.endLabel.hidden = YES;
    if ([model.status isEqualToString:@"1"]) {
        self.getInLiveBtn.userInteractionEnabled = NO;
        self.getInLiveBtn.hidden = NO;
        self.getInLiveBtn.layer.borderColor = UIColorFromRGBHex(0xd5d5d5).CGColor;
        [self.getInLiveBtn setTitleColor:UIColorFromRGBHex(0xcccccc) forState:UIControlStateNormal];
    }
    else if ([model.status isEqualToString:@"2"])
    {
        self.getInLiveBtn.userInteractionEnabled = YES;
        self.getInLiveBtn.hidden = NO;
        self.getInLiveBtn.layer.borderColor = BlueColor.CGColor;
        [self.getInLiveBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    }
    else{
        self.getInLiveBtn.hidden = YES;
        self.endLabel.hidden = NO;
    }
}

- (IBAction)getInLiveBtnClicked:(UIButton *)sender {
    
//    NSLog(@"getintoLive");
}

@end
