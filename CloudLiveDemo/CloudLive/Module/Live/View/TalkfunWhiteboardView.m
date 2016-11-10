//
//  WhiteboardView.m
//  CloudLive
//
//  Created by moruiwei on 16/8/23.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunWhiteboardView.h"
#import "UIView+XMGExtension.h"
#import "TalkfunWhiteboard.h"
#import "TalkfunWhiteboardSlider.h"
#import "PromptClass.h"
@interface TalkfunWhiteboardView()<TalkfunWhiteboardDelegate,TalkfunWhiteboardSliderDelegate>

@property(nonatomic,strong)UILabel *CurrentPage;//当前页
@property(nonatomic,strong)UILabel *Slash;//斜线
@property(nonatomic,strong)UILabel *TotalPage;//总页数
@property(nonatomic,strong)UILabel*Percentage;//进度 百分比

/**默认背景图高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DefaultImageHeight;
/**默认背景图宽度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DefaultImageWith;

@end
@implementation TalkfunWhiteboardView
+ (instancetype)customViwe
{
    TalkfunWhiteboardView *shopView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    
    return shopView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self SetBigPPT];
}
#pragma mark  初始化子控件
- (void)SetBigPPT
{
    //判断是否还要提示
    if([[PromptClass shared]residualFrequency:@"PromptClass"]){
       
        self.PromptClass = [[RemoveHighlightedButton alloc]init];
        [self.PromptClass setTitle:@"点击这里上课哦" forState:UIControlStateNormal];
        [self.PromptClass setImage:[UIImage imageNamed:@"上课提示toast.png"]forState:UIControlStateNormal];
        [self addSubview: self.PromptClass ];
        
        //隐藏提示
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(HideThePrompt) userInfo:nil repeats:NO];
    
    }
    //设置只提示三次
    [[PromptClass shared]  readFile:@"PromptClass" PromptNumber:3];



    self.whiteboard = [TalkfunWhiteboard shared];
    self.whiteboard.delegate = self;
    
    self.whiteboardSlider = [[TalkfunWhiteboardSlider alloc] init];
    self.whiteboardSlider.delegate = self;
    self.whiteboardSlider.hidden = YES;
    
    
    self.CurrentPage = [[UILabel alloc]init];
    [self.middle addSubview:self.CurrentPage];
    
    self.Slash = [[UILabel alloc]init];
    [self.middle addSubview:self.Slash];
    
    self.TotalPage = [[UILabel alloc]init];
    [self.middle addSubview:self.TotalPage];
    
    self.CurrentPage.textAlignment = NSTextAlignmentRight;
    self.CurrentPage.font = [UIFont boldSystemFontOfSize:12];
    self.CurrentPage.textColor = [UIColor whiteColor];
    self.Slash.text = @"/";
    self.Slash.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.Slash.textAlignment = NSTextAlignmentCenter;
    
    self.TotalPage.textColor = [UIColor whiteColor];
    self.TotalPage.textAlignment = NSTextAlignmentLeft;
    self.TotalPage.font = [UIFont boldSystemFontOfSize:12];
    
    self. PromptLoading  = [[UILabel alloc]init];
    self. PromptLoading .font = [UIFont boldSystemFontOfSize:15];
    self. PromptLoading .textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self. PromptLoading .backgroundColor = UIColorFromRGBHex(0x444444);
    self. PromptLoading .layer.cornerRadius = 6;
    self. PromptLoading .layer.masksToBounds = YES;
    [self. PromptLoading  setTextColor:UIColorFromRGBHex(0xffffff) ];
    self. PromptLoading .textAlignment = NSTextAlignmentJustified;
    self. PromptLoading .hidden = YES;
    
    
    UILabel*Percentage =  [[UILabel alloc]init];
    self.Percentage = Percentage;
    Percentage.layer.masksToBounds = YES;
    Percentage.textColor = self. PromptLoading .textColor;
    Percentage.font = [UIFont boldSystemFontOfSize:15];
    Percentage.backgroundColor = [UIColor clearColor];
    Percentage.textAlignment = NSTextAlignmentCenter;
    Percentage.text = @"%";
    [self. PromptLoading  addSubview:Percentage ];
    [self addSubview:self. PromptLoading ];
    
    NSString *name1 = [NSString stringWithFormat:@"  正在加载..%ld",(long)0];
    self. PromptLoading .text = name1;
    self.toolbar.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"配图 2"];
    self.DefaultImageWith.constant =image.size.width;
    self.DefaultImageHeight.constant = image.size.height;
    
    self.DefaultImage.image = image;
    [self.left setBackgroundImage:[UIImage imageNamed:@"上一页"] forState:UIControlStateNormal];
    [self.right setBackgroundImage:[UIImage imageNamed:@"下一页"] forState:UIControlStateNormal];

  
//注册通知
  [self registerNotification];

}
#pragma mark 布局子控件
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.PromptClass.frame = CGRectMake(self.width - 135, 4, 135, 35);

    
    self.whiteboard.frame = CGRectMake(0, 0, self.width, self.height);
    
    self.whiteboardSlider.frame = CGRectMake(0, self.frame.size.height - self.height*0.254, self.width, self.height*0.254);
    
    self.CurrentPage.frame = CGRectMake(0, 0, self.middle.width/2-5, self.middle.height);
    self.Slash.frame =  CGRectMake(self.middle.width/2 -5 , 0, 10, self.middle.height);
    self.TotalPage.frame = CGRectMake(self.middle.width/2 +5, 0, self.middle.width/2 -10, self.middle.height);
    self.CurrentPage.layer.masksToBounds = YES;
    self.CurrentPage.layer.cornerRadius = 6;
    self.TotalPage.layer.cornerRadius = 6;
    self.TotalPage.layer.masksToBounds = YES;
    self. PromptLoading .width = 120;
    self. PromptLoading .height = 38;
    self. PromptLoading .center = CGPointMake(self.center.x, self.center.y -19);
    self.Percentage.width = 14;
    self.Percentage.height = 38;
    self.Percentage.x = self. PromptLoading .width - 19;
    self.Percentage.y = 0;
    self.left.layer.cornerRadius = 6;
    self.right.layer.cornerRadius = 6;
    
    self.left.alpha = 0.9;
    self.right.alpha =0.9;
    self.middle.alpha =0.9;
    self.middle.layer.cornerRadius = 6;
    
    
    [self addSubview:self.NotInClassView];
    [self addSubview:self.whiteboard];
    [self addSubview:self.toolbar];
    [self addSubview:self.whiteboardSlider];
    [self addSubview: self.PromptClass ];
    [self addSubview:self. PromptLoading];
    [self addSubview: self.PageNumberPrompt ];
}
- (void)whiteboardDidTouched {
    
    PERFORM_IN_MAIN_QUEUE(
            self.whiteboardSlider.hidden = YES;
            self.toolbar.hidden = NO;
    );
    
    if([self.delegate respondsToSelector:@selector(whiteboardDidTouched)]){
        [self.delegate whiteboardDidTouched];
    }
}

- (void)sliderDidSelect:(NSDictionary *)result {
    
    if (result==nil) {
        PERFORM_IN_MAIN_QUEUE(self.toolbar.hidden = NO;);
        return;
    }
    NSString *currentPage = [NSString stringWithFormat:@"%@",[result objectForKey:@"currentPage"] ];
    //slider被点击了
    PERFORM_IN_MAIN_QUEUE(
      
                          if([currentPage intValue]<10){
                              self.CurrentPage.text = @"0";
                              self.CurrentPage.text = [self.CurrentPage.text stringByAppendingString:currentPage];
                          }else{
                              self.CurrentPage.text = currentPage;
                          }
                          
            self.toolbar.hidden = NO;
    );
}
#pragma mark注册 接收数据的 多个通知
- (void)registerNotification {
    // 文档下载进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDownloadProgress:) name:TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_PROGRESS object:nil];
    //文档下载完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDownloadDone:) name:TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_DONE object:nil];
    //上图成功与加载ppt成功  --- 刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whiteboardReload:) name:TALKFUN_NOTIFICATION_WHITEBOARD_RELOAD object:nil];
    //进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadProgress:) name:TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_PROGRESS object:nil];
    
    //课件开始选择,与图片开始选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TalkfunEventWhiteboardDocumentLoadingStart) name:TALKFUN_NOTIFICATION_DOCUMENT_DOWNLOAD_START object:nil];
    
    //图片开始选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TalkfunEventWhiteboardDocumentLoadingStart) name:TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_START object:nil];
    
    //上传失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TalkfunNotificationDocumentUploadFailure) name:TALKFUN_NOTIFICATION_DOCUMENT_UPLOAD_FAIL object:nil];
    
}
#pragma mark 上传失败
- (void)TalkfunNotificationDocumentUploadFailure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.Percentage.hidden = YES;
        
        self.PromptLoading.hidden = NO;
        self.PromptLoading.text  = @"        上传失败";
       
 [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
        self.userInteractionEnabled = YES;
    });
    
}
//隐藏toastbtn
- (void)hideToast
{ PERFORM_IN_MAIN_QUEUE(
          self.PromptLoading .hidden = YES;
                        
            self.Percentage.hidden = NO;
                        );
}

#pragma mark 课件开始选择,与图片开始选择
- (void)TalkfunEventWhiteboardDocumentLoadingStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *name1 = [NSString stringWithFormat:@"  正在加载..%d",0];
        self.PromptLoading.text = name1;
        self.NotInClassView.hidden = YES;
        self.PromptLoading.hidden = NO;
    });
}
#pragma mark 文档下载进度
- (void)documentDownloadProgress:(NSNotification*)notification {
    //
    NSDictionary *dict = notification.userInfo;
    if(self.PromptLoading.hidden ==YES){
        self.PromptLoading.hidden = NO;
    }
    PERFORM_IN_MAIN_QUEUE (
    self. PromptLoading .text = dict[@"msg"];
    );
    
}


#pragma mark 文档下载完成
- (void)documentDownloadDone:(NSNotification*)notification {

    PERFORM_IN_MAIN_QUEUE (
        //正在加载
        self.PromptLoading.hidden = YES;
                           
        //判断是否还要提示
        if([[PromptClass shared]  residualFrequency:@"PageNumberPrompt"]){
                    self.PageNumberPrompt.hidden = NO;
                                //隐藏提示
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(HidePageNumberPrompt) userInfo:nil repeats:NO];
            
        };
       //设置只提示三次
       [[PromptClass shared]   readFile:@"PageNumberPrompt" PromptNumber:3];
                    
                        );
    
    
}
#pragma mark 上传图片成功与加载ppt成功   --- 刷新数据
- (void)whiteboardReload:(NSNotification*)notification
{
     PERFORM_IN_MAIN_QUEUE (
    if ( self.toolbar.hidden == YES) {
         self.toolbar.hidden = NO;
               }
    self.PromptLoading.hidden = YES;
    );
    
    
    NSMutableArray *thumbnails = (NSMutableArray *)[notification.userInfo objectForKey:@"thumbnails"];
    
    NSString *currentPage = [NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"currentPage"] ];
    NSString *totalPage = [NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"totalPage"]];
    
    PERFORM_IN_MAIN_QUEUE (
            self.NotInClassView.hidden = YES;
           if([currentPage intValue]<10){
               self.CurrentPage.text  = @"0";
               self.CurrentPage.text  = [self.CurrentPage.text stringByAppendingString:currentPage];
           }else{
               self.CurrentPage.text  = currentPage;
           }
           
           if([totalPage intValue]<10){
               self.TotalPage.text  = @"0";
              self.TotalPage.text  = [self.TotalPage.text stringByAppendingString:totalPage];
           }else{
               self.TotalPage.text  = totalPage;
           }
            self.whiteboardSlider.imageArray = [thumbnails mutableCopy];
            [self.whiteboardSlider reloadData];
         
                           
    NSDictionary *dict = notification.userInfo;
    int currentIndex =  [dict[@"currentIndex"] intValue];
                           
                           
   int currentPage =  [dict[@"currentPage"] intValue];


//   //设置页面子子页索引
   [self.whiteboardSlider initSelectedThumbnail:currentIndex WithCurrentSubPage:currentPage];
                           
    );
}
//3秒后隐藏
- (void)HideThePrompt
{
PERFORM_IN_MAIN_QUEUE (
    self.PromptClass.hidden = YES;
);
}
//3秒后隐藏
- (void)HidePageNumberPrompt
{     PERFORM_IN_MAIN_QUEUE (
    self.PageNumberPrompt.hidden = YES;
);
}

#pragma mark 点击下一页
- (IBAction)rightClick:(UIButton *)sender {
    
    WeakSelf
    [self.whiteboard moveNext:^(NSDictionary *result){
        
   //     NSLog(@"%@",result);
        NSString *currentPage = [NSString stringWithFormat:@"%@",[result objectForKey:@"currentPage"] ];
        
        if([currentPage intValue]<10){
            weakSelf.CurrentPage.text = @"0";
            weakSelf.CurrentPage.text = [self.CurrentPage.text stringByAppendingString:currentPage];
        }else{
            weakSelf.CurrentPage.text = currentPage;
        }
      
        
        int currentIndex =   [[result objectForKey:@"currentIndex"] intValue];
        int   currentSubPage =  [[result objectForKey:@"currentSubPage"] intValue];
        //设置页面子子页索引
        [weakSelf.whiteboardSlider initSelectedThumbnail:currentIndex WithCurrentSubPage:currentSubPage];
    }];
}
#pragma mark 点击了 中间按键
- (IBAction)middle:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.toolbar.hidden = YES;
        
        if (self.PageNumberPrompt.hidden == NO) {
            self.PageNumberPrompt.hidden = YES;
        }
        
    });
    self.HideMark = YES;
    self.whiteboardSlider.hidden = NO;
    // respondsToSelector:能判断某个对象是否实现了某个方法
    if ([self.delegate respondsToSelector:@selector(DirectToolHide)]) {
        [self.delegate DirectToolHide];
    }
     
}
#pragma mark 点击上一页
- (IBAction)leftClick:(UIButton *)sender {
    
    WeakSelf
    [self.whiteboard movePrevious:^(NSDictionary *result){
        
        NSString *currentPage = [NSString stringWithFormat:@"%@",[result objectForKey:@"currentPage"] ];

        if([currentPage intValue]<10){
            weakSelf.CurrentPage.text = @"0";
            weakSelf.CurrentPage.text = [self.CurrentPage.text stringByAppendingString:currentPage];
        }else{
            weakSelf.CurrentPage.text = currentPage;
        }


        int currentIndex =   [[result objectForKey:@"currentIndex"] intValue];
        int   currentSubPage =  [[result objectForKey:@"currentSubPage"] intValue];
        //设置页面子子页索引
        [weakSelf.whiteboardSlider initSelectedThumbnail:currentIndex WithCurrentSubPage:currentSubPage];

    }];
    
}

#pragma mark 点击了选择文档
- (IBAction)SelectDocument:(UIButton *)sender {
    // respondsToSelector:能判断某个对象是否实现了某个方法
    if ([self.delegate respondsToSelector:@selector(SelectDocument)]) {
        [self.delegate SelectDocument];
    }
}
#pragma mark 数据清空
- (void)shutdown
{
    [self.whiteboard shutdown];
    [self.whiteboardSlider shutdown];
  
    [[NSNotificationCenter defaultCenter] removeObserver:self ];

}
#pragma mark 当前View点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}
- (RemoveHighlightedButton*)PageNumberPrompt
{
    if (_PageNumberPrompt==nil) {
        _PageNumberPrompt =  [[RemoveHighlightedButton alloc]init];
        [_PageNumberPrompt setTitle:@"点击可选择页面哦" forState:UIControlStateNormal];
        [_PageNumberPrompt setImage:[UIImage imageNamed:@"页面提示toast.png"]forState:UIControlStateNormal];
        _PageNumberPrompt.hidden = YES;
        _PageNumberPrompt.frame = CGRectMake((self.width -135)/2,self.height -68, 135, 35);
        [self addSubview: _PageNumberPrompt ];
    }
    
    return _PageNumberPrompt;
}
#pragma mark 进度
- (void)uploadProgress:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self. PromptLoading.hidden==YES) {
            self. PromptLoading.hidden = NO;
        }
        NSDictionary * data = notification.userInfo;
        NSProgress *progress =  data[@"progress"];
        self. PromptLoading .hidden = NO;
        if ([progress isKindOfClass:[NSNull class]]) {

            self. PromptLoading .hidden = YES;
        }
        else
        {
            NSInteger bb = 100 * progress.completedUnitCount/progress.totalUnitCount;
            NSString *name1 = [NSString stringWithFormat:@"  正在加载..%ld",(long)bb];
            
            self.PromptLoading.text = name1;
            if(bb == 100)
                self. PromptLoading .hidden = YES;
               bb =0;
        }
        
    });
    
}
- (void)dealloc
{
    //NSLog(@"__________lWhiteboardView___________");
}
@end
