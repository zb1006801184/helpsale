//
//  LeftMainViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/13.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "LeftMainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "LoginViewController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"
@interface LeftMainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *onLineImage;

@property (weak, nonatomic) IBOutlet UIButton *onLineButton;

@property (weak, nonatomic) IBOutlet UIImageView *personalImage;

@property (weak, nonatomic) IBOutlet UIButton *personalButton;

@property (weak, nonatomic) IBOutlet UIImageView *aboutImage;

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;

@property (weak, nonatomic) IBOutlet UIImageView *onLineNoticeImage;

@property (weak, nonatomic) IBOutlet UIImageView *personalNoticeImage;

@property (weak, nonatomic) IBOutlet UIImageView *aboutNoticeImage;

//底部个人信息视图
@property (strong, nonatomic) IBOutlet UIView *bottomPersonalMessageView;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation LeftMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _onLineImage.highlighted = YES;
    _onLineButton.selected = YES;
    _onLineNoticeImage.hidden = NO;
    _headImage.layer.masksToBounds = YES;
    //view
    [self initViews];
    
    _personal = [HSUserDetaiModel getPersonalForKey:[HSUserDetaiModel getPersonal]];
    //区分身份初始化视图
    if ([_personal isEqualToString:buyer]) {
        [_onLineButton setTitle:@"在线拍卖" forState:UIControlStateNormal];
    }

    //action
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *login = [HSUserDetaiModel getLoginForKey:[HSUserDetaiModel getLoginKey]];
    if ([login isEqualToString:@"login"]) {
        _bottomPersonalMessageView.hidden = NO;
    }else {
        _bottomPersonalMessageView.hidden = YES;
    }

    UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@""]];
    
    _userNameLabel.text = model.nick_name;
    
    
}

- (void)initViews {
    _bottomPersonalMessageView.frame = CGRectMake(0, kScreenHeight - 100, 230, 100);
    [self.view addSubview:_bottomPersonalMessageView];
    _bottomPersonalMessageView.hidden = YES;
    NSString *login = [HSUserDetaiModel getLoginForKey:[HSUserDetaiModel getLoginKey]];
    if ([login isEqualToString:@"login"]) {
        _bottomPersonalMessageView.hidden = NO;
    }
}

- (void)initState {
    _onLineImage.highlighted = NO;
    _onLineButton.selected = NO;
    _personalImage.highlighted = NO;
    _personalButton.selected = NO;
    _aboutImage.highlighted = NO;
    _aboutButton.selected = NO;
    _onLineNoticeImage.hidden = YES;
    _personalNoticeImage.hidden = YES;
    _aboutNoticeImage.hidden = YES;
}
#pragma mark - actions

- (IBAction)personalClick:(id)sender {
    UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
    nav.selectedIndex = 1;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}


- (IBAction)ChangeTabbarClick:(id)sender {
    
    UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
    UIButton * button = sender;
    nav.selectedIndex = button.tag - 1;
    [self initState];
    
    if (button == _onLineButton) {
        _onLineButton.selected = YES;
        _onLineImage.highlighted = YES;
        _onLineNoticeImage.hidden = NO;
    }else if (button == _personalButton) {
        _personalButton.selected = YES;
        _personalImage.highlighted = YES;
        _personalNoticeImage.hidden = NO;
    }else if (button == _aboutButton) {
        _aboutButton.selected = YES;
        _aboutImage.highlighted = YES;
        _aboutNoticeImage.hidden = NO;
    }

//    if (button == _personalButton) {
//        
//        PersonalCenterViewController *personalCenterVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
//                
//        self.mm_drawerController.centerViewController = [self getNavigationController:personalCenterVC title:@"" selectImageStr:@"" narmalImageStr:@""];
//        
//    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
    
    
}


- (UINavigationController *)getNavigationController:(UIViewController *)viewController title:(NSString *)title selectImageStr:(NSString *)selectImageStr narmalImageStr:(NSString *)narmalImageStr {
    
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.tabBarItem.title = title;
    nav.navigationBar.barTintColor = [UIColor colorWithHexString:@"050634"];
    NSDictionary *dic=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [nav.navigationBar setTitleTextAttributes:dic];
    nav.tabBarItem.image = [[UIImage imageNamed:narmalImageStr]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return nav;
    
}
//登录click
- (IBAction)loginClick:(id)sender {
    
    UITabBarController * tabbarVC  = (UITabBarController*)self.mm_drawerController.centerViewController;
    LoginViewController *newLoginVC = [[LoginViewController alloc]init];
    UINavigationController *newNav = [[UINavigationController alloc] initWithRootViewController:newLoginVC];
    NSMutableArray *VCAry = [NSMutableArray array];
    [VCAry addObjectsFromArray:tabbarVC.viewControllers];
    [VCAry replaceObjectAtIndex:3 withObject:newNav];
    tabbarVC.viewControllers = VCAry;
    tabbarVC.selectedIndex = 3;
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}
//退出登录
- (IBAction)loginOutClick:(id)sender {
    [HSUserDetaiModel setLogin:@"loginOut" forKey:[HSUserDetaiModel getLoginKey]];
    NSUserDefaults *user = [[NSUserDefaults alloc]init];
    [user removeObjectForKey:[HSUserDetaiModel getUserDetailModelKey]];
    [user removeObjectForKey:[HSUserDetaiModel getPersonal]];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
