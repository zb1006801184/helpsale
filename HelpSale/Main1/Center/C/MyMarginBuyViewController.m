//
//  MyMarginBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/6.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "MyMarginBuyViewController.h"
#import "MarginHeadBuyView.h"
#import "MarginbuyCell.h"
#import "MarginbuyModel.h"
#import "PaySecurityDepositBuyView.h"


@interface MyMarginBuyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) MarginHeadBuyView *headerView;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) PaySecurityDepositBuyView *paySecurityDepositBuyV;

//遮罩
@property (nonatomic,strong) UIView *bgView;


@end

@implementation MyMarginBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMarginAction) name:@"RefreshMarginNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMarginAction) name:@"PayNotifation" object:nil];

    
    _page = 1;
    
    _dataArr = [NSMutableArray array];

    self.titleStr = @"我的保证金";
    
    
    
    
    [self creatUI];
    
    [self loadData];
    
    [self loadData1];
}

//加载列表数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(_page) forKey:@"p"];
    
    [HMDataManager requestUrl:get_user_deposit_list_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            
            if (_page == 1) {
                
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                MarginbuyModel *model = [[MarginbuyModel alloc]initWithDic:dic];
                
                [_dataArr addObject:model];
            }
            
            [_myTableView reloadData];
            
        }
        
        [_myTableView.header endRefreshing];
        
        [_myTableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//获取数据
- (void)loadData1{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [HMDataManager requestUrl:get_my_deposit_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            _dataDic = result[@"result"][@"data"][@"item"];
            
            _headerView.dic = result[@"result"][@"data"][@"item"];
        }
        
    } failure:nil];

}



//UI
- (void)creatUI{
    
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MarginHeadBuyView" owner:self options:nil] lastObject];
    
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 124 + 64);
    
    [self.view addSubview:_headerView];
    

    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 124, kScreenWidth, kScreenHeight - 64 - 124 - 44) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    [self.view addSubview:_myTableView];
    
    _myTableView.tableFooterView = [[UIView alloc]init];
    
    
    [_myTableView registerNib:[UINib nibWithNibName:@"MarginbuyCell" bundle:nil] forCellReuseIdentifier:@"MarginbuyCell"];
    
//    LRWeakSelf(self);
    
//    //下拉刷新
//    
//    [_myTableView addLegendHeaderWithRefreshingBlock:^{
//        
//        weakself.page = 1;
//        
//        [weakself loadData];
//        
//    }];
//    //上拉加载
//    [_myTableView addLegendFooterWithRefreshingBlock:^{
//        weakself.page ++;
//        
//        [weakself loadData];
//    }];
    
    
    UIButton *trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    trueButton.frame = CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44);
    
    trueButton.backgroundColor = [UIColor colorWithHexString:@"D3B180"];
    

    trueButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [trueButton setTitle:@"补充保证金" forState:UIControlStateNormal];
    
    [trueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [trueButton addTarget:self action:@selector(trueAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:trueButton];
    
}

//补充保证金
- (void)trueAction{

    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _paySecurityDepositBuyV = [[[NSBundle mainBundle]loadNibNamed:@"PaySecurityDepositBuyView" owner:self options:nil] lastObject];
    
    _paySecurityDepositBuyV.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 260);
    
    LRWeakSelf(self);
    
    _paySecurityDepositBuyV.backBlock = ^{
        
        [weakself hideOfferView];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:_paySecurityDepositBuyV];
    
}

- (void)hideOfferView{

    [_paySecurityDepositBuyV removeFromSuperview];
    
    [_bgView removeFromSuperview];
    
    _paySecurityDepositBuyV = nil;
    
    _bgView = nil;

}



#pragma mark --UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MarginbuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarginbuyCell" forIndexPath:indexPath];


    cell.model = _dataArr[indexPath.row];
    
    return cell;
}

//通知刷新列表
- (void)RefreshMarginAction{

    _page = 1;
    
    [self loadData];
    
    [self loadData1];
    
}

-(void)dealloc{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
