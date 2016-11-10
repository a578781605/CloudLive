//
//  TalkfunWhiteboardV2.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/18.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TalkfunWhiteboardDelegate <NSObject>
@optional

- (void)whiteboardDidTouched;

@end


@interface TalkfunWhiteboard : UIView

/** 代理对象 */
@property (nonatomic, weak) id<TalkfunWhiteboardDelegate> delegate;

//当前页码
@property (readonly,nonatomic) NSInteger currentPage;
//当前子页码
@property (readonly,nonatomic) NSInteger currentSubPage;
//总页数
@property (readonly,nonatomic) NSInteger totalPage;

//当前索引
@property (readonly,nonatomic) NSInteger currentIndex;

//当前子页索引
@property (readonly,nonatomic) NSInteger currentSubIndex;

+ (id)shared;

//上一页
- (void)movePrevious:(void (^)(NSDictionary *result))callback;

//下一页
- (void)moveNext:(void (^)(NSDictionary *result))callback;

//移动到某个索引
- (void)moveToIndex:(NSInteger)index callback:(void (^)(NSDictionary *result))callback;

//清空画板
//- (void)clearDraw;

//销毁
- (void)shutdown;


@end
