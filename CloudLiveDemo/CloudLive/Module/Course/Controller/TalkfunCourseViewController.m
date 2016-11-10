//
//  TalkfunCourseViewController.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunCourseViewController.h"
#import "TalkfunImageView.h"
#import "TalkfunButton.h"
#import "TalkfunLabel.h"
#import "TalkfunCourseTableViewCell.h"
#import "TalkfunCourse.h"
#import "TalkfunCourseModel.h"
#import "TalkfunLiveViewController.h"
#import "TalkfunLive.h"
#import "NetworkStatusObserver.h"

#define ButtonWidth 150
#define ButtonHeight 35

#define LabelWidth 200
#define LabelHeight 35

@interface TalkfunCourseViewController ()

@property (nonatomic,strong) TalkfunImageView * classImageView;
@property (nonatomic,strong) TalkfunButton * createButton;
@property (nonatomic,strong) TalkfunLabel * noCourseLabel;
@property (nonatomic,strong) TalkfunCourse * course;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSTimer * dismissTimer;
@property (nonatomic,strong) UIAlertController * tipsAlert;

@end

@implementation TalkfunCourseViewController

- (UIAlertController *)tipsAlert
{
    if (!_tipsAlert) {
        _tipsAlert = [UIAlertController alertControllerWithTitle:@"不能进行直播" message:@"该账号当前有其他人在直播中" preferredStyle:UIAlertControllerStyleAlert];
        [_tipsAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _tipsAlert;
}

- (TalkfunImageView *)classImageView
{
    if (!_classImageView) {
        UIImage * classImage = [UIImage imageNamed:@"Class"];
        _classImageView = [[TalkfunImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - classImage.size.width) / 2, 40, classImage.size.width , classImage.size.height) imageNamed:@"Class"];
    }
    return _classImageView;
}

- (TalkfunLabel *)noCourseLabel
{
    if (!_noCourseLabel) {
        _noCourseLabel = [[TalkfunLabel alloc] initWithFrame:CGRectMake((SCREENWIDTH - LabelWidth) / 2, CGRectGetMaxY(self.classImageView.frame) + 16, LabelWidth, LabelHeight) text:@"暂无直播课程，试试新建直播" font:[UIFont systemFontOfSize:14] textColor:UIColorFromRGBHex(0x999999) textAlignment:NSTextAlignmentCenter];
    }
    return _noCourseLabel;
}

- (TalkfunButton *)createButton
{
    if (!_createButton) {
        _createButton = [[TalkfunButton alloc] initWithFrame:CGRectMake((SCREENWIDTH - ButtonWidth) / 2, CGRectGetMaxY(self.noCourseLabel.frame) + 40, ButtonWidth, ButtonHeight) title:@"新建" cornerRadius:CornerRadius borderWidth:1 borderColor:BlueColor target:self selector:@selector(createBtnClicked:)];
        _createButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_createButton addTarget:self action:@selector(createBtnDown:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDownRepeat];
        [_createButton addTarget:self action:@selector(createBtnUp:) forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
    }
    return _createButton;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (TalkfunCourse *)course
{
    if (!_course) {
        _course = [[TalkfunCourse alloc] init];
    }
    return _course;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addRightBarBtn];
    
//    [self addNoCourseTips];
    
    __weak typeof(self) weakSelf = self;
    
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCourseData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //加载gif
    [self loadCADisplayLineImageView];
}

static NSString * networkStatus = nil;
- (void)networkDetect
{
    NSString * networkStr = [[NetworkStatusObserver defaultObserver] currentNetworkStatusDescription];
    networkStatus = networkStr;
    
    NSLog(@"networkStr:%@",networkStr);
    if ([networkStr isEqualToString:NetworkStatus_None]) {
        [self networkTips:YES];
    }
    else{
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
        [self networkTips:YES];
        networkStatus = str;
    }
    else
    {
        if ([networkStatus isEqualToString:NetworkStatus_None]) {
            networkStatus = str;
            [self networkTips:NO];
            [self getCourseData];
        }
    }
}

- (void)networkTips:(BOOL)show
{
    if (show) {
        self.tableView.sectionHeaderHeight = 44;
        self.tableView.tableHeaderView = [self.view networkUnusualView];
        [self.tableView reloadData];
    }
    else
    {
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton * btn = [(UIButton *)self.view viewWithTag:88];
    btn.userInteractionEnabled = YES;
    self.createButton.userInteractionEnabled = YES;
    self.navigationController.navigationBar.hidden = NO;
//    [self removeNoCourseTips];
//    [self getCourseData];
    [self networkDetect];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getCourseData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNetworkStatusChangedNotification object:nil];
    [[NetworkStatusObserver defaultObserver] stopNotifier];
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton new]];
}

- (void)getCourseData
{
    [self.view startAnimation];
    WeakSelf
    [self.course getCourseList:^(id result) {
        @synchronized (self) {
            if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                NSArray * dataArr = result[@"data"];
                [weakSelf.dataSource removeAllObjects];
//                [weakSelf.selectedArray removeAllObjects];
                for (int i = 0; i < dataArr.count; i ++) {
                    TalkfunCourseModel * model = [TalkfunCourseModel mj_objectWithKeyValues:dataArr[i]];
                    [weakSelf.dataSource addObject:model];
//                    [weakSelf.selectedArray addObject:@(0)];
                }
                PERFORM_IN_MAIN_QUEUE([weakSelf.view stopAnimation];
                                      if (dataArr.count != 0) {
                    [weakSelf removeNoCourseTips];
                }else
                {
                    [weakSelf addNoCourseTips];
                                      }
                [weakSelf.tableView reloadData];)
            }
            else
            {
                NSLog(@"result:%@",[result objectForKey:@"msg"]);
                PERFORM_IN_MAIN_QUEUE(if ([result[@"msg"] isKindOfClass:[NSString class]]) {
                    [weakSelf.view stopAnimation];
                    [weakSelf addNoCourseTips];
                })
            }
        }
    }];
}

