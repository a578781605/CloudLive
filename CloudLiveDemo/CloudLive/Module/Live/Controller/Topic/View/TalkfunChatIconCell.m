//
//  TalkfunChatIconCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunChatIconCell.h"
#import "TalkfunChatModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TalkfunChatIconCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameAndTime;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end

@implementation TalkfunChatIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(TalkfunChatModel *)model
{
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    UIImage *image;
    if ([model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
        image = [UIImage imageNamed:@"老师"];
        attach.image = [UIImage imageNamed:@"老师标签"];
    }
    else if ([model.role isEqualToString:TalkfunMemberRoleAdmin])
    {
        image = [UIImage imageNamed:@"助教"];
        attach.image = [UIImage imageNamed:@"助教标签"];
    }
    else
    {
        image = [UIImage imageNamed:@"学生"];
    }
    
    self.icon.layer.cornerRadius = 27 / 2.0;
    self.icon.clipsToBounds = YES;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:image];
    
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIColorFromRGBHex(0x666666)};
    NSMutableAttributedString * nameTimeAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.nickname] attributes:attribute];
    
    if (attach.image) {
        attach.bounds = CGRectMake(0, -2, attach.image.size.width, attach.image.size.height);
        [nameTimeAttr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * dateStr;
    if (model.sendtime) {
        dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.sendtime longLongValue]]];
        
    }
    else
    {
        
        dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.time longLongValue]]];
    }
    
    NSAttributedString * timeAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",dateStr] attributes:@{NSForegroundColorAttributeName:UIColorFromRGBHex(0xaaaaaa)}];
    [nameTimeAttr appendAttributedString:timeAttr];
    
    self.nameAndTime.attributedText = nameTimeAttr;
    
    NSDictionary * info = [TalkfunUtils assembleAttributeString:model.msg boundingSize:CGSizeMake(CGRectGetWidth(self.frame) - 55, 9999) fontSize:14 shadow:NO];
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithAttributedString:info[AttributeStr]];
    [attr deleteCharactersInRange:NSMakeRange(0, 2)];
    self.content.attributedText = attr;
    
}

@end
