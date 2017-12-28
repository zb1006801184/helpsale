//
//  Clear.h
//  ClearDemo
//
//  Created by Air on 2017/5/5.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clear : NSObject

//缓存大小
+(NSString *)getCacheSize;

//清理缓存
+(BOOL)clearCache;

@end
