//
//  PersonalAuctionViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/23.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PersonalAuctionViewController.h"
#import "NetcaseStyleHeaderView.h"
#import "MyGoodsOneViewController.h"
#import "MyGoodsTwoViewController.h"
#import "MyGoodsThreeViewController.h"
#import "MyGoodsFourViewController.h"
@interface PersonalAuctionViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NetcaseStyleHeaderView *headerViewS;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation PersonalAuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的拍品";
    //views
    [self configureHeaderView];
    [self configureMainScrollView];
}
//头部滑动

- (void)configureHeaderView {
    
    self.headerViewS = [[NetcaseStyleHeaderView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, 49)];
    
    self.headerViewS.backgroundColor = [UIColor colorWithRed:5/255.0 green:6/255.0 blue:52/255.0 alpha:1];
    [self.view addSubview:self.headerViewS];
    
    __weak typeof(self) weakSelf = self;
    
    [self.headerViewS setDidSelectedIndex:^(NSInteger index) {
        CGFloat offsetX = index * weakSelf.mainScrollView.frame.size.width;
        CGFloat offsetY = weakSelf.mainScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        /**
         *  如果两个按钮直接间隔的子页面数量大于3，则直接显示，不进行滚动
         */
        if ((ABS(offsetX - weakSelf.mainScrollView.contentOffset.x) / weakSelf.mainScrollView.frame.size.width) > 3) {
            //            [weakSelf adjustHeaderViewToIndex:index];
            [weakSelf.mainScrollView setContentOffset:offset animated:NO];
            [weakSelf addViewOfChildViewController:weakSelf.childViewControllers[index]
                                           atIndex:index];
        }else {
            [weakSelf.mainScrollView setContentOffset:offset animated:YES];
        }
    }];
    NSArray *arr = @[@"送检中",@"已上拍",@"已成交",@"取回商品"];
    [self.headerViewS GetTitlesArray:arr];
}
- (void)configureMainScrollView {
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 69 + 49, kScreenWidth, kScreenHeight - 69 - 49)];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.scrollsToTop = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    [self initViewControlls];

}
- (void)addViewOfChildViewController:(UIViewController *)viewController
                             atIndex:(NSUInteger)index{
    [self.headerViewS.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (idx != index) {
            STTScaleTitleLabel *temlabel = self.headerViewS.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (viewController.view.superview) {
        return;
    }
    
    viewController.view.frame = CGRectMake( self.mainScrollView.bounds.origin.x,
                                           0,
                                           self.mainScrollView.width ,
                                           self.mainScrollView.height);
    [self.mainScrollView addSubview:viewController.view];
}

- (void)initViewControlls
{
    MyGoodsOneViewController *oneVC = [[MyGoodsOneViewController alloc]init];
    [self addChildViewController:oneVC];
    MyGoodsTwoViewController *twoVC = [[MyGoodsTwoViewController alloc]init];
    [self addChildViewController:twoVC];
    MyGoodsThreeViewController *threeVC = [[MyGoodsThreeViewController alloc]init];
    [self addChildViewController:threeVC];
    MyGoodsFourViewController *fourTwoVC = [[MyGoodsFourViewController alloc]init];
    [self addChildViewController:fourTwoVC];
//    // 添加默认控制器
        MyGoodsOneViewController *oneClickVC = [self.childViewControllers firstObject];
    oneClickVC.view.frame = CGRectMake(0, 0, self.mainScrollView.width , self.mainScrollView.height);
    [self.mainScrollView addSubview:oneClickVC.view];
    [self.headerViewS setSelectedIndex:0];
    self.mainScrollView.contentSize = CGSizeMake(self.childViewControllers.count * kScreenWidth, 0);
    
}
#pragma mark - scroll view delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    //    [self adjustHeaderViewToIndex:index];
    
    [self addViewOfChildViewController:self.childViewControllers[index]
                               atIndex:index];
    
    
    
    
    
}
/** 滚动结束 手势导致 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    STTScaleTitleLabel *labelLeft = self.headerViewS.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.headerViewS.subviews.count) {
        STTScaleTitleLabel *labelRight = self.headerViewS.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
}


- (void)adjustHeaderViewToIndex:(NSUInteger)index {
    
    STTScaleTitleLabel *titleLable = (STTScaleTitleLabel *)self.headerViewS.subviews[index];
    CGFloat offsetx = titleLable.center.x - self.headerViewS.frame.size.width * 0.5;
    CGFloat offsetMax = self.headerViewS.contentSize.width - self.headerViewS.frame.size.width;
    
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.headerViewS.contentOffset.y);
    [self.headerViewS setContentOffset:offset animated:YES];
}


#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
