//
//  ForgetPasswordTestPassViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/15.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "ForgetPasswordTestPassViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "LeftMainViewController.h"
#import "HSTabBarViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"

@interface ForgetPasswordTestPassViewController ()

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;


@end

@implementation ForgetPasswordTestPassViewController

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
#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginClick:(id)sender {
    [self changePasswordNet];
}
#pragma mark - Net
- (void)changePasswordNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_phone_string forKey:@"mobile"];
    [paramDic setObject:@"86" forKey:@"code"];
    [paramDic setObject:_passwordTextField.text forKey:@"password"];
    [paramDic setObject:_rand_string forKey:@"rand_string"];
    [HMDataManager requestUrl:@"apiv1/User/user_find_password" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            [self loginNet];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)loginNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_phone_string forKey:@"mobile"];
    [paramDic setObject:_passwordTextField.text forKey:@"password"];
    [paramDic setObject:@"86" forKey:@"code"];
    [HMDataManager requestUrl:@"apiv1/User/password_login" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            NSUserDefaults *user = [[NSUserDefaults alloc]init];
            [user setObject:result[@"result"][@"data"] forKey:@"HMData"];
            [user synchronize];
            [self getUserInfo];
        }
    } failure:^(NSError *error) {
        
    }];

}

- (void)getUserInfo {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [HMDataManager requestUrl:@"User/get_user_info" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            UserDetaiModel *userModel = [[UserDetaiModel alloc]initWithDic:result[@"result"][@"data"]];
            [HSUserDetaiModel setUserDetailModel:userModel forKey:[HSUserDetaiModel getUserDetailModelKey]];
            [HSUserDetaiModel setPersonal:userModel.type forkey:[HSUserDetaiModel getPersonal]];
            [HSUserDetaiModel setIphoneNumbel:_phone_string forKey:[HSUserDetaiModel getIphoneNumbel]];
            [HSUserDetaiModel setLogin:@"login" forKey:[HSUserDetaiModel getLoginKey]];
            [self initWindowsWithPersonal:userModel.type];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
