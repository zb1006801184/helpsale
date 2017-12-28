//
//  StockCellectionCell.m
//  奢易购3.0
//
//  Created by guest on 16/8/8.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "StockCellectionCell.h"

@implementation StockCellectionCell


- (void)setUrl:(NSString *)url{

    _url = url;
    
    
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_url]];
    
}

@end
