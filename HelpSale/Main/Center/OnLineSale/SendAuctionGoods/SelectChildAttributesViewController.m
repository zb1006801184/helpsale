//
//  SelectChildAttributesViewController.m
//  HelpSale
//
//  Created by CYT on 2017/10/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SelectChildAttributesViewController.h"
#import "SelectBrandViewController.h"

@interface SelectChildAttributesViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SelectChildAttributesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];

    self.titleStr = @"选择子分类";
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    _myTableView.tableFooterView = [[UIView alloc]init];
    
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ChildAttributesCell"];
    
    [self loadData];
    
}

//
- (void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_category_id forKey:@"category_id"];
    
    [HMDataManager requestUrl:get_child_category params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                
                [_dataArr addObject:dic];
            }
        
            [_myTableView reloadData];
            
        }
        
    } failure:nil];
    
}




#pragma mark --UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ChildAttributesCell" forIndexPath:indexPath];

    cell.textLabel.text = _dataArr[indexPath.row][@"category_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    SelectBrandViewController *brandVC = [[SelectBrandViewController alloc]init];
//    brandVC.category_name = _dataArr[indexPath.row][@"category_name"];
//    brandVC.category_id = _dataArr[indexPath.row][@"id"];
//    brandVC.fromWhere = _fromWhere;
//    [self.navigationController pushViewController:brandVC animated:YES];
    
    
    self.backBlock(_dataArr[indexPath.row][@"category_name"], _dataArr[indexPath.row][@"id"]);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    

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
