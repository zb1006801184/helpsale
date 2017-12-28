//
//  MarginbuyCell.m
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MarginbuyCell.h"

@implementation MarginbuyCell


- (void)setModel:(MarginbuyModel *)model{

    _model = model;

    _remarkLabel.text = _model.remark;
    
    _timeLabel.text = _model.admin_time;
    
    
    if ([model.type isEqualToString:@"1"]) {
        
        _moneyLabel.text = [NSString stringWithFormat:@"+%@",_model.money];
    }else{
    
        _moneyLabel.text = [NSString stringWithFormat:@"-%@",_model.money];

    }
    
    
    
}

@end
