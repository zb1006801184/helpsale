//
//  MarginbuyCell.h
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarginbuyModel.h"

@interface MarginbuyCell : UITableViewCell

@property (nonatomic,strong) MarginbuyModel *model;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
