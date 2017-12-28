//
//  PersonalCenterBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PersonalCenterBuyViewController.h"
#import "QuotationRecordBuyViewController.h"
#import "UIButton+WebCache.h"
#import "LoginViewController.h"
#import "AdreeManagerBuyViewController.h"
#import "PersonalInformationBuyViewController.h"
#import "MyMarginBuyViewController.h"
#import "TheOrderBuyViewController.h"
#import <UIViewController+MMDrawerController.h>


@interface PersonalCenterBuyViewController ()<UITextFieldDelegate>

@end

@implementation PersonalCenterBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
//    _user_nameTextField.delegate = self;
    
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
    
    leftLabel.text = @"个人中心";
    
    self.navigationItem.titleView = leftLabel;
    
    _headButton.layer.borderWidth = 3;
    
    _headButton.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    
    _headButton.layer.cornerRadius = 35;
    
    _headButton.layer.masksToBounds = YES;

    
}

- (void)showData{

    
    UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];

    NSLog(@"---%@",model.nick_name);
    
    _user_nameTextField.text = model.nick_name;

    [_headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.head_img_url] forState:UIControlStateNormal];
    
    //获取缓存图片的大小(字节)
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    
    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    float MBCache = bytesCache/1000/1000;
    
    _cacheLabel.text = [NSString stringWithFormat:@"清空缓存（%.2lfM）",MBCache];
    

}
- (IBAction)editUserNameAction:(id)sender {

    PersonalInformationBuyViewController *personalInformationBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalInformationBuyViewController"];
    
    [self.navigationController pushViewController:personalInformationBuyVC animated:YES];

}

//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    

//    
//    return YES;
//    
//}


- (IBAction)headAction:(UIButton *)sender {
    
    
}

//左边按钮
- (void)leftBtnAction{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        QuotationRecordBuyViewController *quotationRecordBuyVC = [[QuotationRecordBuyViewController alloc]init];
        
        [self.navigationController pushViewController:quotationRecordBuyVC animated:YES];

    
    }else if (indexPath.row == 2){
        
        TheOrderBuyViewController *theOrderBuyVC = [[TheOrderBuyViewController alloc]init];
        
        [self.navigationController pushViewController:theOrderBuyVC animated:YES];
        
    }else if (indexPath.row == 3){
        
    }else if (indexPath.row == 4){
        AdreeManagerBuyViewController *adreeManagerBuyVC = [[AdreeManagerBuyViewController alloc]init];
        
        [self.navigationController pushViewController:adreeManagerBuyVC animated:YES];
        

    }else if (indexPath.row == 5){
        
        MyMarginBuyViewController *myMarginBuyVC = [[MyMarginBuyViewController alloc]init];
        
        [self.navigationController pushViewController:myMarginBuyVC animated:YES];
        
    }else if (indexPath.row == 6){
        
    }else if (indexPath.row == 7){
        
        _cacheLabel.text = @"清空缓存（0.00M）";
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = @"清空缓存成功";
        
        [hud hideAnimated:YES afterDelay:2];
        
        //异步清除图片缓存 （磁盘中的）
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            

            [[SDImageCache sharedImageCache] clearDisk];
            
        });

        
        
    }else if (indexPath.row == 9){
        
        [HSUserDetaiModel setLogin:@"loginOut" forKey:[HSUserDetaiModel getLoginKey]];
        NSUserDefaults *user = [[NSUserDefaults alloc]init];
        [user removeObjectForKey:[HSUserDetaiModel getUserDetailModelKey]];
        [user removeObjectForKey:[HSUserDetaiModel getPersonal]];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];

    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self showData];

}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
