//
//  HSUserDetaiModel.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetaiModel.h"
@interface HSUserDetaiModel : NSObject

//获取key值
+(NSString *)getIsFristOpenKey;
+(NSString *)getUserNameKey;
+(NSString *)getPasswordKey;
+(NSString *)getLoginKey;
+(NSString *)getUserDetailModelKey;
+(NSString *)getIphoneNumbel;
+(NSString *)getPersonal;
//获得key对应的数据
+(NSString *)getPersonalForKey:(NSString *)key;
+(NSString *)getIsFristOpenKey:(NSString *)key;
+(NSString *)getUserNameForKey:(NSString *)key;
+(NSString *)getPasswordForKey:(NSString *)key;
+(NSString *)getLoginForKey:(NSString *)key;
+(UserDetaiModel *)getUserDetailModelForKey:(NSString *)key;
+(NSString *)getIphoneNumbelForKey:(NSString *)key;

//保存数据
+(void)setPersonal:(NSString *)obj forkey:(NSString *)key;
+(void)setIsFristOpen:(NSString *)obj forKey:(NSString *)key;
+(void)setUserName:(NSString *)obj forKey:(NSString *)key;
+(void)setPassword:(NSString *)obj forKey:(NSString *)key;
+(void)setLogin:(NSString *)obj forKey:(NSString *)key;
+(void)setUserDetailModel:(UserDetaiModel *)obj forKey:(NSString *)key;
+(void)setIphoneNumbel:(NSString *)obj forKey:(NSString *)key;


@end
