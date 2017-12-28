//
//  SelectSeriesViewController.m
//  HelpSale
//
//  Created by CYT on 2017/10/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SelectSeriesViewController.h"
#import "SelectBrandTableViewCell.h"
#import "AuctionGoodsDetailViewController.h"

@interface SelectSeriesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic, strong)NSArray *titleArray;
//数据
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong)NSMutableArray *dataList;


@end

@implementation SelectSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleStr = @"选择系列";
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    _myTableView.tableFooterView = [[UIView alloc]init];

    [self loadData];

}

//
- (void)loadData{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:_brand_id forKey:@"brand_id"];
    
    [HMDataManager requestUrl:@"apiv1/Brand/get_series_by_initial" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            _dataDic = result[@"result"][@"data"][@"list"];
            
            if (_dataDic.count != 0) {
                
                _titleArray = [_dataDic allKeys];
                _titleArray = [_titleArray sortedArrayUsingSelector:@selector(compare:)];
                
                [_myTableView reloadData];

            }
        }
    } failure:^(NSError *error) {
        
    }];

    
}


#pragma mark --UITableViewDelegate

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataList = _dataDic[_titleArray[section]];
    return dataList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectBrandTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectBrandTableViewCell" owner:self options:nil]firstObject];
    }
    NSDictionary *modelDic;
    if (_titleArray.count > 0) {
        NSArray *dataList = _dataDic[_titleArray[indexPath.section]];
        modelDic = dataList[indexPath.row];
    }
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:modelDic[@"logo"]] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLabel.text = modelDic[@"brand_name"];
    
    cell.contenLabel.hidden = YES;
    
//    cell.contenLabel.text = modelDic[@"brand_name_alpha"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 18)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 18)];
    label.text = _titleArray[section];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *dataList = _dataDic[_titleArray[indexPath.section]];
    NSMutableDictionary *modelDic = dataList[indexPath.row];
    
    AuctionGoodsDetailViewController *auctionVC = [[AuctionGoodsDetailViewController alloc]init];
    auctionVC.category_name = @"";
    auctionVC.category_id = _category_id;
    auctionVC.series_name = modelDic[@"brand_name"];
    auctionVC.series_id = modelDic[@"id"];
    auctionVC.brand_name = _brand_name;
    auctionVC.brand_id = _brand_id;
    [self.navigationController pushViewController:auctionVC animated:YES];

    //    NSLog(@"%@",modelDic[@"has_hot_goods"]);
    
//    if ([modelDic[@"has_hot_goods"] isEqualToString:@"1"]) {
//        
//        SelectHotStyleViewController *selectVC = [[SelectHotStyleViewController alloc]init];
//        selectVC.category_name = _category_name;
//        selectVC.category_id = _category_id;
//        selectVC.titleStr = modelDic[@"brand_name"];
//        selectVC.brand_name = modelDic[@"brand_name"];
//        selectVC.brand_id = modelDic[@"id"];
//        selectVC.fromSubmit = _fromSubmit;
//        selectVC.fromWhere = @"1";
//        
//        [self.navigationController pushViewController:selectVC animated:YES];
//        
//    }else{
//        
//        //        SelectHotStyleViewController *hotVC = [[SelectHotStyleViewController alloc]init];
//        //        hotVC.titleStr = modelDic[@"brand_name"];
//        //        hotVC.brand_name = modelDic[@"brand_name"];
//        //        hotVC.brand_id = modelDic[@"id"];
//        //        hotVC.fromWhere = @"1";
//        //        hotVC.category_name = _category_name;
//        //        hotVC.category_id = _category_id;
//        //        hotVC.fromSubmit = _fromSubmit;
//        //        [self.navigationController pushViewController:hotVC animated:YES];
//        //
//    }
//    
    
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _titleArray;
}

//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
    NSLog(@"===%ld,===%@",(long)index , title);
    //点击索引，列表跳转到对应索引的行
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return index;
    
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
