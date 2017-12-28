//
//  ResgiterPassPhoneViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "ResgiterPassPhoneViewController.h"
#import "ResgiterPasswordViewController.h"
@interface ResgiterPassPhoneViewController ()
{
    NSInteger countDown;
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@end

@implementation ResgiterPassPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //views
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_mainView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeClick:(id)sender {
    [self getCodeNet];
}

- (IBAction)nextStepClick:(id)sender {
    
    [self testCodeNet];
}

#pragma mark - Net
- (void)getCodeNet {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_phoneTextField.text forKey:@"mobile"];
    
    [HMDataManager requestUrl:@"apiv1/Sendsms/send_register_code" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            [self netWork];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//验证  验证码
- (void)testCodeNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"86" forKey:@"code"];
    [paramDic setObject:_phoneTextField.text forKey:@"mobile"];
    [paramDic setObject:_codeTextField.text forKey:@"verifycode"];
    [paramDic setObject:@"2" forKey:@"model"];
    [HMDataManager requestUrl:@"apiv1/Sendsms/verify_code" params:paramDic HidHUD:NO success:^(id result) {
        NSString *rand_string = result[@"result"][@"data"][@"rand_string"];
        if (rand_string.length > 1) {
            ResgiterPasswordViewController *resgiterVC = [[ResgiterPasswordViewController alloc]init];
            resgiterVC.personal = _personal;
            resgiterVC.phone_string = _phoneTextField.text;
            resgiterVC.rand_string = rand_string;
            
            [self.navigationController pushViewController:resgiterVC animated:YES];
        }else{
            [self.view showLableViewWithMessage:@"验证码错误!"];
        }
    } failure:^(NSError *error) {
        
    }];

}

- (void)netWork{
    [self NSTimer];
}

- (void)NSTimer{
    countDown = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    self.getCodeButton.enabled = NO;
}
- (void)timerFireMethod:(id)sender{
    countDown--;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)countDown]forState:UIControlStateNormal];
    [self.getCodeButton setBackgroundColor:[UIColor colorWithHexString:@"E8E8E8" alpha:1]];
    [self.getCodeButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
    if (countDown < 1) {
        [timer invalidate];
        [self.getCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getCodeButton setBackgroundColor:[UIColor colorWithHexString:@"937667" alpha:1]];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.getCodeButton.enabled = YES;
    }
}




@end
