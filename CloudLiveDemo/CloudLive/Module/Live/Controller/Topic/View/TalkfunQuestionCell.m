//
//  TalkfunQuestionCell.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunQuestionCell.h"
#import "TalkfunQuestionModel.h"
#import "UIImageView+WebCache.h"

@interface TalkfunQuestionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameAndTime;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation TalkfunQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(TalkfunQuestionModel *)model
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
    
    
//    NSTimeZone * zone = [NSTimeZone systemTimeZone];
//    NSTimeInterval timeInterval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[model.time longLongValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString * time = [formatter stringFromDate:date];
    
    //开始拼名字跟时间
    NSDictionary * attributeDict = @{NSForegroundColorAttributeName:UIColorFromRGBHex(0x666666)};
    NSMutableAttributedString * nameTimeAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.nickname] attributes:attributeDict];
    
    if (attach.image) {
        attach.bounds = CGRectMake(0, -2, attach.image.size.width, attach.image.size.height);
        [nameTimeAttr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    }
    
    NSAttributedString * timeAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",time] attributes:@{NSForegroundColorAttributeName:UIColorFromRGBHex(0xaaaaaa)}];
    [nameTimeAttr appendAttributedString:timeAttr];
    
    self.nameAndTime.attributedText = nameTimeAttr;
    
    
    //开始内容拼接
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIColorFromRGBHex(0x333333)};
    
    NSMutableAttributedString * attributeContent = [[NSMutableAttributedString alloc] initWithString:model.content attributes:attribute];
    
    [attributeContent appendAttributedString:[[NSAttributedString alloc] initWithString:@"   回复" attributes:@{NSForegroundColorAttributeName:BlueColor}]];
    
    NSArray * answerArr = model.answer;
    for (int i = 0; i < answerArr.count; i ++) {
        TalkfunReplyModel * replyModel = answerArr[i];
//        if (i == 0) {
//            [attributeContent appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
//        }
        NSString * role = @"老师";
        if ([replyModel.role isEqualToString:TalkfunMemberRoleAdmin]) {
            role = @"助教";
        }
        NSAttributedString * aNickname = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n[%@]: ",role] attributes:@{NSForegroundColorAttributeName:BlueColor,NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        NSAttributedString * aContent = [[NSAttributedString alloc] initWithString:replyModel.content attributes:attribute];
        [attributeContent appendAttributedString:aNickname];
        [attributeContent appendAttributedString:aContent];
    }
    NSRange range2 = [attributeContent.string rangeOfString:model.content];
    if (range2.location != NSNotFound) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphSpacing:8];
        [paragraphStyle setParagraphSpacingBefore:1];
//        [paragraphStyle setLineSpacing:8];
        [attributeContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(range2.location, attributeContent.length - range2.location)];
    }
    
    self.content.attributedText = attributeContent;
    
}

@end
