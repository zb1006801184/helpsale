//
//  PaymentBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/7.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PaymentBuyViewController.h"
#import "AdressModel.h"
#import "AdreeManagerBuyViewController.h"
#import "PaymentVoucherViewController.h"


@interface PaymentBuyViewController ()

@property (nonatomic,strong) AdressModel *adressModel;//地址

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (nonatomic,strong) NSArray *accountArr;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel1;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel2;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel3;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel4;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel5;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel6;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel7;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel8;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel9;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel10;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel11;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel12;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel13;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel14;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel15;


@end

@implementation PaymentBuyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheDefaultAddressAction) name:@"ChangeTheDefaultAddressNotification" object:nil];

    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 96, 44)];
    
    leftLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    leftLabel.textAlignment = NSTextAlignmentLeft;
    
    leftLabel.font = [UIFont systemFontOfSize:18];
    
    leftLabel.text = @"付款";
    
    self.navigationItem.titleView = leftLabel;
    
    self.tableView.tableFooterView = [[UIView alloc]init];

    NSInteger money = [_pay_money integerValue]  * 1.05;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%ld",money];
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = [UIColor colorWithHexString:@"636570"].CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:_label1.bounds].CGPath;
    
    border.frame = _label1.bounds;
    
    border.lineWidth = 1.f;
    
    border.lineCap = @"butt";
    
    border.lineDashPattern = @[@1, @1];
    
    [_label1.layer addSublayer:border];
    
    
    [self loadData];
    
    [self loadData1];

}

- (void)leftBtnAction{

    [self.navigationController popViewControllerAnimated:YES];
    
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

//获取账号
- (void)loadData1{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_huimai_account params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {

            
            _accountArr = result[@"result"][@"data"][@"item"];
            
            for (int i = 0; i < 5; i++) {
                
                NSDictionary *dic = result[@"result"][@"data"][@"item"][i];

                if (i == 0) {
                    
                    _accountLabel1.text = dic[@"name"];
                    
//                    _accountLabel2.text = dic[@"bank"];

                    _accountLabel3.text = dic[@"account"];

                }else if (i == 1){
                    
                    _accountLabel4.text = dic[@"name"];
                    
                    _accountLabel5.text = dic[@"bank"];
                    
                    _accountLabel6.text = dic[@"account"];

                    
                }else if (i == 2){
                    
                    _accountLabel7.text = dic[@"name"];
                    
                    _accountLabel8.text = dic[@"bank"];
                    
                    _accountLabel9.text = dic[@"account"];
                    
                }else if (i == 3){
                    
                    _accountLabel10.text = dic[@"name"];
                    
                    _accountLabel12.text = dic[@"bank"];
                    
                    _accountLabel11.text = dic[@"account"];
                    
                    
                }else if (i == 4){
                    
                    _accountLabel13.text = dic[@"name"];
                    
                    _accountLabel14.text = dic[@"bank"];
                    
                    _accountLabel15.text = dic[@"account"];
                    
                }
                
                
                
            }
            
            
        }
        
    } failure:nil];
    
}


