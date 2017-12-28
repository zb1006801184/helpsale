//
//  SelectHotStyleViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SelectHotStyleViewController.h"
#import "SelectHotStyleTableViewCell.h"
#import "SelectBrandViewController.m"
#import "AuctionGoodsDetailViewController.h"
#import "CategoryModel.h"
#import "SubmitHotViewController.h"
@interface SelectHotStyleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherStyleLabel;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SelectHotStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"热门款式";
    _dataList = [NSMutableArray array];
    if ([_fromWhere isEqualToString:@"1"]) {
        //来自品牌
        _titleLabel.text = _titleStr;
        _otherStyleLabel.text = [NSString stringWithFormat:@"%@其他款",_titleStr];
        [self getDataList];
    }else {
        [self getDataTwoList];
    }
    
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextStyleClick:(id)sender {
    
    //来自 品牌且上传页
    if ([self.fromWhere isEqualToString:@"1"] && [self.fromSubmit isEqualToString:@"1"]) {
        //返回上传页
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (UIViewController *VC in viewControllers) {
            if ([VC isKindOfClass:[AuctionGoodsDetailViewController class]]) {
                AuctionGoodsDetailViewController *auctionVC = (AuctionGoodsDetailViewController *)VC;
                auctionVC.GetCategoryBlock(_category_name, _category_id, _brand_name, _brand_id);
                [self.navigationController popToViewController:VC animated:YES];
            }
        }

        return;
    }
    
    if ([self.fromWhere isEqualToString:@"1"]) {
        AuctionGoodsDetailViewController *auctionVC = [[AuctionGoodsDetailViewController alloc]init];
        auctionVC.category_name = _category_name;
        auctionVC.category_id = _category_id;
        auctionVC.brand_name = _brand_name;
        auctionVC.brand_id = _brand_id;
        [self.navigationController pushViewController:auctionVC animated:YES];
        return;
        
    }

    SelectHotStyleViewController *hotVC = [[SelectHotStyleViewController alloc]init];
    hotVC.titleStr = _brand_name;
    hotVC.brand_name = _brand_name;
    hotVC.brand_id = _brand_id;
    hotVC.fromWhere = @"1";
    hotVC.category_name = _category_name;
    hotVC.category_id = _category_id;
    hotVC.fromSubmit = _fromSubmit;
    [self.navigationController pushViewController:hotVC animated:YES];

//
//    SelectBrandViewController *brandVC = [[SelectBrandViewController alloc]init];
//    brandVC.category_name = _category_name;
//    brandVC.category_id = _category_id;
//    brandVC.fromSubmit = _fromSubmit;
//    [self.navigationController pushViewController:brandVC animated:YES];
}
- (void)recoverButtonClick:(UIButton *)button {

    
    CategoryModel *model = _dataList[button.tag - 100];
    
    SubmitHotViewController *submitVC = [[SubmitHotViewController alloc]init];
    submitVC.good_id = model.id;

    [self.navigationController pushViewController:submitVC animated:YES];

}
#pragma mark - Net
- (void)getDataList {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_brand_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Hot/get_hot_list_by_brand" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)getDataTwoList {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_category_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Hot/get_hot_list_by_category" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
 
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectHotStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectHotStyleTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectHotStyleTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    CategoryModel *model = _dataList[indexPath.section];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleNameLabel.text = model.goods_name;
    cell.buyBackLabel.text = model.min_price;
    [cell.recoverButton addTarget:self action:@selector(recoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.recoverButton.tag = indexPath.section + 100;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
