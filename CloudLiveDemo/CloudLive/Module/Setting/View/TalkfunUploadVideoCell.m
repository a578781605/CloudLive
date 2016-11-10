//
//  TalkfunUploadVideoCell.m
//  CloudLive
//
//  Created by moruiwei on 16/10/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunUploadVideoCell.h"

@interface TalkfunUploadVideoCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn;
@end
@implementation TalkfunUploadVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn.userInteractionEnabled  = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)showTalkfunUploadVideoController:(id)sender {
    
    
    
  [[NSNotificationCenter defaultCenter] postNotificationName:@"presentTalkfunUploadVideoController" object:nil userInfo:nil];
}

@end
