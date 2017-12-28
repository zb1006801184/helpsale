//
//  FeedbackSuccessBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "FeedbackSuccessBuyViewController.h"

@interface FeedbackSuccessBuyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation FeedbackSuccessBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleStr = @"在线反馈";
    
    _backButton.layer.cornerRadius = 4;
    
    _backButton.layer.borderWidth = .5;
    
    _backButton.layer.borderColor = [UIColor colorWithHexString:@"C79D65"].CGColor;
    
    _backButton.layer.masksToBounds = YES;
    
}

//返回按钮
- (void)leftBtnAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)backHomeAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
