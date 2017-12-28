//
//  AddressModel.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/29.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *recovery_type;
@property (nonatomic, copy) NSString *is_safe;
@property (nonatomic, copy) NSString *delivery_pay;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *recovery_name;
@property (nonatomic, copy) NSString *safe_name;
@property (nonatomic, copy) NSString *delivery_name;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *goods_sn;
@property (nonatomic, copy) NSString *address_user_name;



@property (nonatomic, strong) NSArray *goods_list;
@end
