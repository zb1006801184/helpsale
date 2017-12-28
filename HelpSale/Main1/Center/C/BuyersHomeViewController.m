//
//  BuyersHomeViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BuyersHomeViewController.h"
#import "BuyersHomeCell.h"
#import "BuyersHomeHeaderView.h"
#import "SystemBuyViewController.h"
#import "LotsDetailsBuyViewController.h"
#import "HMDataManager.h"
#import "LotsListBuyModel.h"
#import "CategoryBuyModel.h"
#import <UIViewController+MMDrawerController.h>
#import "SaleCenterTableViewCell.h"




@interface BuyersHomeViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIButton *rightBtn;
    
}

//@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *categoryArr;

@property (nonatomic,strong) NSMutableDictionary *dataDic;

@property (nonatomic,strong) BuyersHomeHeaderView *headerView;

@property (nonatomic,strong) UIView *selectView;

@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,strong) UIButton *selectButton1;

@property (nonatomic,strong) UIView *redView;

@property (nonatomic,copy) NSString *timestamp;


@end

@implementation BuyersHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    _page = 1;
//
    _categoryArr = [NSMutableArray array];
    
    _dataDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < 15; i++) {
        
        [_dataDic setObject:@{@"page":@"1"} forKey:[NSString stringWithFormat:@"%d",i]];

    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];

    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    negativeSpacer.width = 20;

    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 58, 10)];
    
    leftView.image = [UIImage imageNamed:@"Huimai"];
    
    UIBarButtonItem * leftViewItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
    self.navigationItem.leftBarButtonItems = @[leftButtonItem,negativeSpacer,leftViewItem];
    
    //右边notifactiontips
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 15, 16);
    [rightBtn setImage:[UIImage imageNamed:@"Combined Shape"] forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"notifactiontips"] forState:UIControlStateNormal];

    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    [self creatUI];
    
    [self loadData1];

//    [self loadData2];


}

//加载列表数据
- (void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSString *index = [NSString stringWithFormat:@"%d",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];
    
    NSString *page = _dataDic[index][@"page"];
    
    [params setObject:page forKey:@"p"];
    
    if (_selectButton.tag == 100) {
        
        
    }else{
    
        [params setObject:@"1" forKey:@"type"];
        
        _redView.hidden = YES;
        
    }
    
    if (_selectButton1.tag != 200) {
        
        CategoryBuyModel *model = _categoryArr[_selectButton1.tag - 200 - 1];

        [params setObject:model.id forKey:@"category_id"];

    }

    [HMDataManager requestUrl:acution_index_API params:params HidHUD:NO success:^(id result) {

        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            if ([page isEqualToString:@"1"]) {
                
                if (_dataDic[index][@"data"]) {

                    [_dataDic setObject:@{@"page":page} forKey:index];
    
                }
            }

            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:_dataDic[index][@"data"]];
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                LotsListBuyModel *model = [[LotsListBuyModel alloc]initWithDic:dic];

                [dataArr addObject:model];
            }

            [_dataDic setObject:@{@"page":page,@"data":[dataArr copy]} forKey:index];
            
            [_myTableView reloadData];

        }
        
        [_myTableView.header endRefreshing];
        
        [_myTableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//获取分类数据
- (void)loadData1{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_category_list_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {

            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                CategoryBuyModel *model = [[CategoryBuyModel alloc]initWithDic:dic];
                
                [_categoryArr addObject:model];
            }
            
//            _headerView.categoryArr = categoryArr;
            
            [self creatUI];
            
            [self loadData];
            
        }
        
    } failure:nil];

    
}

//获取倒计时
- (void)loadData2{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_next_time_acution_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            _headerView.time = [result[@"result"][@"data"][@"item"][@"next_time_acution"] integerValue];
            
        }
        
    } failure:nil];
    
    
}


//UI
- (void)creatUI{
    
    
//    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"BuyersHomeHeaderView" owner:self options:nil] lastObject];
//    
//    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 32);
//    
//    [self.view addSubview:_headerView];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 78)];
    
    headerView.backgroundColor = [UIColor colorWithHexString:@"050634"];
    
    [self.view addSubview:headerView];
    
    NSArray *titleArr = @[@"一周回顾",@"限时报价"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake((kScreenWidth/2 - 12) * i + 12, 7, (kScreenWidth/2 - 12), 34);
        
        button.tag = 100 + i;
        
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateSelected];
        
        [button setTitleColor:[UIColor colorWithHexString:@"C79D65 "] forState:UIControlStateNormal];
        
        button.layer.borderWidth = 1;
        
        button.layer.borderColor = [UIColor colorWithHexString:@"C79D65"].CGColor;
    
        button.layer.cornerRadius = 2;
        
        button.layer.masksToBounds = YES;
        
        button.backgroundColor = [UIColor clearColor];
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        [button addTarget:self action:@selector(headSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:button];
        
        if (i == 0 ) {
            
            button.selected = YES;
            
            _selectButton = button;
            
            button.backgroundColor = [UIColor colorWithHexString:@"C79D65"];

        }
        
        if (i == 1) {
            
            _redView = [[UIView alloc] init];
            _redView.frame = CGRectMake(button.width/2 + 40, 7, 7, 7);
            _redView.backgroundColor = [UIColor colorWithRed:254/255.0 green:91/255.0 blue:98/255.0 alpha:1/1.0];
            
            _redView.layer.cornerRadius = 3.5;
            
            _redView.layer.masksToBounds = YES;
            
            _redView.hidden = YES;
            
            [button addSubview:_redView];
            
        }
        

    }
    
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/12 - 4, 28, 8, 2)];
    
    _selectView.backgroundColor = [UIColor colorWithHexString:@"C79D65"];

    
