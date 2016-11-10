//
//  TalkfunCourseWareCell.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/29.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunCourseWareModel;
@interface TalkfunCourseWareCell : UICollectionViewCell

- (void)configCellWithModel:(TalkfunCourseWareModel *)model;
- (void)select:(BOOL)select;

@end
