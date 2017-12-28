//
//  TheOrderBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "TheOrderBuyViewController.h"
#import "OrderBuyModel.h"
#import "TheOrderBuyCell.h"
#import "LogisticsDetailsViewController.h"

@interface TheOrderBuyViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;


@property (nonatomic,assign) NSInteger page;


@end

@implementation TheOrderBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    
    _dataArr = [NSMutableArray array];

    self.titleStr = @"已成交订单";
    
    [self creatUI];
    
    [self loadData];


}

//加载列表数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(_page) forKey:@"p"];
    
    [HMDataManager requestUrl:get_acution_already_list_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            
            if (_page == 1) {
                
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                OrderBuyModel *model = [[OrderBuyModel alloc]initWithDic:dic];
                
                [_dataArr addObject:model];
            }
            
            [_myTableView reloadData];
            
        }
        
        [_myTableView.header endRefreshing];
        
        [_myTableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
    
}



//UI
- (void)creatUI{
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"TheOrderBuyCell" bundle:nil] forCellReuseIdentifier:@"TheOrderBuyCell"];
    
    LRWeakSelf(self);
    
    //下拉刷新
    
    [_myTableView addLegendHeaderWithRefreshingBlock:^{
        
        weakself.page = 1;
        
        [weakself loadData];
        
    }];
    //上拉加载
    [_myTableView addLegendFooterWithRefreshingBlock:^{
        weakself.page ++;
        
        [weakself loadData];
    }];
    
    
}

#pragma mark --UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TheOrderBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TheOrderBuyCell" forIndexPath:indexPath];
    
    cell.model = _dataArr[indexPath.section];
    
    cell.backBlock = ^{
      
        _page = 1;
        
        [self loadData];
        
    };
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 246.5;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LogisticsDetailsViewController *logisticsDetailsVC = [[LogisticsDetailsViewController alloc]init];
    
    OrderBuyModel *model = _dataArr[indexPath.section];
    
    logisticsDetailsVC.acution_id = model.id;
    
    [self.navigationController pushViewController:logisticsDetailsVC animated:YES];
    
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
