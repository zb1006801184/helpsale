//
//  Clear.m
//  ClearDemo
//
//  Created by Air on 2017/5/5.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import "Clear.h"

@implementation Clear

+(NSString *)getCacheSize
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // path文件夹下的所有文件
    NSArray *PathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in PathArr){
        
        filePath =[path stringByAppendingPathComponent:subPath];
        
        BOOL isDirectory = NO;
        
        // 是否存在文件夹
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        
        //  不计算的文件夹
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            continue;
        }
        
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        // 每一个文件夹大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 总大小
        totleSize = totleSize + size;
    }
    
    //文件夹大小
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;


}

+(BOOL)clearCache
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    NSArray *PathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
   
    // filePath   path路径的下一级目录的子文件夹
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in PathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//        if (error) {
//            return NO;
//        }
    }
    return YES;
}


@end
