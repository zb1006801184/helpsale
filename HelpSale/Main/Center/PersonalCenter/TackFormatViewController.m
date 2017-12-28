//
//  TackFormatViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/30.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "TackFormatViewController.h"

@interface TackFormatViewController ()

@property (weak, nonatomic) IBOutlet UIButton *expressButton;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;
@property (weak, nonatomic) IBOutlet UIButton *insureButton;
@property (weak, nonatomic) IBOutlet UIButton *toPayButton;

@property (nonatomic, copy) NSString *recovery_type;
@property (nonatomic, copy) NSString *is_safe;
@property (nonatomic, copy) NSString *delivery_pay;


@end

@implementation TackFormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"取回方式";
    [self initViews];
}

- (void)initViews {
    
    
    if (_model) {

        _is_safe = _model.is_safe;
        
        _delivery_pay = _model.delivery_pay;
        
        _recovery_type = _model.recovery_type;
        
        
        if ([_model.recovery_type integerValue] == 1) {
            
            _expressButton.selected = YES;
            _takeButton.selected = NO;
            _recovery_type = @"1";
            
            if ([_model.is_safe isEqualToString:@"1"]) {
                
                _insureButton.selected = YES;
                
            }
            
            if ([_model.delivery_pay isEqualToString:@"1"]) {
                
                _toPayButton.selected = YES;
                
            }
            
        }else{
            
            _expressButton.selected = NO;
            _takeButton.selected = YES;
            _recovery_type = @"2";
            
        }

    }
    
    
//    _expressButton.selected = YES;
//    _insureButton.selected = YES;
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureClick:(id)sender {
    [self getDataNet];
}
//快递
- (IBAction)expressClick:(id)sender {
    _expressButton.selected = YES;
    _takeButton.selected = NO;
    _recovery_type = @"1";
}
//自取
- (IBAction)takeClick:(id)sender {
    _expressButton.selected = NO;
    _takeButton.selected = YES;
    _recovery_type = @"2";

}
//保价
- (IBAction)insureClick:(id)sender {
    _insureButton.selected = !_insureButton.selected;
    if (_insureButton.selected) {
        _is_safe = @"1";
    }else {
        _is_safe = @"2";
    }
}

//到付
- (IBAction)toPayClick:(id)sender {
    _toPayButton.selected = !_toPayButton.selected;
    if (_toPayButton.selected) {
        _delivery_pay = @"1";
    }else {
        _delivery_pay = @"2";
    }

}


#pragma mark - Net
- (void)getDataNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_recovery_type.length < 1 && _is_safe.length < 1 && _delivery_pay.length < 1) {
        [self.view showLableViewWithMessage:@"请选择取回方式!"];
        return;
    }
    if (_recovery_type.length > 0) {
        [paramDic setObject:_recovery_type forKey:@"recovery_type"];
    }
    if (_is_safe.length > 0) {
        [paramDic setObject:_is_safe forKey:@"is_safe"];
    }
    if (_delivery_pay.length > 0) {
        [paramDic setObject:_delivery_pay forKey:@"delivery_pay"];
    }
    [paramDic setObject:_model.id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Order/edit_order" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.setPayFormtBlock) {
                self.setPayFormtBlock();
            }
        }
    } failure:^(NSError *error) {
        
    }];

}


@end
