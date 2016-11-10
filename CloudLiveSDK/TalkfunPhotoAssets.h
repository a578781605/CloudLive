//
//  TalkfunPhotoAssets.h
//  CloudLive
//
//  Created by 孙兆能 on 16/9/11.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface TalkfunPhotoAssets : NSObject

//获取图片的标识（NSString类型）
- (NSMutableArray *)getImageIDs:(NSArray *)assetArray;

//根据asset获取原图
- (UIImage *)originalImage:(PHAsset *)asset;

//获取相册全部asset（PHAsset类型）
- (NSMutableArray *)getImagesAsset;

//获得所有相簿 (PHAssetCollection类型)
- (NSArray *)getAllAlbum;

//根据相簿获取对应的asset数组（PHAsset类型）
- (NSArray *)getPhotoAssets:(PHAssetCollection *)assetCollection;

//根据asset（PHAsset类型）的集合获取缩略图（PHAsset类型）
- (NSMutableArray *)getThumbnailsWithAssetArray:(NSMutableArray *)assetArray;

//根据asset数组获取对应的原图（UIImage类型）
- (NSMutableArray *)getOriginalImagesWithAssets:(NSArray *)assetsArray;

@end
