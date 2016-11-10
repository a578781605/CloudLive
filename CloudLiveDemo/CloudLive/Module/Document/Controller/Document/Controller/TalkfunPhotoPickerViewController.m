//
//  PhotoPickerViewController.m
//  CloudLive
//
//  Created by 孙兆能 on 16/9/11.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunPhotoPickerViewController.h"
#import "JFImagePickerController.h"
#import "TalkfunDocument.h"
#import "TalkfunPhotoCell.h"
#import "TalkfunPhotoAssets.h"
#import <Photos/Photos.h>
#import "AFNetworking.h"

@interface TalkfunPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray * assetsArray;
@property (nonatomic,strong) UICollectionView * photosList;
@property (nonatomic,strong) NSMutableArray * photosArray;
@property (nonatomic,strong) NSMutableArray * selectedArray;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (nonatomic,strong) NSMutableArray * uploadImagesAsset;
@property (nonatomic,strong) UIAlertController * authorizationAlert;
@property (nonatomic,strong) TalkfunDocument * docService;

@end

@implementation TalkfunPhotoPickerViewController

- (UICollectionView *)photosList
{
    if (!_photosList) {
        self.view.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 3;
        NSInteger size = [UIScreen mainScreen].bounds.size.width/4-1;
        if (size%2!=0) {
            size-=1;
        }
        flowLayout.itemSize = CGSizeMake(size, size);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _photosList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44) collectionViewLayout:flowLayout];
        _photosList.delegate = self;
        _photosList.dataSource = self;
        _photosList.backgroundColor = [UIColor whiteColor];
        
        [_photosList registerNib:[UINib nibWithNibName:@"TalkfunPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
        
        [self.view addSubview:_photosList];
    }
    return _photosList;
}

- (TalkfunDocument *)docService
{
    if (!_docService) {
        _docService = [[TalkfunDocument alloc] init];
    }
    return _docService;
}

- (NSMutableArray *)photosArray
{
    if (!_photosArray) {
        _photosArray = [NSMutableArray new];
    }
    return _photosArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}

- (NSMutableArray *)uploadImagesAsset
{
    if (!_uploadImagesAsset) {
        _uploadImagesAsset = [NSMutableArray new];
    }
    return _uploadImagesAsset;
}

- (NSMutableArray *)assetsArray
{
    if (!_assetsArray) {
        _assetsArray = [NSMutableArray new];
    }
    return _assetsArray;
}

- (UIAlertController *)authorizationAlert{
    
    if (!_authorizationAlert) {
        _authorizationAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"拒绝访问相册，可去设置隐私里开启" preferredStyle:UIAlertControllerStyleAlert];
        
        [_authorizationAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _authorizationAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    WeakSelf
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
            {
                [weakSelf showAlert];
            }
            else if (status == PHAuthorizationStatusAuthorized)
            {
                [weakSelf addPhotoAssets];
                PERFORM_IN_MAIN_QUEUE([weakSelf reloadData];)
            }
        }];
    }
    else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted){
        
        [self showAlert];
    }
    else
    {
        [self addPhotoAssets];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFailure) name:TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_FAIL object:nil];
    
}

- (void)showAlert
{
    [self presentViewController:self.authorizationAlert animated:YES completion:nil];
}

- (void)addPhotoAssets
{
    [self.photosArray removeAllObjects];
    [self.assetsArray removeAllObjects];
    TalkfunPhotoAssets * photoAssets = [[TalkfunPhotoAssets alloc] init];
    self.assetsArray = [photoAssets getImagesAsset];
    
    [self.photosArray addObjectsFromArray:[photoAssets getThumbnailsWithAssetArray:self.assetsArray]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WeakSelf
    self.photosList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf addPhotoAssets];
        [weakSelf reloadData];
        [weakSelf.photosList.mj_header endRefreshing];
    }];
    self.photosList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf addPhotoAssets];
        [weakSelf reloadData];
        [weakSelf.photosList.mj_footer endRefreshing];
    }];
    
    [self.selectedArray removeAllObjects];
    [self reloadData];
    
    if (self.photosArray.count != 0) {
        [self.photosList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.photosArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        [self photoBtnsUserInteractionEnable:YES];
        [self loadBtnUserInteractionEnable:NO];
    }
    
}

- (void)reloadData
{
    [self.photosList reloadData];
}

