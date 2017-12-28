//
//  SelectHotStyleTableViewCell.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SelectHotStyleTableViewCell.h"

@implementation SelectHotStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recoverButton.layer.borderWidth = 0.5;
    self.recoverButton.layer.borderColor = [UIColor colorWithHexString:@"C79D65"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
