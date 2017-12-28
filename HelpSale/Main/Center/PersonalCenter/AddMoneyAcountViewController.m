//
//  AddMoneyAcountViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AddMoneyAcountViewController.h"
#import <UIViewController+MMDrawerController.h>

@interface AddMoneyAcountViewController ()
@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIView *threeView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *accoun_class;

@property (weak, nonatomic) IBOutlet UITextField *bankAccountTextField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation AddMoneyAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收款账号管理";
    //views
    [self initViews];
}
- (void)initViews {
    _oneView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    _twoView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    _threeView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;

    if (_model) {
        _userNameTextField.text = _model.account_name;
        _accoun_class.text = _model.bank_name;
        _bankAccountTextField.text = _model.account;
        [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addAccountClick:(id)sender {
    if (_model && [_model.fromWhere isEqualToString:@"1"]) {
        [self alterTwoNet:_model];
        return;
    }
    if (_model) {
        [self alterNetWithModel:_model];
        return;
    }
    [self addAccountNet];
    
    
}

#pragma mark - Net
- (void)addAccountNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_userNameTextField.text.length < 1 || _bankAccountTextField.text.length < 1 || _accoun_class.text.length < 1) {
        [self.view showLableViewWithMessage:@"请填写完信息再保存!"];
        return;
    }
    [paramDic setObject:_userNameTextField.text forKey:@"account_name"];
    [paramDic setObject:_bankAccountTextField.text forKey:@"account"];
    [paramDic setObject:_accoun_class.text forKey:@"bank_name"];

    [HMDataManager requestUrl:@"apiv1/Bankaccount/add_bank_account" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addAccounBlock) {
                self.addAccounBlock();
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)alterNetWithModel:(AccountModel *)model {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_userNameTextField.text.length < 1 || _bankAccountTextField.text.length < 1 || _accoun_class.text.length < 1) {
        [self.view showLableViewWithMessage:@"请填写完信息再保存!"];
        return;
    }
    [paramDic setObject:_userNameTextField.text forKey:@"account_name"];
    [paramDic setObject:_bankAccountTextField.text forKey:@"account"];
    [paramDic setObject:_accoun_class.text forKey:@"bank_name"];
    [paramDic setObject:model.id forKey:@"id"];
    [HMDataManager requestUrl:@"apiv1/Bankaccount/edit_bank_account" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addAccounBlock) {
                self.addAccounBlock();
            }
        }
    } failure:^(NSError *error) {
        
    }];

}

- (void)alterTwoNet:(AccountModel *)model {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_userNameTextField.text.length < 1 || _bankAccountTextField.text.length < 1 || _accoun_class.text.length < 1) {
        [self.view showLableViewWithMessage:@"请填写完信息再保存!"];
        return;
    }
    [paramDic setObject:_userNameTextField.text forKey:@"account_name"];
    [paramDic setObject:_bankAccountTextField.text forKey:@"account"];
    [paramDic setObject:_accoun_class.text forKey:@"bank_name"];
    [paramDic setObject:model.id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Order/edit_order" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addAccounBlock) {
                self.addAccounBlock();
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
}

@end
