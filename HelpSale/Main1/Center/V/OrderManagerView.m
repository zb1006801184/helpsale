//
//  OrderManagerView.m
//  WholeCategory
//
//  Created by CYT on 2017/3/13.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "OrderManagerView.h"

@implementation OrderManagerView



- (void)setDic:(NSDictionary *)dic{

    _dic = dic;

    
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:_dic[@"picture"]]];

    _titleLabel.text = _dic[@"goods_name"];
    
     _priceLabel.text = [NSString stringWithFormat:@"订单号:%@",dic[@"order_sn"]];

    _formLabel.text = [NSString stringWithFormat:@"%@:%@",dic[@"express_name"],dic[@"express_no"]];

}


@end
