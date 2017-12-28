//
//  AdreeManagerBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AdreeManagerBuyViewController.h"
#import "AdressCell.h"
#import "AdressModel.h"
#import "AddOrEditAddressViewController.h"


@interface AdreeManagerBuyViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;


@property (nonatomic,strong) NSMutableArray *dataArr;


@property (nonatomic,assign) NSInteger page;

@end

@implementation AdreeManagerBuyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _page = 1;
    
    _dataArr = [NSMutableArray array];
    
    //右边
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 50, 16);
    
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.titleStr = @"地址管理";
    
    [self creatUI];

    [self loadData];
    
}

//加载列表数据
- (void)loadData{
    
    //11111111
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(_page) forKey:@"p"];
    
    [HMDataManager requestUrl:get_address_list_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            
            if (_page == 1) {
                
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                AdressModel *model = [[AdressModel alloc]initWithDic:dic];
                
                [_dataArr addObject:model];
            }
            
            [_myTableView reloadData];
            
        }
        
        [_myTableView.header endRefreshing];
        
        [_myTableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)rightBtnAction{
    
    AddOrEditAddressViewController *addOrEditAddressVC = [[AddOrEditAddressViewController alloc]init];
    
    addOrEditAddressVC.isAddress = YES;
    
    addOrEditAddressVC.updateAddressBlock = ^{

        _page = 1;

        [self loadData];
    };
    
    [self.navigationController pushViewController:addOrEditAddressVC animated:YES];

}

//UI
- (void)creatUI{
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"AdressCell" bundle:nil] forCellReuseIdentifier:@"AdressCell"];
    
}


#pragma mark --UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdressCell" forIndexPath:indexPath];

    cell.model = _dataArr[indexPath.section];

    cell.backBlock = ^(){
        
        _page = 1;

        [self loadData];
    };
    
    if (_order_id) {
        
        cell.order_id = _order_id;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}




@end
