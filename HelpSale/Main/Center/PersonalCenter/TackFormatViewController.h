//
//  TackFormatViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/30.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
@interface TackFormatViewController : UIViewController
@property (nonatomic, strong) AccountModel *model;

@property (nonatomic, copy) void (^setPayFormtBlock)();

@end
