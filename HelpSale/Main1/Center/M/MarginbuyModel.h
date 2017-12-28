//
//  MarginbuyModel.h
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface MarginbuyModel : BaseModel


@property (nonatomic, copy) NSString *id;//列表ID
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *type;//列表ID
@property (nonatomic, copy) NSString *money;//列表ID
@property (nonatomic, copy) NSString *payment;//列表ID
@property (nonatomic, copy) NSString *is_pay;//列表ID
@property (nonatomic, copy) NSString *remark;//列表ID
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *admin_time;


@end
