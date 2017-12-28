//
//  LogisticsDetailsCell.m
//  WholeCategory
//
//  Created by CYT on 2017/3/14.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "LogisticsDetailsCell.h"

@implementation LogisticsDetailsCell

- (void)setDic:(NSDictionary *)dic{

    _dic = dic;

    _addressLabel.text = _dic[@"context"];
    
    
    _timeLabel.text = [_dic[@"ftime"] substringWithRange:NSMakeRange(11, 5)];
    
    _dateLabel.text = [_dic[@"ftime"] substringWithRange:NSMakeRange(5, 5)];
    
    

}

@end
