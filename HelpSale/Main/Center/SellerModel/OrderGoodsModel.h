//
//  OrderGoodsModel.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/29.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface OrderGoodsModel : BaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *series_id;
@property (nonatomic, copy) NSString *goods_sn;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *status_name;
@property (nonatomic, copy) NSString *status_format;
@property (nonatomic, copy) NSString *now_high_price;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *offer_count;
@property (nonatomic, copy) NSString *category_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;


@property (nonatomic, strong) NSArray *goods_list;
@property (nonatomic, strong) NSArray *picture_list;

@end
