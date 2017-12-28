//
//  OneselfSelectViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/31.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "OneselfSelectViewController.h"
#import "OrdinaryTableViewCell.h"
#import "CategoryModel.h"
@interface OneselfSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation OneselfSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"单选";
    self.titleLabel.text = [NSString stringWithFormat:@"选择%@",_parent_name];
    _dataList = [NSMutableArray array];
    _mainTableView.tableFooterView = [[UIView alloc]init];
    [self getDataNet];
}
#pragma mark - actions
- (IBAction)sureClick:(id)sender {
    
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrdinaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrdinaryTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrdinaryTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    CategoryModel *model = _dataList[indexPath.row];
    cell.titleLabel.text = model.attribute_name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryModel *model = _dataList[indexPath.row];
    if (self.GetNameBlock) {
        self.GetNameBlock(model.attribute_name, model.id, model.parent_id);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Net
- (void)getDataNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_parent_id forKey:@"id"];
    [HMDataManager requestUrl:@"apiv1/Attribute/get_child_attribute" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
