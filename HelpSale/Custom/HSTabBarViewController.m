//
//  HSTabBarViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/13.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "HSTabBarViewController.h"
#import "OnlineSaleViewController.h"
#import "AboutHSViewController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"
#import "SaleCenterViewController.h"
#import "BuyersHomeViewController.h"

@interface HSTabBarViewController ()

@end

@implementation HSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor redColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    self.tabBar.barTintColor = [UIColor blackColor];
    self.tabBar.translucent = NO;
    NSArray *array;
    _personal = [HSUserDetaiModel getPersonalForKey:[HSUserDetaiModel getPersonal]];
    if ([_personal isEqualToString:seller]) {
        array = @[[self saleCenter],[self PersonalCenter],[self AboutHS]];
    }else {
        array = @[[self OnlineSale],[self PersonalCenterBuy],[self AboutHS]];
    };

    self.viewControllers = array;

}

- (void)viewWillLayoutSubviews {
    
    //设置tabbar高度为0
    CGRect tabFrame =self.tabBar.frame;
    
    tabFrame.size.height= 0;
    
    tabFrame.origin.y= self.view.frame.size.height- 0;
    
    self.tabBar.frame= tabFrame;
    
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

- (UINavigationController *)saleCenter {
    SaleCenterViewController *saleCenter = [[SaleCenterViewController alloc]init];
    return [self getNavigationController:saleCenter title:@"saleCenter" selectImageStr:@"" narmalImageStr:@""];
}
- (UINavigationController *)OnlineSale {
    
    BuyersHomeViewController *buyersHomeVC = [[BuyersHomeViewController alloc]init];
    
    return [self getNavigationController:buyersHomeVC title:@"onLineSale" selectImageStr:@"" narmalImageStr:@""];
}

- (UINavigationController *)AboutHS {
    AboutHSViewController *AboutHSVC = [[AboutHSViewController alloc]init];
    return [self getNavigationController:AboutHSVC title:@"AboutHS" selectImageStr:@"" narmalImageStr:@""];
}

- (UINavigationController *)PersonalCenterBuy {

    PersonalCenterViewController *personalCenterVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
    
    return [self getNavigationController:personalCenterVC title:@"onLineSale" selectImageStr:@"" narmalImageStr:@""];

}

- (UINavigationController *)PersonalCenter {
    
    PersonalCenterViewController *PersonalCnterVC = [[PersonalCenterViewController alloc]init];
    return [self getNavigationController:PersonalCnterVC title:@"PersonalCenterView" selectImageStr:@"" narmalImageStr:@""];
}

- (UINavigationController *)login {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    return [self getNavigationController:loginVC title:@"login" selectImageStr:@"" narmalImageStr:@""];
}


@end
