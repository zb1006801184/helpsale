//
//  STTScaleTitleLabel.h
//  SZBBS
//
//  Created by AngusChen on 16/2/22.
//  Copyright © 2016年 Seentao Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTScaleTitleLabel : UILabel
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *highlightColor;

- (void)setScale:(CGFloat)scale animated:(BOOL)animated;
@end
