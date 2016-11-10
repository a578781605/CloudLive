//
//  TalkfunSettingViewController.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunSettingViewController.h"
#import "TalkfunClearCacheCell.h"
#import "TalkfunSetting.h"
#import "TalkfunCloudLive.h"
#import "TalkfunSettingBeautyCell.h"
#import "TalkfunUploadVideoCell.h"
#import "TalkfunUploadVideoController.h"
#import "UIView+XMGExtension.h"
#import "AppDelegate.h"



@interface TalkfunSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *toastBtn;
@property (nonatomic,strong) NSTimer * dismissTimer;
@property (nonatomic,strong) UIAlertController * logoutSheet;
//@property (nonatomic,strong) UIActionSheet * sheet;



@end

@implementation TalkfunSettingViewController

//- (UIActionSheet *)sheet
//{
//    if (!_sheet) {
//        _sheet = [[UIActionSheet alloc] initWithTitle:@"jalwejf" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"destruc" otherButtonTitles:nil, nil];
//    }
//    return _sheet;
//}

- (UIAlertController *)logoutSheet
{
    if (!_logoutSheet) {
        if (ISIPAD) {
            _logoutSheet = [UIAlertController alertControllerWithTitle:@"确定要退出当前账号?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        }
        else
        {
            _logoutSheet = [UIAlertController alertControllerWithTitle:@"确定要退出当前账号?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        }
        
        __weak typeof(self) weakSelf = self;
        [_logoutSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            [[[TalkfunCloudLive alloc] init] logout];
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"logout");
        }]];
        [_logoutSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        
    }
    return _logoutSheet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    
    
    self.logoutBtn.layer.borderWidth = 1;
    self.logoutBtn.layer.borderColor = UIColorFromRGBHex(0xd5d5d5).CGColor;
    
    

}
// 控制器的view即将显示的时候调用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentTalkfunUploadVideoController) name:@"presentTalkfunUploadVideoController" object:nil];
}

//- (void)presentTalkfunUploadVideoController
//{TalkfunUploadVideoController *vc = [[TalkfunUploadVideoController alloc]init];
//    vc.view.backgroundColor = [UIColor whiteColor];
//   [self.navigationController pushViewController:vc animated:YES];
//    
//}
- (IBAction)toastBtnClicked:(UIButton *)sender {
    
    [self hideToast];
}

- (IBAction)logoutBtnClicked:(UIButton *)sender {
    
//    [self.sheet showInView:self.view];
    if([[UIDevice currentDevice].model hasPrefix:@"iPad"])
    {
        UIPopoverPresentationController *popPresenter = [self.logoutSheet
                                                         popoverPresentationController];
        
        popPresenter.sourceView = sender;
        popPresenter.sourceRect = sender.bounds;
        [self.navigationController presentViewController:self.logoutSheet animated:YES completion:nil];
    }
    else
        [self.navigationController presentViewController:self.logoutSheet animated:YES completion:nil];
}

//隐藏toastbtn
- (void)hideToast
{
    [UIView animateWithDuration:DismissToastDuration animations:^{
        self.toastBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
    }];
}
//创建timer
- (void)createDismissTimer
{
    self.toastBtn.alpha = 0.7;
    [self.dismissTimer invalidate];
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:ToastDuration target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    
    if (indexPath.row == 0) {
        TalkfunClearCacheCell * cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        if (!cell) {
            cell = [[TalkfunClearCacheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger size = [[[TalkfunSetting alloc] init] getCacheSize];
        [cell configCellWithDictionary:@{@"size":@(size)}];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        TalkfunSettingBeautyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"beautyCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunSettingBeautyCell" owner:nil options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 2)
    {
        TalkfunUploadVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UploadVideo"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunUploadVideoCell" owner:nil options:nil][0];
            
        
            
        }
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [[[TalkfunSetting alloc] init] clearCache];
        [tableView reloadData];
        [self createDismissTimer];
    }
    
    if(indexPath.row == 2) {
        TalkfunUploadVideoController *vc = [[TalkfunUploadVideoController alloc]init];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
//  控制器的view即将消失的时候调用
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end
