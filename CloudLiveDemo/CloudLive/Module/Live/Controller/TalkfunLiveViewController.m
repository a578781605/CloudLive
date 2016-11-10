//
//  TalkfunLiveViewController.m
//  Interface
//
//  Created by moruiwei on 16/8/22.
//  Copyright © 2016年 moruiwei. All rights reserved.


#import "TalkfunLiveViewController.h"
#import "UIView+XMGExtension.h"
#import "TalkfunChatViewController.h"
#import "TalkfunQuestionViewController.h"
#import "FileViewController.h"
#import "TalkfunWhiteboardView.h"
#import "XMGTitleButton.h"
#import "TalkfunCourse.h"
#import "TalkfunCourseModel.h"
#import "IQKeyboardManager.h"
#import "TalkfunButton.h"
#import "TalkfunLive.h"
#import "TalkfunQuestionModel.h"
#import "NetworkStatusObserver.h"
#import "TalkfunCloudLive.h"
#import "AppDelegate.h"
#import "TalkfunCourseResourse.h"
#import "TalkfunUploadPrompt.h"
#define SendButtonHeight 30
#define SendButtonWidth  50
#define TitleIndicatorViewWidth 70
/** 导航栏的最大Y值(底部) */
CGFloat const XMGNavBarBottom = 64;
/** TabBar的高度 */
CGFloat const XMGTabBarH = 49;
/** 标题栏的高度 */
CGFloat const XMGTitlesViewH = 40;
@interface TalkfunLiveViewController ()<UIScrollViewDelegate,TalkfunLiveDelegate,WhiteboardViewDelegate,UITextFieldDelegate,CAAnimationDelegate>
/**画板*/
@property(nonatomic,strong)TalkfunWhiteboardView *whiteboardView;
/**视频操作工具条*/
@property(nonatomic,strong)UIView *DirectTool;
/**标题栏*/
@property(nonatomic,strong)UIView *titlesView;
/**视频预览*/
@property(nonatomic,strong)UIView *preview;
//临时的预览
@property(nonatomic,strong)UIView  *TemPreview;;
/** 当前被选中的标题按钮 */
@property (nonatomic, weak) XMGTitleButton *selectedTitleButton;
/** 标题指示器 */
@property (nonatomic, weak) UIView *titleIndicatorView;
/** 存放所有子控制器的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 存放所有的标题按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;

/**所有工具Button*/
@property (nonatomic, strong)NSMutableArray *toolButtonArray;
/**开始上课按钮*/
@property (nonatomic,strong) UIButton * startLiveBtn;
/**课程*/
@property (nonatomic,strong) TalkfunCourse * course;
/**记住消失前scrollView的偏移量*/
@property (nonatomic,assign) int offsetNum;
/**退出actionSheet*/
@property (nonatomic,strong) UIAlertController * cancelSheet;
//加textfield
@property (nonatomic,strong) UIView * chatTFContainerView;
@property (nonatomic,strong) UITextField * chatTF;
@property (nonatomic,strong) UIButton * sendBtn;
@property (nonatomic,strong) UIView * replyTFContainerView;
@property (nonatomic,strong) UITextField * replyTF;
@property (nonatomic,strong) UIButton * replyBtn;

/*信息收发管理**/
@property (nonatomic,strong) TalkfunLive * liveManager;
@property (nonatomic,strong) TalkfunQuestionModel * replyModel;
/*网络异常view**/
@property (nonatomic,strong) UIView * networkView;
/*语音模式的图片**/
@property (nonatomic,strong) UIImageView * voiceModemImageView;
/*语音模式底层动画view**/
@property (nonatomic,strong) UIView * voiceModemAnimationView;
/*是不是退出**/
@property(nonatomic,assign)BOOL isExit;
/*有没有开始直播**/
@property(nonatomic,assign)BOOL  LiveState;

/*聊天提示红点**/
@property (nonatomic,strong) UIView * chatMessagesTips;
/*提问提示信息数**/
@property (nonatomic,assign) NSInteger questionNum;
/*提示label**/
@property (nonatomic,strong) UILabel * questionNumLabel;

/*有没有麦克风与相机 的权限**/
@property(nonatomic,assign)BOOL CameraPermissions;

/*摄像头开关**/
@property (nonatomic,assign)BOOL Camera_Switch;
/*初始化完成 才能退出**/
@property(nonatomic,assign)BOOL InitializationIsComplete;
/*恢复上课的提示**/
@property(nonatomic,strong)UIAlertController *alert ;
/*记住断网时候的时间**/
@property (nonatomic,strong) NSDate * noNetworkTime;

@end

@implementation TalkfunLiveViewController

- (TalkfunLive *)liveManager
{
    if (!_liveManager) {
        _liveManager = [[TalkfunLive alloc] initWithCourseID:self.model.course_id];
        //设置美颜
        NSNumber * number = [UserDefaults objectForKey:@"beauty"];
        _liveManager.beauty = [number boolValue];
    }
    return _liveManager;
}

- (UIAlertController*)alert
{
    if (_alert==nil) {
        _alert = [UIAlertController alertControllerWithTitle:@"" message:@"WTF this is the message" preferredStyle:UIAlertControllerStyleAlert];

        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"网络已恢复,请继续上课"];
        [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [[hogan string] length])];
        //修改message字体用
        [_alert setValue:hogan forKey:@"attributedMessage"];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [_alert addAction:action1];
    }
    return _alert;
}
- (UITextField *)chatTF
{
    if (!_chatTF) {
        _chatTF = [[UITextField alloc] initWithFrame:CGRectMake(12, (CGRectGetHeight(self.chatTFContainerView.frame) - 30) / 2, CGRectGetWidth(self.view.frame) - SendButtonWidth - 12 - 8 - 12, 30)];
        _chatTF.borderStyle = UITextBorderStyleRoundedRect;
        _chatTF.delegate = self;
    }
    return _chatTF;
}

