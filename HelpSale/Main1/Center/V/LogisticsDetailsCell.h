//
//  LogisticsDetailsCell.h
//  WholeCategory
//
//  Created by CYT on 2017/3/14.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsDetailsCell : UITableViewCell


@property (nonatomic,strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
