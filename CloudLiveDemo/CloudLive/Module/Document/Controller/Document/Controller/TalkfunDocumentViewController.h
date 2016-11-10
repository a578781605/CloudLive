//
//  coursewareViewController.h
//  CloudLive
//
//  Created by moruiwei on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunDocumentViewController : UIViewController

@property (nonatomic,strong) TalkfunCourseModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic,copy) void (^loadCallback)(BOOL loading);

@end