- (UITextField *)replyTF
{
    if (!_replyTF) {
        _replyTF = [[UITextField alloc] initWithFrame:CGRectMake(12, (CGRectGetHeight(self.replyTFContainerView.frame) - 30) / 2, CGRectGetWidth(self.view.frame) - SendButtonWidth - 12 - 8 - 12, 30)];
        _replyTF.borderStyle = UITextBorderStyleRoundedRect;
        _replyTF.delegate = self;
    }
    return _replyTF;
}

- (UIView *)chatMessagesTips
{
    if (!_chatMessagesTips) {
        UIButton * btn = self.titleButtons[0];
        _chatMessagesTips = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.frame) / 2 + 20, 4, 7, 7)];
        _chatMessagesTips.backgroundColor = UIColorFromRGBHex(0xff5252);
        _chatMessagesTips.layer.cornerRadius = 7 / 2.0;
        _chatMessagesTips.clipsToBounds = YES;
        [btn addSubview:_chatMessagesTips];
    }
    return _chatMessagesTips;
}

- (UILabel *)questionNumLabel
{
    if (!_questionNumLabel) {
        UIButton * btn = self.titleButtons[1];
        _questionNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.frame) / 2 + 15, 4, 20, 15)];
        _questionNumLabel.textAlignment = NSTextAlignmentCenter;
        _questionNumLabel.textColor = [UIColor whiteColor];
        _questionNumLabel.font = [UIFont systemFontOfSize:11];
        _questionNumLabel.layer.cornerRadius = 15 / 2.0;
        _questionNumLabel.clipsToBounds = YES;
        _questionNumLabel.backgroundColor = UIColorFromRGBHex(0xff5252);
        [btn addSubview:_questionNumLabel];
    }
    return _questionNumLabel;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[TalkfunButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.chatTFContainerView.frame) - 12 - SendButtonWidth, (CGRectGetHeight(self.chatTFContainerView.frame) - SendButtonHeight) / 2, SendButtonWidth, SendButtonHeight) title:@"发送" cornerRadius:4 borderWidth:0 borderColor:nil target:self selector:@selector(sendBtnClicked:)];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = BlueColor;
    }
    return _sendBtn;
}
- (UIButton *)replyBtn
{
    if (!_replyBtn) {
        _replyBtn = [[TalkfunButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.replyTFContainerView.frame) - 12 - SendButtonWidth, (CGRectGetHeight(self.replyTFContainerView.frame) - SendButtonHeight) / 2, SendButtonWidth, SendButtonHeight) title:@"发送" cornerRadius:4 borderWidth:0 borderColor:nil target:self selector:@selector(sendBtnClicked:)];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_replyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _replyBtn.backgroundColor = BlueColor;
    }
    return _replyBtn;
}
- (TalkfunCourse *)course
{
    if (!_course) {
        _course = [[TalkfunCourse alloc] init];
    }
    return _course;
}
- (UIImageView *)voiceModemImageView
{
    if (!_voiceModemImageView) {
        UIImage * image = [UIImage imageNamed:@"语音动效"];
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        _voiceModemImageView = [[UIImageView alloc] initWithImage:image];
        _voiceModemImageView.frame = CGRectMake(CGRectGetWidth(self.view.frame) - width - 37 / 2, CGRectGetHeight(self.view.frame) - height - 56 - 13 / 2, width, height);
        
    }
    return _voiceModemImageView;
}

