//
//  PhotoCollectionViewCell.h
//  HM
//
//  Created by Air on 2017/3/24.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *TitleImage;


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIProgressView *loadingView;

@end
