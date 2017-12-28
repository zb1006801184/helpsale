//
//  PaySecurityDepositBuyView.m
//  HelpSale
//
//  Created by CYT on 2017/9/7.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PaySecurityDepositBuyView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"



@implementation PaySecurityDepositBuyView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    _view1.layer.borderWidth = 1;
    
    _view1.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;

    _view1.layer.cornerRadius = 4;

    _view1.layer.masksToBounds = YES;
    
    _moneyTextField.delegate = self;

}

- (IBAction)cancelAction:(id)sender {
    
    _backBlock();
    
}

- (IBAction)trueAction:(id)sender {

    UIButton *button = [self viewWithTag:100];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:_moneyTextField.text forKey:@"pay_money"];
    
    if (button.selected) {
        
        [params setObject:@"1" forKey:@"pay_type"];

    }else{
    
        [params setObject:@"2" forKey:@"pay_type"];

    }
    
    [HMDataManager requestUrl:create_order params:params HidHUD:YES success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            if (button.selected) {

                NSString *appScheme = @"com.HelpSale.huimai";
                
                [[AlipaySDK defaultService] payOrder:result[@"result"][@"data"][@"item"][@"prepayid"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSLog(@"reslut = %@ ",resultDic);
                    
                }];
                
            }else{
            
                PayReq* wxreq = [[PayReq alloc] init];
                
                wxreq.openID              = result[@"result"][@"data"][@"item"][@"appid"];
                wxreq.partnerId           = result[@"result"][@"data"][@"item"][@"partnerid"];
                wxreq.prepayId            = result[@"result"][@"data"][@"item"][@"prepayid"];
                wxreq.nonceStr            = result[@"result"][@"data"][@"item"][@"noncestr"];
                wxreq.timeStamp           = [result[@"result"][@"data"][@"item"][@"timestamp"] intValue];;
                wxreq.sign = result[@"result"][@"data"][@"item"][@"sign"];
                wxreq.package = @"Sign=WXPay";
                
                [WXApi sendReq:wxreq];

            }
            
        }
        
    } failure:nil];

    
    
    _backBlock();

}
- (IBAction)paySelectAction:(UIButton *)sender {

    if (!sender.selected) {
        
        if (sender.tag == 100) {
            
            UIButton *button = [self viewWithTag:101];
            button.selected = NO;
            sender.selected = YES;
            
            
        }else{
        
            UIButton *button = [self viewWithTag:100];
            
            button.selected = NO;
            sender.selected = YES;
            
        }

    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    self.top = kScreenHeight - 460;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    
    self.top = kScreenHeight - 260;
    
    return YES;
    
}

@end