- (UIView *)voiceModemAnimationView
{
    if (!_voiceModemAnimationView) {
        _voiceModemAnimationView = [[UIView alloc] initWithFrame:_voiceModemImageView.frame];
        _voiceModemAnimationView.layer.cornerRadius = self.voiceModemImageView.frame.size.width / 2;
        _voiceModemAnimationView.backgroundColor = BlueColor;
        _voiceModemAnimationView.alpha = 0.2;
    }
    return _voiceModemAnimationView;
}
#pragma mark 蒙板- 提示 -控制器
- (UIAlertController *)cancelSheet
{
    if (!_cancelSheet) {
        if (ISIPAD) {
            _cancelSheet = [UIAlertController alertControllerWithTitle:@"确定要退出编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        }
        else
        {
            _cancelSheet = [UIAlertController alertControllerWithTitle:@"确定要退出编辑?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        }
         WeakSelf
        [_cancelSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.LiveState = NO;

            weakSelf.navigationController.navigationBar.userInteractionEnabled = NO;
            [weakSelf.liveManager stop:^(id result){
                
            if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                //下课并退出  控制器
                if (weakSelf.isExit) {
                [weakSelf.whiteboardView shutdown];
                [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                [weakSelf.liveManager shutdown];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                });}
                
                else
                    {
                 //仅仅是下课
                PERFORM_IN_MAIN_QUEUE([weakSelf.startLiveBtn setImage:[UIImage imageNamed:@"nav bar_btn_class on"] forState:UIControlStateNormal];)
                        weakSelf.isExit = YES;
                    }
                weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
                
                 #pragma mark 上传提示器
             //   [TalkfunUploadPrompt show];
                //保存课程信息
                [self saveCourseInformation];
                
            }else{
                 weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf createDismissTimerWithTitle:@"下课操失败"];
                });
            }
              
            }];
        }]];
        [_cancelSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.isExit = YES;
        }]];
    }
    return _cancelSheet;
}
#pragma mark - 懒加载
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (NSMutableArray *)toolButtonArray
{
    if (!_toolButtonArray) {
        _toolButtonArray = [NSMutableArray array];
    }
    return _toolButtonArray;
}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    //默认是开启的
    self.Camera_Switch = YES;
    self.view.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
     //设置画板
    [self SetWhiteboardView];
    
    //功能按条 .
    [self SetDirectTool];
    
    //添加子控制器
    [self setupChildVcs];
    
    // 设置导航栏
    [self setupNav];
    
    // 添加标题栏
    [self setupTitlesView];
    
    //摄像头预览View
    [self Setpreview];
    
   //添加scrollView
    [self setupScrollView];
    
    //根据scrollView的偏移量的添加子控制器的view
   [self addChildVcView];
    
    //加文字输入框
    [self addTextField];
    
    //添加监听事件（on）
   [self onSomething];
    
    //网络状态
    [self networkDetect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];//键盘将出现事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil]; //键盘将隐藏事件监听
    //进入后台 时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    //进入前台时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    //定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        self.InitializationIsComplete = YES;
    });
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.scrollView setContentOffset:CGPointMake(self.offsetNum * CGRectGetWidth(self.scrollView.frame), 0)];
}
#pragma mark 进入前台时调用
- (void)appWillEnterForegroundNotification {
    //开始直播了才,连接
    if (self.LiveState) {
        [self.liveManager resume];
    }
}
#pragma mark 进入后台 时调用
- (void)WillResignActiveNotification{
    if (self.LiveState) {
        [self.liveManager pause:nil];
    }
    //得到当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    //一个后台任务标识符
    UIBackgroundTaskIdentifier taskID;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        //如果系统觉得我们还是运行了太久，将执行这个程序块，并停止运行应用程序
        [app endBackgroundTask:taskID];
    }];
    if (taskID == UIBackgroundTaskInvalid) {
        return;
    }
    //告诉系统我们完成了
    [app endBackgroundTask:taskID];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark 添加监听事件(on) (用户事件）
- (void)onSomething
{
    WeakSelf
    [self.liveManager on:TALKFUN_EVENT_MEMBER_JOIN_ME callback:^(id result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_TOTAL_ONLINE object:nil userInfo:@{@"total":[result[@"online"][@"total"] stringValue]}];
    }];
    
    [self.liveManager on:TALKFUN_EVENT_MEMBER_JOIN_OTHER callback:^(id result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_TOTAL_ONLINE object:nil userInfo:@{@"total":[result[@"total"] stringValue]}];
    }];
    [self.liveManager on:TALKFUN_EVENT_CHAT_SENT callback:^(id result) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_CHAT_SEND object:nil userInfo:result];
        
        UIButton *btn = weakSelf.titleButtons[0];
        if (!btn.selected) {
            weakSelf.chatMessagesTips.hidden = NO;
        }
        
        NSLog(@"%@:%@",TALKFUN_EVENT_CHAT_SENT,result);
    }];
    
    [self.liveManager on:TALKFUN_EVENT_QUESTION_ASK callback:^(id result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_QUESTION_ASK object:nil userInfo:result];
        
        UIButton * btn = weakSelf.titleButtons[1];
        if (!btn.selected) {
            weakSelf.questionNum += 1;
            CGRect rect = [TalkfunUtils getRectWithString:[NSString stringWithFormat:@"%ld",weakSelf.questionNum] size:CGSizeMake(100, 15) fontSize:11];
            CGRect frame = weakSelf.questionNumLabel.frame;
            frame.size.width = rect.size.width;
            if (weakSelf.questionNum < 10 && frame.size.width < 15) {
                frame.size.width = 15;
            }
            else
            {
                frame.size.width = rect.size.width + 8;
            }
            weakSelf.questionNumLabel.frame = frame;
            weakSelf.questionNumLabel.text = [NSString stringWithFormat:@"%ld",weakSelf.questionNum];
            weakSelf.questionNumLabel.hidden = NO;
        }
    }];
    
    [self.liveManager on:TALKFUN_EVENT_QUESTION_REPLY callback:^(id result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_QUESTION_REPLY object:nil userInfo:result];
        
    }];
    
    [self.liveManager on:TALKFUN_EVENT_FLOWER_SEND callback:^(id result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_FLOWER_SEND object:nil userInfo:result];
    }];
    
    [self.liveManager on:TALKFUN_EVENT_CONNECT callback:^(id result) {
        
    }];
    
    [self.liveManager on:TALKFUN_EVENT_DISCONNECT callback:^(id result) {
        
    }];
    
    [self.liveManager on:TALKFUN_EVENT_ERROR callback:^(id result) {
        
    }];
    
    [self.liveManager on:TALKFUN_EVENT_RECONNECT callback:^(id result) {
        
    }];
    
    [self.liveManager on:TALKFUN_EVENT_RECONNECT_ATTEMPT callback:^(id result) {
        
    }];
}
#pragma mark 添加textfield
- (void)addTextField
{

    self.chatTFContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44)];
    self.chatTFContainerView.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
    [self.view addSubview:self.chatTFContainerView];
    
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.chatTFContainerView.frame), 0.5)];
    topLine.backgroundColor = UIColorFromRGBHex(0xd5d5d5);
    [self.chatTFContainerView addSubview:topLine];
    
    [self.chatTFContainerView addSubview:self.chatTF];
    [self.chatTFContainerView addSubview:self.sendBtn];
    
    self.chatTFContainerView.hidden = YES;
    
    self.replyTFContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44)];
    self.replyTFContainerView.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
    [self.view addSubview:self.replyTFContainerView];
    
    UIView * topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.replyTFContainerView.frame), 0.5)];
    topLine2.backgroundColor = UIColorFromRGBHex(0xd5d5d5);
    [self.replyTFContainerView addSubview:topLine2];
    
    [self.replyTFContainerView addSubview:self.replyTF];
    [self.replyTFContainerView addSubview:self.replyBtn];
    
    self.replyTFContainerView.hidden = YES;
}

