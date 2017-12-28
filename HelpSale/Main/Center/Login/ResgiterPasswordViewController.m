//
//  ResgiterPasswordViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "ResgiterPasswordViewController.h"
#import "LoginViewController.h"
#import "PersonalSureStateViewController.h"
#import "LeftMainViewController.h"
#import "HSTabBarViewController.h"
#import "AppDelegate.h"

@interface ResgiterPasswordViewController ()

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation ResgiterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //views
    self.nickNameTextField.text = [self getNumbelName];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_mainView];
    
}


#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreeClick:(id)sender {
    [self resgiterAccountNet];
}
//生产名字
- (NSString *)getNumbelName
{
    NSString *Namel = [NSString stringWithFormat:@"HM-%d",[self getRandomNumber:100000 to:999999]];
    return Namel;
}
-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

- (IBAction)lookAgreementClick:(id)sender {
}
#pragma mark - Net
- (void)resgiterAccountNet {
    if (_passwordTextField.text.length < 1 || _surePasswordTextField.text.length < 1 ) {
        [self.view showLableViewWithMessage:@"密码不能为空"];
        return;
    }
    if (![_surePasswordTextField.text isEqualToString:_passwordTextField.text]) {
        [self.view showLableViewWithMessage:@"俩次密码不一致"];
        return;
    }
    if (_nickNameTextField.text.length < 1) {
        [self.view showLableViewWithMessage:@"昵称不能为空"];
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_phone_string forKey:@"mobile"];
    [paramDic setObject:@"86" forKey:@"code"];
    [paramDic setObject:_passwordTextField.text forKey:@"password"];
    [paramDic setObject:_nickNameTextField.text forKey:@"nick_name"];
    [paramDic setObject:_rand_string forKey:@"rand_string"];
    [paramDic setObject:_personal forKey:@"type"];
    [HMDataManager requestUrl:@"apiv1/User/register" params:paramDic HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            
            if ([_personal isEqualToString:@"seller"]) {
                
                NSUserDefaults *user = [[NSUserDefaults alloc]init];
                [user setObject:result[@"result"][@"data"] forKey:@"HMData"];
                [user synchronize];
                [self getUserInfo];

                
//                LoginViewController *loginVC = [[LoginViewController alloc]init];
//                [self.navigationController pushViewController:loginVC animated:YES];
//                
            }else{
                PersonalSureStateViewController *personalSureStateVC = [[PersonalSureStateViewController alloc]init];

                [self.navigationController pushViewController:personalSureStateVC animated:YES];
            }
            
        }else{
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
            [HSUserDetaiModel setIphoneNumbel:_phone_string forKey:[HSUserDetaiModel getIphoneNumbel]];
            [HSUserDetaiModel setLogin:@"login" forKey:[HSUserDetaiModel getLoginKey]];
            
            [self initWindowsWithPersonal:userModel.type];
        }
    } failure:^(NSError *error) {
        
    }];
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



@end
