//
//  SelectClassifyViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SelectClassifyViewController.h"
#import "SelectClassifyTableViewCell.h"
#import "SelectHotStyleViewController.h"
#import "OrderGoodsModel.h"
#import "SaleCenterViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "SelectBrandViewController.h"
#import "SelectChildAttributesViewController.h"


@interface SelectClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SelectClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择商品分类";
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataList = [NSMutableArray array];
    [self getDataList];
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    
    if ([_whereFrom isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray) {
        if ([temVC isKindOfClass:[SaleCenterViewController class]]) {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
    
}

#pragma mark - Net
- (void)getDataList {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [HMDataManager requestUrl:@"apiv1/Category/get_category_list" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                OrderGoodsModel *model = [[OrderGoodsModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *images = @[@"watch-1",@"jewelry-1",@"bag-1",@"other"];
    
    SelectClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectClassifyTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectClassifyTableViewCell" owner:self options:nil]firstObject];
    }
//    cell.contentImage.image = [UIImage imageNamed:images[indexPath.row]];
    if (_dataList.count < 1) {
        return cell;
    }
    OrderGoodsModel *model = _dataList[indexPath.row];
    [cell.contentImage sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderGoodsModel *model = _dataList[indexPath.row];
    
    
    SelectBrandViewController *brandVC = [[SelectBrandViewController alloc]init];
    brandVC.category_name = model.category_name;
    brandVC.category_id = model.id;
    brandVC.fromWhere = _whereFrom;
    [self.navigationController pushViewController:brandVC animated:YES];

//    SelectChildAttributesViewController *brandVC = [[SelectChildAttributesViewController alloc]init];
//    brandVC.category_name = model.category_name;
//    brandVC.category_id = model.id;
//    brandVC.fromWhere = _whereFrom;
//    [self.navigationController pushViewController:brandVC animated:YES];

    
    
    
    
//    SelectHotStyleViewController *selectVC = [[SelectHotStyleViewController alloc]init];
//    selectVC.category_name = model.category_name;
//    selectVC.category_id = model.id;
//    selectVC.fromSubmit = _whereFrom;
//    [self.navigationController pushViewController:selectVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

@end
