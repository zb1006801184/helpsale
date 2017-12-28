//
//  HSUserDetaiModel.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "HSUserDetaiModel.h"

@implementation HSUserDetaiModel
//获取key值
+(NSString *)getIsFristOpenKey
{
    return @"IsFristOpen";
}

+(NSString *)getUserNameKey
{
    return @"UserName";
}

+(NSString *)getPasswordKey
{
    return @"Password";
}

+(NSString *)getLoginKey
{
    return @"Login";
}

+(NSString *)getUserDetailModelKey
{
    return @"UserDetailModel";
}

+(NSString *)getIphoneNumbel
{
    return @"getIphoneNumbel";
}
+(NSString *)getPersonal
{
    return @"getPersonal";
}
//获得key对应的数据
+(NSString *)getPersonalForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
+(NSString *)getIsFristOpenKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(NSString *)getUserNameForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(NSString *)getPasswordForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(NSString *)getLoginForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(UserDetaiModel *)getUserDetailModelForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *simpleUer = [userDefaults objectForKey:key];
    return [[UserDetaiModel alloc]initWithDic:simpleUer];
}

+(NSString *)getIphoneNumbelForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

//保存数据
+(void)setPersonal:(NSString *)obj forkey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }

}
+(void)setIphoneNumbel:(NSString *)obj forKey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }
}

+(void)setIsFristOpen:(NSString *)obj forKey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }
}

+(void)setUserName:(NSString *)obj forKey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }
}

+(void)setPassword:(NSString *)obj forKey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }
}

+(void)setLogin:(NSString *)obj forKey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:obj forKey:key];
        [userDefaults synchronize];
    }
}

+(void)setUserDetailModel:(UserDetaiModel *)obj forKey:(NSString *)key
{
    if (obj) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[obj toDictionary] forKey:key];
        [userDefaults synchronize];
    }
}

@end
