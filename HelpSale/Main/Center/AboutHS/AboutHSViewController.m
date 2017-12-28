//
//  AboutHSViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/13.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AboutHSViewController.h"
#import <UIViewController+MMDrawerController.h>



@interface AboutHSViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *_webView;

@end

@implementation AboutHSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"关于会麦";
    
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 96, 44)];
    
    leftLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    leftLabel.textAlignment = NSTextAlignmentLeft;
    
    leftLabel.font = [UIFont systemFontOfSize:18];
    
    leftLabel.text = @"关于会麦";
    
    self.navigationItem.titleView = leftLabel;

    
    [__webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.huimaionline.com/mobile/page.action?catid=A8F62C21-AC36-94AD-3064-924D1D7ED2F4"]]];
    
    
}

//左边按钮
- (void)leftBtnAction{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
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
