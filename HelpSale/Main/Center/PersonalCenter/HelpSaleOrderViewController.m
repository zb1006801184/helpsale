//
//  HelpSaleOrderViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/21.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "HelpSaleOrderViewController.h"
#import "HelpSaleOrderTableViewCell.h"
#import "HelpSaleOrderDetailViewController.h"
#import "OrderGoodsModel.h"
#import <UIViewController+MMDrawerController.h>

@interface HelpSaleOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation HelpSaleOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"帮卖订单";
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _page = 1;
    _dataList = [NSMutableArray array];
    [self getListData];
    __weak typeof(self)weakSelf = self;
    [self.mainTableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getListData];
    }];
    [self.mainTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getListData];
    }];
    //views
    
    //actions
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Net
- (void)getListData {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(_page) forKey:@"page"];
    [HMDataManager requestUrl:@"sellerv1/order/get_order_list" params:paramDic HidHUD:NO success:^(id result) {
        if (_page == 1) {
            [_dataList removeAllObjects];
        }
        NSArray *list = result[@"result"][@"data"][@"list"];
        NSMutableArray *dataAry = [NSMutableArray array];
        for (NSDictionary *dic in list) {
            NSMutableArray *listAllAry = [NSMutableArray array];
            OrderGoodsModel *models = [[OrderGoodsModel alloc]initWithDic:dic];
            NSMutableArray *goodsAry = [NSMutableArray array];
            for (NSDictionary *goodDic in models.goods_list) {
                OrderGoodsModel *model = [[OrderGoodsModel alloc]initWithDic:goodDic];
                [goodsAry addObject:model];
            }
            [listAllAry addObject:models];
            [listAllAry addObject:goodsAry];
            [dataAry addObject:listAllAry];
        }
        [_dataList addObjectsFromArray:dataAry];
        [self.mainTableView reloadData];
        
        if (dataAry.count > 0) {
            [_mainTableView footerEndRefreshing];
        }else{
            [_mainTableView.footer noticeNoMoreData];
        }
        [_mainTableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - actions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataList = _dataList[section][1];
    return dataList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpSaleOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpSaleOrderTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HelpSaleOrderTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    OrderGoodsModel *model = _dataList[indexPath.section][1][indexPath.row];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleName.text = model.goods_name;
    cell.priceLabel.text = model.now_high_price;
    cell.stateLabel.text = model.status_format;
    
    if ([model.status_format isEqualToString:@"到店取回"]||[model.status_format isEqualToString:@"快递取回"]) {
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"FE5B62"];
        
    }else if ([model.status_format isEqualToString:@"已成交"]){
    
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];

    }else{
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"C79D65"];
    }

    if ([model.now_high_price isEqualToString:@""]) {
        
        cell.view1.hidden = YES;
        
        cell.view2.hidden = YES;
    }else{
        
        cell.view1.hidden = NO;
        
        cell.view2.hidden = NO;
    
    }
    
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderGoodsModel *model = _dataList[section][0];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 14)];
    orderLabel.textColor = [UIColor colorWithHexString:@"636570"];
    orderLabel.font = [UIFont systemFontOfSize:14];
    orderLabel.text = [NSString stringWithFormat:@"订单号: %@",model.order_sn];
    [view addSubview:orderLabel];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, kScreenWidth - 20, 12)];
    timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = [NSString stringWithFormat:@"%@",model.add_time];
    [view addSubview:timeLabel];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderGoodsModel *model = _dataList[indexPath.section][0];
    HelpSaleOrderDetailViewController *detailVC = [[HelpSaleOrderDetailViewController alloc]init];
    detailVC.order_id = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}


@end
