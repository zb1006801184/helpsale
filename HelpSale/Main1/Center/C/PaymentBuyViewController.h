//
//  PaymentBuyViewController.h
//  HelpSale
//
//  Created by CYT on 2017/9/7.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseViewController.h"

@interface PaymentBuyViewController : UITableViewController


@property (nonatomic,copy) NSString *acution_id;

@property (nonatomic,copy) NSString *pay_money;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *adreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@end
