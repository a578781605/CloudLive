//
//  coursewareViewController.m
//  CloudLive
//
//  Created by moruiwei on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunDocumentViewController.h"
#import "UIView+XMGExtension.h"
#import "TalkfunDocument.h"
#import "TalkfunCourseWareCell.h"
#import "TalkfunCourseWareModel.h"
#import "TalkfunButton.h"

#define ButtonWidth 100
#define ButtonHeight 30
#define ButtonFont 14

@interface TalkfunDocumentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * selectedArray;
@property (nonatomic,strong) TalkfunDocument * docService;
@property (nonatomic,strong) UIView * btnContainView;
@property (nonatomic,strong) UIButton * loadBtn;

@end

@implementation TalkfunDocumentViewController

- (UIView *)btnContainView
{
    if (!_btnContainView) {
        _btnContainView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), CGRectGetWidth(self.view.frame), 44)];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_btnContainView.frame), 0.5)];
        view.backgroundColor = UIColorFromRGBHex(0xdddddd);
        [_btnContainView addSubview:view];
        _btnContainView.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
    }
    return _btnContainView;
}

- (UIButton *)loadBtn
{
    if (!_loadBtn) {
        _loadBtn = [[TalkfunButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.btnContainView.frame) - ButtonWidth) / 2, (CGRectGetHeight(self.btnContainView.frame) - ButtonHeight) / 2, ButtonWidth, ButtonHeight) title:@"载入" titleColor:UIColorFromRGBHex(0xffffff) hightlightTitleColor:nil font:[UIFont systemFontOfSize:ButtonFont] image:nil target:self selector:@selector(loadBtnClicked:)];
        _loadBtn.backgroundColor = UIColorFromRGBHex(0xcccccc);
        _loadBtn.layer.cornerRadius = 4;
    }
    return _loadBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) collectionViewLayout:flowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        //注册Cell
        [_collectionView registerNib:[UINib nibWithNibName:@"TalkfunCourseWareCell" bundle:nil] forCellWithReuseIdentifier:@"courseWareCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        _selectedArray = [NSMutableArray new];
    }
    return _dataSource;
}

- (TalkfunDocument *)docService
{
    if (!_docService) {
        _docService = [[TalkfunDocument alloc] init];
    }
    return _docService;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadDone:) name:TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_DONE object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)uploadDone:(NSNotification *)notification
{
    [self setLoadBtnBackgroundColor:YES];
}

// 一般用来调试控制器view的真实尺寸
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WeakSelf
    
    NSArray *idleImages = [NSArray arrayWithObject:[UIImage imageNamed:@"rose"]];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    NSArray *idleImages2 = [NSArray arrayWithObject:[UIImage imageNamed:@"rose"]];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
    [footer setImages:idleImages2 forState:MJRefreshStateIdle];
    self.collectionView.mj_footer = footer;
    
    [self getData];
    
}

- (void)getData
{
    WeakSelf
    [self.docService getDocumentListOfCourse:self.model.course_id callback:^(id result) {
        
        //data:@[@{@"id":string,@"name":string,@"thumbnail":string},...]
        if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
            NSArray * dataArr = result[@"data"];
            if (dataArr.count != 0) {
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.selectedArray removeAllObjects];
                for (int i = 0; i < dataArr.count; i ++) {
                    TalkfunCourseWareModel * model = [TalkfunCourseWareModel mj_objectWithKeyValues:dataArr[i]];
                    [weakSelf.dataSource addObject:model];
                    [weakSelf.selectedArray addObject:@(0)];
                }
                PERFORM_IN_MAIN_QUEUE([weakSelf.collectionView reloadData];
                                      [weakSelf.view addSubview:weakSelf.collectionView];
                                      [weakSelf.view addSubview:weakSelf.btnContainView];
                                      [weakSelf.btnContainView addSubview:weakSelf.loadBtn];)
                
            }
        }
        weakSelf.docService = nil;
    }];
}

- (void)loadBtnClicked:(UIButton *)btn
{
    if (self.loadCallback) {
        self.loadCallback(YES);
    }
    [self setLoadBtnBackgroundColor:NO];
    NSInteger index = [self.selectedArray indexOfObject:@(1)];
    
    if ([self.selectedArray containsObject:@(1)]) {
        
        //TODO:请求课件图片
        TalkfunCourseWareModel * model = self.dataSource[index];
        WeakSelf
        [self.docService loadDocument:model.ID callback:^(id result) {
            
            weakSelf.docService = nil;
        }];
    }
    
}

- (void)setLoadBtnBackgroundColor:(BOOL)blue
{
    PERFORM_IN_MAIN_QUEUE(if (blue) {
        if (self.loadCallback) {
            self.loadCallback(NO);
        }
        self.loadBtn.backgroundColor = BlueColor;
        self.loadBtn.userInteractionEnabled = YES;
    }
                          else
                          {
                              self.loadBtn.backgroundColor = UIColorFromRGBHex(0xcccccc);
                              self.loadBtn.userInteractionEnabled = NO;
                          })
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"courseWareCell";
    TalkfunCourseWareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TalkfunCourseWareModel * model = self.dataSource[indexPath.row];

    [cell configCellWithModel:model];
    
    if ([self.selectedArray[indexPath.row] isEqualToNumber:@(0)]) {
        [cell select:NO];
    }
    else
    {
        [cell select:YES];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH - 24 - 21) / 3, (SCREENWIDTH - 24 - 21) / 3);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 12, 0, 12);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunCourseWareCell * cell = (TalkfunCourseWareCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedArray[indexPath.row] isEqualToNumber:@(1)]) {
        
        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(0)];
        [cell select:NO];
        [self setLoadBtnBackgroundColor:NO];
    }
    else
    {
        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(1)];
        [cell select:YES];
        [self setLoadBtnBackgroundColor:YES];
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunCourseWareCell * cell = (TalkfunCourseWareCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell select:NO];
    
    [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(0)];
    NSLog(@"item------%ld",(long)indexPath.item);
    NSLog(@"row=%ld",(long)indexPath.row);
    NSLog(@"section=%ld",(long)indexPath.section);
    
    if (![self.selectedArray containsObject:@(1)]) {
        
        [self setLoadBtnBackgroundColor:NO];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
