//
//  WithdrawalBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "WithdrawalBuyViewController.h"

@interface WithdrawalBuyViewController ()

@end

@implementation WithdrawalBuyViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    self.titleStr = @"保证金提现";

    _moneyLabel.text = _dic[@"cash_deposit"];

    _view1.layer.borderWidth = 1;
    
    _view2.layer.borderWidth = 1;
    
    _view3.layer.borderWidth = 1;
    
    _view4.layer.borderWidth = 1;
    
    _view1.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    
    _view2.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    
    _view3.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    
    _view4.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;

    _view1.layer.cornerRadius = 4;
    
    _view2.layer.cornerRadius = 4;
    
    _view3.layer.cornerRadius = 4;
    
    _view4.layer.cornerRadius = 4;
    

    _view1.layer.masksToBounds = YES;
    
    _view2.layer.masksToBounds = YES;
    
    _view3.layer.masksToBounds = YES;

    _view4.layer.masksToBounds = YES;

    
}



- (IBAction)tureAction:(id)sender {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_nameTextField.text forKey:@"account_name"];
    
    [params setObject:_typeTextField.text forKey:@"bank_name"];

    [params setObject:_accountTextField.text forKey:@"account"];

    [params setObject:_moneyTextField.text forKey:@"money"];

    [HMDataManager requestUrl:apply_deposit_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        

        
        if ([model.code intValue] == 1) {

            hud.label.text = @"成功提交申请";
            
            [hud hideAnimated:YES afterDelay:2];

            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMarginNotification" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        
            hud.label.text = result[@"result"][@"error_msg"];

            [hud hideAnimated:YES afterDelay:2];
        }
        
        

        
    } failure:nil];
    
    
}


@end
