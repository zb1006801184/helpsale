//
//  SubmitSuccessViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/9/4.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SubmitSuccessViewController.h"
#import "SaleCenterViewController.h"
#import "SelectClassifyViewController.h"

@interface SubmitSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIView *callView;

@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@end

@implementation SubmitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _callView.layer.cornerRadius = 4;
    _callView.layer.borderWidth = 0.5;
    _callView.layer.borderColor  = [UIColor colorWithHexString:@"C79D65"].CGColor;
    if ([_fromWhere isEqualToString:@"1"]) {
        _centerLabel.text = @"尊敬的先生/女士，已收到您的申请认证信息，我们将会尽快完成审核，并与您取得联系，请保持电话畅通，或与我们联系。";
    }
    
    [self saveGoods];
    
}

//保存商品信息
- (void)saveGoods {
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];//获取json文件保存的路径
    NSMutableArray *goodArys = [NSMutableArray array];
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:goodArys options:NSJSONWritingPrettyPrinted error:nil];
    [json_data writeToFile:filePath atomically:YES];
    
}


#pragma mark - actions
- (IBAction)callClick:(id)sender {
    
    NSString *allString = [NSString stringWithFormat:@"tel:400-7755-059"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    
}
- (IBAction)backClick:(id)sender {
    
    if ([_fromWhere isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *VC in viewControllers) {
        if ([VC isKindOfClass:[SaleCenterViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}
- (IBAction)againAction:(id)sender {
    
    SelectClassifyViewController *classifyVC = [[SelectClassifyViewController alloc]init];
    
    [self.navigationController pushViewController:classifyVC animated:YES];

}

@end
