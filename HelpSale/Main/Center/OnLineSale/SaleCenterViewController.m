//
//  SaleCenterViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SaleCenterViewController.h"
#import "SaleCenterTableViewCell.h"
#import "SaleGoodsDetailViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "SelectClassifyViewController.h"
#import "OrderGoodsModel.h"
#import "SystemBuyViewController.h"

@interface SaleCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@end

@implementation SaleCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"售卖中心";
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _page = 1;
    _dataList = [NSMutableArray array];
    [self getListData];
    //views
    __weak typeof(self)weakSelf = self;
    [self.mainTableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getListData];
    }];
    [self.mainTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getListData];
    }];
    [self.mainTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //清除本地存储上传拍品信息
    [self saveGoods];
    
    [self loadData3];
    
}

//保存商品信息
- (void)saveGoods {
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];//获取json文件保存的路径
    NSMutableArray *goodArys = [NSMutableArray array];
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:goodArys options:NSJSONWritingPrettyPrinted error:nil];
    [json_data writeToFile:filePath atomically:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - actions
- (IBAction)leftNavClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)rightNavClick:(id)sender {
    
    SystemBuyViewController *systemBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"SystemBuyViewController"];
    
    
    [self.navigationController pushViewController:systemBuyVC animated:YES];
    

    
}
- (IBAction)sendGoodsClick:(id)sender {
    SelectClassifyViewController *classifyVC = [[SelectClassifyViewController alloc]init];
    
    [self.navigationController pushViewController:classifyVC animated:YES];
}

- (IBAction)callClick:(id)sender {
    
    NSString *allString = [NSString stringWithFormat:@"tel:400-7755-059"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    
}
#pragma mark - Net
- (void)getListData {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(_page) forKey:@"page"];
    [HMDataManager requestUrl:@"sellerv1/Acution/index" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            if (_page == 1) {
                [_dataList removeAllObjects];
            }
            NSMutableArray *models = [NSMutableArray array];
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                OrderGoodsModel *model = [[OrderGoodsModel alloc]initWithDic:dic];
                [models addObject:model];
            }
            [_dataList addObjectsFromArray:models];
            if (models.count < 1) {
                [_mainTableView.footer noticeNoMoreData];
            }else{
                [_mainTableView footerEndRefreshing];
            }
        }
        [_mainTableView headerEndRefreshing];
        [_mainTableView reloadData];
        
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
    SaleCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleCenterTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SaleCenterTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    OrderGoodsModel *model = _dataList[indexPath.section];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleNameLabel.text = model.goods_name;
    cell.timeLabel.text = model.end_time;
    cell.statusLabel.text = model.status_format;
    
    if ([model.status_format isEqualToString:@"已成交"]) {
        
        cell.statusLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];
        
        cell.dealImageV.hidden = NO;
        
    }else{
        
        cell.statusLabel.textColor = [UIColor colorWithHexString:@"C79D65"];
        
        cell.dealImageV.hidden = YES;

    }
    
    cell.quoteNumbelLabel.text = model.offer_count;
    cell.circuseeLabel.text = [NSString stringWithFormat:@"%@人围观",model.view];
    cell.closeTheSaleLabel.text = model.price;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderGoodsModel *model = _dataList[indexPath.section];
    SaleGoodsDetailViewController *goodsDetailsVC = [[SaleGoodsDetailViewController alloc]init];
    goodsDetailsVC.good_id = model.goods_id;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}

//获取红点
- (void)loadData3{
    
    //推送数量
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_unread_push_record_nums params:params HidHUD:YES success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            int nums = [result[@"result"][@"data"][@"nums"] intValue];;
            
            if (nums > 0 ) {
                
                [_rightButton setImage:[UIImage imageNamed:@"notifactiontips"] forState:UIControlStateNormal];
                
            }else{
                
                [_rightButton setImage:[UIImage imageNamed:@"Combined Shape"] forState:UIControlStateNormal];
            }

        }
        
    } failure:nil];
    
    
}




@end