//选择支付方式
- (IBAction)selectMethodPaymentAction:(id)sender {
    
    UIButton *bt = (UIButton*)sender;
    
    if (!bt.selected) {
        
        if (bt.tag == 100) {
            
            UIButton *button1 = [self.view viewWithTag:101];
            UIButton *button2 = [self.view viewWithTag:102];
            button1.selected = NO;
            button2.selected = NO;
            bt.selected = YES;
            
        }else if (bt.tag == 101){
            
            UIButton *button1 = [self.view viewWithTag:100];
            UIButton *button2 = [self.view viewWithTag:102];
            button1.selected = NO;
            button2.selected = NO;
            bt.selected = YES;
            
        }else if (bt.tag == 102){
            
            UIButton *button1 = [self.view viewWithTag:100];
            UIButton *button2 = [self.view viewWithTag:101];
            button1.selected = NO;
            button2.selected = NO;
            bt.selected = YES;
            
        }

    }

    
}
//选择会麦账号
- (IBAction)SelectAccountAction:(id)sender {
    
    UIButton *bt = (UIButton*)sender;
    
    if (!bt.selected) {
        
        for (int i = 0; i < 5; i++) {
            
            UIButton *button = [self.view viewWithTag:200 + i];

            button.selected = NO;
            
        }
        
        bt.selected = YES;

        
//        if (bt.tag == 200) {
//            
//            UIButton *button1 = [self.view viewWithTag:201];
//            UIButton *button2 = [self.view viewWithTag:202];
//            UIButton *button3 = [self.view viewWithTag:203];
//            UIButton *button4 = [self.view viewWithTag:204];
//            button1.selected = NO;
//            button2.selected = NO;
//            button3.selected = NO;
//            button4.selected = NO;
//
//            
//        }else if (bt.tag == 201){
//            
//            UIButton *button1 = [self.view viewWithTag:200];
//            UIButton *button2 = [self.view viewWithTag:202];
//            button1.selected = NO;
//            button2.selected = NO;
//            bt.selected = YES;
//            
//        }else if (bt.tag == 202){
//            
//            UIButton *button1 = [self.view viewWithTag:200];
//            UIButton *button2 = [self.view viewWithTag:201];
//            button1.selected = NO;
//            button2.selected = NO;
//            bt.selected = YES;
//            
//        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        AdreeManagerBuyViewController *adreeManagerBuyVC = [[AdreeManagerBuyViewController alloc]init];
        
        [self.navigationController pushViewController:adreeManagerBuyVC animated:YES];
        

    }else if (indexPath.row == 10){

        NSMutableDictionary *params = [NSMutableDictionary dictionary];

        [params setObject:_acution_id forKey:@"acution_id"];
        
//        [params setObject:_pay_money forKey:@"pay_money"];

        int pay_type = 0;
        
        for (int i = 0; i < 3; i ++) {
            
            UIButton *bt = [self.view viewWithTag:100 + i];
            
            if (bt.selected) {
                
                pay_type = i + 1;
            }
            
        }
        
        [params setObject:[NSString stringWithFormat:@"%d",pay_type] forKey:@"pay_type"];

        int accept_account = 0;
        
        for (int i = 0; i < 5; i ++) {
            
            UIButton *bt = [self.view viewWithTag:200 + i];
            
            if (bt.selected) {
                
                accept_account = i;
                
            }

        }
        
        
        if (accept_account == 0) {
            
            [params setObject:[NSString stringWithFormat:@"%@(%@)",_accountArr[accept_account][@"name"],_accountArr[accept_account][@"account"]] forKey:@"accept_account"];

        }else{
            
            [params setObject:[NSString stringWithFormat:@"%@(%@)",_accountArr[accept_account][@"bank"],_accountArr[accept_account][@"account"]] forKey:@"accept_account"];
            
        }
        
        
//        [params setObject:[NSString stringWithFormat:@"%d",accept_account] forKey:@"accept_account"];
        
        [params setObject:_accountTextField.text forKey:@"pay_account"];
        
        [params setObject:_adressModel.id forKey:@"address_id"];

        
//        [params setObject:_adressModel.user_name forKey:@"user_name"];
//
//        [params setObject:_adressModel.mobile forKey:@"mobile"];
//
//        [params setObject:_adressModel.province forKey:@"province"];
//
//        [params setObject:_adressModel.city forKey:@"city"];
//
//        [params setObject:_adressModel.area forKey:@"area"];
//        
//        [params setObject:_adressModel.address forKey:@"address"];
//
//        [params setObject:_adressModel.province_id forKey:@"province_id"];
//
//        [params setObject:_adressModel.city_id forKey:@"city_id"];
//
//        [params setObject:_adressModel.area_id forKey:@"area_id"];
        
        PaymentVoucherViewController *paymentVoucherVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentVoucherViewController"];

        paymentVoucherVC.params = params;
        
        [self.navigationController pushViewController:paymentVoucherVC animated:YES];


    }
    
}


//
- (void)changeTheDefaultAddressAction{
    
    [self loadData];
    
}

- (void)dealloc{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
