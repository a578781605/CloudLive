//
//  TalkfunDocument.h
//  CloudLive
//
//  Created by 孙兆能 on 16/9/19.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunDocument : NSObject

//根据courseID获取PPT文件列表
- (void)getDocumentListOfCourse:(NSString *)courseID callback:(void (^)(id result))callback;

//根据PPT课件ID获取相应课件信息
- (void)getDocument:(NSString *)courseWareID callback:(void (^)(id result))callback;

//根据PPT课件ID加载课件
- (void)loadDocument:(NSString *)courseWareID callback:(void (^)(id result))callback;

//提供course_id和本地图片的asset（PHAsset或者ALAsset类型）的对象的集合 上传图片，返回上传结果
- (void)upload:(NSString *)course_id imagesAssetArray:(NSArray *)imagesAssetArray callback:(void (^)(id result))callback;

@end
