//
//  SystemBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SystemBuyViewController.h"
#import "MessageBuyViewController.h"
#import "OnlineFeedbackBuyViewController.h"

@interface SystemBuyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLAbel;

@end

@implementation SystemBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    

    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 96, 44)];
    
    leftLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    leftLabel.textAlignment = NSTextAlignmentLeft;
    
    leftLabel.font = [UIFont systemFontOfSize:18];
    
    leftLabel.text = @"系统消息";
    
    self.navigationItem.titleView = leftLabel;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self loadData];
    
}



//加载列表数据
- (void)loadData{
    
    //11111111
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    
    [HMDataManager requestUrl:get_last_system_record params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {

            _contLabel.text = result[@"result"][@"data"][@"title"];
            
            _timeLAbel.text = result[@"result"][@"data"][@"add_time"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}



//返回按钮
- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        MessageBuyViewController *messageBuyVC = [[MessageBuyViewController alloc]init];
        
        [self.navigationController pushViewController:messageBuyVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        OnlineFeedbackBuyViewController *onlineFeedbackBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"OnlineFeedbackBuyViewController"];
        
        [self.navigationController pushViewController:onlineFeedbackBuyVC animated:YES];

    }

    
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

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

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
