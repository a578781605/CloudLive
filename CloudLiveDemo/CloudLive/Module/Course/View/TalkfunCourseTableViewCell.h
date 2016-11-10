//
//  TalkfunCourseTableViewCell.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunCourseModel;
@interface TalkfunCourseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *seperateView;
@property (weak, nonatomic) IBOutlet UIButton *getInLiveBtn;

- (void)configCellWithModel:(TalkfunCourseModel *)model;

@end
