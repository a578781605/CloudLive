//
//  TalkfunQuestionViewController.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunQuestionViewController.h"
#import "TalkfunQuestionModel.h"
#import "TalkfunQuestionCell.h"


@interface TalkfunQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation TalkfunQuestionViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 61;
//    self.tableView.estimatedRowHeight = 100;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(question:) name:TALKFUN_NOTIFICATION_QUESTION_ASK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reply:) name:TALKFUN_NOTIFICATION_QUESTION_REPLY object:nil];
}

- (void)question:(NSNotification *)notification
{
    TalkfunQuestionModel * model = [TalkfunQuestionModel mj_objectWithKeyValues:notification.userInfo];
    [self.dataSource addObject:model];
    [self reloadData];
}

- (void)reply:(NSNotification *)notification
{
    NSDictionary * replyDict = notification.userInfo;
    NSNumber * replyId = replyDict[@"replyId"];
    for (int i = 0; i < self.dataSource.count; i ++) {
        TalkfunQuestionModel * model = self.dataSource[i];
        if ([model.qid isEqualToNumber:replyId]) {
            
            NSMutableArray * mutableArr = [NSMutableArray arrayWithArray:model.answer];
            NSMutableDictionary * question = [NSMutableDictionary dictionaryWithDictionary:replyDict];
            [question removeObjectForKey:@"question"];
            TalkfunReplyModel * replyModel = [TalkfunReplyModel mj_objectWithKeyValues:question];
            [mutableArr addObject:replyModel];
//            [mutableArr addObject:question];
            model.answer = mutableArr;
            [self.dataSource replaceObjectAtIndex:i withObject:model];
            
            break;
        }
    }
    if (self.dataSource.count != 0) {
        [self reloadData];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TalkfunQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunQuestionCell" owner:nil options:nil][0];
    }
    
    TalkfunQuestionModel * model = self.dataSource[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunQuestionModel * model = self.dataSource[indexPath.row];
    NSArray * replyArr = model.answer;
    NSInteger enterNum = 0;
    for (int i = 0; i < replyArr.count; i ++) {
        TalkfunReplyModel * replyModel = replyArr[i];
        CGRect frame = [TalkfunUtils getRectWithString:[NSString stringWithFormat:@"[老师]: %@",replyModel.content] size:CGSizeMake(self.view.frame.size.width - 55, 999) fontSize:14];
        enterNum += frame.size.height / 17;
    }
    CGRect rect = [TalkfunUtils getRectWithString:[NSString stringWithFormat:@"%@   回复",model.content] size:CGSizeMake(self.view.frame.size.width - 55, 999) fontSize:14];
    
    return rect.size.height + 36 + 13.9 * (enterNum + replyArr.count);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunQuestionModel * model = self.dataSource[indexPath.row];
    if (self.replyBtnBlock) {
        self.replyBtnBlock(model);
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
