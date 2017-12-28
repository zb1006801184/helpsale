//
//  BuyersHomeCell.m
//  HelpSale
//
//  Created by CYT on 2017/1/1.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BuyersHomeCell.h"
#import "PaymentBuyViewController.h"
#import "UIView+Controller.h"

@implementation BuyersHomeCell



- (void)setModel:(LotsListBuyModel *)model{

    _model = model;
    
    if (model.category_name.length > 3) {
        
        _ViewWidth.constant = 80;
        
    }else{
        
        _ViewWidth.constant = 52;
    }

    _categoryLabel.layer.borderWidth = .5;
    
    _categoryLabel.layer.borderColor = [UIColor colorWithHexString:@"d9d9d9"].CGColor;

    
    _categoryLabel.text = _model.category_name;
    
    _editButton.layer.borderWidth = 1;
    
    _editButton.layer.borderColor = [UIColor colorWithHexString:@"C79D65"].CGColor;
    
    _editButton.layer.cornerRadius = 2;
    
    _editButton.layer.masksToBounds = YES;
    
    
    _goodsNameLabel.text = _model.goods_name;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ 结束",_model.end_time];
    
    [_goodsImageV sd_setImageWithURL:[NSURL URLWithString:_model.picture]];

    
    if ([_model.status integerValue] == 1) {
        
        _timeImageV.image = [UIImage imageNamed:@"timeless"];
        
        _timeImageHeight.constant = 16;
        
        _timeImageWidth.constant = 28;
        
        _statesLabel.text = @"竞拍中";

        _statesLabel.textColor = [UIColor colorWithHexString:@"C79D65"];

    }else{
        
        _timeImageV.image = [UIImage imageNamed:@"time"];
        
        _timeImageHeight.constant = 16;
        
        _timeImageWidth.constant = 16;
        
        _statesLabel.text = @"已成交";
        
        _statesLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];
        
    }
    
//    if ([model.status_format isEqualToString:@"已成交"]  ) {
//        
//        _statesLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];
//        
//    }else{
//        
//        _statesLabel.textColor = [UIColor colorWithHexString:@"C79D65"];
//
//    }
    
    CGRect rect = [_model.goods_name boundingRectWithSize:CGSizeMake(kScreenWidth - 112, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    _goodNameHeight.constant = rect.size.height + 1;
    
    if (_isHome) {
        
        _priceLabel.textAlignment = NSTextAlignmentLeft;

        NSString *priceStr = [NSString stringWithFormat:@"已有%@人报价  %@人围观",_model.offer_count,_model.view];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr];
        
        NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%@",_model.offer_count]];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FE5B62"] range:range];
        
        _priceLabel.attributedText = string;
        
        _editButton.hidden = YES;
        
        _promptLabel.hidden = YES;
        
        _statesLabel.hidden = NO;

        
    }else{
        
        if ([_model.status isEqualToString:@"1"]) {
            
            _statesLabel.hidden = YES;
            
            _promptLabel.hidden = YES;
            
            _editButton.hidden = NO;
            
            [_editButton setTitle:@"修改出价" forState:UIControlStateNormal];
            
            NSString *priceStr = [NSString stringWithFormat:@"我的出价%@",_model.my_price];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr];
            NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%@",_model.my_price]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CF9444"] range:range];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
            
            _priceLabel.attributedText = string;

            _priceLabel.textAlignment = NSTextAlignmentRight;
            
        }else{

            _statesLabel.hidden = NO;
            
            _statesLabel.textColor = [UIColor colorWithHexString:@"C79D65"];

            
            NSString *priceStr = [NSString stringWithFormat:@"成交价 %@ 我的出价 %@",_model.now_high_price,_model.my_price];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr];
            
            NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%@",_model.my_price]];
            
            NSRange range2 = NSMakeRange(priceStr.length - _model.my_price.length, _model.my_price.length);
            
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CF9444"] range:range];
            
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
            
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CF9444"] range:range2];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range2];
            
            _priceLabel.attributedText = string;
            
            _priceLabel.textAlignment = NSTextAlignmentRight;
            
            if ([_model.status isEqualToString:@"3"]) {
                
                _statesLabel.text = @"待付款";
                
                _promptLabel.hidden = NO;

                _editButton.hidden = NO;
                
                [_editButton setTitle:@"确定付款" forState:UIControlStateNormal];
                
                _promptLabel.text = [NSString stringWithFormat:@"%@ 后未支付，将扣除5%%保证金",_model.pay_limit_time];
                
            }else if ([_model.status isEqualToString:@"4"]){
            
                _statesLabel.text = @"已付款待核实";

                _editButton.hidden = YES;
                
                _promptLabel.hidden = YES;

            }else if ([_model.status isEqualToString:@"2"]){
                
                _statesLabel.text = @"等待卖家确认报价";
                
                _editButton.hidden = YES;
                
                _promptLabel.hidden = YES;
                
            }else if ([_model.status isEqualToString:@"5"]){
                
                _statesLabel.text = @"待发货";
                
                _editButton.hidden = YES;
                
                _promptLabel.hidden = YES;
                
            }else if ([_model.status isEqualToString:@"6"]){
                
                _statesLabel.text = @"已发货";
                
                [_editButton setTitle:@"确认收货" forState:UIControlStateNormal];

                _editButton.hidden = NO;
                
                _promptLabel.hidden = NO;
                
                _promptLabel.text = [NSString stringWithFormat:@"剩余确认时间：%@ ",_model.confirm_limit_time];


            }else if ([_model.status isEqualToString:@"7"]){
                
                _statesLabel.text = @"已成交";
                
                _editButton.hidden = YES;
                
                _promptLabel.hidden = YES;
                
                _statesLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];

            }else if ([_model.status isEqualToString:@"1000"]){
                
                _statesLabel.hidden = YES;
                
                _editButton.hidden = YES;
                
                _promptLabel.hidden = YES;
                
                
                NSString *priceStr = [NSString stringWithFormat:@"我的出价 %@ 排名 %@",_model.my_price,_model.rank];
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr];
                
                NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%@",_model.my_price]];
                
                NSRange range2 = NSMakeRange(priceStr.length - _model.rank.length, _model.rank.length);
                
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CF9444"] range:range];
                
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
                
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CF9444"] range:range2];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range2];

                _priceLabel.attributedText = string;

            }else{
            
                _statesLabel.text = _model.status_format;
                
                _editButton.hidden = YES;
                
                _promptLabel.hidden = YES;
                
                _statesLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];

            }
            
            
            
        }
        
//        _promptLabel.hidden = YES;

}
    
    
    

}
- (IBAction)editAction:(id)sender {
    
    
    if (!_isHome&&[_model.status isEqualToString:@"1"]) {
        
        _modifyQuotationBlock();
        
    }else if ([_model.status isEqualToString:@"6"]){
        
        UIAlertView  *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"请仔细核对货品无误再确认收货，确认收货超过24小时，对货品出现异议将不再受理" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertV show];

        
        
    }else  if ([_model.status isEqualToString:@"3"]) {

        PaymentBuyViewController *paymentBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentBuyViewController"];

        paymentBuyVC.acution_id = _model.id;
        
        paymentBuyVC.pay_money = _model.now_high_price;
        
        [self.viewController.navigationController pushViewController:paymentBuyVC animated:YES];
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:_model.id forKey:@"acution_id"];
        
        [HMDataManager requestUrl:confirm_express_API params:params HidHUD:NO success:^(id result) {
            
            BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
            
            if ([model.code intValue] == 1) {
                
                _backBlock();
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
}



@end
