//
//  TalkfunPhotoCell.h
//  CloudLive
//
//  Created by 孙兆能 on 16/9/11.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;

- (void)configCell:(UIImage *)image;

- (void)selectedCell:(BOOL)selected num:(NSInteger)num;

@end
