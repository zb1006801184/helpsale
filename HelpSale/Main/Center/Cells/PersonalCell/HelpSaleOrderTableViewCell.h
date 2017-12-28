//
//  HelpSaleOrderTableViewCell.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/21.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpSaleOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *view1;
@property (weak, nonatomic) IBOutlet UILabel *view2;

@end
