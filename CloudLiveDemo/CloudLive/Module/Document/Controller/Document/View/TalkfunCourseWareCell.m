//
//  TalkfunCourseWareCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/29.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunCourseWareCell.h"
#import "TalkfunCourseWareModel.h"

@interface TalkfunCourseWareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *selectStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation TalkfunCourseWareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellWithModel:(TalkfunCourseWareModel *)model
{
    self.thumbnail.layer.borderColor = UIColorFromRGBHex(0xeeeeee).CGColor;
    
    [self.thumbnail sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"默认图片"] options:SDWebImageRetryFailed];
    
    self.name.text = model.name;
}

- (void)select:(BOOL)select
{
    if (!select) {
        
        self.selectStatusImageView.alpha = 0.3;
        self.selectStatusImageView.image = [UIImage imageNamed:@"未选择"];
    }
    else
    {
        self.selectStatusImageView.alpha = 1;
        self.selectStatusImageView.image = [UIImage imageNamed:@"课件选择"];
        self.selectStatusImageView.transform = CGAffineTransformMakeScale(.0, .0);
        [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.selectStatusImageView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

@end
