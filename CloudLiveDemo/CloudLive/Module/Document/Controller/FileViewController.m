//
//  FileViewController.m
//  CloudLive
//
//  Created by moruiwei on 16/8/23.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "FileViewController.h"
#import "TalkfunDocumentViewController.h"
#import "TalkfunPhotoPickerViewController.h"
#import "XMGTitleButton.h"
#import "UIView+XMGExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>

/** 导航栏的最大Y值(底部) */
//CGFloat const XMGNavBarBottom = 64;
@interface FileViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,assign) NSInteger selectedSegmented;

@property(nonatomic,strong)UIView *titlesView;

/** 存放所有的标题按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;
//所有工具Button
@property (nonatomic, strong)NSMutableArray *toolButtonArray;
/** 当前被选中的标题按钮 */
@property (nonatomic, weak) XMGTitleButton *selectedTitleButton;
/** 标题指示器 */
@property (nonatomic, weak) UIView *titleIndicatorView;
/** 存放所有子控制器的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation FileViewController
#pragma mark - 懒加载
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (NSMutableArray *)toolButtonArray
{
    if (!_toolButtonArray) {
        _toolButtonArray = [NSMutableArray array];
    }
    return _toolButtonArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.scrollView) {
        //添加子控制器
        [self setupChildVcs];
        
        // 添加scrollView
        [self setupScrollView];
        
        // 根据scrollView的偏移量的添加子控制器的view
        [self addChildVcView];
    }
    else
    {
        [self selectmyView:(int)self.selectedSegmented];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.selectedSegmented = self.segmentedControl.selectedSegmentIndex;
}

- (IBAction)click:(UISegmentedControl *)sender {
      NSInteger Index = sender.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [self selectmyView:0];
            break;
        case 1:
            
            [self selectmyView:1];
            
            break;
        default:
            break;
    }
    
    
}
#pragma mark - 添加子控制器
- (void)setupChildVcs
{
    WeakSelf
    //课件
    TalkfunDocumentViewController *TchatableView = [[TalkfunDocumentViewController alloc] init];
    TchatableView.loadCallback = ^(BOOL loading){
        
        if (!loading != weakSelf.segmentedControl.userInteractionEnabled) {
            PERFORM_IN_MAIN_QUEUE(weakSelf.segmentedControl.userInteractionEnabled = !loading;)
        }
    };
    TchatableView.model = self.model;
    TchatableView.title = @"课件";
    [self addChildViewController:TchatableView];
    //图片
//    PictureViewController *QuizTableView = [[PictureViewController alloc] init];
//    QuizTableView.model = self.model;
//    QuizTableView.title = @"图片";
//    [self addChildViewController:QuizTableView];
 
    //图片二
    TalkfunPhotoPickerViewController * photoPicker = [[TalkfunPhotoPickerViewController alloc] init];
    photoPicker.loadCallback = ^(BOOL loading){
        
        if (!loading != weakSelf.segmentedControl.userInteractionEnabled) {
            PERFORM_IN_MAIN_QUEUE(weakSelf.segmentedControl.userInteractionEnabled = !loading;)
        }
        
    };
    photoPicker.model = self.model;
    photoPicker.title = @"照片";
    [self addChildViewController:photoPicker];
}

#pragma mark 添加scrollView
- (void)setupScrollView
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 50, self.view.width, self.view.height-50);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
 
    
    // 禁止掉[自动设置scrollView的内边距]
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置内容大小 ,禁止左右
    scrollView.contentSize = CGSizeMake(0, 0);
}

- (void)selectmyView:(int)titleButton
{
    // 滚动scrollView
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 其他方法
/**
 *  根据scrollView的偏移量的添加子控制器的view
 */
- (void)addChildVcView
{
//    for (int i = 0; i < self.childViewControllers.count; i ++) {
//        UIViewController * vc = self.childViewControllers[i];
//        if (vc.isViewLoaded) {
//            continue;
//        }
////        if (i == 1) {
//            vc.view.frame = CGRectMake(i * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
////        }
////        else
////        {
////            vc.view.frame = self.scrollView.bounds;
////        }
//        
//        [self.scrollView addSubview:vc.view];
//    }
    UIScrollView *scrollView = self.scrollView;
    
    // 计算按钮索引
    int index = scrollView.contentOffset.x / scrollView.width;
    
    // 添加对应的子控制器view
    UIViewController *willShowVc = self.childViewControllers[index];
    
    if (index == 1 && willShowVc.isViewLoaded && ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted)) {
        
        TalkfunPhotoPickerViewController * photoPicker = (TalkfunPhotoPickerViewController *)willShowVc;
        [photoPicker showAlert];
    }
    
    if (willShowVc.isViewLoaded) return;
    // 设置子控制器view的frame
    willShowVc.view.frame = scrollView.bounds;
   // willShowVc.view.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:willShowVc.view];
    
    
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 如果通过setContentOffset:animated:让scrollView[进行了滚动动画], 那么最后会在停止滚动时调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 根据scrollView的偏移量的添加子控制器的view
    [self addChildVcView];
}

@end
