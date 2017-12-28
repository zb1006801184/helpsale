//
//  MessageBuyCell.h
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBuyModel.h"

@interface MessageBuyCell : UITableViewCell

@property (nonatomic,strong) MessageBuyModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endtimeLabel;

@end
