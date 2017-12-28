//
//  ScanCell.h
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScrollView.h"
@interface ScanCell : UICollectionViewCell


@property(nonatomic,copy)NSString *imageURL;
@property(nonatomic,strong)PhotoScrollView *scrollView;
@property (nonatomic,strong) UIImage *image;


@end
