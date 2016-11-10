//
//  TalkfunUploadListCell.h
//  CloudLive
//
//  Created by moruiwei on 16/11/3.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunUploadListCell : UITableViewCell
@property (strong, nonatomic)  UILabel *historyVideoName;

@property (strong, nonatomic)  UILabel *VideoSizeLabel;


@property (nonatomic,strong)NSMutableDictionary *dict;
@end
