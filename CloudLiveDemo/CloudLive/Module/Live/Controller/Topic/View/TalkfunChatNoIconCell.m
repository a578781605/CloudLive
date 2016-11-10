//
//  TalkfunChatNoIconCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunChatNoIconCell.h"
#import "TalkfunChatModel.h"

@interface TalkfunChatNoIconCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end

@implementation TalkfunChatNoIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(TalkfunChatModel *)model
{
    if ([model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
        self.name.textColor = UIColorFromRGBHex(0xf34747);
    }
    else if ([model.role isEqualToString:TalkfunMemberRoleAdmin])
    {
        self.name.textColor = UIColorFromRGBHex(0xfea61a);
    }
    else
    {
        self.name.textColor = BlueColor;
    }
    self.name.text = model.nickname;
    CGRect rect = [TalkfunUtils getRectWithString:self.name.text size:CGSizeMake(self.frame.size.width, CGRectGetHeight(self.name.frame)) fontSize:14];
    self.nameWidthConstraint.constant = rect.size.width;
    
//    self.content.text = @":  奥数的房间爱老师厉害2afjlhjkjhlkjk";
    
    CGRect frame = [TalkfunUtils getRectWithString:model.nickname size:CGSizeMake(CGRectGetWidth(self.frame), 25) fontSize:14];
    
    NSDictionary * info = [TalkfunUtils assembleAttributeString:model.msg boundingSize:CGSizeMake(CGRectGetWidth(self.frame) - CGRectGetWidth(frame), 9999) fontSize:14 shadow:YES];
    
    NSAttributedString * attr = info[AttributeStr];
    self.content.attributedText = attr;
    
}

@end
