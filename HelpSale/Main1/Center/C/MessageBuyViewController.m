//
//  MessageBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MessageBuyViewController.h"
#import "MessageBuyCell.h"
#import "UIViewController+MMDrawerController.h"
#import "MessageBuyModel.h"
#import "LotsDetailsBuyViewController.h"
#import "SaleGoodsDetailViewController.h"

@interface MessageBuyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;



@end

@implementation MessageBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _page = 1;
    
    _dataArr = [NSMutableArray array];
    
    self.titleStr = @"系统消息";
    
    [self creatUI];

    [self loadData];

}

//加载列表数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(_page) forKey:@"page"];
    
    [HMDataManager requestUrl:get_push_record_list_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            if (_page == 1) {
                
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                MessageBuyModel *model = [[MessageBuyModel alloc]initWithDic:dic];
                
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
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"MessageBuyCell" bundle:nil] forCellReuseIdentifier:@"MessageBuyCell"];
    
    _myTableView.tableFooterView = [[UIView alloc]init];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageBuyCell" forIndexPath:indexPath];

    cell.model = _dataArr[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 188;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    MessageBuyModel *model = _dataArr[indexPath.row];

    
    UserDetaiModel *Usermodel = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];

    if ([Usermodel.type isEqualToString:@"buyer"]) {
        
        LotsDetailsBuyViewController *lotsDetailsBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"LotsDetailsBuyViewController"];
        
        lotsDetailsBuyVC.goodsId = model.object_id;
        
        [self.navigationController pushViewController:lotsDetailsBuyVC animated:YES];

        
    }else{
        
        SaleGoodsDetailViewController *goodsDetailsVC = [[SaleGoodsDetailViewController alloc]init];
        goodsDetailsVC.good_id = model.object_id;
        [self.navigationController pushViewController:goodsDetailsVC animated:YES];
        
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
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
