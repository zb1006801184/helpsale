//
//  MyGoodsFourViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/23.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MyGoodsFourViewController.h"
#import "MyAuctionTableViewCell.h"
#import "OrderGoodsModel.h"
#import "SaleGoodsDetailViewController.h"
#import "AuctionFootOneView.h"
#import "LogisticsDetailsViewController.h"
#import "HelpSaleOrderDetailViewController.h"

@interface MyGoodsFourViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MyGoodsFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

}
#pragma mark - Net
- (void)getListData {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(_page) forKey:@"page"];
    [paramDic setObject:@"customer_recovery" forKey:@"status"];
    [HMDataManager requestUrl:@"sellerv1/Goods/get_my_goods_list" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            if (_page == 1) {
                [_dataList removeAllObjects];
            }
            NSArray *list = result[@"result"][@"data"][@"list"];
            NSMutableArray *models = [NSMutableArray array];
            for (NSDictionary *dic in list) {
                OrderGoodsModel *model = [[OrderGoodsModel alloc]initWithDic:dic];
                [models addObject:model];
            }
            [_dataList addObjectsFromArray:models];
            [self.mainTableView reloadData];
            
            if (list.count > 0) {
                [_mainTableView footerEndRefreshing];
            }else{
                [_mainTableView.footer noticeNoMoreData];
            }
        }
        [_mainTableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAuctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAuctionTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyAuctionTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    OrderGoodsModel *model = _dataList[indexPath.section];
    cell.timeLabel.text = model.add_time;
    cell.titleLabel.text = model.goods_name;
    cell.stateLabel.text = model.status_format;
    
    if ([model.status_format isEqualToString:@"到店取回"]) {
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"FE5B62"];
        
    }else{
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"C79D65"];
    }

    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@""]];
    cell.goods_snLabel.text = model.goods_sn;

    if (model.category_name.length > 3) {
        
        cell.viewHeight.constant = 80;
        
    }else{
        
        cell.viewHeight.constant = 52;
    }
    
//    CAShapeLayer *border = [CAShapeLayer layer];
//    
//    border.strokeColor = [UIColor colorWithHexString:@"636570"].CGColor;
//    
//    border.fillColor = nil;
//    
//    border.path = [UIBezierPath bezierPathWithRect:CGRectMake(cell.categoryLabel.bounds.origin.x, cell.categoryLabel.bounds.origin.x, cell.viewHeight.constant, 18)].CGPath;
//    
//    border.frame = CGRectMake(cell.categoryLabel.bounds.origin.x, cell.categoryLabel.bounds.origin.x, cell.viewHeight.constant, 18);
//    
//    border.lineWidth = 1.f;
//    
//    border.lineCap = @"butt";
//    
//    border.lineDashPattern = @[@1, @1];
//    
//    [cell.categoryLabel.layer addSublayer:border];
    
    cell.categoryLabel.layer.borderWidth = .5;
    
    cell.categoryLabel.layer.borderColor = [UIColor colorWithHexString:@"d9d9d9"].CGColor;
    

    cell.categoryLabel.text = model.category_name;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 156;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    OrderGoodsModel *model = _dataList[section];
    if ([model.status isEqualToString:@"19"]) {
        return 30;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    OrderGoodsModel *model = _dataList[section];
    NSLog(@"%@",model.status);
    if ([model.status isEqualToString:@"19"]) {
        AuctionFootOneView *view = [[[NSBundle mainBundle]loadNibNamed:@"AuctionFootOneView" owner:self options:nil]firstObject];
        view.notSureButton.layer.cornerRadius = 2;
        view.notSureButton.layer.borderWidth = 0.5;
        view.notSureButton.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
    
        [view.notSureButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    
        view.sureButton.layer.cornerRadius = 2;
        view.sureButton.layer.borderWidth = 0.5;
        view.sureButton.layer.borderColor = [AppStyle colorForDefault].CGColor;
        view.notSureButton.tag = 100+section;
        view.sureButton.tag = 1000+section;
        [view.notSureButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [view.sureButton setTitle:@"确认收货" forState:UIControlStateNormal];

        [view.notSureButton addTarget:self action:@selector(dissatisfiedClick:) forControlEvents:UIControlEventTouchUpInside];
        [view.sureButton addTarget:self action:@selector(sureSaleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }

    return nil;
}


//查看物流
- (void)dissatisfiedClick:(UIButton *)button {
    
    NSLog(@"1");
    
    LogisticsDetailsViewController *logisticsDetailsVC = [[LogisticsDetailsViewController alloc]init];

    OrderGoodsModel *model = _dataList[button.tag - 100];
    
    logisticsDetailsVC.goods_id = model.goods_id;
    
    [self.navigationController pushViewController:logisticsDetailsVC animated:YES];
    
}
//确认收货
- (void)sureSaleClick:(UIButton *)button {
    NSLog(@"2");
    
    OrderGoodsModel *model = _dataList[button.tag - 1000];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:model.goods_id forKey:@"goods_id"];
    
    [HMDataManager requestUrl:confirm_recaption_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            [_dataList removeAllObjects];
            _page = 1;
            [self getListData];

        }
        
    } failure:^(NSError *error) {
        
    }];


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderGoodsModel *model = _dataList[indexPath.section];

    HelpSaleOrderDetailViewController *detailVC = [[HelpSaleOrderDetailViewController alloc]init];
    detailVC.order_id = model.id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    

//    SaleGoodsDetailViewController *goodsDetailsVC = [[SaleGoodsDetailViewController alloc]init];
//    goodsDetailsVC.good_id = model.goods_id;
//    
//    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
//
}



@end
