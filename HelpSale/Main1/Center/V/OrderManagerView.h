//
//  OrderManagerView.h
//  WholeCategory
//
//  Created by CYT on 2017/3/13.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderManagerView : UIView




@property (nonatomic,strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *formLabel;

@end
