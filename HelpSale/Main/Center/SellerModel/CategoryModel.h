//
//  CategoryModel.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/31.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *attribute_name;
@property (nonatomic, copy)NSString *attribute_type;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *parent_id;
@property (nonatomic, copy)NSString *mark;
@property (nonatomic, copy)NSString *sort;
@property (nonatomic, copy)NSString *format;
@property (nonatomic, copy)NSString *parent_name;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *goods_id;

@property (nonatomic, copy)NSString *photo;
@property (nonatomic, copy)NSString *min_price;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *view;
@property (nonatomic, copy)NSString *category_id;
@property (nonatomic, copy)NSString *brand_id;
@property (nonatomic, copy)NSString *category_name;
@property (nonatomic, copy)NSString *brand_name;

@property (nonatomic, copy)NSString *series_id;
@property (nonatomic, copy)NSString *goods_sn;
@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *attribute_value;
@property (nonatomic, copy)NSString *offer_count;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, strong)NSArray *status_group;
@property (nonatomic, strong)NSArray *picture_list;
@property (nonatomic, strong)NSArray *attribute_list;
@property (nonatomic, strong) NSDictionary *acution;
@property (nonatomic, copy)NSString *status_format;
@property (nonatomic, copy)NSString *child_has_logo;



@property (nonatomic, assign)BOOL isSelect;
@end
