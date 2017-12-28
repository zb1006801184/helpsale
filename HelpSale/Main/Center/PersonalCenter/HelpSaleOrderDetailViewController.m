//
//  HelpSaleOrderDetailViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "HelpSaleOrderDetailViewController.h"
#import "HelpSaleOrderTableViewCell.h"
#import "AddOrEditAddressViewController.h"
#import "AddMoneyAcountViewController.h"
#import "OrderGoodsModel.h"
#import "AddressModel.h"
#import "AuctionFootOneView.h"
#import "TackFormatViewController.h"
#import "AccountModel.h"
#import <UIViewController+MMDrawerController.h>
#import "SaleGoodsDetailViewController.h"
#import "AdressModel.h"
#import "AdreeManagerBuyViewController.h"
#import "MyMoneyAccountViewController.h"



@interface HelpSaleOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) AddressModel *dataModel;

@property (nonatomic, strong) AdressModel *adreeModel;

@property (nonatomic, strong) NSMutableArray *dataList;

//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
//银行账号
@property (weak, nonatomic) IBOutlet UILabel *moneyAcctounLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//商品取回方式
@property (weak, nonatomic) IBOutlet UILabel *expressLabel;
//收货人名字
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
//收货人电话
@property (weak, nonatomic) IBOutlet UILabel *personPhone;
//收货人地址
@property (weak, nonatomic) IBOutlet UILabel *personAddressLabel;
//
@property (strong, nonatomic) IBOutlet UIView *showDissatifiedView;

@property (strong, nonatomic) IBOutlet UIView *showSureView;

//
@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UILabel *showContenLabel;

@property (nonatomic, strong) AccountModel *model;

@property (nonatomic, strong) NSString *takeCalss;

@property (nonatomic, strong) OrderGoodsModel *orderModel;

@end

@implementation HelpSaleOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheDefaultAddressAction) name:@"ChangeTheDefaultAddressNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheDefaultAccountAction) name:@"ChangeTheDefaultAccountNotification" object:nil];
    

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheDefaultAddressAction) name:@"ChangeTheDefaultAddressNotification" object:nil];

    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataList = [NSMutableArray array];
    _takeCalss = @"1";
    [self getData];
    //views
    [self initViews];
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


- (void)initViews {
    _headView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    _mainTableView.tableHeaderView = _headView;
    _footView.frame = CGRectMake(0, 0, kScreenWidth, 330);
    _mainTableView.tableFooterView = _footView;
    self.showDissatifiedView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.showDissatifiedView.hidden = YES;
    self.firstButton.selected = YES;
    self.showSureView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.showSureView.hidden = YES;
    self.showDissatifiedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.showSureView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:self.showDissatifiedView];
    [self.view addSubview:self.showSureView];
}
- (void)showDataInViews {
    
    _accountNameLabel.text = [NSString stringWithFormat:@"户名:  %@",_dataModel.account_name];
    _moneyAcctounLabel.text = [NSString stringWithFormat:@"账户:  %@",_dataModel.account];
    _addressLabel.text = [NSString stringWithFormat:@"开户行  %@",_dataModel.bank_name];
    _personNameLabel.text = _dataModel.address_user_name;
    _personPhone.text = _dataModel.mobile;
    _orderLabel.text = [NSString stringWithFormat:@"商品编号:  %@",_dataModel.goods_sn];
    _timeLabel.text = _dataModel.add_time;
    
    
    _personAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_dataModel.province,_dataModel.city,_dataModel.area,_dataModel.address];
    
    _expressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_dataModel.recovery_name,_dataModel.safe_name,_dataModel.delivery_name];

}


