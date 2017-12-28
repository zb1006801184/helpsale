//
//  BuyersHomeHeaderView.h
//  HelpSale
//
//  Created by CYT on 2017/8/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryBuyModel.h"

@interface BuyersHomeHeaderView : UIView

@property (nonatomic,strong) NSArray *categoryArr;

@property (nonatomic,assign) NSInteger time;


@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@end
