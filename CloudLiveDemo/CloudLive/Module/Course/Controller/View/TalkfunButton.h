//
//  TalkfunButton.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunButton : UIButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor target:(id)target selector:(SEL)selector;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor hightlightTitleColor:(UIColor *)hightlightTitleColor font:(UIFont *)font image:(UIImage *)image target:(id)target selector:(SEL)selector;

@end
