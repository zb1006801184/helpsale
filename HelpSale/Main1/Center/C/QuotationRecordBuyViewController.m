//
//  QuotationRecordBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "QuotationRecordBuyViewController.h"
#import "LotsDetailsBuyViewController.h"
#import "BuyersHomeCell.h"
#import "OfferBuyView.h"

@interface QuotationRecordBuyViewController ()<UITableViewDelegate,UITableViewDataSource>


//遮罩
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) OfferBuyView *offerBuyView;


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

@implementation QuotationRecordBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleStr = @"报价记录";

    _page1 = 1;
    
    _page2 = 1;
    
    _page3 = 1;
    
    
    _dataArr1 = [NSMutableArray array];
    
    _dataArr2 = [NSMutableArray array];
    
    _dataArr3 = [NSMutableArray array];
    

    [self creatUI];

    [self loadData];
    
}

//UI
- (void)creatUI{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    
    headerView.backgroundColor = [UIColor colorWithHexString:@"050634"];
    
    [self.view addSubview:headerView];
    
    
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(41, 46, 8, 2)];
    
    _selectView.backgroundColor = [UIColor colorWithHexString:@"C79D65"];
    
    NSArray *titleArr = @[@"竞拍中",@"中标",@"未中标"];
    
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

//加载列表数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    if (_selectButton.tag - 100 == 0) {
        
        [params setObject:@(_page1) forKey:@"p"];
        
        [params setObject:@"1" forKey:@"type"];
        
    }else if (_selectButton.tag - 100 == 1){
        
        [params setObject:@(_page2) forKey:@"p"];
        
        [params setObject:@"2" forKey:@"type"];
        
    }else if (_selectButton.tag - 100 == 2){
        
        [params setObject:@(_page3) forKey:@"p"];
        
        [params setObject:@"3" forKey:@"type"];
    }
    
    [HMDataManager requestUrl:my_offer_record params:params HidHUD:NO success:^(id result) {
        
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
                    
                    model.status = @"1000";
                    
                    [_dataArr3 addObject:model];
                }
                
            }
            
            [_myTableView reloadData];
            
        }
        
        [_myTableView.header endRefreshing];
        
        [_myTableView.footer endRefreshing];
        
    } failure:nil];
    
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
    
    cell.modifyQuotationBlock = ^{

        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
        
        _offerBuyView = [[[NSBundle mainBundle]loadNibNamed:@"OfferBuyView" owner:self options:nil] lastObject];
        
        _offerBuyView.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 260);
        
        _offerBuyView.goods_id = model.goods_id;
        
        _offerBuyView.isEdit = YES;
        
        LRWeakSelf(self);
        
        _offerBuyView.backBlock = ^{
            
            [weakself hideOfferView];
        };
        
        _offerBuyView.tureBlock = ^{
            
            [weakself hideOfferView];

            _page1 = 1;
            
            [weakself loadData];
            
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:_offerBuyView];
    };
    
    cell.backBlock = ^{
      
        _page1 = 2;
        
        [self loadData];

    };
    
    
    return cell;
    
}

- (void)hideOfferView{
    
    [_bgView removeFromSuperview];
    
    [_offerBuyView removeFromSuperview];
    
    _bgView = nil;
    
    _offerBuyView = nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_selectButton.tag == 102){
        
        if (section == 0) {
            return 24;

        }
        
    }
    
    return 0.00001f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (_selectButton.tag == 102){

        if (section == 0) {

            UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
            
            label.textColor = [UIColor colorWithHexString:@"999999"];
            
            label.text = @"一周内未中标";
            
            label.font = [UIFont systemFontOfSize:12];
            
            return label;
            
        }
        
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LotsListBuyModel *model = nil;
    
    if (_selectButton.tag == 100) {
        
        model = _dataArr1[indexPath.section];
    }else if (_selectButton.tag == 101){
        
        model = _dataArr2[indexPath.section];
        
    }else if (_selectButton.tag == 102){
        
        model = _dataArr3[indexPath.section];
    }
    
    if ([model.status isEqualToString:@"1"]||[model.status isEqualToString:@"3"]||[model.status isEqualToString:@"6"]) {
        
        return 156;
    }

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



@end
