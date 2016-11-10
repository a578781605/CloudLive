//
//  TalkfunScheduleButton.m
//  CloudLive
//
//  Created by moruiwei on 16/11/4.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunScheduleButton.h"
#import "UIView+XMGExtension.h"
#define UIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface TalkfunScheduleButton ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end
@implementation TalkfunScheduleButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_progress>0) {
        self.imageView.x = self.width/2 - (self.imageView.image.size.width/2)+1.5;
    }
    
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];

self.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    
  [self setTitleColor:UIColorFromRGBHex(0x14c864) forState:UIControlStateNormal];

}


- (void)drawProgress:(CGFloat )progress
{
    _progress = progress;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    if(_progress==0){
        
        [self setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
        
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center1 = CGPointMake(self.width/2, self.width/2);  //设置圆心位置
    CGFloat radius1 = 17.5;  //设置半径
    CGFloat startA1 = - M_PI_2;  //圆起点位置
    CGFloat endA1 = -M_PI_2 + M_PI * 2 * 1;  //圆终点位置
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center1 radius:radius1 startAngle:startA1 endAngle:endA1 clockwise:YES];
    
    CGContextSetLineWidth(ctx, 1.8); //设置线条宽度
    
    [UIColorFromRGBHex(0xaaaaaa) setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path1.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);
    
    
    
    CGPoint center = CGPointMake(self.width/2, self.width/2);  //设置圆心位置
    CGFloat radius = 18;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 1.8); //设置线条宽度
    
    [UIColorFromRGBHex(0x14c864) setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
    
}
/**
 *  重写这个方法的目的:去掉高亮状态所做的一切操作
 */
- (void)setHighlighted:(BOOL)highlighted {}
@end
