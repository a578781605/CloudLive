//
//  TalkfunScheduleView.m
//  CloudLive
//
//  Created by moruiwei on 16/11/4.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunScheduleView.h"

#define UIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface TalkfunScheduleView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end
@implementation TalkfunScheduleView
- (UILabel *)label
{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 31, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        label.font = [UIFont boldSystemFontOfSize:10];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

- (void)drawProgress:(CGFloat )progress
{
    
    
    NSLog(@"=========%f",progress);
    _progress = progress/100;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(19, 19);  //设置圆心位置
    CGFloat radius = 19;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 3); //设置线条宽度
    
    [UIColorFromRGBHex(0x14c864) setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
    
}

@end