- (void)sendBtnClicked:(UIButton *)btn
{
    NSMutableDictionary * parameter = [NSMutableDictionary new];
    if (self.sendBtn == btn && self.chatTF.isFirstResponder && self.chatTF.text.length != 0) {
        parameter[@"msg"] = self.chatTF.text;
        [self.liveManager emit:TALKFUN_EVENT_CHAT_SENT params:parameter callback:^(id result) {
            if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_CHAT_SEND object:nil userInfo:result[@"data"]];
             //   NSLog(@"%@:%@",TALKFUN_EVENT_CHAT_SENT,result);
            }
        }];
        self.chatTF.text = nil;
    }
    else if (btn == self.replyBtn && self.replyTF.isFirstResponder && self.replyTF.text.length != 0)
    {
        parameter[@"course_id"] = self.model.course_id;
        parameter[@"replyId"] = self.replyModel.qid;
        parameter[@"content"] = self.replyTF.text;
        [self.liveManager emit:TALKFUN_EVENT_QUESTION_REPLY params:parameter callback:nil];
        self.replyTF.text = nil;
    }
    [self.view endEditing:YES];
}
//键盘将出现事件监听
- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary * keyboardInfo = notification.userInfo;
    NSValue * keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    if (self.scrollView.contentOffset.x < SCREENWIDTH / 2) {
        self.chatTFContainerView.transform = CGAffineTransformMakeTranslation(0, -keyboardFrameEndRect.size.height);
    }
    else
    {
        self.replyTFContainerView.transform = CGAffineTransformMakeTranslation(0, -keyboardFrameEndRect.size.height);
    }

}
 //键盘将隐藏事件监听
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.scrollView.contentOffset.x > SCREENWIDTH / 2) {
        self.replyTFContainerView.transform = CGAffineTransformIdentity;
        self.replyTFContainerView.hidden = YES;
    }
    else
    {
        self.chatTFContainerView.transform = CGAffineTransformIdentity;
        TalkfunChatViewController * chatVC = self.childViewControllers[0];
        if (chatVC.containsCamera || self.scrollView.contentOffset.x > CGRectGetWidth(self.view.frame) / 2) {
            self.chatTFContainerView.hidden = YES;
        }
    }
}

