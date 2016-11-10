//
//  MInPPTViewCell.h
//  CloudLive
//
//  Created by moruiwei on 16/8/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class PPTModel;
@interface TalkfunWhiteboardSliderCell : UICollectionViewCell

/** 模型数据 */
@property (nonatomic, strong) NSMutableDictionary *current;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *page;


/** URL地址 */
@property (nonatomic,strong)NSString *URL;


@end
