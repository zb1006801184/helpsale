//
//  AdressModel.h
//  WholeCategory
//
//  Created by CYT on 2017/3/6.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "BaseModel.h"

@interface AdressModel : BaseModel



@property (nonatomic,copy) NSString *id;//该记录的id

@property (nonatomic,copy) NSString *province_id;//省id

@property (nonatomic,copy) NSString *city_id;//市id

@property (nonatomic,copy) NSString *area_id;//区id


@property (nonatomic,copy) NSString *user_id;//用户id

@property (nonatomic,copy) NSString *province;//省名

@property (nonatomic,copy) NSString *city;//市名

@property (nonatomic,copy) NSString *area;//区名


@property (nonatomic,copy) NSString *mobile;//手机号

@property (nonatomic,copy) NSString *user_name;//收件地址 寄件地址 人名

@property (nonatomic,copy) NSString *address;//详细地址

@property (nonatomic,copy) NSString *is_default;//默认


@end