//    NSArray *titleArr1 = @[@"全部",@"腕表",@"箱包",@"首饰",@"其他"];
    
    for (int i = 0; i < _categoryArr.count + 1; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(kScreenWidth/6 * i, 48, kScreenWidth/6, 30);
        
        button.tag = 200 + i;
        
        [button setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateSelected];
        
        [button setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(headSelectAction1:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:button];
        
        if (i == 0 ) {
            button.selected = YES;
            
            [button addSubview:_selectView];
            
            _selectButton1 = button;
            
            [button setTitle:@"全部" forState:UIControlStateNormal];

        }else{
            
            CategoryBuyModel *model = _categoryArr[i - 1];
            
            [button setTitle:model.category_name forState:UIControlStateNormal];

        }
        
    }
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 78 , kScreenWidth, kScreenHeight - 78 - 64) style:UITableViewStyleGrouped];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"SaleCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"SaleCenterTableViewCell"];
    
    LRWeakSelf(self);
    
    //下拉刷新

    [_myTableView addLegendHeaderWithRefreshingBlock:^{
      
        NSString *index = [NSString stringWithFormat:@"%ld",(weakself.selectButton.tag - 100)* 5 + (weakself.selectButton1.tag - 200)];

        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakself.dataDic[index]];
        
        [dic setObject:@"1" forKey:@"page"];
        
        [weakself.dataDic setObject:[dic copy] forKey:index];
        
        [weakself loadData];
        
    }];
    //上拉加载
    [_myTableView addLegendFooterWithRefreshingBlock:^{
        
        NSString *index = [NSString stringWithFormat:@"%ld",(weakself.selectButton.tag - 100)* 5 + (weakself.selectButton1.tag - 200)];
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakself.dataDic[index]];
        
        NSInteger page = [dic[@"page"] integerValue];
        
        page ++;
        
        [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
        
        [weakself.dataDic setObject:[dic copy] forKey:index];
        
        [weakself loadData];
        
    }];

}

//
- (void)headSelectAction:(UIButton*)bt{
    
    if (bt.selected == NO) {
        
        bt.selected = YES;
        
        _selectButton.backgroundColor = [UIColor clearColor];
        
        bt.backgroundColor = [UIColor colorWithHexString:@"C79D65"];
        
        _selectButton.selected = NO;
        
        _selectButton = bt;
        
        _selectButton1.selected = NO;
        
        UIButton *button = [self.view viewWithTag:200];
        
        button.selected = YES;
        
        _selectButton1 = button;

        [button addSubview:_selectView];


        NSString *index = [NSString stringWithFormat:@"%ld",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];
        
        if (_dataDic[index][@"data"]) {
            
            NSArray *dataArr = _dataDic[index][@"data"];
            
            if (dataArr.count != 0) {
                
                [_myTableView reloadData];
                
            }else{
                
                [self loadData];
            }

        }else{
            
            [self loadData];
        
        }
        
        
    }


}

- (void)headSelectAction1:(UIButton*)bt{
    
    
    if (bt.selected == NO) {
        
        bt.selected = YES;
        
        [bt addSubview:_selectView];
        
        _selectButton1.selected = NO;
        
        _selectButton1 = bt;
        
        NSString *index = [NSString stringWithFormat:@"%ld",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];
        
        if (_dataDic[index][@"data"]) {
            
            NSArray *dataArr = _dataDic[index][@"data"];
            
            if (dataArr.count != 0) {
                
                [_myTableView reloadData];
                
            }else{
                
                [self loadData];
            }
            
        }else{
            
            [self loadData];
            
        }

    }

    
}

