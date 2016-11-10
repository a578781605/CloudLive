//
//  TalkfunSetContentOffset.h
//  CloudLive
//
//  Created by moruiwei on 16/9/12.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunSetContentOffset : NSObject

+ (instancetype)sharedinstance;
- (void)initWithSelectedThumbnail:(int)SelectedThumbnail  withCollectionView:(UICollectionView*)collectionView WithFrame:(CGRect)frame  WithImageArray:(NSMutableArray*)imageArray;

@end