#pragma mark - Net
- (void)getData {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.order_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/order/get_order_by_id" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            
            [_dataList removeAllObjects];
            
            _adreeModel = [[AdressModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
            _dataModel = [[AddressModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
            _model = [[AccountModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
            
//            NSArray *list = _dataModel.goods_list;
//            
//            for (NSDictionary *dic in list) {
//                OrderGoodsModel *model = [[OrderGoodsModel alloc]initWithDic:dic];
//                
//                [_dataList addObject:model];
//            }
            
            OrderGoodsModel *model = [[OrderGoodsModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
            
            [_dataList addObject:model];
            
            [self.mainTableView reloadData];
            [self showDataInViews];
        }
    } failure:^(NSError *error) {
        
    }];
}

//进入下次拍卖
- (void)takeGoodsNet {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.orderModel.id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Acution/refuse_price" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getData];
        }
    } failure:^(NSError *error) {
        
    }];

    
}

//取回商品
- (void)getGoodsNet {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.orderModel.id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Goods/recaption" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getData];
            
        }
    } failure:^(NSError *error) {
        
    }];

}
//确认出售
- (void)sureSaleClick {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_orderModel.id forKey:@"goods_id"];
    [HMDataManager requestUrl:@"sellerv1/Acution/confirm_price" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editAddressClick:(id)sender {
    
    AdreeManagerBuyViewController *adreeManagerBuyVC = [[AdreeManagerBuyViewController alloc]init];
    
    
    adreeManagerBuyVC.order_id = _order_id;
    
    [self.navigationController pushViewController:adreeManagerBuyVC animated:YES];


//
//    AddOrEditAddressViewController *addressVC = [[AddOrEditAddressViewController alloc]init];
//    addressVC.updateAddressBlock = ^{
//        [_dataList removeAllObjects];
//        [self getData];
//    };
//    
//    addressVC.model = _model;
//    
//    addressVC.model1 = _adreeModel;
//    
//    [self.navigationController pushViewController:addressVC animated:YES];
}
- (IBAction)editAccountClick:(id)sender {
    
    
    MyMoneyAccountViewController *myMoneyAccountVC = [[MyMoneyAccountViewController alloc]init];
    
    myMoneyAccountVC.order_id = _order_id;
    
    [self.navigationController pushViewController:myMoneyAccountVC animated:YES];

    
//    AddMoneyAcountViewController *moneyVC = [[AddMoneyAcountViewController alloc]init];
//    
//    moneyVC.addAccounBlock = ^{
//        [_dataList removeAllObjects];
//        [self getData];
//    };
//    moneyVC.model = _model;
//    _model.fromWhere = @"1";
//    [self.navigationController pushViewController:moneyVC animated:YES];
//    
}



- (IBAction)editTakeFormatClick:(id)sender {
    TackFormatViewController *takeVC = [[TackFormatViewController alloc]init];
    
    
    takeVC.model = _model;
    takeVC.setPayFormtBlock = ^{
        [_dataList removeAllObjects];
        [self getData];
    };
    [self.navigationController pushViewController:takeVC animated:YES];
}

//对价格不满意
- (void)dissatisfiedClick:(UIButton *)button {
    
    NSLog(@"1");
    self.showDissatifiedView.hidden = NO;
    _orderModel = _dataList[button.tag - 100];
}
//确认出售
- (void)sureSaleClick:(UIButton *)button {
    NSLog(@"2");
    _orderModel = _dataList[button.tag - 1000];
    [self sureSaleClick];
}
//确认
- (void)sureReceivables:(UIButton *)button {
    NSLog(@"3");
    self.showSureView.hidden = NO;
    
}

//取回商品
- (IBAction)firstClick:(id)sender {
    _firstButton.selected = YES;
    _twoButton.selected = NO;
    _takeCalss = @"1";
}

//进入下次拍卖
- (IBAction)twoClick:(id)sender {
    _takeCalss = @"2";
    _firstButton.selected = NO;
    _twoButton.selected = YES;

}

//返回
- (IBAction)hideShowClick:(id)sender {
    _showDissatifiedView.hidden = YES;
}

//确认
- (IBAction)sureShowClick:(id)sender {
    _showDissatifiedView.hidden = YES;
    if ([_takeCalss isEqualToString:@"1"]) {
        [self getGoodsNet];
    }else if ([_takeCalss isEqualToString:@"2"]) {
        [self takeGoodsNet];
    }
}

//确认
- (IBAction)sureTwoShowClick:(id)sender {
    _showSureView.hidden = YES;
    [self sureSaleClick];
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpSaleOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpSaleOrderTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HelpSaleOrderTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    OrderGoodsModel *model = _dataList[indexPath.section];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleName.text = model.goods_name;
    
    if ([model.now_high_price integerValue] == 0) {
        
        cell.view1.hidden = YES;
        
        cell.view2.hidden = YES;
        
        cell.priceLabel.hidden = YES;
    }else{
        
        cell.view1.hidden = NO;
        
        cell.view2.hidden = NO;
        
        cell.priceLabel.hidden = NO;
    
    }
    
    cell.priceLabel.text = model.now_high_price;
    cell.stateLabel.text = model.status_format;
    
    if ([model.status_format isEqualToString:@"到店取回"]||[model.status_format isEqualToString:@"快递取回"]) {
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"FE5B62"];
        
    }else if ([model.status_format isEqualToString:@"已成交"]){
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];
        
    }else{
        
        cell.stateLabel.textColor = [UIColor colorWithHexString:@"C79D65"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    OrderGoodsModel *model = _dataList[section];
    if ([model.status isEqualToString:@"2"]||[model.status isEqualToString:@"4"]) {
        return 30;
    }

    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    OrderGoodsModel *model = _dataList[section];
    NSLog(@"%@",model.status);
    if ([model.status isEqualToString:@"2"]) {
        AuctionFootOneView *view = [[[NSBundle mainBundle]loadNibNamed:@"AuctionFootOneView" owner:self options:nil]firstObject];
        view.notSureButton.layer.cornerRadius = 2;
        view.notSureButton.layer.borderWidth = 0.5;
        view.notSureButton.layer.borderColor = [AppStyle colorForCrucial].CGColor;
        view.sureButton.layer.cornerRadius = 2;
        view.sureButton.layer.borderWidth = 0.5;
        view.sureButton.layer.borderColor = [AppStyle colorForDefault].CGColor;
        view.notSureButton.tag = 100+section;
        view.sureButton.tag = 1000+section;
        [view.notSureButton addTarget:self action:@selector(dissatisfiedClick:) forControlEvents:UIControlEventTouchUpInside];
        [view.sureButton addTarget:self action:@selector(sureSaleClick:) forControlEvents:UIControlEventTouchUpInside];

        return view;
    }else if ([model.status isEqualToString:@"4"]){
        AuctionFootOneView *view = [[[NSBundle mainBundle]loadNibNamed:@"AuctionFootOneView" owner:self options:nil]firstObject];
        view.notSureButton.hidden = YES;
        view.sureButton.layer.cornerRadius = 2;
        view.sureButton.layer.borderWidth = 0.5;
        view.sureButton.layer.borderColor = [AppStyle colorForDefault].CGColor;
        [view.sureButton addTarget:self action:@selector(sureReceivables:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderGoodsModel *model = _dataList[indexPath.section];
    
    SaleGoodsDetailViewController *goodsDetailsVC = [[SaleGoodsDetailViewController alloc]init];
    goodsDetailsVC.good_id = model.goods_id;
    
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
}

//改变默认地址
- (void)changeTheDefaultAddressAction{
    
    [_dataList removeAllObjects];
    [self getData];
    
}
//改变默认银行账号
- (void)changeTheDefaultAccountAction{
    
    [_dataList removeAllObjects];
    [self getData];

}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
