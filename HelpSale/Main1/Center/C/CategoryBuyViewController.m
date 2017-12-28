//
//  CategoryBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "CategoryBuyViewController.h"
#import "BuyersHomeCell.h"
#import "LotsDetailsBuyViewController.h"
#import "LotsListBuyModel.h"

@interface CategoryBuyViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) UIView *selectView;

@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,assign) NSInteger page1;

@property (nonatomic,assign) NSInteger page2;

@property (nonatomic,assign) NSInteger page3;

@property (nonatomic,strong) NSMutableArray *dataArr1;

@property (nonatomic,strong) NSMutableArray *dataArr2;

@property (nonatomic,strong) NSMutableArray *dataArr3;




@end

@implementation CategoryBuyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _page1 = 1;
    
    _page2 = 1;

    _page3 = 1;

    
    _dataArr1 = [NSMutableArray array];
    
    _dataArr2 = [NSMutableArray array];

    _dataArr3 = [NSMutableArray array];

    self.titleStr = _model.category_name;
    
    [self creatUI];

    [self loadData];
    

}


//加载列表数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_model.id forKey:@"category_id"];

    if (_selectButton.tag - 100 == 0) {
        
        [params setObject:@(_page1) forKey:@"p"];

        [params setObject:@"" forKey:@"type"];
        
    }else if (_selectButton.tag - 100 == 1){
        
        [params setObject:@(_page2) forKey:@"p"];
        
        [params setObject:@"1" forKey:@"type"];

    }else if (_selectButton.tag - 100 == 2){
        
        [params setObject:@(_page3) forKey:@"p"];
        
        [params setObject:@"3" forKey:@"type"];
    }
    
    [HMDataManager requestUrl:get_acution_list_by_category_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            if (_selectButton.tag == 100) {
                if (_page1 == 1) {
                    
                    [_dataArr1 removeAllObjects];
                }

                
            }else if (_selectButton.tag == 101){
                
                if (_page2 == 1) {
                    
                    [_dataArr2 removeAllObjects];
                }

                
            }else if (_selectButton.tag == 102){
                
                if (_page3 == 1) {
                    
                    [_dataArr3 removeAllObjects];
                }

            }
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                LotsListBuyModel *model = [[LotsListBuyModel alloc]initWithDic:dic];
                
                if (_selectButton.tag == 100) {
                    
                    [_dataArr1 addObject:model];
                }else if (_selectButton.tag == 101){
                    
                    [_dataArr2 addObject:model];
                    
                }else if (_selectButton.tag == 102){
                    
                    [_dataArr3 addObject:model];
                }
                
            }
            
            [_myTableView reloadData];
            
        }
        
        [_myTableView.header endRefreshing];
        
        [_myTableView.footer endRefreshing];
        
    } failure:nil];
    
}

//UI
- (void)creatUI{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    
    headerView.backgroundColor = [UIColor colorWithHexString:@"050634"];
    
    [self.view addSubview:headerView];
    
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(41, 46, 8, 2)];
    
    _selectView.backgroundColor = [UIColor colorWithHexString:@"C79D65"];
    
    NSArray *titleArr = @[@"全部",@"正在热拍",@"一周回顾"];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(90 * i, 0, 90, 48);
        
        button.tag = 100 + i;
        
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateSelected];
        
        [button setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];

        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button addTarget:self action:@selector(headSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:button];
        
        if (i == 0 ) {
            button.selected = YES;
            
            [button addSubview:_selectView];
            
            _selectButton = button;
        }

    }
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 48, kScreenWidth, kScreenHeight - 48 - 64) style:UITableViewStyleGrouped];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"BuyersHomeCell" bundle:nil] forCellReuseIdentifier:@"BuyersHomeCell"];
    
    LRWeakSelf(self);
    
    //下拉刷新
    
    [_myTableView addLegendHeaderWithRefreshingBlock:^{
        
        if (weakself.selectButton.tag == 100) {
            
            weakself.page1 = 1;
            
        }else if (weakself.selectButton.tag == 101){
            
            weakself.page2 = 1;

        }else if (weakself.selectButton.tag == 102){
            
            weakself.page3 = 1;

        }
        
        [weakself loadData];

    }];
    //上拉加载
    [_myTableView addLegendFooterWithRefreshingBlock:^{
        
        if (weakself.selectButton.tag == 100) {
            
            weakself.page1 ++;
            
        }else if (weakself.selectButton.tag == 101){
            
            weakself.page2 ++;
            
        }else if (weakself.selectButton.tag == 102){
            
            weakself.page3 ++;
            
        }

        [weakself loadData];
    }];

    
}

- (void)headSelectAction:(UIButton*)bt{
    
    if (bt.selected == NO) {

        bt.selected = YES;

        [bt addSubview:_selectView];

        _selectButton.selected = NO;
        
        _selectButton = bt;
        
        if (bt.tag == 100) {

            if (_dataArr1.count == 0) {
                
                [self loadData];
                
            }else{
            
                [_myTableView reloadData];
            }
            
            
        }else if (bt.tag == 101){
            
            if (_dataArr2.count == 0) {
                
                [self loadData];
                
            }else{
                
                [_myTableView reloadData];
            }

            
        
        }else if (bt.tag == 102){
            
            if (_dataArr3.count == 0) {
                
                [self loadData];
                
            }else{
                
                [_myTableView reloadData];
            }
            
        }
        
    }
    
}

#pragma mark --UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_selectButton.tag == 100) {
        
        return _dataArr1.count;
    }else if (_selectButton.tag == 101){
    
        return _dataArr2.count;

    }else if (_selectButton.tag == 102){
        
        return _dataArr3.count;
    }

    return 0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BuyersHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyersHomeCell" forIndexPath:indexPath];

    LotsListBuyModel *model = nil;
    
    if (_selectButton.tag == 100) {
        
        model = _dataArr1[indexPath.section];
    }else if (_selectButton.tag == 101){
        
        model = _dataArr2[indexPath.section];
        
    }else if (_selectButton.tag == 102){
        
        model = _dataArr3[indexPath.section];
    }

    cell.model = model;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 127;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LotsDetailsBuyViewController *lotsDetailsBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"LotsDetailsBuyViewController"];
    
    LotsListBuyModel *model = nil;

    if (_selectButton.tag == 100) {
        
        model = _dataArr1[indexPath.section];
    }else if (_selectButton.tag == 101){
        
        model = _dataArr2[indexPath.section];
        
    }else if (_selectButton.tag == 102){
        
        model = _dataArr3[indexPath.section];
    }
    
    lotsDetailsBuyVC.lotsId = model.id;

    [self.navigationController pushViewController:lotsDetailsBuyVC animated:YES];
    
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
