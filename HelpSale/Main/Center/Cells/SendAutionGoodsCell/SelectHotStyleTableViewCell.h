//
//  SelectHotStyleTableViewCell.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHotStyleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *recoverButton;

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyBackLabel;

@end
