//
//  GlobalUtils.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/28.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const selectBrand;
FOUNDATION_EXPORT NSString *const buyer;
FOUNDATION_EXPORT NSString *const seller;
FOUNDATION_EXPORT NSString *const acution_success;
FOUNDATION_EXPORT NSString *const acution_deal;
FOUNDATION_EXPORT NSString *const waiting_acution;
FOUNDATION_EXPORT NSString *const acution;


@interface GlobalUtils : NSObject

//开发URL
+ (NSString *)urlWithDev;

//图片URL
+ (NSString *)urlWithImage;

+ (NSString *)testCodeNetWithPhone:(NSString*)phone code:(NSString *)code verifycode:(NSString *)verifycode model:(NSString *)mode;

//判断是否是此状态
+ (BOOL)isHaveStateWith:(NSArray *)stateAry state:(NSString *)state;

@end