- (void)addRightBarBtn
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    //添加右边设置按钮
    UIButton * settingBtn = [[TalkfunButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40) title:nil cornerRadius:0 borderWidth:0 borderColor:nil target:self selector:@selector(settingBtnClicked:)];
    [settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpOutside];
    [settingBtn addTarget:self action:@selector(settingBtnHightLight:) forControlEvents:UIControlEventTouchDown];
    UIImage * settingImage = [UIImage imageNamed:@"setting"];
    UIImageView * settingImageView = [[TalkfunImageView alloc] initWithFrame:CGRectMake(28, -1, settingImage.size.width, settingImage.size.height) imageNamed:@"setting"];
    settingImageView.tag = 100;
    [settingBtn addSubview:settingImageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
//    [settingItem addSubview:settingImage];
}

- (void)addLeftBarButton
{
    UIButton * btn = [(UIButton *)self.view viewWithTag:88];
    if (btn) {
        return;
    }
    //添加左边新建按钮（没有课程的时候不添加）
    UIButton * createCourseBtn = [[TalkfunButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44) title:@"新建" titleColor:BlueColor hightlightTitleColor:UIColorFromRGBHex(0x3b9bed) font:[UIFont systemFontOfSize:Nav_text_font_size] image:nil target:self selector:@selector(createBtnClicked:)];
    createCourseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    createCourseBtn.tag = 88;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:createCourseBtn];
}

- (void)createBtnDown:(UIButton *)btn
{
    btn.backgroundColor = UIColorFromRGBHex(0x56acf5);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)createBtnUp:(UIButton *)btn
{
    [btn setTitleColor:UIColorFromRGBHex(0x56acf5) forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
}

- (void)settingBtnHightLight:(UIButton *)btn
{
    UIImageView * imageView = [(UIImageView *)btn viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"setting_click"];
}

- (void)addNoCourseTips
{
    if (_dataSource && self.dataSource.count == 0) {
        //图片
        [self.view addSubview:self.classImageView];
        
        //暂无直播课程，试试新建直播
        [self.view addSubview:self.noCourseLabel];
        
        //新建按钮
        [self.view addSubview:self.createButton];
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)removeNoCourseTips
{
    PERFORM_IN_MAIN_QUEUE([_classImageView removeFromSuperview];
                          _classImageView = nil;
                          [_noCourseLabel removeFromSuperview];
                          _noCourseLabel = nil;
                          [_createButton removeFromSuperview];
                          _createButton = nil;
                          self.view.backgroundColor = UIColorFromRGBHex(0xf2f2f2);
                          [self addLeftBarButton];)
}

- (void)createBtnClicked:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
//    TalkfunCreateViewController * createController = [[TalkfunCreateViewController alloc] init];
//    [self.navigationController pushViewController:createController animated:YES];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGBHex(0x56acf5) forState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"createCourse" sender:self];
}

- (void)settingBtnClicked:(UIBarButtonItem *)item
{
    UIButton * btn = (UIButton *)item;
    UIImageView * imageView = [(UIImageView *)btn viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"setting"];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self performSegueWithIdentifier:@"setting" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TalkfunCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    
    TalkfunCourseModel * model = self.dataSource[indexPath.row];
    [cell configCellWithModel:model];
    
    cell.getInLiveBtn.tag = indexPath.row + 10000;
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunCourseModel * model = self.dataSource[indexPath.row];
    if ([model.status isEqualToString:@"3"]) {
        //已结束
        return 107;
    }
    else
    {
        return 122;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)getInLiveBtn:(UIButton *)sender {
    
    self.tableView.userInteractionEnabled = NO;
    NSLog(@"getintoLive:%ld",(long)sender.tag);

    WeakSelf
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block TalkfunLiveViewController * liveVC = [[TalkfunLiveViewController alloc] init];
    [self.course verifyLivingOrNot:^(id result) {

        if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
            PERFORM_IN_MAIN_QUEUE(liveVC.model = self.dataSource[sender.tag - 10000];
                                  [weakSelf.navigationController pushViewController:liveVC animated:YES];
                                  [weakSelf createDismissTimerWithTitle:@"验证成功"];)
        }
        else if ([result[@"code"] intValue] == TalkfunCodeInTheLive)
        {
            PERFORM_IN_MAIN_QUEUE([weakSelf presentViewController:weakSelf.tipsAlert animated:YES completion:nil];)
        }
        else
        {
            NSString * msg = result[@"msg"];
            if (msg) {
                PERFORM_IN_MAIN_QUEUE([weakSelf createDismissTimerWithTitle:msg];)
            }
        }
        dispatch_semaphore_signal(semaphore);
        weakSelf.tableView.userInteractionEnabled = YES;

    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

//创建timer
- (void)createDismissTimerWithTitle:(NSString *)title
{
    [self.view toast:title position:self.view.center];
    [self.dismissTimer invalidate];
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:ToastDuration target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}

- (void)hideToast
{
    [self.view untoast];
    
}
//加载上传gif动态图片
-(void)loadCADisplayLineImageView
{
   UIImageView* displayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width -60, self.view.frame.size.height -60-64, 45,45)];
    //    [displayImageView setCenter:self.view.center];
    displayImageView.image = [UIImage sd_animatedGIFNamed:@"uploadImage"];
    
    [self.view addSubview:displayImageView];
//    [displayImageView setImage:[CADisplayLineImage imageNamed:@"uploadImage.gif"]];
    
}

- (void)dealloc
{
    
}




@end
