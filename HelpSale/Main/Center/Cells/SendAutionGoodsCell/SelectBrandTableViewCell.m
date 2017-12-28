//
//  SelectBrandTableViewCell.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/28.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SelectBrandTableViewCell.h"

@implementation SelectBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
