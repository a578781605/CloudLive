//
//  TalkfunChatViewController.m
//  CloudLive
//
//  Created by 孙兆能 on 16/8/31.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunChatViewController.h"
#import "TalkfunChatModel.h"
#import "TalkfunChatIconCell.h"
#import "TalkfunChatNoIconCell.h"

#define ButtonWidth  35
#define ButtonHeight 35

@interface TalkfunChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIButton * chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineNumLabelWidthConstraint;

@end

@implementation TalkfunChatViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UIButton *)chatBtn
{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatBtn.layer.cornerRadius = ButtonHeight / 2;
        
        _chatBtn.backgroundColor = BlueColor;
        [_chatBtn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.alpha = 0.9;
        [self.view addSubview:_chatBtn];
    }
    return _chatBtn;
}

- (void)chatBtnClicked:(UIButton *)btn
{
    if (self.chatBtnBlock) {
        self.chatBtnBlock();
    }
}

- (void)setContainsCamera:(BOOL)containsCamera
{
    if (_containsCamera != containsCamera) {
        _containsCamera = containsCamera;
        [self setTableviewStyle:containsCamera];
        [self reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 25;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    self.onlineLabel.layer.cornerRadius = 25 / 2.0;
    self.onlineLabel.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chat:) name:TALKFUN_NOTIFICATION_CHAT_SEND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineTotal:) name:TALKFUN_NOTIFICATION_TOTAL_ONLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flower:) name:TALKFUN_NOTIFICATION_FLOWER_SEND object:nil];
    
    self.containsCamera = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.chatBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 12 - ButtonWidth, CGRectGetHeight(self.view.frame) - 12 - ButtonHeight, 35, 35);
    [self.chatBtn setImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
    [self.chatBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    [self.view addSubview:self.onlineLabel];
    
    [self setTableviewStyle:self.containsCamera];
    
}

- (void)flower:(NSNotification *)notification
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
    if ([dict[@"amount"] intValue]) {
        NSMutableString * msg = [NSMutableString new];
        for (int i = 0; i < [dict[@"amount"] intValue]; i ++) {
            [msg appendString:@"[rose]"];
        }
        [dict setObject:msg forKey:@"msg"];
    }
    TalkfunChatModel * model = [TalkfunChatModel mj_objectWithKeyValues:dict];
    [self.dataSource addObject:model];
    if (self.dataSource.count > 20) {
        [self.dataSource removeObjectAtIndex:0];
    }
    
    [self reloadData];
}

- (void)onlineTotal:(NSNotification *)notification
{
    NSString * total = notification.userInfo[@"total"];
    self.onlineLabel.text = [NSString stringWithFormat:@"在线 %@ 人",total];
    CGRect rect = [TalkfunUtils getRectWithString:self.onlineLabel.text size:CGSizeMake(200, 25) fontSize:11];
    self.onlineNumLabelWidthConstraint.constant = CGRectGetWidth(rect) + 24;
}

- (void)chat:(NSNotification *)notification
{
    TalkfunChatModel * model = [TalkfunChatModel mj_objectWithKeyValues:notification.userInfo];
    
    [self.dataSource addObject:model];
    if (self.dataSource.count > 20) {
        [self.dataSource removeObjectAtIndex:0];
    }
    
    [self reloadData];
}

- (void)reloadData
{
    if (self.dataSource.count != 0) {
        self.tableView.contentInset = UIEdgeInsetsZero;
        [self.tableView reloadData];
        
        if (self.containsCamera && self.tableView.contentSize.height < CGRectGetHeight(self.view.frame) * 0.4) {
            self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.view.frame) * 0.4 - self.tableView.contentSize.height, 0, 0, 0);
        }
        else
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

- (void)setTableviewStyle:(BOOL)containCamera
{
    if (!containCamera) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        CGRect frame = self.view.frame;
        frame.size.height -= 44;
        self.tableView.frame = frame;
        self.chatBtn.hidden = YES;
    }
    else
    {
        self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) * 0.6, self.view.frame.size.width, CGRectGetHeight(self.view.frame) * 0.4);
        self.tableView.backgroundColor = [UIColor clearColor];
        self.chatBtn.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.containsCamera) {
        TalkfunChatNoIconCell * cell = [tableView dequeueReusableCellWithIdentifier:@"noIconChat"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunChatNoIconCell" owner:nil options:nil][0];
        }
        
        TalkfunChatModel * model = self.dataSource[indexPath.row];
        [cell configCellWithModel:model];
        
        return cell;
    }
    else
    {
        TalkfunChatIconCell * cell = [tableView dequeueReusableCellWithIdentifier:@"iconChat"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunChatIconCell" owner:nil options:nil][0];
        }
        
        TalkfunChatModel * model = self.dataSource[indexPath.row];
        [cell configCellWithModel:model];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunChatModel * model = self.dataSource[indexPath.row];
    
    CGRect frame = [TalkfunUtils getRectWithString:model.nickname size:CGSizeMake(CGRectGetWidth(self.tableView.frame), 25) fontSize:14];
    
    if (self.containsCamera) {
        NSDictionary * info = [TalkfunUtils assembleAttributeString:model.msg boundingSize:CGSizeMake(CGRectGetWidth(self.tableView.frame) - CGRectGetWidth(frame) - 10 - 60, 9999) fontSize:14 shadow:NO];
        
        NSString * rectStr = info[TextRect];
        CGRect rect = CGRectFromString(rectStr);
        CGFloat height = CGRectGetHeight(rect) + CGRectGetHeight(rect) / 25 * 5;
        if (height < 25) {
            height = 25;
        }
        return height;
    }
    else
    {
        NSDictionary * info = [TalkfunUtils assembleAttributeString:model.msg boundingSize:CGSizeMake(CGRectGetWidth(self.tableView.frame) - 10 - 60, 9999) fontSize:14 shadow:NO];
        
        NSString * rectStr = info[TextRect];
        CGRect rect = CGRectFromString(rectStr);
        
        CGFloat height = CGRectGetHeight(rect) + 29 +CGRectGetHeight(rect) / 25 * 10;
        if (height < 61) {
            height = 61;
        }
        return height;
    }
    
}
//通知 控制器退出前调用
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
