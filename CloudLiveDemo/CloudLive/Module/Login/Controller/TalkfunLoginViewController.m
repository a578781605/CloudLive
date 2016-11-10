//
//  ViewController.m
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/16.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunLoginViewController.h"
#import "TalkfunCloudLive.h"
#import "TalkfunLoginNavigationController.h"
#import "TalkfunCourseViewController.h"

@interface TalkfunLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordViewVerticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toastBtnWidthConstraint;

@property (weak, nonatomic) IBOutlet UITextField *anchorIDTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *customerServiceBtn;
@property (nonatomic,strong) UIAlertController * customerServiceAlert;
@property (nonatomic,strong) NSTimer * dismissTimer;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
//登录逻辑
@property (nonatomic,strong) TalkfunCloudLive * login;
@end

@implementation TalkfunLoginViewController

- (TalkfunCloudLive *)login
{
    if (!_login) {
        _login = [[TalkfunCloudLive alloc] init];
    }
    return _login;
}

- (UIAlertController *)customerServiceAlert
{
    if (!_customerServiceAlert) {
        _customerServiceAlert = [UIAlertController alertControllerWithTitle:@"联系客服" message:@"电话：400-100-8532\nQQ：2848890180\n邮箱：sales@talk-fun.com" preferredStyle:UIAlertControllerStyleAlert];
        [_customerServiceAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
        
    }
    return _customerServiceAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoVerticalSpace.constant = HeightRatio * self.logoVerticalSpace.constant;
    self.passwordViewVerticalSpace.constant *= HeightRatio;
    
    id obj = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"@云直播 %@",obj];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id ID = [self.login getID];
    if (ID) {
        self.anchorIDTF.text = [NSString stringWithFormat:@"%@",ID];
    }
    if ([self.login isLogin]) {
        self.autoLogin = YES;
        [self performSegueWithIdentifier:@"login" sender:self];
        WeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.coverView removeFromSuperview];
            weakSelf.autoLogin = NO;
        });
        
    }
    else
    {
        [self.coverView removeFromSuperview];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.coverView removeFromSuperview];
    self.autoLogin = NO;
    self.passwordTF.text = nil;
}

//MARK:按钮点击事件
//登录按钮
- (IBAction)loginBtnClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.anchorIDTF.text.length == 0) {
        [self createDismissTimerWithTitle:@"主播ID不能为空"];
    }
    else if (self.passwordTF.text.length == 0)
    {
        [self createDismissTimerWithTitle:@"密码不能为空"];
    }
    else
    {
        [self.view startAnimation];
        WeakSelf
        [self.login login:self.anchorIDTF.text password:self.passwordTF.text callback:^(id result){
            
            if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                
                PERFORM_IN_MAIN_QUEUE([weakSelf performSegueWithIdentifier:@"login" sender:weakSelf];

            [weakSelf.view stopAnimation];)
            }
            else
            {
                NSLog(@"login result:%@",[result objectForKey:@"msg"]);
                PERFORM_IN_MAIN_QUEUE(if ([result[@"msg"] isKindOfClass:[NSString class]]) {
                    NSString * msg = result[@"msg"];
                    [weakSelf createDismissTimerWithTitle:msg];
                    [weakSelf.view stopAnimation];
                })
                
            }
            
        }];
    }
}

//MARK:传参
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    TalkfunLoginNavigationController *navController = segue.destinationViewController;
//    UIViewController * destinationVC = segue.destinationViewController;
//    [self.navigationController pushViewController:destinationVC animated:NO];
    
}

//联系客服按钮
- (IBAction)customerServiceBtnClicked:(UIButton *)sender {
    
    [self presentViewController:self.customerServiceAlert animated:YES completion:nil];
    
}

//隐藏toastbtn
- (void)hideToast
{
    UIButton * toastBtn = [self.view getToastBtn];
    [UIView animateWithDuration:DismissToastDuration animations:^{
        toastBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
    }];
}
//创建timer
- (void)createDismissTimerWithTitle:(NSString *)title
{
    UIButton * toastBtn = [self.view getToastBtn];
    [self.view toast:title position:CGPointMake(self.view.center.x, self.view.center.y + 100)];

    toastBtn.alpha = 1;
    [self.dismissTimer invalidate];
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:ToastDuration target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.anchorIDTF.isFirstResponder) {
        [self.passwordTF becomeFirstResponder];
    }
    else if (self.passwordTF.isFirstResponder)
    {
        [self loginBtnClicked:nil];
    }
    return YES;
}

@end
