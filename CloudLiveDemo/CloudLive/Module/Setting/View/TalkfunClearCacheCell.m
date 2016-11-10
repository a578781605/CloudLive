//
//  TalkfunClearCacheCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/23.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunClearCacheCell.h"

@implementation TalkfunClearCacheCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configCellWithDictionary:(NSDictionary *)dictionary
{
    self.textLabel.text = @"清除缓存";
    self.textLabel.font = [UIFont systemFontOfSize:16];
    NSString * sizeStr = [TalkfunUtils fileSizeWithInterge:[dictionary[@"size"] integerValue]];
    CGRect rect = [TalkfunUtils getRectWithString:sizeStr size:CGSizeMake(100, 44) fontSize:16];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 25, 44)];
    label.text = sizeStr;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGBHex(0xaaaaaa);
    UIImage * image = [UIImage imageNamed:@"btn_more"];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) - image.size.width, (CGRectGetHeight(label.frame) - image.size.height) / 2, image.size.width, image.size.height)];
    imageView.image = image;
    [label addSubview:imageView];
    self.accessoryView = label;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
