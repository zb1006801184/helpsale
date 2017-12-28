//
//  ModifyNicknameViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/5.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "ModifyNicknameViewController.h"


@interface ModifyNicknameViewController ()



@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleStr = @"个人信息";
    
    //右边
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 50, 16);
    
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    _nick_nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    _nick_nameTextField.backgroundColor = [UIColor whiteColor];
    
    _nick_nameTextField.textColor = [UIColor colorWithHexString:@"666666"];
    
    _nick_nameTextField.font = [UIFont systemFontOfSize:16];
    
    _nick_nameTextField.text = _nickNameStr;
    
    [self.view addSubview:_nick_nameTextField];
    
}

- (void)rightBtnAction{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_nick_nameTextField.text forKey:@"nick_name"];
    
    [HMDataManager requestUrl:change_user_info_API params:params HidHUD:YES success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {

            UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];

            model.nick_name = _nick_nameTextField.text;
            
            [HSUserDetaiModel setUserDetailModel:model forKey:[HSUserDetaiModel getUserDetailModelKey]];
            
            [self.navigationController popViewControllerAnimated:YES];

        }
        
        
    } failure:nil];
    
    
    
    
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