#pragma mark - 添加子控制器
- (void)setupChildVcs
{
    //聊天
    TalkfunChatViewController *tchatableView = [[TalkfunChatViewController alloc] init];
    WeakSelf
    tchatableView.chatBtnBlock = ^(){
        weakSelf.chatTFContainerView.hidden = NO;
        [weakSelf.chatTF becomeFirstResponder];
        weakSelf.chatTF.placeholder = nil;
        
    };
    tchatableView.title = @"聊天";
    [self addChildViewController:tchatableView];
    //提问
    TalkfunQuestionViewController *quizTableView = [[TalkfunQuestionViewController alloc] init];
    quizTableView.replyBtnBlock = ^(TalkfunQuestionModel *model){
        weakSelf.replyModel = model;
        weakSelf.replyTFContainerView.hidden = NO;
        [weakSelf.replyTF becomeFirstResponder];
        weakSelf.replyTF.placeholder = [NSString stringWithFormat:@"回复 %@",model.nickname];
    };
    quizTableView.title = @"提问";
    [self addChildViewController:quizTableView];
    //文档
    FileViewController *noticeView = [[FileViewController alloc] init];
    noticeView.model = self.model;
    noticeView.title = @"选择文档";
    [self addChildViewController:noticeView];
}
#pragma mark  设置导航栏
- (void)setupNav
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav bar_btn_back"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:UIColorFromRGBHex(0x666666) forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(Exit:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, - 12, 0, 0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.isExit =YES;
    // 左边内容
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"nav bar_btn_class on"] forState:UIControlStateNormal];
    self.startLiveBtn = btn;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(StartLiveCLick:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    // 右边内容
    self.navigationItem.rightBarButtonItems = @[item1];
    //中间
    self.navigationItem.title = self.model.course_name;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    
}
#pragma mark  添加标题栏
- (void)setupTitlesView
{
    UIView * titlesView = [[UIView alloc]init];
    self.titlesView = titlesView;
    self.titlesView.x = 0;
    self.titlesView.y = XMGNavBarBottom +self.whiteboardView.height;
    self.titlesView.width = self.view.width;
    
    if (self.view.height ==568) {
        
       self.titlesView.height = 30;
    }else{
        self.titlesView.height = 40;
    }
    
    self.titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.view addSubview:self.titlesView];
    
    // 添加标题
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonW = titlesView.width / count;
    CGFloat titleButtonH = titlesView.height;
    
    for (int i = 0; i < count; i++) {
        // 创建
        XMGTitleButton *titleButton = [[XMGTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        // 设置
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal]; // selected = NO;
        [titleButton setTitleColor:[UIColor colorWithRed:107 / 255.0 green:186 / 255.0 blue:249 / 255.0 alpha:1] forState:UIControlStateSelected]; // selected = YES;
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // 数据
        [titleButton setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
    }
 
    UIView *top = [[UIView alloc]init];
    top.frame = CGRectMake(0, 0, self.view.width, 1);
    top.backgroundColor = UIColorFromRGBHex(0xdddddd);
    [titlesView addSubview: top];
   
    UIView *bottom = [[UIView alloc]init];
    bottom.frame = CGRectMake(0, titleButtonH -1, self.view.width, 1);
    bottom.backgroundColor = UIColorFromRGBHex(0xdddddd);
    [titlesView addSubview: bottom];
    
    // 添加底部的指示器
    UIView *titleIndicatorView = [[UIView alloc] init];
    [titlesView addSubview:titleIndicatorView];
    
    // 设置指示器的背景色为按钮的选中文字颜色
    XMGTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    titleIndicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    titleIndicatorView.height = 3;
    titleIndicatorView.bottom = titlesView.height;
    self.titleIndicatorView = titleIndicatorView;
    // 让被点击的标题按钮变成选中状态
    firstTitleButton.selected = YES;
    // 被点击的标题按钮 -> 当前被选中的标题按钮
    self.selectedTitleButton = firstTitleButton;
    // 自动根据当前内容计算尺寸
    [firstTitleButton.titleLabel sizeToFit];
    // 让指示器移动
    titleIndicatorView.width = TitleIndicatorViewWidth;
    titleIndicatorView.centerX = firstTitleButton.centerX;
}


#pragma mark  标题栏中button的点击
- (void)titleButtonClick:(XMGTitleButton *)titleButton
{
    if (titleButton.tag==0) {
        self.chatMessagesTips.hidden = YES;
        self.view.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
        if(!self.CameraPermissions ){
        //配置推流
        [self  ConfigurationCamera];
        }
        self.preview.hidden = NO;
        TalkfunChatViewController * chatVC = self.childViewControllers[0];
        if (!chatVC.containsCamera) {
            [self chatTF:YES];
        }
        else
        {
            [self chatTF:NO];
        }
    }else if(titleButton.tag ==1){
        self.view.backgroundColor = [UIColor whiteColor];
        self.questionNumLabel.hidden = YES;
        self.questionNum = 0;

        self.preview.hidden = YES;
        self.chatTFContainerView.hidden = YES;
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
        self.preview.hidden = YES;
        self.chatTFContainerView.hidden = YES;
    }
    // 让当前被选中的标题按钮恢复以前的状态(取消选中)
    self.selectedTitleButton.selected = NO;
    // 让被点击的标题按钮变成选中状态
    titleButton.selected = YES;
    // 被点击的标题按钮 -> 当前被选中的标题按钮
    self.selectedTitleButton = titleButton;
    // 让指示器移动
    [UIView animateWithDuration:0.25 animations:^{
        
    self.titleIndicatorView.width = TitleIndicatorViewWidth;
    self.titleIndicatorView.centerX = titleButton.centerX;
    }];
    // 滚动scrollView
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}
#pragma mark 添加scrollView
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.x = 0;
    scrollView.y = self.preview.y;
    scrollView.width = self.view.width;
    scrollView.height =  self.view.height- self.preview.y;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // 禁止掉[自动设置scrollView的内边距]
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置内容大小 ,禁止左右
    scrollView.contentSize = CGSizeMake(0, 0);
}

