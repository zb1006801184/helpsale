//
//  MessageBuyCell.m
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MessageBuyCell.h"

@implementation MessageBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MessageBuyModel *)model{

    _model = model;
    
    _timeLabel.text = _model.add_time;
    
    _typeLabel.text = _model.title;
    
    _nameLabel.text = _model.content;
    
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:_model.cover_img]];

    _addtimeLabel.hidden = YES;
    
    _endtimeLabel.hidden = YES;
    
    
    
}


@end
