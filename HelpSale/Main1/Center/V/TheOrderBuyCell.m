//
//  TheOrderBuyCell.m
//  HelpSale
//
//  Created by CYT on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "TheOrderBuyCell.h"

@implementation TheOrderBuyCell



- (void)setModel:(OrderBuyModel *)model{

    _model = model;

    _orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",_model.order_sn];
    
    _timeLabel.text = _model.add_time;
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = [UIColor colorWithHexString:@"636570"].CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:_FHButton.bounds].CGPath;
    
    border.frame = _FHButton.bounds;
    
    border.lineWidth = 1.f;
    
    border.lineCap = @"butt";
    
    border.lineDashPattern = @[@1, @1];
    
    [_FHButton.layer addSublayer:border];
    
    _CourierLabel.text = [NSString stringWithFormat:@"%@:%@",_model.express_name,_model.express_no];
    
    _nameLabel.text = _model.user_name;
    
    _adressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_model.province,_model.city,_model.area,_model.address];
    
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_model.picture]];

    _goodsNameLabel.text = _model.goods_name;
    
    
    NSString *priceStr = [NSString stringWithFormat:@"合计%@（含5%%佣金）",_model.pay_money];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%@",_model.pay_money]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CF9444"] range:range];
    
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    NSRange range1 = [priceStr rangeOfString:@"（含5%佣金）"];

    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F5554A"] range:range1];
    
    
    _moneyLabel.attributedText = string;
    
    _tureButton.layer.cornerRadius = 4;
    
    _tureButton.layer.masksToBounds = YES;

    if ([_model.status isEqualToString:@"18"]) {
        
        [_tureButton setTitle:@"已完成" forState:UIControlStateNormal];
        
        _tureButton.layer.borderWidth = 1;
        
        _tureButton.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;

        [_tureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        
        _tureButton.userInteractionEnabled = NO;
        
    }else{
        
        [_tureButton setTitle:@"确认收货" forState:UIControlStateNormal];
        
        _tureButton.layer.borderWidth = 1;
        
        _tureButton.layer.borderColor = [UIColor colorWithHexString:@"C79D65"].CGColor;
        
        [_tureButton setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateNormal];

        _tureButton.userInteractionEnabled = YES;

    }
    
}


- (IBAction)tureAction:(id)sender {
    
    
    UIAlertView  *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"请仔细核对货品无误再确认收货，确认收货超过24小时，对货品出现异议将不再受理" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertV show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:_model.id forKey:@"acution_id"];
        
        [HMDataManager requestUrl:confirm_express_API params:params HidHUD:NO success:^(id result) {
            
            BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
            
            if ([model.code intValue] == 1) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

                hud.label.text = @"确认收货成功";
                
                hud.mode = MBProgressHUDModeText;
                
                [hud hideAnimated:YES afterDelay:2];
                
                _backBlock();
            }
            
        } failure:^(NSError *error) {
            
        }];

    }
}

@end