#pragma mark - <UIScrollViewDelegate>  如果通过setContentOffset:让scrollView[进行了滚动动画], 那么最后会在停止滚动时调用这个方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 根据scrollView的偏移量的添加子控制器的view
    int index = scrollView.contentOffset.x / scrollView.width;
    self.offsetNum = index;
    if (index >= 2) {
        [self addChildVcViewWithScrollViewContentOffset];
        if (_voiceModemImageView) {
            self.voiceModemImageView.hidden = YES;
            self.voiceModemAnimationView.hidden = YES;
        }
    }
    else if (_voiceModemImageView.hidden)
    {
        self.voiceModemImageView.hidden = NO;
        self.voiceModemAnimationView.hidden = NO;
    }
}
#pragma mark -根据scrollView的偏移量的添加子控制器的view
- (void)addChildVcView
{
    for (int i = 0; i < 2; i ++) {
        UIViewController * vc = self.childViewControllers[i];
        if (vc.isViewLoaded) {
            continue;
        }
        vc.view.frame = CGRectMake(i * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        if (i == 0) {
            vc.view.backgroundColor = [UIColor clearColor];
        }else
        {
            vc.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        [self.scrollView addSubview:vc.view];
    }

}

- (void)addChildVcViewWithScrollViewContentOffset
{
    UIScrollView *scrollView = self.scrollView;
    // 计算按钮索引
    int index = scrollView.contentOffset.x / scrollView.width;
    self.offsetNum = index;
    // 添加对应的子控制器view
    UIViewController *willShowVc = self.childViewControllers[index];
    if (willShowVc.isViewLoaded) return;
    // 设置子控制器view的frame
    willShowVc.view.frame =  scrollView.bounds;

    if (index==0) {
        willShowVc.view.backgroundColor = [UIColor clearColor];
    }else{
        willShowVc.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    [scrollView addSubview:willShowVc.view];
}
#pragma mark 设置画板
- (void)SetWhiteboardView
{
    //画板VIEW
    self.whiteboardView = [TalkfunWhiteboardView customViwe];
    self.whiteboardView.delegate = self;
    
    if(self.view.height <=568){
         self.whiteboardView.frame = CGRectMake(0, XMGNavBarBottom, self.view.width, self.view.width* 0.75 );
    }else{
         self.whiteboardView.frame = CGRectMake(0, XMGNavBarBottom, self.view.width, self.view.width* 0.75);
    }
    self.whiteboardView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.view addSubview: self.whiteboardView];

    //选择文件
    self.whiteboardView.SelectDocument.width = self.view.width *0.4;
    self.whiteboardView.SelectDocument.height = self.view.height *0.25;
    self.whiteboardView.SelectDocument.layer.borderWidth = 1.4;
    self.whiteboardView.SelectDocument.layer.borderColor = [UIColor colorWithRed:107 / 255.0 green:186 / 255.0 blue:249 / 255.0 alpha:1].CGColor;
    self.whiteboardView.SelectDocument.layer.cornerRadius = 4;
    self.TemPreview = [[UIView alloc]init];
    self.TemPreview.userInteractionEnabled = NO;
    if(self.view.height <=568){
        self.TemPreview.frame = CGRectMake(0, XMGNavBarBottom, self.view.width, self.view.width* 0.75 );
    }else{
        self.TemPreview.frame = CGRectMake(0, XMGNavBarBottom, self.view.width, self.view.width* 0.75);
    }
    self.TemPreview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.TemPreview ];
    
}
#pragma mark 功能按条
-(void)SetDirectTool
{
    float DirectToolW = 0;
    float DirectToolH = 0;
    
    if (self.view.height <= 568)
    {
         DirectToolW = 35;
         DirectToolH = 35;
    }else{
         DirectToolW = 40;
         DirectToolH = 40;
    }
    float DirectToolX = 12;
    UIView *DirectTool = [[UIView alloc]init];
    DirectTool.frame = CGRectMake(DirectToolX,XMGNavBarBottom +(self.whiteboardView.height-(DirectToolH*4) -(12*3))/2, DirectToolW, (DirectToolH*4) +(12*3));
    DirectTool.backgroundColor = [UIColor clearColor];
    [self.view addSubview:DirectTool];
    self.DirectTool = DirectTool;
    //列数
    NSUInteger columnsCount = 1;
    //总数
    NSUInteger count = 4;
    float btnH = DirectToolW;
    float btnW = DirectToolW;
    NSArray *array = @[@"关闭视频-3.jpg",@"关闭视频-2.jpg",@"屏幕切换.jpg",@"摄像头调转.jpg"];
    for (int i =0; i<count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.x = 0;
        if(i>0){
        btn.y = (i / columnsCount) * (btnH  +12) ;
        }else
        {
        btn.y = (i / columnsCount) * btnH  ;
        }
       [btn setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        btn.width = btnW;
        btn.height = btnH;
        btn.layer.cornerRadius = btnH/2;
        btn.backgroundColor= [UIColor colorWithRed:107 / 255.0 green:186 / 255.0 blue:249 / 255.0 alpha:1];
        [DirectTool addSubview:btn];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:8];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolButtonArray addObject:btn];
    }

}

#pragma mark 视频功能条 的按键
- (void)btnClick:(UIButton*)btn
{
    [self.view endEditing:YES];
    btn.selected = ! btn.selected;
    if (btn.tag==0) {
        //摄像头开关
        if (btn.selected)
        {
            self.TemPreview.y = -1000;
            self.preview.y = -1000;
            self.Camera_Switch =NO;
            [btn  setImage:[UIImage imageNamed:@"关闭视频-1"] forState:UIControlStateNormal];
            //弹窗口,提示
            [self createDismissTimerWithTitle:@"已转换至语音模式"] ;
            
            for (UIButton *btn in self.toolButtonArray) {
                if ((btn.tag) ==2) {
                    btn.hidden =YES;
                }else if ((btn.tag) ==3){
                    btn.hidden =YES;
                }
                
            }
            
            //弹窗
            [self addVoiceModemTips];
            
            [self chatVCContainsCamera:NO];
            
            
            
            [self.liveManager cameraStop:^(id result) {
                
            }];
        }else
        {
            self.TemPreview.y = 64;
            self.preview.y = self.scrollView.y;
            
            self.Camera_Switch =YES;;
            
            for (UIButton *btn in self.toolButtonArray) {
                if ((btn.tag) ==2) {
                    btn.hidden =NO;
                }else if ((btn.tag) ==3){
                    btn.hidden =NO;
                }
            }
            [btn  setImage:[UIImage imageNamed:@"关闭视频-3.jpg"] forState:UIControlStateNormal];
            [self createDismissTimerWithTitle:@"视频模式已开启"];
            UIButton * button = [(UIButton *)self.view viewWithTag:2];
            if (!button.selected) {
                
                [self chatVCContainsCamera:YES];
            }
            [self removeVoiceModemTips];
            [self.liveManager cameraStart:^(id result) {
                
            }];
        }
    }else if(btn.tag==1){
        //关闭音频
        if(btn.selected)
        {
            [btn  setImage:[UIImage imageNamed:@"关闭视频.jpg"] forState:
             UIControlStateNormal];
            self.liveManager.micGain = 0;
            [self createDismissTimerWithTitle:@"麦克风已关闭"];
            
        }else{
            [btn  setImage:[UIImage imageNamed:@"关闭视频-2.jpg"] forState:
             UIControlStateNormal];
            self.liveManager.micGain = 1;
            //弹窗口,提示
            [self createDismissTimerWithTitle:@"麦克风已开启"];
        }
        
    }else if(btn.tag==2){
        //View转换
        if (btn.selected) {
            self.TemPreview.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            self.liveManager.previewView = self.TemPreview;
            [self chatVCContainsCamera:NO];
        }else{
            self.TemPreview.backgroundColor = [UIColor clearColor];
            self.liveManager.previewView =self.preview;
            
            [self chatVCContainsCamera:YES];
        }
        
    }else if(btn.tag==3){
        //前后转换
        [self.liveManager setCameraFront:btn.selected];
    }
}

