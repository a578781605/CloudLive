//
//  TalkfunCreateCourseController.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunCreateCourseController.h"
#import "TalkfunCourse.h"

#define MAX_STARWORDS_LENGTH 20

@interface TalkfunCreateCourseController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong) UIAlertController * cancelSheet;
@property (weak, nonatomic) IBOutlet UIView *tfContainView;
@property (weak, nonatomic) IBOutlet UITextField *addThemeTF;
@property (weak, nonatomic) IBOutlet UILabel *charaterNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UIView *dataPickerContainView;
@property (nonatomic,strong) NSTimer * dismissTimer;
@property (nonatomic,strong) NSDate * startTime;
@property (nonatomic,strong) NSDate * endTime;
@property (nonatomic,strong) TalkfunCourse * course;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (nonatomic,strong) UIAlertController * tipsAlert;

@end

@implementation TalkfunCreateCourseController

- (UIAlertController *)tipsAlert
{
    if (!_tipsAlert) {
        _tipsAlert = [UIAlertController alertControllerWithTitle:@"创建失败" message:@"该账号当前有其他人在直播中" preferredStyle:UIAlertControllerStyleAlert];
        [_tipsAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _tipsAlert;
}

- (TalkfunCourse *)course
{
    if (!_course) {
        _course = [[TalkfunCourse alloc] init];
    }
    return _course;
}

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
        
        __weak typeof(self) weakSelf = self;
        [_cancelSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [_cancelSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _cancelSheet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = UIColorFromRGBHex(0x999999);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked:)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.datePicker.minimumDate = [NSDate date];
    
//    self.addThemeTF.delegate = nil;
//    [_addThemeTF addObserver:self forKeyPath:@"text.length" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification object:self.addThemeTF];
    
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    
//}

- (void)cancelBtnClicked:(UIButton *)btn
{
    if (self.addThemeTF.text.length != 0 || self.endTimeTF.text.length != 0 || self.startTimeTF.text.length != 0) {
        [self presentViewController:self.cancelSheet animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)toastBtnClicked:(UIButton *)sender {
    
    [self hideToast];
}
- (IBAction)pickCancelClicked:(UIButton *)sender {
    
    [self hideDatePicker];
}
- (IBAction)ensureBtnClicked:(UIButton *)sender {
    
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    
    [forMatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *dateStr = [forMatter stringFromDate:self.datePicker.date];
    
//    NSTimeInterval timestamp = [self.datePicker.date timeIntervalSince1970];
    
//    NSDate * time = [forMatter dateFromString:dateStr];
//    
//    NSLog(@"timestamp:%ld time:%@",(NSInteger)timestamp,time);
    
    if (self.startTimeTF.layer.cornerRadius != 0) {
        self.startTimeTF.text = dateStr;
        self.startTime = self.datePicker.date;
    }
    else
    {
        self.endTimeTF.text = dateStr;
        self.endTime = self.datePicker.date;
    }
    
    [self hideDatePicker];
}
- (IBAction)createCourseBtnClicked:(UIButton *)sender {
    
    if (self.addThemeTF.text.length == 0)
    {
        [self createDismissTimerWithTitle:@"直播主题不能为空"];
    }
    else if (self.startTimeTF.text.length == 0) {
        [self createDismissTimerWithTitle:@"开始时间不能为空"];
    }
    else if (self.endTimeTF.text.length == 0)
    {
        [self createDismissTimerWithTitle:@"结束时间不能为空"];
    }
    else if ([[self.startTime dateByAddingTimeInterval:600] compare:[NSDate date]] == NSOrderedAscending)
    {
        [self createDismissTimerWithTitle:@"开始时间小于现在的时间"];
    }
    else if ([self.startTime compare:self.endTime] != NSOrderedAscending)
    {
        [self createDismissTimerWithTitle:@"开始时间不能大于或等于结束时间"];
    }
//    else if ([self.endTime compare:[NSDate date]] != NSOrderedDescending)
//    {
//        [self createDismissTimerWithTitle:@"时间设置错误"];
//    }
    else if (!self.view.isAnimating) {
        [self.view startAnimation];
        
        WeakSelf
        NSString * startTime = [self getDateStringWithDate:self.startTime];
        NSString * endTime = [self getDateStringWithDate:self.endTime];
        [self.course addCourse:self.addThemeTF.text startTime:startTime endTime:endTime callback:^(id result) {
            
            if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                PERFORM_IN_MAIN_QUEUE([weakSelf createDismissTimerWithTitle:@"创建成功"];
                                      [weakSelf.view stopAnimation];)
            }
            else
            {
                NSString * msg = result[@"msg"];
                NSLog(@"createResult:%@",msg);
                PERFORM_IN_MAIN_QUEUE(weakSelf.tipsAlert.message = msg;
                                      [weakSelf presentViewController:weakSelf.tipsAlert animated:YES completion:nil];
//                                      [weakSelf createDismissTimerWithTitle:msg];
                                      [weakSelf.view stopAnimation];)
            }
        }];
        
    }
    
}

- (NSString *)getDateStringWithDate:(NSDate *)date
{
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    
    [forMatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateStr = [forMatter stringFromDate:date];
    
    return dateStr;
}

//显示时间选择
- (void)showDatePicker
{
    if (self.dataPickerContainView.alpha == 1) {
        return;
    }
    self.dataPickerContainView.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.dataPickerContainView.frame;
        frame.origin.y -= frame.size.height;
        self.dataPickerContainView.frame = frame;
    }];
}
//隐藏时间选择
- (void)hideDatePicker
{
    [self changeColorOfTextField:self.startTimeTF select:NO];
    [self changeColorOfTextField:self.endTimeTF select:NO];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.dataPickerContainView.frame;
        frame.origin.y += frame.size.height;
        self.dataPickerContainView.frame = frame;
        self.dataPickerContainView.alpha = 0.0;
    }];
}
//隐藏toastbtn
- (void)hideToast
{
    UIButton * toastBtn = [self.view getToastBtn];
    [UIView animateWithDuration:DismissToastDuration animations:^{
        toastBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
        if ([toastBtn.titleLabel.text isEqualToString:@"创建成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
//创建timer
- (void)createDismissTimerWithTitle:(NSString *)title
{
    //[self.toastBtn setTitle:title forState:UIControlStateNormal];
    [self.view toast:title position:CGPointMake(self.view.center.x, self.view.center.y + 100)];
    //CGRect rect = [TalkfunTools getRectWithString:title size:CGSizeMake(SCREENWIDTH, 40) fontSize:15];
    //self.toastBtnWidthConstraint.constant = rect.size.width + 40;
    //self.toastBtn.alpha = 0.7;
    [self.dismissTimer invalidate];
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:ToastDuration target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}
//改变日期输入框颜色
- (void)changeColorOfTextField:(UITextField *)textField select:(BOOL)select
{
    if (select) {
        textField.layer.borderColor = BlueColor.CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 4;
    }
    else
    {
        textField.layer.borderColor = nil;
        textField.layer.borderWidth = 0;
        textField.layer.cornerRadius = 0;
    }
}

#pragma mark text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ((textField == self.startTimeTF || textField == self.endTimeTF) && !self.addThemeTF.isFirstResponder) {
        [self.addThemeTF resignFirstResponder];
        
        [self changeColorOfTextField:self.startTimeTF select:NO];
        [self changeColorOfTextField:self.endTimeTF select:NO];
        [self.view endEditing:YES];
        [self changeColorOfTextField:textField select:YES];
        if (textField == self.endTimeTF && self.startTimeTF.text.length != 0) {
            self.datePicker.minimumDate = self.startTime;
        }
        else
        {
            self.datePicker.minimumDate = [NSDate date];
        }
        [self showDatePicker];
        return NO;
    }
    else
    {
        self.charaterNumLabel.hidden = NO;
        self.startTimeTF.userInteractionEnabled = NO;
        self.endTimeTF.userInteractionEnabled = NO;
        [self changeColorOfTextField:self.startTimeTF select:NO];
        [self changeColorOfTextField:self.endTimeTF select:NO];
        [self hideDatePicker];
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.charaterNumLabel.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (self.dataPickerContainView.alpha == 1) {
//        [self hideDatePicker];
//    }
    [self.view endEditing:YES];
    self.startTimeTF.userInteractionEnabled = YES;
    self.endTimeTF.userInteractionEnabled = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.addThemeTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Notification Method
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSInteger num = 20 - toBeString.length;
    if (num > 20) {
        num = 20;
    }else if (num < 0){
        num = 0;
    }
    
    self.charaterNumLabel.text = [NSString stringWithFormat:@"%ld",num];
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
