//
//  EditPhoneBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/5.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "EditPhoneBuyViewController.h"

@interface EditPhoneBuyViewController (){
    
    UITextField *accountTextField;
    UITextField *passwordTextField;
    
    UIButton *codeButton;
    
    UIButton *trueButton;
    
    NSInteger number;
    
}


@end

@implementation EditPhoneBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleStr = @"个人信息";
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    
    number = 60;

    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(32.5, 103.5 , 90, 14)];
    
    
    if (_typeStr == 1) {
        
        numLabel.text = @"当前手机号";

    }else{
    
        numLabel.text = @"新手机号";

    }
    
    
    numLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    numLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:numLabel];
    
    accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(114.5, 103.5, kScreenWidth - 103.5 - 64, 14)];
    
    accountTextField.font = [UIFont systemFontOfSize:14];
    
    accountTextField.textColor =[UIColor colorWithHexString:@"#636570"];
    
    [self.view addSubview:accountTextField];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(32.5, 125.5 , kScreenWidth - 65, .5)];
    
    line.backgroundColor = [UIColor colorWithHexString:@"d8d8d8"];
    
    [self.view addSubview:line];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(32.5, 180, kScreenWidth - 65, .5)];
    
    line1.backgroundColor = [UIColor colorWithHexString:@"d8d8d8"];
    
    [self.view addSubview:line1];
    

    UILabel *numLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(32.5, 158, 70, 14)];
    
    numLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    
    numLabel1.font = [UIFont systemFontOfSize:14];
    
    numLabel1.text = @"验证码";
    
    [self.view addSubview:numLabel1];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(114.5, 158 , kScreenWidth - 103.5 - 64 - 32.5, 14)];
    
    passwordTextField.font = [UIFont systemFontOfSize:14];
    passwordTextField.textColor =[UIColor colorWithHexString:@"#636570"];
    passwordTextField.secureTextEntry = YES;
    
    [self.view addSubview:passwordTextField];
    
    accountTextField.placeholder = @"输入您的手机号";
    passwordTextField.placeholder = @"输入验证码";

    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    codeButton.frame = CGRectMake(kScreenWidth - 32.5 - 83, 150, 83, 26);
    
    codeButton.backgroundColor = [UIColor colorWithHexString:@"#D3B180"];
    
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [codeButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [codeButton addTarget:self action:@selector(codeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.layer.cornerRadius = 4;
    codeButton.layer.masksToBounds = YES;
    
    [self.view addSubview:codeButton];

    
    trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    trueButton.frame = CGRectMake(32.5, 220.5, kScreenWidth - 32.5 - 44, 44);

    trueButton.backgroundColor = [UIColor colorWithHexString:@"D3B180"];

    trueButton.layer.cornerRadius = 4;
    
    trueButton.layer.masksToBounds = YES;
    
    if (_typeStr == 1) {
        
        [trueButton setTitle:@"下一步" forState:UIControlStateNormal];
        
    }else{
        
        [trueButton setTitle:@"确定" forState:UIControlStateNormal];
        
    }

    
    [trueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [trueButton addTarget:self action:@selector(trueAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:trueButton];

}

//获取验证码
- (void)codeButtonAction:(UIButton*)bt{
    
    if ([accountTextField.text isEqualToString:@""]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.removeFromSuperViewOnHide = YES;
        
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = @"请输入账号";
        
        [hud hideAnimated:YES afterDelay:2];
        
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"86" forKey:@"code"];
    
    [params setObject:accountTextField.text forKey:@"mobile"];
    
    NSString *url = @"";
    
    if (_typeStr == 1) {
    
        url = change_phone_one_code;
    }else{
    
        url = change_phone_two_code;

    }
    
    [HMDataManager requestUrl:url params:params HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {

            codeButton.userInteractionEnabled = NO;
            
            codeButton.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
            [codeButton setTitleColor:[UIColor colorWithHexString:@"#BBBBBB"] forState:UIControlStateNormal];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
- (void)timeAction:(NSTimer*)timer{
    
    if (number == 0) {
        
        codeButton.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
        number = 60;
        codeButton.backgroundColor = [UIColor colorWithHexString:@"#D3B180"];
        [codeButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    }else{
        
        number--;
        
        [codeButton setTitle:[NSString stringWithFormat:@"再次获取(%ld)",number] forState:UIControlStateNormal];
        
    }
    
}




//确定
- (void)trueAction{
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"86" forKey:@"code"];
    [paramDic setObject:accountTextField.text forKey:@"mobile"];
    [paramDic setObject:passwordTextField.text forKey:@"verifycode"];
    [paramDic setObject:@"4" forKey:@"model"];
    [HMDataManager requestUrl:@"apiv1/Sendsms/verify_code" params:paramDic HidHUD:NO success:^(id result) {
        NSString *rand_string = result[@"result"][@"data"][@"rand_string"];
        if (rand_string.length > 1) {

            if (_typeStr == 1) {
                
                EditPhoneBuyViewController *editPhoneBuyVC = [[EditPhoneBuyViewController alloc]init];
                
                editPhoneBuyVC.typeStr = 2;
                
                editPhoneBuyVC.rand_string1 = rand_string;
                
                [self.navigationController pushViewController:editPhoneBuyVC animated:YES];

            }else{
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];

                [params setObject:@"86" forKey:@"code"];
                [params setObject:accountTextField.text forKey:@"mobile"];
                [params setObject:_rand_string1 forKey:@"rand_string1"];
                [params setObject:rand_string forKey:@"rand_string2"];
                
                [HMDataManager requestUrl:change_user_phone params:params HidHUD:NO success:^(id result) {

                    BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
                    if ([model.code intValue] == 1) {

                        UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];
                        
                        model.mobile = accountTextField.text;

                        [HSUserDetaiModel setUserDetailModel:model forKey:[HSUserDetaiModel getUserDetailModelKey]];
                        
                        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];

                    }
                    
                }failure:^(NSError *error) {
                    
                }];
                
            }
            
            
        }else{
            [self.view showLableViewWithMessage:@"验证码错误!"];
        }
    } failure:^(NSError *error) {
        
    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