#pragma mark 摄像头预览View
- (void)Setpreview
{
    self.preview = [[UIView alloc]init];
    self.preview.y =  XMGNavBarBottom +self.whiteboardView.height +self.titlesView.height;
    self.preview.height =self.view.height- self.preview.y ;
    self.preview.width = self.preview.height/0.75;
     self.preview.x = (self.view.width - self.preview.width )/2;
    [self.view addSubview:self.preview];
    //配置推流
    [self  ConfigurationCamera];
}

//初始化直播器
- (void)setPermission
{
//主线程中更新
dispatch_async(dispatch_get_main_queue(), ^{
    [self.liveManager setPreview:self.preview];
    self.liveManager.delegate = self;
    //记录一下,开启权限成功
    self.CameraPermissions = YES;
});

}
//配置推流
- (void)ConfigurationCamera
{
WeakSelf
    [self.liveManager applyPermission:^(BOOL state) {
        //授权通过 了才开始推流
        if (state) {
            [weakSelf setPermission];
        }
    }];
}
#pragma mark rtmp 视频流状态  delegate
- (void)streamStatusChanged:(TalkfunLiveStreamState)sessionState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (sessionState) {
                case TalkfunLiveStreamStatePreviewStarted:
                break;
                case TalkfunLiveStreamStateStarting:
                // NSLog(@"RTMP状态:RTMP状态: 连接中...");
                break;
                case TalkfunLiveStreamStateStarted:
                break;
                case TalkfunLiveStreamStateEnded:
                
                break;
                case TalkfunLiveStreamStateError:
                
            {
                WeakSelf
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf createDismissTimerWithTitle:@"连接错误"];
                });
            }
                break;
            default:
                break;
        }
    });
}

#pragma mark 课程状态 delegate:
- (void)liveStatusChanged:(TalkfunLiveState)liveState
{
    if (liveState == TalkfunLiveStateStart) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.LiveState){
                [self createDismissTimerWithTitle:@"已上课"];
            }else{
              //  [self createDismissTimerWithTitle:@"已连接"];
            }
        });
    }
}
- (void)addVoiceModemTips
{
    [self.view addSubview:self.voiceModemImageView];
    if (self.scrollView.contentOffset.x >= SCREENWIDTH * 2) {
        self.voiceModemImageView.hidden = YES;
        self.voiceModemAnimationView.hidden = YES;
    }
    
    CAKeyframeAnimation *voiceModemAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.whiteboardView.center.x, self.whiteboardView.center.y + 20);
    CGPathAddQuadCurveToPoint(path, NULL, CGRectGetWidth(self.view.frame) / 1.5, 0, CGRectGetMidX(self.voiceModemImageView.frame), CGRectGetMidY(self.voiceModemImageView.frame));
    voiceModemAnimation.path = path;
    voiceModemAnimation.delegate = self;
    CGPathRelease(path);
    voiceModemAnimation.duration = 0.8;
    [self.voiceModemImageView.layer addAnimation:voiceModemAnimation forKey:@"voiceModemAnimation"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.view addSubview:self.voiceModemAnimationView];
    [self voiceModemTipsAnimation];
}

- (void)voiceModemTipsAnimation
{
    _voiceModemAnimationView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:1 animations:^{
        _voiceModemAnimationView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        _voiceModemAnimationView.alpha = 0.15;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _voiceModemAnimationView.transform = CGAffineTransformIdentity;
            _voiceModemAnimationView.alpha = 0.2;
        } completion:^(BOOL finished) {
            if (self.voiceModemImageView.superview) {
                [self voiceModemTipsAnimation];
            }
        }];
    }];
}

- (void)removeVoiceModemTips
{
    [self.voiceModemImageView removeFromSuperview];
    [self.voiceModemAnimationView removeFromSuperview];
}
- (void)chatTF:(BOOL)show
{
    self.chatTFContainerView.hidden = !show;
}

- (void)chatVCContainsCamera:(BOOL)contains
{
    TalkfunChatViewController * chatVC = self.childViewControllers[0];
    chatVC.containsCamera = contains;
    if (self.selectedTitleButton == self.titleButtons.firstObject) {
        [self chatTF:!contains];
    }
    else
    {
        [self chatTF:NO];
    }
}

