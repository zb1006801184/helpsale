//
//  getGoodsByIdModel.h
//  HM
//
//  Created by Air on 2017/3/16.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import "BaseModel.h"

@interface getGoodsByIdModel : BaseModel
@property(nonatomic,assign) int category_id;
@property(nonatomic,assign) int customer_id;
@property(nonatomic,assign) int has_price;
@property(nonatomic,strong) NSString *cost_price;
@property(nonatomic,strong) NSString *attribute_id;
@property (nonatomic, strong) NSString *format;
@property(nonatomic,strong) NSString *partner_price;
@property(nonatomic,strong) NSString *market_price;
@property(nonatomic,strong) NSString *brand_id;
@property(nonatomic,strong) NSString *series_id;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *goods_model;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) NSString *remark;
@property (nonatomic,copy,getter=TheNew_level)NSString *new_level;//
@property(nonatomic,strong) NSString *goods_id;
@property(nonatomic,strong) NSString *attribute_value;
@property(nonatomic,strong) NSString *attribute_type;
@property(nonatomic,strong) NSString *parent_id;
@property(nonatomic,strong) NSString *attribute_name;
@property(nonatomic,strong) NSString *parent_name;
@property (nonatomic,strong) NSArray *photo_list;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *sales_price;
@property (nonatomic, strong) NSString *brand_name;
@property (nonatomic, strong) NSString *series_name;
@property (nonatomic, strong) NSString *goods_sn;
@property (nonatomic, strong) NSString *customer_name;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *huanxin_userid;
@property (nonatomic, strong) NSString *from_userid;
@property (nonatomic, assign)  int uid;


@property (nonatomic, strong) NSString *huanxin_username;
@property (nonatomic, assign) int is_collection;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSArray *price_list;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *to_userid;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *deal_price;
@property (nonatomic, strong) NSString *goods_thumb;
@property (nonatomic, strong) NSString *top_category_name;
@property (nonatomic, assign) int integral_left;
@property (nonatomic, assign) int is_my_goods;

@property (nonatomic, assign) int views;

@property (nonatomic, assign) int chat_id;
@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSString *moments;
@property (nonatomic, assign) int consume_integral;
@end
