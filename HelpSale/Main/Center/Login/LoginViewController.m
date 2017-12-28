//
//  LoginViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/15.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "LeftMainViewController.h"
#import "HSTabBarViewController.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"
#import "RYDataManager.h"

@interface LoginViewController (){

    NSInteger countDown;
    NSTimer *timer;

}
//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *resgiterButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarController.tabBar.hidden = YES;
    //views
    [self initViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)initViews {
    self.resgiterButton.layer.borderColor = [UIColor colorWithHexString:@"D79C65"].CGColor;
    _phoneTextField.text = [HSUserDetaiModel getIphoneNumbelForKey:[HSUserDetaiModel getIphoneNumbel]];
}

- (void)initWindowsWithPersonal:(NSString *)personal {
    //初始化控制器
    LeftMainViewController *leftVC = [[LeftMainViewController alloc]init];
    leftVC.personal = personal;
    //初始化导航控制器
    HSTabBarViewController *centerTab = [[HSTabBarViewController alloc]init];
    centerTab.personal = personal;
    //使用MMDrawerController
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerTab leftDrawerViewController:leftVC rightDrawerViewController:nil];
    //设置打开/关闭抽屉的手势
    appDelegate.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    appDelegate.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //设置左右两边抽屉显示的多少
    appDelegate.drawerController.maximumLeftDrawerWidth = 230;
    appDelegate.drawerController.maximumRightDrawerWidth = 230;
    appDelegate.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [appDelegate.window setRootViewController:appDelegate.drawerController];
    [appDelegate.window makeKeyAndVisible];
}
#pragma mark - action

- (IBAction)leftNavClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)loginClick:(id)sender {
    [self loginNet];
}

- (IBAction)resgiterClick:(id)sender {
    RegisterViewController *resgiterVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:resgiterVC animated:YES];
}

- (IBAction)forgetPasswordClick:(id)sender {
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
#pragma mark - Net
- (void)loginNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"86" forKey:@"code"];
    [paramDic setObject:_phoneTextField.text forKey:@"mobile"];

    NSString *url = @"";
    
    if (_selectButton.selected) {
        
        url = @"Apiv1/User/verify_code_login";
        
        [paramDic setObject:_passwordTextField.text forKey:@"verifycode"];

    }else{
        
        url = @"apiv1/User/password_login";
        
        [paramDic setObject:_passwordTextField.text forKey:@"password"];

    }
    
    [HMDataManager requestUrl:url params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            NSUserDefaults *user = [[NSUserDefaults alloc]init];
            [user setObject:result[@"result"][@"data"] forKey:@"HMData"];
            [user synchronize];
            [self getUserInfo];
            
            [RYDataManager RYTokenAndLogin];

        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)getUserInfo {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [HMDataManager requestUrl:@"apiv1/User/get_user_info" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            
            UserDetaiModel *userModel = [[UserDetaiModel alloc]initWithDic:result[@"result"][@"data"]];
            
            [HSUserDetaiModel setUserDetailModel:userModel forKey:[HSUserDetaiModel getUserDetailModelKey]];
            [HSUserDetaiModel setPersonal:userModel.type forkey:[HSUserDetaiModel getPersonal]];
            [HSUserDetaiModel setIphoneNumbel:_phoneTextField.text forKey:[HSUserDetaiModel getIphoneNumbel]];
            [HSUserDetaiModel setLogin:@"login" forKey:[HSUserDetaiModel getLoginKey]];
            
            [self initWindowsWithPersonal:userModel.type];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)getCodeClick:(id)sender {
    [self getCodeNet];
}

#pragma mark - Net
- (void)getCodeNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_phoneTextField.text forKey:@"mobile"];
    [HMDataManager requestUrl:@"Apiv1/Sendsms/send_login_code" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            [self netWork];
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


//短信登录和密码登录切换
- (IBAction)selectButtonAction:(id)sender {
    
    _selectButton.selected = !_selectButton.selected;
    
    if (_selectButton.selected) {
    
        
        _getCodeButton.hidden = NO;
        
//        [_selectButton setTitle:@"密码登录" forState:UIControlStateNormal];
        
        _passwordLabel.text = @"验证码";
        
        _passwordTextField.placeholder = @"输入验证码";
        
    }else{
    
        _getCodeButton.hidden = YES;

//        [_selectButton setTitle:@"短信验证码登录" forState:UIControlStateNormal];

        _passwordLabel.text = @"密码";
        
        _passwordTextField.placeholder = @"输入密码";

    }
    
}

@end
