//
//  uploadVideoTipView.h
//  CloudLive
//
//  Created by moruiwei on 16/10/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uploadVideoTipView : UIView

//描述文本
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
//现在上传视频
@property (weak, nonatomic) IBOutlet UIButton *UploadVideoNowLabel;


//稍后上传视频
@property (weak, nonatomic) IBOutlet UIButton *LaterUploadVdeoLabel;

/**类方法创建这个 View*/
+ (instancetype)customViwe;



@end
