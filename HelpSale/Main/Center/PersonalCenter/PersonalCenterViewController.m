//
//  PersonalCenterViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/13.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "PesonalTableViewCell.h"
#import "personalTwoTableViewCell.h"
#import "Clear.h"
#import "HelpSaleOrderViewController.h"
#import "PersonalAuctionViewController.h"
#import "MyMoneyAccountViewController.h"
#import "PersonalSureStateViewController.h"
#import "AdreeManagerBuyViewController.h"
#import "LoginViewController.h"
#import "PersonalInformationBuyViewController.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIImageView *head_Image;

@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@property (weak, nonatomic) IBOutlet UILabel *certifyLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //views
    _head_Image.layer.masksToBounds = YES;
    //actions
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;

    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getData {
    UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];
    [_head_Image sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@""]];
    _userNameLabel.text = model.nick_name;
    if ([model.is_buyer_veryfy isEqualToString:@"1"]) {
        _certifyLabel.text = @"商家认证";
    }else {
        _certifyLabel.text = @"";
    }
    
    
    
}


#pragma mark - actions
- (IBAction)menuClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)notifyClick:(id)sender {
    
}
- (IBAction)editClick:(id)sender {
    
    PersonalInformationBuyViewController *personalInformationBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalInformationBuyViewController"];
    
    [self.navigationController pushViewController:personalInformationBuyVC animated:YES];

    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 2) {
        personalTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalTwoTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"personalTwoTableViewCell" owner:self options:nil]firstObject];
        }
        if (indexPath.section == 3) {
            
            cell.titleLabel.text = [NSString stringWithFormat:@"清空缓存(%@)",[Clear getCacheSize]];
        }
        if (indexPath.section == 4) {
            cell.titleLabel.text = @"退出登录";
            cell.titleLabel.textColor = [AppStyle colorForCrucial];
        }
        return cell;
    }
    NSArray *titles = @[@[@"我的拍品"],@[@"地址管理",@"收款账号管理"],@[@"商家认证"]];
    PesonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PesonalTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PesonalTableViewCell" owner:self options:nil]firstObject];
    }
    cell.titleLabel.text = titles[indexPath.section][indexPath.row];
    if (indexPath.section == 2) {
        cell.contenLabel.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 4) {
        return 16;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        HelpSaleOrderViewController *orderVC = [[HelpSaleOrderViewController alloc]init];
//        [self.navigationController pushViewController:orderVC animated:YES];
//    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        PersonalAuctionViewController *actionVC = [[PersonalAuctionViewController alloc]init];
        [self.navigationController pushViewController:actionVC animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {

        AdreeManagerBuyViewController *adreeManagerBuyVC = [[AdreeManagerBuyViewController alloc]init];
        
        [self.navigationController pushViewController:adreeManagerBuyVC animated:YES];

    }

    if (indexPath.section == 1 && indexPath.row == 1) {
        MyMoneyAccountViewController *accountVC = [[MyMoneyAccountViewController alloc]init];
        [self.navigationController pushViewController:accountVC animated:YES];
    }
    if (indexPath.section == 2) {
        
        
        UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];

        if ([model.is_buyer_veryfy isEqualToString:@"3"]) {
            
            [self.view showLableViewWithMessage:@"已经提交过认证资料"];
            
            return;

        }else{

            PersonalSureStateViewController *statuVC = [[PersonalSureStateViewController alloc]init];
            [self.navigationController pushViewController:statuVC animated:YES];
            
        }
        
 
    }
    if (indexPath.section == 3) {
        if ([Clear clearCache]) {
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            [self.view showLableViewWithMessage:@"清理成功"];
        }
    }else if (indexPath.section == 4) {
        
        [HSUserDetaiModel setLogin:@"loginOut" forKey:[HSUserDetaiModel getLoginKey]];
        NSUserDefaults *user = [[NSUserDefaults alloc]init];
        [user removeObjectForKey:[HSUserDetaiModel getUserDetailModelKey]];
        [user removeObjectForKey:[HSUserDetaiModel getPersonal]];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
//        
//        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
//        nav.selectedIndex = 3;
//        [HSUserDetaiModel setLogin:@"loginOut" forKey:[HSUserDetaiModel getLoginKey]];
    }
    
}






@end
