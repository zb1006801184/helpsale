//
//  SureSubmitViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/9/1.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SureSubmitViewController.h"
#import "SureSubmitTableViewCell.h"
#import "SureSubmitAddressViewController.h"
#import "AdressModel.h"
#import "AdreeManagerBuyViewController.h"
#import "AccountModel.h"
#import "MyMoneyAccountViewController.h"
#import "SubmitSuccessViewController.h"


@interface SureSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UIView *footView;

//@property (weak, nonatomic) IBOutlet UIView *accountNameView;
//
//@property (weak, nonatomic) IBOutlet UIView *bankNameView;
//
//@property (weak, nonatomic) IBOutlet UIView *accountView;

@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *bankTextField;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (nonatomic, strong) NSMutableArray *dataList;

//@property (weak, nonatomic) IBOutlet UILabel *goodsNumbelLabel;

@property (weak, nonatomic) IBOutlet UIButton *expressButton;

@property (weak, nonatomic) IBOutlet UIButton *takeButton;

@property (weak, nonatomic) IBOutlet UIButton *insureButton;

@property (weak, nonatomic) IBOutlet UIButton *toPay;


@property (nonatomic, strong) NSString *recovery_type;

@property (nonatomic, strong) NSString *is_safe;
@property (nonatomic, strong) NSString *delivery_pay;

@property (nonatomic,strong) AdressModel *adressModel;//地址

@property (nonatomic,strong) AccountModel *accountModel;//银行账号


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *adreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;





@end

@implementation SureSubmitViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheDefaultAddressAction) name:@"ChangeTheDefaultAddressNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheDefaultAccountAction) name:@"ChangeTheDefaultAccountNotification" object:nil];

    // Do any additional setup after loading the view from its nib.
    self.title = @"确认提交";
    _dataList = [NSMutableArray array];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //get data
    //
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];//获取json文件保存的路径
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    NSArray *dataAry ;
    if (data) {
        id responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的数据（字典）
        [_dataList addObjectsFromArray:responseDic];
        [_mainTableView reloadData];
        dataAry = responseDic;
    }
//    _goodsNumbelLabel.text = [NSString stringWithFormat:@"本次共提交拍品 %lu 件",(unsigned long)dataAry.count];
    
    [self initViews];
    
    [self loadData];
    
    [self loadData1];

}


- (void)initViews {
//    _accountNameView.layer.borderWidth = 0.5;
//    _accountNameView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
//    _bankNameView.layer.borderWidth = 0.5;
//    _bankNameView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
//    _accountView.layer.borderWidth = 0.5;
//    _accountView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    
    _mainTableView.tableFooterView = _footView;
    
}

//获取默认地址数据
- (void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_default_address params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            if ([result[@"result"][@"data"][@"item"] isKindOfClass:NSDictionary.class]) {
                
                _adressModel = [[AdressModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
                
                _nameLabel.text = _adressModel.user_name;
                
                _adreeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_adressModel.province,_adressModel.city,_adressModel.area,_adressModel.address];
                
                _phoneLabel.text = _adressModel.mobile;

            }
            
        }
        
    } failure:nil];
    
}

//获取默认银行账号
- (void)loadData1{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_default_account params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            if ([result[@"result"][@"data"][@"item"] isKindOfClass:NSDictionary.class]) {
                
                _accountModel = [[AccountModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
                
                _accountNameTextField.text = _accountModel.account_name;
                
                _bankTextField.text = _accountModel.bank_name;
                
                _accountTextField.text = _accountModel.account;
                
            }
            
        }
        
    } failure:nil];
    
}
//修改银行账号
- (IBAction)editBankAction:(id)sender {
    
    MyMoneyAccountViewController *accountVC = [[MyMoneyAccountViewController alloc]init];
    
    [self.navigationController pushViewController:accountVC animated:YES];
    
}
//修改地址
- (IBAction)editAdressAction:(id)sender {
    
    AdreeManagerBuyViewController *adreeManagerBuyVC = [[AdreeManagerBuyViewController alloc]init];
    
    [self.navigationController pushViewController:adreeManagerBuyVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)removeClick:(UIButton *)button {
    [_dataList removeObjectAtIndex:button.tag - 100];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:_dataList options:NSJSONWritingPrettyPrinted error:nil];
    [json_data writeToFile:filePath atomically:YES];
    [_mainTableView reloadData];
    
}

//取回方式
- (IBAction)expressClick:(id)sender {
    _recovery_type = @"1";
    _expressButton.selected = YES;
    _takeButton.selected = NO;
}
- (IBAction)takeClick:(id)sender {
    _recovery_type = @"2";
    _expressButton.selected = NO;
    _takeButton.selected = YES;
    
    _insureButton.selected = NO;
    _toPay.selected = NO;
}

