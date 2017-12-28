//
//  MyMoneyAccountTableViewCell.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/23.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMoneyAccountTableViewCell : UITableViewCell

//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editButton;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *is_defaultImage;

@property (weak, nonatomic) IBOutlet UILabel *setAccountLabel;

@property (weak, nonatomic) IBOutlet UIButton *setButton;


@end
