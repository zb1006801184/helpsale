//
//  AddOrEditAddressViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
#import "AdressModel.h"

@interface AddOrEditAddressViewController : UIViewController

@property (nonatomic, copy) void (^updateAddressBlock)();

@property (nonatomic, strong) AccountModel *model;

@property (nonatomic,strong) AdressModel *model1;

@property (nonatomic,copy) NSString *order_id;

@property (nonatomic,assign) BOOL isAddress;

@end
