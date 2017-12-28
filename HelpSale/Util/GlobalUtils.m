//
//  GlobalUtils.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/28.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "GlobalUtils.h"


NSString *const selectBrand = @"brand";
NSString *const buyer = @"buyer";
NSString *const seller = @"seller";
//已成交
NSString *const acution_success = @"acution_success";
//已结拍
NSString *const acution_deal = @"acution_deal";
//待上拍
NSString *const waiting_acution = @"waiting_acution";
//已上拍
NSString *const acution = @"acution";



static NSString *const keySendTime = @"SendTime";

@implementation GlobalUtils

+ (NSString *)urlWithDev {
    return @"http://huimai.xianhuoapp.com/";
}

+ (NSString *)urlWithImage {
    return @"http://oujyod9vp.bkt.clouddn.com/";
}


+ (BOOL)isHaveStateWith:(NSArray *)stateAry state:(NSString *)state {
    for (NSString *str in stateAry) {
        if ([str isEqualToString:state]) {
            return YES;
        }
    }
    return NO;
}

//区分 买家   卖家


+ (NSString *)testCodeNetWithPhone:(NSString *)phone code:(NSString *)code verifycode:(NSString *)verifycode model:(NSString *)mode {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:code forKey:@"code"];
    [paramDic setObject:phone forKey:@"mobile"];
    [paramDic setObject:verifycode forKey:@"verifycode"];
    [paramDic setObject:mode forKey:@"model"];
    __block NSString *rand_string ;
    [HMDataManager requestUrl:@"Sendsms/verify_code" params:paramDic HidHUD:NO success:^(id result) {
        rand_string = result[@"rand_string"];
    } failure:^(NSError *error) {
        
    }];
    
    return rand_string;
}
@end
