//
//  CheckBoxViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/31.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "CheckBoxViewController.h"
#import "SelectMuchAttribeTableViewCell.h"
#import "CategoryModel.h"
@interface CheckBoxViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (nonatomic, strong) NSArray *TitleArry;
@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataDics;
@property (nonatomic, strong) NSArray *selectAry;
@property (nonatomic, strong) NSString *parentId;

@end

@implementation CheckBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _TitleArry = [NSArray array];
    _dataLists = [NSMutableArray array];
    _dataDics = [NSMutableArray array];
    _dataDic = [NSDictionary dictionary];
    _selectAry = [NSArray array];
    if (_selectId.length > 0) {
        _selectAry = [_selectId componentsSeparatedByString:@","];
    }
    self.titleName.text = _titleStr;
    [self getDataList];
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureClick:(id)sender {
    //处理选择好了的数据
    NSString *name = @"";
    NSString *nameId = @"";
    for (NSArray *ary in _dataDics) {
        for (CategoryModel *model in ary) {
            if (model.isSelect) {
                name = [NSString stringWithFormat:@"%@,%@",name,model.attribute_name];
                nameId = [NSString stringWithFormat:@"%@,%@",nameId,model.id];
                _parentId = model.parent_id;
            }
        }
    }
    CategoryModel *model = _dataDics[0][0];
    _parentId = model.parent_id;
    
    
    if (name.length > 0) {
        name = [name substringFromIndex:1];
        nameId = [nameId substringFromIndex:1];
        if (self.GetAttribeBlock) {
            self.GetAttribeBlock(name,nameId,_parentId);
        }
    }else{
        if (self.GetAttribeBlock) {
            self.GetAttribeBlock(@"",@"",_parentId);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)isSelectBtnClick:(UIButton *)button {
    SelectMuchAttribeTableViewCell *cell = (SelectMuchAttribeTableViewCell *)[[button superview]superview];
    NSIndexPath *index = [_mainTableView indexPathForCell:cell];
    CategoryModel *model = _dataDics[index.section][index.row];
    model.isSelect = !model.isSelect;
    _dataDics[index.section][index.row] = model;
    [_mainTableView reloadData];
}
#pragma mark - Net
- (void)getDataList {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_attribute_id forKey:@"id"];
    [HMDataManager requestUrl:@"apiv1/Attribute/get_attribute_by_initial" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            _dataDic = result[@"result"][@"data"][@"list"];
            if ([_dataDic isKindOfClass:[NSDictionary class]]) {
                _TitleArry = [_dataDic allKeys];
            }
            NSArray *TitleArry = [_TitleArry sortedArrayUsingSelector:@selector(compare:)];
            _TitleArry = TitleArry;
            //处理数据
            for (NSString *key in _TitleArry) {
                NSArray *item = _dataDic[key];
                NSMutableArray *modelsTwo = [NSMutableArray array];
                for (NSDictionary *dic in item) {
                    CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                    //对比已经选中的id
                    for (NSString *str in _selectAry) {
                        if ([[NSString stringWithFormat:@"%@",model.id] isEqualToString:str]) {
                            model.isSelect = YES;
                        }
                    }
                    
                    [modelsTwo addObject:model];
                }
                [_dataDics addObject:modelsTwo];
            }
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataDics.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_TitleArry.count > 0) {
        NSArray *dataList = _dataDic[_TitleArry[section]];
        return dataList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectMuchAttribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectMuchAttribeTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectMuchAttribeTableViewCell" owner:self options:nil]firstObject];
    }
    NSDictionary *modelDic;
    if (_TitleArry.count > 0) {
        NSArray *dataList = _dataDic[_TitleArry[indexPath.section]];
        modelDic = dataList[indexPath.row];
    }
    cell.NameLabel.text = modelDic[@"attribute_name"];
    
    CategoryModel *model = _dataDics[indexPath.section][indexPath.row];
    
    cell.isSelectBtn.selected = model.isSelect;

    [cell.isSelectBtn addTarget:self action:@selector(isSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CategoryModel *model = _dataDics[indexPath.section][indexPath.row];
    model.isSelect = !model.isSelect;
    _dataDics[indexPath.section][indexPath.row] = model;
    
    [_mainTableView reloadData];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //    if (tableView == _LeftTableView) {
    //        return nil;
    //    }
    //更改索引的背景颜色
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //更改索引的背景颜色:
    //    tableView.sectionIndexColor = [UIColor clearColor];
    return _TitleArry;
}

//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
    
    NSLog(@"===%ld,===%@",(long)index , title);
    
    //点击索引，列表跳转到对应索引的行
    
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //弹出首字母提示
    
    
    return index;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 18)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 18)];
    label.text = _TitleArry[section];
    [view addSubview:label];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

@end
