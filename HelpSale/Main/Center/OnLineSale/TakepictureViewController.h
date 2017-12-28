//
//  TakepictureViewController.h
//  HelpSale
//
//  Created by CYT on 2017/10/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseViewController.h"

@interface TakepictureViewController : BaseViewController


typedef void (^BackBlock)(UIImage *image);


@property (nonatomic,copy) BackBlock backBlock;

@property (nonatomic,copy) NSString *labelText;



@end