//右边按钮
- (void)rightBtnAction{
    
    SystemBuyViewController *systemBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"SystemBuyViewController"];


    [self.navigationController pushViewController:systemBuyVC animated:YES];

}
//左边按钮
- (void)leftBtnAction{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

#pragma mark --UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSString *index = [NSString stringWithFormat:@"%ld",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];

    if (_dataDic[index][@"data"]) {
        
        NSArray *dataArr = _dataDic[index][@"data"];

        return dataArr.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SaleCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleCenterTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SaleCenterTableViewCell" owner:self options:nil]firstObject];
    }
    
    NSString *index = [NSString stringWithFormat:@"%ld",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];

    
    NSArray *dataArr = _dataDic[index][@"data"];

    if (dataArr.count < 1) {
        return cell;
    }
    LotsListBuyModel *model = dataArr[indexPath.section];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleNameLabel.text = model.goods_name;
    cell.timeLabel.text = model.end_time;
    cell.statusLabel.text = model.status_format;
    
    if ([model.status_format isEqualToString:@"已成交"]) {
        
        cell.statusLabel.textColor = [UIColor colorWithHexString:@"33B0E7"];
        
        cell.dealImageV.hidden = NO;
        
    }else{
        
        cell.statusLabel.textColor = [UIColor colorWithHexString:@"FE5B62"];
        
        cell.dealImageV.hidden = YES;
        
    }
    
    cell.quoteNumbelLabel.text = model.offer_count;
    cell.circuseeLabel.text = [NSString stringWithFormat:@"%@人围观",model.view];
    
    
//    cell.closeTheSaleLabel.text = model.price;
    
    cell.closeTheSaleLabel.hidden = YES;
    
    cell.view1.hidden = YES;
    
    cell.view2.hidden = YES;
    
    if (model.category_name.length > 3) {
        
        cell.viewHeight.constant = 80;
        
    }else{
        
        cell.viewHeight.constant = 52;
    }
    
//    CAShapeLayer *border = [CAShapeLayer layer];
//    
//    border.strokeColor = [UIColor colorWithHexString:@"636570"].CGColor;
//    
//    border.fillColor = nil;
//    
//    border.path = [UIBezierPath bezierPathWithRect:CGRectMake(cell.categoryLabel.bounds.origin.x, cell.categoryLabel.bounds.origin.x, cell.viewHeight.constant, 18)].CGPath;
//    
//    border.frame = CGRectMake(cell.categoryLabel.bounds.origin.x, cell.categoryLabel.bounds.origin.x, cell.viewHeight.constant, 18);
//    
//    border.lineWidth = 1.f;
//    
//    border.lineCap = @"butt";
//    
//    border.lineDashPattern = @[@1, @1];
//    
//    [cell.categoryLabel.layer addSublayer:border];
//    
    cell.categoryLabel.layer.borderWidth = .5;
    
    cell.categoryLabel.layer.borderColor = [UIColor colorWithHexString:@"d9d9d9"].CGColor;
    
    cell.categoryLabel.text = model.category_name;
    
    return cell;

    
    
//    BuyersHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyersHomeCell" forIndexPath:indexPath];
//    
//    cell.isHome = YES;
//    
//    NSString *index = [NSString stringWithFormat:@"%ld",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];
//    
//    NSArray *dataArr = _dataDic[index][@"data"];
//        
//    cell.model = dataArr[indexPath.section];
//    
//    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    
    LotsDetailsBuyViewController *lotsDetailsBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"LotsDetailsBuyViewController"];
    
    NSString *index = [NSString stringWithFormat:@"%ld",(_selectButton.tag - 100)* 5 + (_selectButton1.tag - 200)];
    
    NSArray *dataArr = _dataDic[index][@"data"];
    
    LotsListBuyModel *model = dataArr[indexPath.section];

    lotsDetailsBuyVC.lotsId = model.id;
    
    if (_selectButton.tag == 100) {
        
        lotsDetailsBuyVC.isHome = YES;
    }
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
 
    [self loadData3];

}


//获取红点
- (void)loadData3{
    
    //推送数量
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_unread_push_record_nums params:params HidHUD:YES success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            int nums = [result[@"result"][@"data"][@"nums"] intValue];;
            
            if (nums > 0 ) {
                
                [rightBtn setImage:[UIImage imageNamed:@"notifactiontips"] forState:UIControlStateNormal];

            }else{
            
                [rightBtn setImage:[UIImage imageNamed:@"Combined Shape"] forState:UIControlStateNormal];
            }
            
        }
        
    } failure:nil];
    
    //新的拍品
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    
//    NSTimeInterval a=[dat timeIntervalSince1970];
    
    if (_timestamp) {
        
        [params1 setObject:_timestamp forKey:@"timestamp"];

    }else{
    
        [params1 setObject:@"0" forKey:@"timestamp"];
    }

    [HMDataManager requestUrl:check_new_acution params:params1 HidHUD:YES success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            int count = [result[@"result"][@"data"][@"item"][@"count"] intValue];;
            
            _timestamp = result[@"result"][@"data"][@"item"][@"timestamp"];
            
            if (count > 0 ) {
                
                _redView.hidden = NO;
                
            }else{

                _redView.hidden = YES;
            }
            
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
