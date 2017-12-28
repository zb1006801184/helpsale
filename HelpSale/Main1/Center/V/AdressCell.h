//
//  AdressCell.h
//  WholeCategory
//
//  Created by CYT on 2017/3/2.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressModel.h"

@interface AdressCell : UITableViewCell<UIAlertViewDelegate>

typedef void (^BackBlock)();


@property (nonatomic,copy) BackBlock backBlock;

@property (nonatomic,strong) AdressModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (nonatomic,copy) NSString *order_id;


@end
