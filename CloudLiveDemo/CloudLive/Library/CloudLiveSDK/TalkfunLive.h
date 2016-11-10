//
//  TalkfunLive.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/18.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

//连接状态
typedef NS_ENUM(NSInteger, TalkfunLiveStreamState)
{
    TalkfunLiveStreamStateNone,
    TalkfunLiveStreamStatePreviewStarted,
    TalkfunLiveStreamStateStarting,
    TalkfunLiveStreamStateStarted,
    TalkfunLiveStreamStateEnded,
    TalkfunLiveStreamStateError
};

typedef NS_ENUM(NSInteger, TalkfunLiveState)
{
    TalkfunLiveStateStop,
    TalkfunLiveStatePause,
    TalkfunLiveStateStart,
    TalkfunLiveStateFail
};

@protocol TalkfunLiveDelegate <NSObject>

@required
/*!
 *连接状态  VCSessionDelegate
 */
- (void)streamStatusChanged:(TalkfunLiveStreamState)sessionState;
/*!
 * 连接成功后是否成功上课
 */
- (void)liveStatusChanged:(TalkfunLiveState)liveState;

@end

@interface TalkfunLive : NSObject

//代理
@property (atomic, weak)   id<TalkfunLiveDelegate> delegate;
//直播状态
@property (nonatomic) TalkfunLiveState liveState;
//流状态
@property (nonatomic) TalkfunLiveStreamState streamState;
/**p视频预览VIEW*/
@property(nonatomic, strong)  UIView *previewView;
//该属性表示麦克风音量增益因子，初始化时默认为1.0，推流开始后可以修改，其取值范围为[0, 1]
@property (atomic, assign) float micGain;//0~1.0
//课程ID
@property (nonatomic) NSString *courseID;
//网络状态
@property (nonatomic) NSString * networkStatusStr;
//是否设置美颜
@property (nonatomic,assign) BOOL beauty;

//初始化直播器
- (void)setPreview:(UIView *)previewView;


/*!
 *前后摄像头
 */
- (void)setCameraFront:(BOOL)bCameraFrontFlag;

/*!
 *设备授权相关的接口
 */
-(void)applyPermission:(void (^)(BOOL state))callback;

/**
 *  传入你要上的课程
 */
- (id)initWithCourseID:(NSString *)courseID;

/**
 *  设置直播课程ID
 */
- (void)setCourseID:(NSString *)courseID;

/**
 *  开始直播
 */
- (void)start:(void (^)(id data))callback;

/**
 *  开启摄像头
 */
- (void)cameraStart:(void (^)(id result))callback;

/**
 *  关闭摄像头
 */
- (void)cameraStop:(void (^)(id result))callback;

/**
 *  暂停直播
 */
- (void)pause:(void (^)(id result))callback;

/**
 *  恢复直播
 */
- (void)resume;

/**
 *  结束直播
 */
- (void)stop:(void (^)(id result))callback;

/**
 *  触发某个事件(没有回调)
 */
- (void)emit:(NSString *)event params:(NSDictionary *)params;

/**
 *  触发某个事件(有回调)
 */
- (void)emit:(NSString *)event params:(NSDictionary *)params callback:(void (^)(id result))callback;

/**
 *  监听事件
 */
- (void)on:(NSString *)event callback:(void (^)(id result))callback;

/**
 *  取消监听事件
 */
- (void)off:(NSString *)event;

/**
 *  网络状态改变时调用（有网络为YES，没有网络为NO）
 */
- (void)network:(BOOL)network;

/**
 *  销毁(退出控制器时调用)
 */
- (void)shutdown;


@end
