//
//  PriceBuyCell.h
//  HelpSale
//
//  Created by CYT on 2017/9/4.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceBuyCell : UICollectionViewCell


@property (nonatomic,strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
