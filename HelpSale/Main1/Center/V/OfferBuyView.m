//
//  OfferBuyView.m
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "OfferBuyView.h"
#import "UIView+Controller.h"

@implementation OfferBuyView

- (void)awakeFromNib{
    
    [super awakeFromNib];

    _bgView.layer.borderWidth = 1;
    
    _bgView1.layer.borderWidth = 1;

    _bgView2.layer.borderWidth = 1;
    
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;
    
    _bgView1.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;

    _bgView2.layer.borderColor = [UIColor colorWithHexString:@"D9D9D9"].CGColor;

    _bgView.layer.cornerRadius = 4;
    
    _bgView1.layer.cornerRadius = 4;

    _bgView2.layer.cornerRadius = 4;

    _bgView.layer.masksToBounds = YES;
    
    _bgView2.layer.masksToBounds = YES;

    _bgView1.layer.masksToBounds = YES;
    
    _priceTextField.delegate = self;
    
    _codeTextField.delegate = self;

    
}


- (IBAction)backAction:(id)sender {
    
    _backBlock();
    
}

- (IBAction)tureAction:(id)sender {
    
    NSLog(@"%@ %@ %@",_codeTextField.text,_captchaView.changeString,_goods_id);
    
    if ([[_codeTextField.text lowercaseString] isEqualToString:[_captchaView.changeString lowercaseString]]) {
        
        NSString *url = @"";
        
        if (_isEdit) {
         
            url = edit_offer_API;
        }else{
            
            url = add_offer_API;

        }
        
        //正确弹出警告款提示正确

        [HMDataManager requestUrl:url params:[@{@"goods_id":_goods_id,@"price":_priceTextField.text} mutableCopy] HidHUD:NO success:^(id result) {

            BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
            
            if ([model.code intValue] == 1) {

                _tureBlock();
                
            }else{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = model.error_msg;
                
                [hud hideAnimated:YES afterDelay:2];
            
            }
            
        } failure:nil];
        

    }else{
        //验证不匹配
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = @"验证码不正确";
        
        [hud hideAnimated:YES afterDelay:2];
        
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
