//
//  MarginHeadBuyView.m
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MarginHeadBuyView.h"
#import "WithdrawalBuyViewController.h"
#import "UIView+Controller.h"


@implementation MarginHeadBuyView

- (void)setDic:(NSDictionary *)dic{

    _dic = dic;
    
    _moneyLabel.text = _dic[@"cash_deposit"];
    
    _freezeMoneyLabel.text = [NSString stringWithFormat:@"冻结金额:(%@)",_dic[@"cash_freeze"]];
    
}

- (IBAction)withdrawalAction:(id)sender {
    
    
    WithdrawalBuyViewController *withdrawalBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"WithdrawalBuyViewController"];
    
    withdrawalBuyVC.dic = _dic;
    [self.viewController.navigationController pushViewController:withdrawalBuyVC animated:YES];
        
    
    
}

@end
