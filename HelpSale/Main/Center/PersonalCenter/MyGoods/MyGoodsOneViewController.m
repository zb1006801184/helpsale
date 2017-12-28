//
//  MyGoodsOneViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/23.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MyGoodsOneViewController.h"
#import "MyAuctionTableViewCell.h"
#import "OrderGoodsModel.h"
#import "SaleGoodsDetailViewController.h"
#import "HelpSaleOrderDetailViewController.h"

@interface MyGoodsOneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation MyGoodsOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"送检中";
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
    [paramDic setObject:@"waiting_acution" forKey:@"status"];
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
    cell.goods_snLabel.text = model.goods_sn;
    
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@""]];
    
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
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderGoodsModel *model = _dataList[indexPath.section];
    
    HelpSaleOrderDetailViewController *detailVC = [[HelpSaleOrderDetailViewController alloc]init];
    detailVC.order_id = model.id;
    
    [self.navigationController pushViewController:detailVC animated:YES];

    
//    SaleGoodsDetailViewController *goodsDetailsVC = [[SaleGoodsDetailViewController alloc]init];
//    goodsDetailsVC.good_id = model.goods_id;
//    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
//
    
}
@end
