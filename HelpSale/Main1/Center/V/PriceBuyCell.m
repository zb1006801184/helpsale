//
//  PriceBuyCell.m
//  HelpSale
//
//  Created by CYT on 2017/9/4.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PriceBuyCell.h"

@implementation PriceBuyCell



- (void)setDic:(NSDictionary *)dic{

    _dic = dic;

    _nameLabel.text = _dic[@"user_name"];
    
    _priceLabel.text = _dic[@"price"];
    
    
}



@end
