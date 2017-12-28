//
//  BuyersHomeCell.h
//  HelpSale
//
//  Created by CYT on 2017/1/1.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotsListBuyModel.h"

@interface BuyersHomeCell : UITableViewCell<UIAlertViewDelegate>


typedef void (^ModifyQuotationBlock)();

@property (nonatomic,copy) ModifyQuotationBlock modifyQuotationBlock;//修改进价

typedef void (^BackBlock)();

@property (nonatomic,copy) BackBlock backBlock;

@property (nonatomic,assign) BOOL isHome;

@property (nonatomic,strong) LotsListBuyModel *model;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeImageWidth;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodNameHeight;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewWidth;


@end
