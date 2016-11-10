//
//  TalkfunUploadVideoController.m
//  CloudLive
//
//  Created by moruiwei on 16/10/27.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunUploadVideoController.h"
#import "TalkfunHeaderView.h"
#import "TalkfunUploadListCell.h"
#import "UIView+XMGExtension.h"
#import "TalkfunCourseResourse.h"
@interface TalkfunUploadVideoController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *videoArray;

/**删除*/
@property (nonatomic,strong) UIAlertController * showDelete;

/**上传*/
@property (nonatomic,strong) UIAlertController * showUpload;


//选中的
@property(nonatomic,assign )int Selected;
@end

@implementation TalkfunUploadVideoController
- (NSMutableArray *)videoArray
{
    if(_videoArray==nil){
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
    // 监听通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(uploadButtonClick:) name:@"uploadButtonClick" object:nil];


 
//    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"你可以是猿猿，也更欢迎媛媛^_^ 收录一些程序员的人文与技术的湿货，也许是猿媛们的鸡汤，但必定有价值" forKey:@"course_name"];
    [dict1 setObject:@"0" forKey:@"schedule"];
//
    
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"其实，动画执续时间_duration也可以更改！" forKey:@"course_name"];
    [dict2 setObject:@"20" forKey:@"schedule"];
    
//    //读取保存的课程信息
//    NSMutableArray *array = [TalkfunCourseResourse readList];
//    
//    
//    
//    for (NSDictionary*dict  in array) {
//        [dict setValue:@"10" forKey:@"schedule"];
//    }
    
 //   [self.videoArray  addObjectsFromArray:array];
    
    [self.videoArray  addObject:dict1];
    [self.videoArray  addObject:dict2];

    
    
    self.navigationItem.title = @"上传回放";
    
    //1.添加tableview
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

 self.tableView.backgroundColor = UIColorFromRGBHex(0xf8f8f8);
    self.tableView.frame =[UIScreen mainScreen].bounds;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    self.tableView.scrollEnabled =NO;
    // 添加头部视图
    TalkfunHeaderView *headView = [TalkfunHeaderView customViwe];

    self.tableView.tableHeaderView = headView;
 
}
- (void)lineWidthChange:(UISlider *)sender {
    NSLog(@"%f",sender.value);
   NSMutableDictionary *dict2  =  self.videoArray[1];
    [dict2 setObject:[NSString stringWithFormat:@"%f",sender.value*100] forKey:@"schedule"];

    [self.tableView reloadData];
    
}
#pragma mark - 监听通知
- (void)uploadButtonClick:(NSNotification *)note
{

       TalkfunUploadListCell *cell  = note.object;

     NSMutableDictionary *dict =   self.videoArray[(long)cell.tag];
    if ([dict[@"pause"]isEqualToString:@"1"]) {
           [dict setObject:@"0" forKey:@"pause"];
    }else{
          [dict setObject:@"1" forKey:@"pause"];
    }

    [self.tableView reloadData];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        TalkfunUploadListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TalkfunUploadListCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunUploadListCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tag = (int)indexPath.row;
        
        cell.dict = self.videoArray[indexPath.row ];
        
        return cell;
 
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


 - (NSArray* )tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    UITableViewRowAction *funUploadRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"上传" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
          NSLog(@"要上传 的 是 的 是第%i行",(int)indexPath.row);
         weakSelf.Selected = (int)indexPath.row;
        [weakSelf presentViewController:weakSelf.showUpload animated:YES completion:nil];
    }];
    funUploadRowAction.backgroundColor = UIColorFromRGBHex(0x14c864);
    
    
    
    
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
    

        NSLog(@"要删除 的 是第%i行",(int)indexPath.row);
        weakSelf.Selected = (int)indexPath.row;
        PERFORM_IN_MAIN_QUEUE(  [weakSelf presentViewController:weakSelf.showDelete animated:YES completion:nil];)
      
        
    }];
       deleteRoWAction.backgroundColor = UIColorFromRGBHex(0xff5f5f);

    return @[deleteRoWAction, funUploadRowAction];//最后返回这俩个RowAction 的数组
    
}



#pragma mark
- (UIAlertController *)showDelete
{
    if (!_showDelete) {
        
        if (ISIPAD) {
            _showDelete = [UIAlertController alertControllerWithTitle:@"确定删除该回放视频?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        }
        else
        {
            _showDelete = [UIAlertController alertControllerWithTitle:@"确定删除该回放视频?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        }

        WeakSelf
        
        [_showDelete addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

         NSDictionary *dict =    weakSelf.videoArray[weakSelf.Selected];
            
            //删除课程信息
            [TalkfunCourseResourse removeList:dict];
            
            
            // 删除选中的
            [weakSelf.videoArray removeObjectAtIndex:weakSelf.Selected];
            
         PERFORM_IN_MAIN_QUEUE(  [weakSelf.tableView reloadData];)
        }]];
        
        [_showDelete addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         PERFORM_IN_MAIN_QUEUE(  [weakSelf.tableView reloadData];)
       
            
        }]];

    }
    return _showDelete;
}


- (UIAlertController *)showUpload
{
    if (!_showUpload) {
        
        if (ISIPAD) {
            _showUpload = [UIAlertController alertControllerWithTitle:@"确定上传该回放视频?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        }
        else
        {
            _showUpload = [UIAlertController alertControllerWithTitle:@"确定上传该回放视频?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        }
        
        WeakSelf
        [_showUpload addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            PERFORM_IN_MAIN_QUEUE(  [weakSelf.tableView reloadData];)
        }]];
        
        
        [_showUpload addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            PERFORM_IN_MAIN_QUEUE(  [weakSelf.tableView reloadData];)
        }]];
        
    }
    return _showUpload;
}

@end