- (IBAction)insureClick:(id)sender {
    
    _insureButton.selected = !_insureButton.selected;

    if (_insureButton.selected) {
        
        _is_safe = @"1";
        
        _recovery_type = @"1";

        _expressButton.selected = YES;
        
        _takeButton.selected = NO;

    }else{
        
        _is_safe = @"2";
    }
//
//    _is_safe = @"1";
//    _delivery_pay = @"2";
//    _insureButton.selected = YES;
//    _toPay.selected = NO;
}
- (IBAction)payClick:(id)sender {
    
    _toPay.selected = !_toPay.selected;
    
    if (_toPay.selected) {
        
        _delivery_pay = @"1";
        
        _recovery_type = @"1";
        
        _expressButton.selected = YES;
        
        _takeButton.selected = NO;
        
    }else{
        
        _delivery_pay = @"2";
    }


//    _is_safe = @"2";
//    _delivery_pay = @"1";
//    _insureButton.selected = NO;
//    _toPay.selected = YES;
}

#pragma mark - actions
- (IBAction)nextClick:(id)sender {
    
    
    [self submitClick];
    
//    SureSubmitAddressViewController *sureVC = [[SureSubmitAddressViewController alloc]init];
//    sureVC.bank_name = _bankTextField.text;
//    sureVC.account = _accountTextField.text;
//    sureVC.account_name = _accountNameTextField.text;
//    [self.navigationController pushViewController:sureVC animated:YES];
    
    
}

#pragma mark - Net

- (void)submitClick {
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    NSArray *goods_list = [NSArray array];
    
    if (data) {
        id responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的数据（字典）
        goods_list = responseDic;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_recovery_type.length > 0) {
        [paramDic setObject:_recovery_type forKey:@"recovery_type"];
    }
    if (_is_safe.length > 0) {
        [paramDic setObject:_is_safe forKey:@"is_safe"];
    }
    if (_delivery_pay.length > 0) {
        [paramDic setObject:_delivery_pay forKey:@"delivery_pay"];
    }
    //    if (_nameLabel.text.length > 0) {
    //        [paramDic setObject:_nameLabel.text forKey:@"user_name"];
    //    }
    
    if (_adressModel.id) {
        
        [paramDic setObject:_adressModel.id forKey:@"address_id"];
    }
    
    if (_accountModel.id) {
        
        [paramDic setObject:_accountModel.id forKey:@"bank_account_id"];
        
    }
    
//    NSMutableDictionary *goods_listDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < goods_list.count ; i++) {
//        [goods_listDic setObject:goods_list[i] forKey:[NSString stringWithFormat:@"%d",i]];
        
        NSDictionary *dic = goods_list[i];
        
        NSArray *keyStrArr = dic.allKeys;
        
        for (NSString *keyStr in keyStrArr) {
            
            [paramDic setObject:dic[keyStr] forKey:keyStr];
        }
        
    }
    
//    [paramDic setObject:goods_listDic forKey:@"goods_list"];
    
    [HMDataManager requestUrl:@"sellerv1/Goods/add_goods" params:paramDic HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            SubmitSuccessViewController *submitVC = [[SubmitSuccessViewController alloc]init];
            [self.navigationController pushViewController:submitVC animated:YES];
        }
    } failure:^(NSError *error) {
        
        
        
    }];
    
    
}
- (IBAction)backClick:(id)sender {
    
    [_dataList removeObjectAtIndex:_dataList.count - 1];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:_dataList options:NSJSONWritingPrettyPrinted error:nil];
    
    [json_data writeToFile:filePath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)overlookClick:(id)sender {
    
    [self submitClick];

//    SureSubmitAddressViewController *sureVC = [[SureSubmitAddressViewController alloc]init];
//    [self.navigationController pushViewController:sureVC animated:YES];
}
#pragma mark - Net
- (void)getDataList:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    NSDictionary *dataDic = _dataList[indexPath.row];
    NSString *category_id = dataDic[@"category_id"];
    NSString *brand_id = dataDic[@"brand_id"];
    NSString *hot_id = dataDic[@"hot_id"];

    if (category_id.length > 0) {
        [paramDic setObject:category_id forKey:@"category_id"];
    }
    if (brand_id.length > 0) {
        [paramDic setObject:brand_id forKey:@"brand_id"];
    }
    if (hot_id.length > 0) {
        [paramDic setObject:hot_id forKey:@"hot_id"];
    }
    
    [HMDataManager requestUrl:@"apiv1/Goods/create_goods_name" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SureSubmitTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:indexPath];
                cell.titleNameLabel.text = result[@"result"][@"data"][@"item"];
            });

        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SureSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SureSubmitTableViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SureSubmitTableViewCell" owner:self options:nil]firstObject];
    }

    NSDictionary *dataDic = _dataList[indexPath.row];
    
    NSLog(@"%@",dataDic);
    
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",[GlobalUtils urlWithImage],dataDic[@"picture_list"][@"0"][@"image"]];
    
    NSLog(@"%@",imageStr);
    
//    NSString *imageStr = [NSString stringWithFormat:@"%@",dataDic[@"photo"]];

    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""]];
    [cell.removeButton addTarget:self action:@selector(removeClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.removeButton.tag = indexPath.row + 100;
    
    
    cell.removeButton.hidden = YES;
    
    [self getDataList:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//改变默认地址
- (void)changeTheDefaultAddressAction{
    
    [self loadData];
    
}
//改变默认银行账号
- (void)changeTheDefaultAccountAction{
    
    [self loadData1];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
