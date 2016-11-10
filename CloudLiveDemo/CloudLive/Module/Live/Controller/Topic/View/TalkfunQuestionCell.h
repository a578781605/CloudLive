//
//  TalkfunQuestionCell.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunQuestionModel;
@interface TalkfunQuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerHeightConstraint;

- (void)configCellWithModel:(TalkfunQuestionModel *)model;

@end