#pragma mark 开始直播
- (void)StartLiveCLick:(UIButton*)btn
{
    [self.view endEditing:YES];

    if (self.LiveState==NO) {
       WeakSelf
        __block UIButton * button = btn;
        [self.liveManager start:^(id data) {
            
            if ([data[@"code"] intValue] == TalkfunCodeSuccess) {
                
                PERFORM_IN_MAIN_QUEUE([button setImage:[UIImage imageNamed:@"nav bar_btn_class over"] forState:UIControlStateNormal];)
                
                weakSelf.LiveState = YES;
            
            }
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([data[@"code"] intValue] == TalkfunCodeInTheLive) {
                        [weakSelf.view alert:@"不能进行直播" message:data[@"msg"]];
                    }
                    else{
                        [weakSelf createDismissTimerWithTitle:data[@"msg"]];
                    }
                    
                });
            }
        
        }];


    }else{
      
        self.isExit = NO;
        [self Exit:btn];

    }
 
}
- (void)tcommunicationClicked:(UIButton*)btn
{
    [self.view endEditing:YES];
    //聊天
    if(btn.tag==0){
        self.preview.hidden = NO;
        
    //提问
    }else if(btn.tag ==1){
    
        self.preview.hidden = YES;
    //文档
    }else{
          self.preview.hidden = YES;
    }

    // 滚动scrollView
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = btn.tag * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}

static NSString * networkStatus = nil;
- (void)networkDetect
{
    NSString * networkStr = [[NetworkStatusObserver defaultObserver] currentNetworkStatusDescription];
    networkStatus = networkStr;
    
    if ([networkStr isEqualToString:NetworkStatus_None]) {
        [self networkTips:YES];
    }
    else
    {
        [self networkTips:NO];
    }
    [[NetworkStatusObserver defaultObserver] startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kNetworkStatusChangedNotification object:nil];
}

- (void)networkChange:(NSNotification *)notification
{
    NSDictionary * userInfo = notification.userInfo;
    NSString * str = [userInfo objectForKey:kNetworkStatusDescriptionKey];
    
    
    if ([str isEqualToString:NetworkStatus_None]) {
        self.noNetworkTime = [NSDate date];
        [self networkTips:YES];
        networkStatus = str;
        [self.liveManager network:NO];
        self.liveManager.networkStatusStr = str;

    }
    else
    {
        
        if (![str isEqualToString:networkStatus]) {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.noNetworkTime];
            NSLog(@"%lf",interval);
            if (self.LiveState && interval - 590 > 0) {
                WeakSelf
                [self.liveManager start:^(id data) {
                    if ([data[@"code"] intValue] == TalkfunCodeSuccess) {
                        
                    }
                    else
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.view alert:@"不能进行直播" message:@"恢复上课失败"];
                            
                        });
                    }
                }];
            }
            networkStatus = str;
            [self.liveManager network:YES];
            [self networkTips:NO];
            self.noNetworkTime = nil;
            
            if(self.LiveState){
                [self presentViewController:self.alert animated:YES completion:nil];
            }

        }
    }
    
}

- (void)networkTips:(BOOL)show
{
    PERFORM_IN_MAIN_QUEUE(if (show) {
        self.networkView = [self.view networkUnusualView];
        CGRect rect = self.networkView.frame;
        rect.origin.y = 64;
        self.networkView.frame = rect;
        [self.view addSubview:self.networkView];
    }
                          else
                          {
                              NSLog(@"%@",self.networkView);
                              [self.networkView removeFromSuperview];
                              self.networkView = nil;
                          })
}


#pragma mark 退出 控制器 或  下课
- (void)Exit:(UIButton *)btn
{
    if(!self.LiveState ){
        if ( self.InitializationIsComplete) {
            [self.liveManager shutdown];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self.whiteboardView shutdown];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        
        NSString * title = nil;
        if ([btn.titleLabel.text isEqualToString:@"返回"]) {
            title = @"你确定要退出?";
        }
        else
        {
            title = @"你确定要下课?";
        }
        self.cancelSheet.title = title;
        [self presentViewController:self.cancelSheet animated:YES completion:nil];
    }
}
#pragma mark WhiteboardViewDelegate 代理
- (void)DirectToolHide
{
    if(self.whiteboardView.HideMark ==NO){
        if (self.DirectTool.hidden ==YES) {
            self.DirectTool.hidden =NO;
        }else{
            self.DirectTool.hidden =YES;
        }
    }else{
        self.DirectTool.hidden =YES;
    }

}
#pragma mark 点击了选择文档
- (void)SelectDocument
{
    [self titleButtonClick:self.titleButtons[2]];
   
}

#pragma mark text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.placeholder = nil;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    textField.placeholder = nil;

}
//创建timer
- (void)createDismissTimerWithTitle:(NSString *)title
{
    UIButton * toastBtn = [self.whiteboardView getToastBtn];
    [self.view toast:title position:CGPointMake(self.view.center.x, self.view.center.y -50)];
    toastBtn.alpha = 1;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}
//隐藏toastbtn
- (void)hideToast
{
    [self.view untoast];
}


#pragma mark 保存课程信息
- (void)saveCourseInformation {
    NSMutableDictionary *information  = [NSMutableDictionary dictionary];
    [information setObject:self.model.course_id forKey:@"course_id"];
    [information setObject:self.model.course_name  forKey:@"course_name"];
    //保存
    [TalkfunCourseResourse  addList :information];
}



- (void)whiteboardDidTouched {
    self.DirectTool.hidden = !self.DirectTool.hidden;
}
- (void)dealloc
{
    NSLog(@"__________liveViewController Dealloc___________");
}
@end
