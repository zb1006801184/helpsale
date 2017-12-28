//
//  SureSubmitTableViewCell.m
//  HelpSale
//
//  Created by 朱标 on 2017/9/1.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SureSubmitTableViewCell.h"

@implementation SureSubmitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.removeButton.layer.cornerRadius = 2;
    self.removeButton.layer.borderWidth = 0.5;
    self.removeButton.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
