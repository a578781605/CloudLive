//
//  TalkfunWhiteboardSlider.m
//  CloudLive
//
//  Created by LuoLiuyou on 16/10/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunWhiteboardSlider.h"
#import "TalkfunWhiteboardSliderCell.h"
#import "TalkfunSetContentOffset.h"
#import "TalkfunWhiteboard.h"

@interface TalkfunWhiteboardSlider()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



/**保存现在选中的是那个缩略图*/
@property (nonatomic, assign) int CurrentPage;

@end

@implementation TalkfunWhiteboardSlider

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self initSlider];
    }
    return self;
}
#pragma mark 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    //确定是水平滚动，还是垂直滚动
    self.collectionView.frame = self.bounds;
}
#pragma mark 创建UICollectionView
- (void)initSlider{
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor = [UIColorFromRGBHex(0x000000) colorWithAlphaComponent:0.3];
    
    UINib *nib = [UINib nibWithNibName:@"TalkfunWhiteboardSliderCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"TalkfunWhiteboardSliderCell"];
    [self addSubview:self.collectionView];
    self.CurrentPage = 10000;
    

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}
#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"TalkfunWhiteboardSliderCell";
    TalkfunWhiteboardSliderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    
    NSMutableDictionary *model = (NSMutableDictionary *)self.imageArray[indexPath.item];
    cell.current = model;
    
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width  )/4,( self.frame.size.height -10));
}
#pragma mark 定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    WeakSelf
    self.hidden = YES;
    if((int)indexPath.row ==self.CurrentPage){
        if ([weakSelf.delegate respondsToSelector:@selector(sliderDidSelect:)]) {
            [weakSelf.delegate sliderDidSelect:nil];
        }
        return;
    }
    

    //设置 子页面 是第一
    [self initSelectedThumbnail:(int)indexPath.row WithCurrentSubPage:1];
    //更改背景色
    [self CurrentPage:(int)indexPath.row PreviousPage:self.CurrentPage];

    [[TalkfunWhiteboard shared] moveToIndex:indexPath.row callback:^(NSDictionary *result){
         self.CurrentPage = (int)indexPath.row ;
        if ([weakSelf.delegate respondsToSelector:@selector(sliderDidSelect:)]) {
            [weakSelf.delegate sliderDidSelect:result];
        }
    }];
    
    
}
//更改背景色
- (void)CurrentPage:(int)CurrentPage  PreviousPage:(int)PreviousPage
{
    
    if (PreviousPage==10000) {
        
            NSMutableDictionary *model = (NSMutableDictionary *)self.imageArray[CurrentPage];
            [model setObject:@"1" forKey:@"backgroundColor"];

        self.CurrentPage = CurrentPage;
        [self setContentOffset];
        [self.collectionView reloadData];
        return;
    }
    
    if(CurrentPage ==PreviousPage)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *model = (NSMutableDictionary*)self.imageArray[CurrentPage];
        [model setObject:@"1" forKey:@"backgroundColor"];
        
        
        NSMutableDictionary *Previous = (NSMutableDictionary*)self.imageArray[PreviousPage];
        [Previous setObject:@"0"forKey:@"backgroundColor"];
        
        self.CurrentPage = CurrentPage;
          [self setContentOffset];
        [self.collectionView reloadData];
      
    });

}


//删除通知
- (void)shutdown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 首次才调数据刷新
- (void)reloadData
{

    [self.collectionView setContentOffset:CGPointMake(0, 0)];
    self.CurrentPage = 10000;
    [self.collectionView reloadData];
    
}

#pragma mark - lazy
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


//设置现在是的页面   与子页面索引
- (void)initSelectedThumbnail:(int)SelectedThumbnail  WithCurrentSubPage:(int)currentSubPage;

{
    dispatch_async(dispatch_get_main_queue(), ^{
        //设置SelectedThumbnail背景色
        [self CurrentPage:SelectedThumbnail PreviousPage:self.CurrentPage];
   
        NSMutableDictionary *model = (NSMutableDictionary*)self.imageArray[SelectedThumbnail];
        NSArray *urlArray = model[@"thumbnailUrls"];
        //是页有多页才设置
        if (urlArray.count>1) {
            NSString *url =   urlArray[currentSubPage -1];
            [model setObject:url forKey:@"thumbnail"];
            [self.collectionView reloadData];
        }

    });

}
- (void)setContentOffset
{
    [[TalkfunSetContentOffset  sharedinstance] initWithSelectedThumbnail:self.CurrentPage  withCollectionView:self.collectionView WithFrame:self.frame WithImageArray:self.imageArray];
}
@end
