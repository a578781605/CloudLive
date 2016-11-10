//
//  UIView+TalkfunActivityIndicator.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "UIView+TalkfunActivityIndicator.h"
#import <objc/runtime.h>

@implementation UIView (TalkfunActivityIndicator)

static NSString * alertKey = @"alertKey";

- (void)setAlertController:(UIAlertController *)alertController
{
    objc_setAssociatedObject(self, &alertKey, alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIAlertController *)alertController
{
    return objc_getAssociatedObject(self, &alertKey);
}

- (void)alert:(NSString *)title message:(NSString *)message
{
    self.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self.alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    UIViewController * vc = (UIViewController *)self.nextResponder;
    if (vc) {
        [vc presentViewController:self.alertController animated:YES completion:nil];
    }
}

//开始动画
- (void)startAnimation
{
    [self stopAnimation];
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.center.x, self.center.y - 50);
    indicator.tag = 991;
    indicator.color = UIColorFromRGBHex(0x333333);
    [self addSubview:indicator];
    [indicator startAnimation];
}

//结束动画
- (void)stopAnimation
{
    UIActivityIndicatorView * indicator = (UIActivityIndicatorView *)[self viewWithTag:991];
    [indicator stopAnimation];
    [indicator removeFromSuperview];
    indicator.tag = 991;
    indicator = nil;
}

//是否在动画
- (BOOL)isAnimating
{
    UIActivityIndicatorView * indicator = (UIActivityIndicatorView *)[self viewWithTag:991];
    if (!indicator) {
        return NO;
    }
    else
    {
        return indicator.isAnimating;
    }
}

static NSTimer * timer;

- (void)toast:(NSString *)string position:(CGPoint)position
{
    /*
    if ([self isToast]) {
        return;
    }
     */
    
    UIButton * button = [(UIButton *)self viewWithTag:989];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColorFromRGBHex(0x444444);
        [button setTitleColor:UIColorFromRGBHex(0xffffff) forState:UIControlStateNormal];
        button.layer.cornerRadius = 4;
        button.tag = 989;
        [button addTarget:self action:@selector(untoast) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    button.alpha = 1;
    
    NSArray * arr = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".?;'[]{}+_)(*&^%$#@!~`| \\。？：“？）（+——*&……%￥#@！~·"]];
    string = [arr componentsJoinedByString:@""];
   
    [button setTitle:string forState:UIControlStateNormal];
    CGRect rect = [TalkfunUtils getRectWithString:string size:CGSizeMake(SCREENWIDTH, 40) fontSize:15];
    button.frame = CGRectMake(0, 0, rect.size.width + 20, 38);
    
    if (CGPointEqualToPoint(position, CGPointZero)) {
        button.center = self.center;
    }
    else
    {
        button.center = position;
    }
    

    
    [self addSubview:button];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:ToastDuration target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    
}

- (void)hideToast
{
    [self untoast];
    [timer invalidate];
}

- (void)InitWithImage:(UIImage *)image position:(CGPoint)position
{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.frame =  CGRectMake(0, self.center.y - 40, 30, 30);
    imageView.tag = 999;
    
    [self addSubview:imageView];
    
}

- (UIButton *)getToastBtn
{
    UIButton * button = (UIButton *)[self viewWithTag:989];
    return button;
}

- (UIImageView*)getToastImageView
{
    
    UIImageView * ImageView = (UIImageView *)[self viewWithTag:999];
    
    return ImageView;
}

- (void)untoast
{
    __block UIButton * button = (UIButton *)[self viewWithTag:989];
    [UIView animateWithDuration:DismissToastDuration animations:^{
        button.alpha = 0;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];
}

- (BOOL)isToast
{
    UIButton * button = (UIButton *)[self viewWithTag:989];
    if (button.alpha == 0) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (UIView *)networkUnusualView
{
    if ([self containsNetworkUnusualView]) {
        UIView * view = [self viewWithTag:777];
        return view;
    }
    UIView * networkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    networkView.tag = 777;
    networkView.backgroundColor = UIColorFromRGBHex(0xfff1da);
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pop up_warning"]];
    imageView.frame = CGRectMake(36 * WidthRatio, (44 - 22) / 2, 22, 22);
    [networkView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 12 * WidthRatio, CGRectGetMinY(imageView.frame), CGRectGetWidth(self.frame) - (CGRectGetMaxX(imageView.frame) + 12 * WidthRatio), 22)];
    label.text = @"当前网络异常，请检查你的网络设置";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColorFromRGBHex(0x666666);
    
    [networkView addSubview:label];
    
    return networkView;
}

- (void)removeNetworkUnusualView
{
    UIView * view = [self viewWithTag:777];
    if (view.superview || view) {
        [view removeFromSuperview];
        view = nil;
    }
}

- (BOOL)containsNetworkUnusualView
{
    UIView * view = [self viewWithTag:777];
    if (view) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end

