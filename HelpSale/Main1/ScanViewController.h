//
//  ScanViewController.h
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnIndexBlock)(NSInteger index);


@interface ScanViewController : BaseViewController


@property (nonatomic, copy) ReturnIndexBlock returnIndexBlock;

@property(nonatomic,strong)NSIndexPath *currentIndexPath;//点击的单元格索引

@property(nonatomic,strong)NSArray *imageURLArr;

@property(nonatomic,strong)NSArray *imageArr;




- (void)returnIndex:(ReturnIndexBlock)block;


@end
