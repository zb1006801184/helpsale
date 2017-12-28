//
//  PaySecurityDepositBuyView.h
//  HelpSale
//
//  Created by CYT on 2017/9/7.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySecurityDepositBuyView : UIView

typedef void (^BackBlock)();

@property (nonatomic,copy) BackBlock backBlock;

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end
