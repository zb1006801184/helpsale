//
//  LogisticsDetailsViewController.m
//  WholeCategory
//
//  Created by CYT on 2017/3/14.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "LogisticsDetailsViewController.h"
#import "OrderManagerView.h"
#import "LogisticsDetailsCell.h"


@interface LogisticsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{

    OrderManagerView *orderV;
}


@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSDictionary *dataDic;


@end

@implementation LogisticsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleStr = @"物流详情";

    _dataArr = [NSMutableArray array];
    
    [self creatUI];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

//加载
- (void)loadData{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (_goods_id) {
        
        [params setObject:_goods_id forKey:@"goods_id"];

    }else{
    
        [params setObject:_acution_id forKey:@"id"];
        
    }
    
    [HMDataManager requestUrl:get_express_info_API params:params HidHUD:NO success:^(id result) {
        
        NSLog(@"%@",result);
        
        [_dataArr addObjectsFromArray:result[@"result"][@"data"][@"item"][@"express_list"]];
        
        orderV.dic = result[@"result"][@"data"][@"item"];
        
        _dataDic = result[@"result"][@"data"][@"item"];
        
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

    
}
//
- (void)creatUI{
    
    orderV = [[[NSBundle mainBundle]loadNibNamed:@"OrderManagerView" owner:self options:nil] lastObject];
    
    orderV.frame = CGRectMake(0, 0, kScreenWidth,86 + 64);
    
    [self.view addSubview:orderV];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 86 + 10, kScreenWidth, kScreenHeight - 86  - 10 - 64) style:UITableViewStyleGrouped];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"LogisticsDetailsCell" bundle:nil] forCellReuseIdentifier:@"LogisticsDetailsCell"];
    
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    _myTableView.separatorStyle = NO;

}


#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_dataArr.count != 0) {
        
        return _dataArr.count + 1;

    }
    
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsDetailsCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.addressLabel.text = [NSString stringWithFormat:@"%@\n%@",_dataDic[@"user_name"],_dataDic[@"express_address"]];
        
        cell.imageV.image = [UIImage imageNamed:@"shoudress"];
        
    }else{
    
        cell.dic = _dataArr[indexPath.row - 1];
        
        cell.imageV.image = [UIImage imageNamed:@"wulform"];
        
        if (indexPath.row == _dataArr.count) {
            
            cell.imageV.image = [UIImage imageNamed:@"jidress"];
        }
        
    }
    
    return cell;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;

}


@end
