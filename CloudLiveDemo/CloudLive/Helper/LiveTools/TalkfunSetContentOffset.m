//
//  TalkfunSetContentOffset.m
//  CloudLive
//
//  Created by moruiwei on 16/9/12.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "TalkfunSetContentOffset.h"

@implementation TalkfunSetContentOffset

+ (instancetype)sharedinstance {
    static TalkfunSetContentOffset *s_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[self alloc] init];
        
    });
    return s_instance;
}

- (void)initWithSelectedThumbnail:(int)SelectedThumbnail  withCollectionView:(UICollectionView*)collectionView WithFrame:(CGRect)frame  WithImageArray:(NSMutableArray*)imageArray
{
 
    
    if (SelectedThumbnail ==0 ||SelectedThumbnail ==0||SelectedThumbnail ==1||SelectedThumbnail ==2||SelectedThumbnail ==3) {
        [collectionView setContentOffset:CGPointMake(0*(frame.size.width/4) , 0)];
    }else if (SelectedThumbnail==4){
        [collectionView setContentOffset:CGPointMake(2.5*(frame.size.width/4) , 0)];
    }else if (SelectedThumbnail==5)
    {
        [collectionView setContentOffset:CGPointMake(3.5*(frame.size.width/4) , 0)];
    }else if (SelectedThumbnail==6)
    {
        [collectionView setContentOffset:CGPointMake(4.5*(frame.size.width/4) , 0)];
    }else
        if (SelectedThumbnail >1 &&SelectedThumbnail <imageArray.count-1) {
            if (SelectedThumbnail ==imageArray.count-2) {
                      [collectionView setContentOffset:CGPointMake((SelectedThumbnail -2 )*(frame.size.width/4) , 0)];
            }else{
                      [collectionView setContentOffset:CGPointMake((SelectedThumbnail -1.5 )*(frame.size.width/4) , 0)];
            }
      
        }else if(SelectedThumbnail ==imageArray.count-1){
            [collectionView setContentOffset:CGPointMake((SelectedThumbnail - 2.8) *(frame.size.width/4) , 0)];
        }else{
            
            [collectionView setContentOffset:CGPointMake(SelectedThumbnail*(frame.size.width/4) , 0)];
        }
    
    [collectionView reloadData];

}



@end
