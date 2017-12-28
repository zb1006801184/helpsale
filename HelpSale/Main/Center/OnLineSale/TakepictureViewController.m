//
//  TakepictureViewController.m
//  HelpSale
//
//  Created by CYT on 2017/10/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "TakepictureViewController.h"
#import "TakeAPictureView.h"


#define WeakSelf    __weak typeof(self) weakSelf = self;
#define StrongSelf  __strong typeof(weakSelf) self = weakSelf;


@interface TakepictureViewController ()

@property (weak, nonatomic) IBOutlet TakeAPictureView *cameraView;

@end

@implementation TakepictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakSelf
    self.cameraView.getImage = ^(UIImage *image){
        StrongSelf

        self.backBlock(image);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(12, 37.5, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftBtn];
    
    
    UIButton *takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    
    takePhoto.backgroundColor = [UIColor colorWithHexString:@"4A4B61"];
    
    takePhoto.alpha = .6;
    
    takePhoto.layer.cornerRadius = 32.5;
    
    takePhoto.layer.masksToBounds = YES;
    
    takePhoto.frame = CGRectMake(kScreenWidth/2 - 32.5, kScreenHeight - 65 - 50, 65, 65);
    
    [takePhoto addTarget:self action:@selector(takepictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:takePhoto];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 22, kScreenHeight - 44 - 60.5, 44, 44)];
    
    view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    view.layer.cornerRadius = 22;
    
    view.layer.masksToBounds = YES;
    
    view.userInteractionEnabled = NO;
    
    [self.view addSubview:view];
    
    self.cameraView.labelText = _labelText;
    
}

- (IBAction)takepictureAction:(id)sender {
    
    NSLog(@"拍照");
    
    
    [self.cameraView takeAPicture];

}

- (void)leftBtnAction{

    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.cameraView startRunning];

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.cameraView stopRunning];
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
