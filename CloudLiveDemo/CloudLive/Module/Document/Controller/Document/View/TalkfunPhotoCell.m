//
//  TalkfunPhotoCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/9/11.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunPhotoCell.h"

@interface TalkfunPhotoCell ()

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation TalkfunPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCell:(UIImage *)image
{
//    [self.photoButton setBackgroundImage:image forState:UIControlStateNormal];
    self.photoImageView.image = image;
}

- (void)selectedCell:(BOOL)selected num:(NSInteger)num
{
    self.chooseImage.image = selected ? [UIImage imageNamed:@"choice"] : [UIImage imageNamed:@"未选择"];
    if (selected) {
        self.numLabel.text = [NSString stringWithFormat:@"%ld",num + 1];
        self.chooseImage.transform = CGAffineTransformMakeScale(.5, .5);
        [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.chooseImage.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    else
    {
        self.numLabel.text = nil;
    }
}

- (IBAction)photoBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.chooseImage.image = sender.selected ? [UIImage imageNamed:@"choice"] : [UIImage imageNamed:@"未选择"];
}

@end
