//
//  AdressCell.m
//  WholeCategory
//
//  Created by CYT on 2017/3/2.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "AdressCell.h"
#import "UIView+Controller.h"
#import "AddOrEditAddressViewController.h"

@implementation AdressCell


- (void)setModel:(AdressModel *)model{

    _model = model;

    _nameLabel.text = _model.user_name;
    
    _phoneLabel.text = _model.mobile;
    
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_model.province,_model.city,_model.area,_model.address];
    
    if ([_model.is_default isEqualToString:@"1"]) {
        
        _defaultButton.selected = YES;
        
        _defaultLabel.text = @"默认地址";
        
        _defaultLabel.textColor = [UIColor colorWithHexString:@"F5554A"];
        
    }else{
    
        _defaultButton.selected = NO;
        
        _defaultLabel.text = @"设为默认";
        
        _defaultLabel.textColor = [UIColor colorWithHexString:@"999999"];

    }

    
}


- (IBAction)deleteAction:(id)sender {
    
    UIAlertView  *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确定删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertV show];
    
}

- (IBAction)editAction:(id)sender {
    

    AddOrEditAddressViewController *addOrEditAddressVC = [[AddOrEditAddressViewController alloc]init];
    
    addOrEditAddressVC.isAddress = YES;
    
    addOrEditAddressVC.model1 = _model;
    
    
    addOrEditAddressVC.updateAddressBlock = ^{

        _backBlock();
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAddressNotification" object:nil];

    };
    
    [self.viewController.navigationController pushViewController:addOrEditAddressVC animated:YES];
    
}

- (IBAction)defaultAction:(id)sender {
    
    if (![_model.is_default isEqualToString:@"1"]) {

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:_model.id forKey:@"id"];
        
        [HMDataManager requestUrl:set_default_address_API params:params HidHUD:NO success:^(id result) {
            
            BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
            
            if ([model.code intValue] == 1) {
                
                _backBlock();
                
                
                if (_order_id) {
                    
                    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                    
                    [paramDic setObject:_order_id forKey:@"id"];
                    
                    [paramDic setObject:_model.id forKey:@"address_id"];
                    
                    [HMDataManager requestUrl:@"sellerv1/Order/edit_order" params:paramDic HidHUD:NO success:^(id result) {
                        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
                        if ([model.code integerValue] == 1) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAddressNotification" object:nil];

                        }
                    } failure:^(NSError *error) {
                        
                    }];

                    
                }else{
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAddressNotification" object:nil];
                
                
                }
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];

        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:_model.id forKey:@"id"];
        
        [HMDataManager requestUrl:delete_address_API params:params HidHUD:NO success:^(id result) {
            
            BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
            
            if ([model.code intValue] == 1) {
                
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                
                hud.label.text = @"删除成功";
                
                hud.mode = MBProgressHUDModeText;
                
                [hud hideAnimated:YES afterDelay:2];

                
                _backBlock();
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTheDefaultAddressNotification" object:nil];
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];

        
        
    }
}

@end
