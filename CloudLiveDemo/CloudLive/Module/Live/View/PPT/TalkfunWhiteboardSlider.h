//
//  TalkfunWhiteboardSlider.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/10/21.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TalkfunWhiteboardSliderDelegate <NSObject>
@optional

- (void)sliderDidSelect:(NSDictionary *)result;

@end


@interface TalkfunWhiteboardSlider : UIView

@property(nonatomic,strong) NSMutableArray *imageArray;




@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, weak) id<TalkfunWhiteboardSliderDelegate> delegate;

//现在选中的是那个缩略图*/

//传入当前页面索引   与子页面索引
- (void)initSelectedThumbnail:(int)SelectedThumbnail  WithCurrentSubPage:(int)currentSubPage;


- (void)reloadData;
/**清空*/
-(void)shutdown;
@end
