//
//  RegisterViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "RegisterViewController.h"
#import "ResgiterPassPhoneViewController.h"
static NSString *const buyPersonal = @"buyer";
static NSString *const salePersonal = @"seller";
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)buyPersonClick:(id)sender {
    ResgiterPassPhoneViewController *resgiterVC = [[ResgiterPassPhoneViewController alloc]init];
    resgiterVC.personal = buyPersonal;
    [self.navigationController pushViewController:resgiterVC animated:YES];
}

- (IBAction)salePersonClick:(id)sender {
    ResgiterPassPhoneViewController *resgiterVC = [[ResgiterPassPhoneViewController alloc]init];
    resgiterVC.personal = salePersonal;
    [self.navigationController pushViewController:resgiterVC animated:YES];
}

@end
