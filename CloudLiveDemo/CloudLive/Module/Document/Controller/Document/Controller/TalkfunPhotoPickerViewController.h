//
//  PhotoPickerViewController.h
//  CloudLive
//
//  Created by 孙兆能 on 16/9/11.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunPhotoPickerViewController : UIViewController

@property (nonatomic,copy) void (^loadCallback)(BOOL loading);
@property (nonatomic,strong) TalkfunCourseModel * model;

- (void)showAlert;

@end
