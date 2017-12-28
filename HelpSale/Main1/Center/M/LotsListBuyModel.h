//
//  LotsListBuyModel.h
//  HelpSale
//
//  Created by CYT on 2017/8/29.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface LotsListBuyModel : BaseModel


@property (nonatomic, copy) NSString *id;//列表ID
@property (nonatomic,copy) NSString *start_time;//开始时间
@property (nonatomic,copy) NSString *end_time;//结束时间
@property (nonatomic,copy) NSString *goods_id;//商品ID
@property (nonatomic,copy) NSString *view;//浏览量
@property (nonatomic,copy) NSString *is_delete;//是否删除：1是2否
@property (nonatomic,copy) NSString *status;//状态码。1-出价中，2-已结拍待买家确认价格,3-待买家付款，4-已付款待确认5,财务确认代发货，6-已发货，7-已签收，8-买家违约，9-流拍
@property (nonatomic,copy) NSString *add_time;//添加时间
@property (nonatomic,copy) NSString *acution_type;//拍卖会类型：1-1小时快拍，2-正常，3-夜拍
@property (nonatomic,copy) NSString *category_id;//分类ID
@property (nonatomic,copy) NSString *category_name;//分类ID

@property (nonatomic,copy) NSString *goods_name;//商品名称
@property (nonatomic,copy) NSString *picture;//商品缩略图
@property (nonatomic,copy) NSString *status_format;//状态显示
@property (nonatomic,copy) NSString *offer_count;//出价数量
@property (nonatomic,copy) NSString *my_price;//我的出价
@property (nonatomic,copy) NSString *now_high_price;//当前成交价
@property (nonatomic,copy) NSString *rank;//当前成交价

@property (nonatomic,copy) NSString *pay_limit_time;//倒计时
@property (nonatomic,copy) NSString *confirm_limit_time;//倒计时







@end
