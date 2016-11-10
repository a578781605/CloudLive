//
//  MInPPTViewCell.m
//  CloudLive
//
//  Created by moruiwei on 16/8/26.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunWhiteboardSliderCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
//#import "PPTModel.h"
#import "MJExtension.h"
@implementation TalkfunWhiteboardSliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



/**
 *  设置子控件显示的数据
 */
- (void)setCurrent:(NSMutableDictionary *)current{
    
    _current = current;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor whiteColor];

    self.page.layer.cornerRadius = 8;
    self.page.layer.masksToBounds = YES;
    if ([current objectForKey:@"thumbnail"]) {
    
        NSString *url = [current objectForKey:@"thumbnail" ];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];

    }

    if([current objectForKey:@"backgroundColor"] && [[current objectForKey:@"backgroundColor"] isEqualToString:@"1"]){
 
        self.backgroundColor = [UIColor colorWithRed:64 / 255.0 green:169 / 255.0 blue:249 / 255.0 alpha:1];
    }
    else{
         self.backgroundColor = [UIColor clearColor];
    }
    self.page.text = [NSString stringWithFormat:@"%@",[current objectForKey:@"page"]];

}
@end
