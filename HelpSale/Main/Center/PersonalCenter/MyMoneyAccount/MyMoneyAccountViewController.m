//
//  MyMoneyAccountViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/23.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MyMoneyAccountViewController.h"
#import "MyMoneyAccountTableViewCell.h"
#import "AddMoneyAcountViewController.h"
#import "AccountModel.h"
@interface MyMoneyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic,copy) NSString *deleteId;
@end

@implementation MyMoneyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataList = [NSMutableArray array];
    [self getListData];
}
#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAccountClick:(id)sender {
    AddMoneyAcountViewController *editVC = [[AddMoneyAcountViewController alloc]init];
    __weak typeof(self)weakSelf = self;
    editVC.addAccounBlock = ^{
        [_dataList removeAllObjects];
        [weakSelf getListData];
    };
    [self.navigationController pushViewController:editVC animated:YES];

}
//编辑地址
- (void)editClick:(UIButton *)button {
    MyMoneyAccountTableViewCell *cell = (MyMoneyAccountTableViewCell *)[[button superview]superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    AccountModel *model = _dataList[indexPath.section];

    AddMoneyAcountViewController *editVC = [[AddMoneyAcountViewController alloc]init];
    editVC.model = model;
    __weak typeof(self)weakSelf = self;
    editVC.addAccounBlock = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAccountNotification" object:nil];

        [_dataList removeAllObjects];
        [weakSelf getListData];
    };
    
    [self.navigationController pushViewController:editVC animated:YES];

}
//设置默认
- (void)setAccountClick:(UIButton *)button {

    MyMoneyAccountTableViewCell *cell = (MyMoneyAccountTableViewCell *)[[button superview]superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    AccountModel *model = _dataList[indexPath.section];
    [self setAccountNet:model.id];
}
- (void)deleteClick:(UIButton *)button {
    
    MyMoneyAccountTableViewCell *cell = (MyMoneyAccountTableViewCell *)[[button superview]superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    AccountModel *model = _dataList[indexPath.section];
    
    _deleteId = model.id;

    UIAlertView  *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确定删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertV show];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {

        [self deleteAccountNet:_deleteId];

    }
}

#pragma mark - Net
- (void)getListData {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [HMDataManager requestUrl:@"apiv1/Bankaccount/get_account_list" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                AccountModel *model = [[AccountModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
            
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)setAccountNet:(NSString *)account_id {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:account_id forKey:@"id"];
    [HMDataManager requestUrl:@"apiv1/Bankaccount/set_default_account" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAccountNotification" object:nil];
            [_dataList removeAllObjects];
            [self getListData];
            
            if (_order_id) {
                
                NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                
                [paramDic setObject:_order_id forKey:@"id"];
                
                [paramDic setObject:account_id forKey:@"bank_account_id"];
                
                [HMDataManager requestUrl:@"sellerv1/Order/edit_order" params:paramDic HidHUD:NO success:^(id result) {
                    BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
                    if ([model.code integerValue] == 1) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAddressNotification" object:nil];
                        
                    }
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)deleteAccountNet:(NSString *)account_id {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:account_id forKey:@"id"];
    [HMDataManager requestUrl:@"apiv1/Bankaccount/delete_account" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getListData];
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
    MyMoneyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMoneyAccountTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyMoneyAccountTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    AccountModel *model = _dataList[indexPath.section];
    cell.nameLabel.text = model.account_name;
    cell.bankAccountLabel.text = model.account;
    cell.addressLabel.text = model.bank_name;
    cell.is_defaultImage.highlighted = NO;
    [cell.editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.setButton addTarget:self action:@selector(setAccountClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.setAccountLabel.text = @"设为默认";
    cell.setAccountLabel.textColor = [UIColor colorWithHexString:@"999999"];

    if ([model.is_default isEqualToString:@"1"]) {
        cell.is_defaultImage.highlighted = YES;
        cell.setAccountLabel.text = @"默认账号";
        cell.setAccountLabel.textColor = [UIColor colorWithHexString:@"C79D65"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.5)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
