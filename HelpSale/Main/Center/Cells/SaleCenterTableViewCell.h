//
//  SaleCenterTableViewCell.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/17.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *quoteNumbelLabel;

@property (weak, nonatomic) IBOutlet UILabel *circuseeLabel;

@property (weak, nonatomic) IBOutlet UILabel *closeTheSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *dealImageV;
@property (weak, nonatomic) IBOutlet UILabel *view1;
@property (weak, nonatomic) IBOutlet UILabel *view2;

@end
