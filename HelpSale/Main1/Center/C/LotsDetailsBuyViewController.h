//
//  LotsDetailsBuyViewController.h
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotsDetailsBuyViewController : UITableViewController


@property (nonatomic,copy) NSString *lotsId;

@property (nonatomic,copy) NSString *goodsId;

@property (weak, nonatomic) IBOutlet UILabel *view1;
@property (weak, nonatomic) IBOutlet UILabel *view2;
@property (weak, nonatomic) IBOutlet UILabel *view3;
@property (weak, nonatomic) IBOutlet UILabel *view4;
@property (weak, nonatomic) IBOutlet UILabel *view5;
@property (weak, nonatomic) IBOutlet UILabel *view6;

@property (nonatomic,assign) BOOL isHome;

@end
