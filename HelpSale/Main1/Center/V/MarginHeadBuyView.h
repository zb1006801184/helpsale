//
//  MarginHeadBuyView.h
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MarginHeadBuyView : UIView


@property (nonatomic,strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezeMoneyLabel;

@end
