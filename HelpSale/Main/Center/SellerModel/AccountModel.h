//
//  AccountModel.h
//  HelpSale
//
//  Created by 朱标 on 2017/9/7.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface AccountModel : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *is_default;
@property (nonatomic, copy) NSString *fromWhere;
@property (nonatomic, copy) NSString *recovery_type;
@property (nonatomic, copy) NSString *is_safe;
@property (nonatomic, copy) NSString *delivery_pay;


@end
