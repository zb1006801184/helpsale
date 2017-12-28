//
//  LotsDetailBuyModel.h
//  HelpSale
//
//  Created by CYT on 2017/9/1.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface LotsDetailBuyModel : BaseModel


@property (nonatomic, copy) NSString *id;//详情ID

@property (nonatomic, copy) NSString *goods_id;//详情ID

@property (nonatomic, copy) NSString *goods_name;//商品名称


@property (nonatomic, copy) NSString *brand_name;//品牌

@property (nonatomic, copy) NSString *category_name;//品牌

@property (nonatomic, copy) NSString *series_name;//品牌

@property (nonatomic, copy) NSString *series_id;//品牌


@property (nonatomic, strong) NSArray *attribute_list;//属性

@property (nonatomic, strong) NSString *remark;//备注

@property (nonatomic, strong) NSString *button;//按钮文字

@property (nonatomic, strong) NSArray *picture_list;//图片

@property (nonatomic, strong) NSArray *price_list;//历史出价记录，从高到底

@property (nonatomic, strong) NSDictionary *price;

@property (nonatomic,copy) NSString *left_seconds;//拍品结束剩余秒数

@property (nonatomic,strong) NSDictionary *acution;

@property (nonatomic,copy) NSString *view;//浏览量

@property (nonatomic,copy) NSString *offer_count;//出价数量

@property (nonatomic,copy) NSString *status;//状态码。1-出价中，2-已结拍待买家确认价格,3-待买家付款，4-已付款待确认5,财务确认代发货，6-已发货，7-已签收，8-买家违约，9-流拍




@end
