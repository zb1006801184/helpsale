//
//  NetcaseStyleHeaderView.h
//  SZBBS
//
//  Created by AngusChen on 16/3/9.
//  Copyright © 2016年 Seentao Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTScaleTitleLabel.h"

@interface NetcaseStyleHeaderView : UIScrollView
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) void (^didSelectedIndex)(NSInteger index);
@property (nonatomic, assign) NSInteger selectedIndex;

@end
@interface NetcaseStyleHeaderView (STTInfoType)
-(void)GetTitlesArray:(NSArray*)titles;

@end
//@class STTInfoType;
//@interface NetcaseStyleHeaderView (STTInfoType)
//- (void)setTypes:(NSArray<STTInfoType *> *)types;
//@end