#pragma mark collectionView delegate dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    UIImage * image = self.photosArray[indexPath.row];
    
    [cell configCell:image];
    
    if ([self.selectedArray containsObject:@(indexPath.row + 1)]) {
        [cell selectedCell:YES num:[self.selectedArray indexOfObject:@(indexPath.row + 1)]];
    }
    else
    {
        [cell selectedCell:NO num:0];
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedArray containsObject:@(indexPath.row + 1)]) {
        [self.selectedArray removeObject:@(indexPath.row + 1)];
        if (self.selectedArray.count == 0) {
            
            [self loadBtnUserInteractionEnable:NO];
        }
        else
        {
            [self.loadBtn setTitle:[NSString stringWithFormat:@"载入(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
            if (self.loadBtn.userInteractionEnabled == NO) {
                [self loadBtnUserInteractionEnable:YES];
            }
        }
        [self reloadData];
        [self.photosList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else
    {
        if (self.selectedArray.count < MaxUploadNum) {
            [self.selectedArray addObject:@(indexPath.row + 1)];
            [self.loadBtn setTitle:[NSString stringWithFormat:@"载入(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
            if (self.loadBtn.userInteractionEnabled == NO) {
                [self loadBtnUserInteractionEnable:YES];
            }
            [self reloadData];
            [self.photosList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        else
        {
            
            [self.view toast:@"最多只能选择10张" position:CGPointMake(self.view.center.x - CGRectGetMinX(self.view.frame), self.view.center.y - 30)];
        }
    }
}

- (IBAction)loadBtn:(UIButton *)sender {
    
    if (self.selectedArray.count != 0) {
        [self photoBtnsUserInteractionEnable:NO];
//        self.view.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_PROGRESS object:nil userInfo:@{@"progress":[NSNull null]}];
    }
    
    dispatch_async(dispatch_queue_create("loadImages", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.uploadImagesAsset removeAllObjects];
        for (int i = 0; i < self.selectedArray.count; i ++) {
            NSInteger selectedNum = [self.selectedArray[i] integerValue];
            if (self.assetsArray[selectedNum - 1]) {
                [self.uploadImagesAsset addObject:self.assetsArray[selectedNum - 1]];
            }
            
        }
        if (self.model && self.uploadImagesAsset.count != 0) {
            
            [self getUploadUrlAndUploadImage];
        }
    });
    
}

- (void)uploadFailure
{
    PERFORM_IN_MAIN_QUEUE([self photoBtnsUserInteractionEnable:YES];
                          [self loadBtnUserInteractionEnable:NO];
                          NSLog(@"tupian上传失败");
                          [self.uploadImagesAsset removeAllObjects];
                          [self.selectedArray removeAllObjects];
                          [self reloadData];)
}

- (IBAction)albumBtn:(UIButton *)sender {
    
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:nil];
    picker.view.frame = [UIScreen mainScreen].bounds;
    picker.pickerDelegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)getUploadUrlAndUploadImage
{
    WeakSelf
    [self.selectedArray removeAllObjects];
    
    PERFORM_IN_MAIN_QUEUE([self photoBtnsUserInteractionEnable:NO];)
    
    
    [self.docService upload:self.model.course_id imagesAssetArray:self.uploadImagesAsset callback:^(id result) {
        
        NSNumber * code = result[@"code"];
        //        NSString * msg = result[@"msg"];
        if ([code isEqualToNumber:@(0)]) {
            PERFORM_IN_MAIN_QUEUE([weakSelf photoBtnsUserInteractionEnable:YES];
                                  [weakSelf loadBtnUserInteractionEnable:NO];
                                  NSLog(@"tupian上传完毕");
                                  [weakSelf.uploadImagesAsset removeAllObjects];
                                  [weakSelf.selectedArray removeAllObjects];
                                  [weakSelf reloadData];)
        }
        else
        {
            PERFORM_IN_MAIN_QUEUE([weakSelf photoBtnsUserInteractionEnable:YES];
                                  [weakSelf loadBtnUserInteractionEnable:NO];)
        }
        weakSelf.docService = nil;
    }];
}

- (void)photoBtnsUserInteractionEnable:(BOOL)enable
{
    self.view.userInteractionEnabled = enable;
    self.albumBtn.userInteractionEnabled = enable;
    if (self.loadCallback) {
        self.loadCallback(!enable);
    }
    
    [self loadBtnUserInteractionEnable:enable];
}

- (void)loadBtnUserInteractionEnable:(BOOL)enable
{
    self.loadBtn.userInteractionEnabled = enable;
    if (!enable) {
        self.loadBtn.backgroundColor = UIColorFromRGBHex(0xcccccc);
        [self.loadBtn setTitle:@"载入" forState:UIControlStateNormal];
    }
    else
    {
        self.loadBtn.backgroundColor = BlueColor;
    }
}

#pragma mark - JFImagePicker delegate
- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    
    [self.uploadImagesAsset removeAllObjects];
    
    if (picker.assets.count != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_PROGRESS object:nil userInfo:@{@"progress":[NSNull null]}];
        
        [self.uploadImagesAsset addObjectsFromArray:picker.assets];
    }
    
    if (self.model && self.uploadImagesAsset.count != 0) {
        dispatch_async(dispatch_queue_create("loadImages", DISPATCH_QUEUE_CONCURRENT), ^{
                
            [self getUploadUrlAndUploadImage];
        });
    }
    
    [self imagePickerDidCancel:picker];
    
#pragma mark 发送图片给ppt
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadImages" object:picker.assets];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    
    [JFImagePickerController clear];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
