//
//  WhiteboardView.h
//  CloudLive
//
//  Created by moruiwei on 16/8/23.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemoveHighlightedButton.h"

@class TalkfunWhiteboard;
@class TalkfunWhiteboardSlider;


@protocol WhiteboardViewDelegate <NSObject>
@optional
- (void)DirectToolHide ;  //点击了画板,告诉外面,外面隐藏视频条

-(void)SelectDocument; //点击了选择文档,根控制器的标题切换
- (void)whiteboardDidTouched;

@end

@interface TalkfunWhiteboardView : UIView

@property (nonatomic,strong) UIView *whiteboardContainer;



@property (nonatomic,strong) TalkfunWhiteboard *whiteboard;


@property (nonatomic,strong) TalkfunWhiteboardSlider* whiteboardSlider;


/**类方法创建这个 View*/
+ (instancetype)customViwe;

/** 代理对象 */
@property (nonatomic, weak) id<WhiteboardViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *NotInClassView;
/**默认背景图*/
@property (weak, nonatomic) IBOutlet UIImageView *DefaultImage;
/**选择文档*/
@property (weak, nonatomic) IBOutlet UIButton *SelectDocument;
@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UILabel *text;

@property (weak, nonatomic) IBOutlet UIButton *right;
//工具中间按键
@property (weak, nonatomic) IBOutlet UIButton *middle;
/**ppt工具*/
@property (weak, nonatomic) IBOutlet UIView *toolbar;

/**点击可选择页面哦*/
@property (nonatomic,strong) RemoveHighlightedButton *PageNumberPrompt;
/** 点击这里上课哦*/
@property (nonatomic,strong)RemoveHighlightedButton * PromptClass;

/**默认是: 正在加载..*/
@property(nonatomic,strong)UILabel * PromptLoading ;

/**隐藏标记*/
@property (nonatomic,assign)BOOL HideMark;//记录,外部的视频工具条是不是隐藏状态




/**删除接收数据的通知*/
-(void)shutdown;


@end


