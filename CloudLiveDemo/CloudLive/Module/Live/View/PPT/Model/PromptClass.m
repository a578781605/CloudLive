//
//  PromptClass.m
//  CloudLive
//
//  Created by moruiwei on 16/11/1.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import "PromptClass.h"

static PromptClass *_counter;

@implementation PromptClass


+ (id)shared {
    if(!_counter){
        _counter = [[self alloc] init];
    }
    return _counter;
}
- (BOOL)residualFrequency:(NSString*)name
{
    BOOL show =YES;
    NSDictionary *PromptClassDict =  [self readCountDictWithName:name];
    int temp = [PromptClassDict[@"key"] intValue];
    if(!PromptClassDict){
        show = YES;
    }else if(temp>1){
        show = YES;
    }else {
        show = NO;
    }
    return show;
}
- (NSDictionary*)readCountDictWithName:(NSString*)name
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingString:@".plist"];
    // 存的时候用什么对象存,读取的时候也是用什么对象读取
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}
- (void)readFile:(NSString *)name  PromptNumber:(int)count

{
    NSDictionary *countDict =  [self readCountDictWithNmae:name];
    if (!countDict) {
        // plist存储不能存储自定义对象好啊
        NSDictionary *dict = @{@"key":[NSString stringWithFormat:@"%i",count]};
        [self saveCount:dict  WithNmae:name];
    }else{
        NSString *temp = countDict[@"key"];
        int count =  [temp intValue] -1;
        if (count>0) {
            NSString *tem = [NSString stringWithFormat:@"%i",count];
            NSDictionary *dict = @{@"key":tem};
            [self saveCount:dict WithNmae:name];
        }
    }
}
- (NSDictionary*)readCountDictWithNmae:(NSString*)name
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    
    // 拼接文件路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:name];
    
    filePath = [filePath stringByAppendingString:@".plist"];
    
    // 存的时候用什么对象存,读取的时候也是用什么对象读取
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

- (void)saveCount:(NSDictionary*)dict  WithNmae:(NSString*)name;
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingString:@".plist"];
    // File:文件全路径 => 所有文件夹路径 + 文件路径
    [dict writeToFile:filePath atomically:YES];
}

@end
