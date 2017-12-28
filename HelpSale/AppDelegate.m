//
//  AppDelegate.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/11.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "HSTabBarViewController.h"
#import "LeftMainViewController.h"
#import "LoginViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RYDataManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>



@interface AppDelegate ()<RCIMUserInfoDataSource,WXApiDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //去除系统默认导航栏特效
    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSString *login = [HSUserDetaiModel getLoginForKey:[HSUserDetaiModel getLoginKey]];
    //已登录
    if ([login isEqualToString:@"login"]) {
        //初始化控制器
        LeftMainViewController *leftVC = [[LeftMainViewController alloc]init];
        leftVC.personal = [HSUserDetaiModel getPersonalForKey:[HSUserDetaiModel getPersonal]];
        //初始化导航控制器
        HSTabBarViewController *centerTab = [[HSTabBarViewController alloc]init];
        //使用MMDrawerController
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerTab leftDrawerViewController:leftVC rightDrawerViewController:nil];
        //设置打开/关闭抽屉的手势
        self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
        //设置左右两边抽屉显示的多少
        self.drawerController.maximumLeftDrawerWidth = 230;
        self.drawerController.maximumRightDrawerWidth = 230;
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setRootViewController:self.drawerController];
        [self.window makeKeyAndVisible];
        
        [RYDataManager RYTokenAndLogin];

    }else {
        
    //未登录
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setRootViewController:nav];
        [self.window makeKeyWindow];
    }
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        
        [application registerUserNotificationSettings:settings];
        
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58b3e904f43e4821dc001288"];

    [WXApi registerApp:@"wx190f090a7feb1fdf"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx190f090a7feb1fdf" appSecret:@"01aa520ae0b9d8ace7cd61202b4b5df8" redirectURL:@""];

    //融云
    [[RCIM sharedRCIM] initWithAppKey:@"bmdehs6pb11us"];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];

    return YES;
}

//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    NSLog(@"%@",token);
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application

shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier

{

    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        
        return NO;
        
    }
    
    return YES;
    
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayNotifation" object:nil];
            }

        }];
    }
    return YES;
}


#pragma mark - WXApiDelegate

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
    
    if (resp.errCode == 0) {
        
        
        if (resp.errCode == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayNotifation" object:nil];
            
        }

        
    }
    
    
}



@end
