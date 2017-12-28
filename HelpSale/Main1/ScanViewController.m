//
//  ScanViewController.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanCollectionView.h"

@interface ScanViewController ()<UIScrollViewDelegate>
{
    ScanCollectionView *scanCollectionV;
    UIButton *rightBtn;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleStr = @"相册";

    
    scanCollectionV=[[ScanCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth+40, kScreenHeight)];
    
//    1.把数组传到scanCollectionV中
    scanCollectionV.backgroundColor = [UIColor whiteColor];
    
    if (_imageURLArr) {
        scanCollectionV.imageURLArr= _imageURLArr;

    }else{
    
        scanCollectionV.imageArr= _imageArr;

    }
    

    NSLog(@"%@",_currentIndexPath);
    
    [scanCollectionV scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self.view addSubview:scanCollectionV];
    
}


- (void)returnIndex:(ReturnIndexBlock)block{

    self.returnIndexBlock = block;

}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
}
@end
