//
//  SubmitHotViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/9/4.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SubmitHotViewController.h"
#import "OneselfSelectTableViewCell.h"
#import "CategoryModel.h"
#import "InputOneTableViewCell.h"
#import "OneselfSelectViewController.h"
#import "CheckBoxViewController.h"
#import "SelectClassifyViewController.h"
#import "SureSubmitViewController.h"
#import "SelectClassifyViewController.h"
#import "CenterTextuerViewController.h"

@interface SubmitHotViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *price_Min;
@property (weak, nonatomic) IBOutlet UILabel *price_Max;
@property (weak, nonatomic) IBOutlet UILabel *goodNumbel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableDictionary *attribute_list_idDic;
@property (nonatomic, strong)NSMutableDictionary *attribute_list_nameDic;
@end

@implementation SubmitHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //views
    _dataDic = [NSDictionary dictionary];
    _dataList = [NSMutableArray array];
    _attribute_list_nameDic = [NSMutableDictionary dictionary];
    _attribute_list_idDic = [NSMutableDictionary dictionary];
    [self getDataNet];
    [self getListNet];
}
- (void)initViews {
    _mainTableView.tableHeaderView = _headView;
    _mainTableView.tableFooterView = [[UIView alloc]init];
    
    
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"photo"]]] placeholderImage:[UIImage imageNamed:@""]];
    _titleNameLabel.text = _dataDic[@"goods_name"];
    _price_Min.text = _dataDic[@"min_price"];
    _price_Max.text = _dataDic[@"max_price"];
    _goodNumbel.text = [NSString stringWithFormat:@"商品编号  %@", _dataDic[@"goods_model"]];
}
#pragma mark - Net
- (void)getDataNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_good_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Hot/get_hot_detail" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            _dataDic = result[@"result"][@"data"][@"item"];
            [self initViews];
            }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)getListNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_good_id forKey:@"id"];
    [HMDataManager requestUrl:@"Apiv1/Attribute/get_attribute_by_hot" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
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
//保存商品信息
- (void)saveGoods {
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    NSMutableArray *goods;
    id responseAry;
    if (data) {
        responseAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的数据（字典）
    }
    goods = responseAry;
    
    NSMutableArray *goodArys = [NSMutableArray array];
    NSMutableDictionary *goodDics = [NSMutableDictionary dictionary];
    if (_attribute_list_idDic!= nil) {
        [goodDics setObject:_attribute_list_idDic forKey:@"attribute_list"];
    }
    [goodDics setObject:_good_id forKey:@"hot_id"];
    
    if (_dataDic[@"photo"]) {

        [goodDics setObject:@{@"0":@{@"image":[_dataDic[@"photo"] substringFromIndex:[GlobalUtils urlWithImage].length]}} forKey:@"picture_list"];

    }

    //    [goodDics setObject:_dataDic[@"id"] forKey:@"hot_id"];

    if (goods.count > 0) {
        [goodArys addObjectsFromArray:goods];
    }
    if (goodDics!=nil) {
        [goodArys addObject:goodDics];
    }
    
    
    NSLog(@"%@",goodArys);
    
    if (goodArys.count > 0) {
        NSData *json_data = [NSJSONSerialization dataWithJSONObject:goodArys options:NSJSONWritingPrettyPrinted error:nil];
        [json_data writeToFile:filePath atomically:YES];
    }

}


#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)againSubmitClick:(id)sender {
    [self saveGoods];
    SelectClassifyViewController *selectClassifyVC = [[SelectClassifyViewController alloc]init];
    [self.navigationController pushViewController:selectClassifyVC animated:YES];

}
- (IBAction)atOnceClick:(id)sender {
    NSLog(@"%@",_attribute_list_idDic);
    [self saveGoods];
    SureSubmitViewController *submitVC = [[SureSubmitViewController alloc]init];
    submitVC.hot_id = _good_id;
    [self.navigationController pushViewController:submitVC animated:YES];
}
#pragma mark - textField
-(void)textFieldDidChange :(UITextField *)theTextField {
    InputOneTableViewCell *cell = (InputOneTableViewCell *)[[theTextField superview] superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    CategoryModel *model = _dataList[indexPath.row];
    if (theTextField.text.length > 0) {
        [_attribute_list_nameDic setObject:theTextField.text forKey:model.attribute_name];
        [_attribute_list_idDic setObject:theTextField.text forKey:model.id];
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *model = _dataList[indexPath.row];
    //单选
    if ([model.attribute_type isEqualToString:@"radio"]) {
        OneselfSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneselfSelectTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OneselfSelectTableViewCell" owner:self options:nil]firstObject];
        }
        cell.titleLabel.text = model.attribute_name;
        cell.contenLabel.text = [NSString stringWithFormat:@"请选择%@",model.attribute_name];
        if (_attribute_list_nameDic[model.attribute_name]) {
            cell.contenLabel.text = _attribute_list_nameDic[model.attribute_name];
        }
        return cell;
    }
    
    //多选
    if ([model.attribute_type isEqualToString:@"checkbox"]) {
        OneselfSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneselfSelectTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OneselfSelectTableViewCell" owner:self options:nil]firstObject];
        }
        cell.titleLabel.text = model.attribute_name;
        cell.contenLabel.text = [NSString stringWithFormat:@"请选择%@",model.attribute_name];
        if (_attribute_list_nameDic[model.attribute_name]) {
            cell.contenLabel.text = _attribute_list_nameDic[model.attribute_name];
        }
        return cell;
    }
    //输入
    if ([model.attribute_type isEqualToString:@"text"]) {
        InputOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputOneTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"InputOneTableViewCell" owner:self options:nil]firstObject];
        }
        cell.titleLabel.text = model.attribute_name;
        cell.inputTextField.placeholder = [NSString stringWithFormat:@"请输入%@",model.attribute_name];
        if (_attribute_list_nameDic[model.attribute_name]) {
            cell.inputTextField.text = _attribute_list_nameDic[model.attribute_name];
        }
        [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        return cell;
    }
    
    OneselfSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneselfSelectTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OneselfSelectTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataList.count < 1) {
        return cell;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryModel *model = _dataList[indexPath.row];
    //选择类别
    
    
    //单选
    if ([model.attribute_type isEqualToString:@"radio"]) {
        OneselfSelectViewController *selectVC = [[OneselfSelectViewController alloc]init];
        selectVC.parent_id = model.id;
        selectVC.parent_name = model.attribute_name;
        selectVC.GetNameBlock = ^(NSString *name, NSString *nameid, NSString *parentId) {
            [_attribute_list_nameDic setObject:name forKey:model.attribute_name];
            [_attribute_list_idDic setObject:nameid forKey:parentId];
            
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }
    if ([model.attribute_type isEqualToString:@"checkbox"]) {
        
        if ([model.child_has_logo isEqualToString:@"1"]) {
            
            CenterTextuerViewController *textureVC = [[CenterTextuerViewController alloc]init];
            
            textureVC.isHot = YES;
            
            textureVC.titleStr = [NSString stringWithFormat:@"选择%@",model.attribute_name];
            
            textureVC.attribute_id = model.id;
            
            textureVC.selectId = [_attribute_list_idDic objectForKey:model.id];
            
            textureVC.GetAttribeTextureBlock = ^(NSString *name,NSString *nameId,NSString *parentId){
                
                [_attribute_list_nameDic setObject:name forKey:model.attribute_name];
                [_attribute_list_idDic setObject:nameId forKey:[NSString stringWithFormat:@"%@",parentId]];
                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                
            };
            
            [self.navigationController pushViewController:textureVC animated:YES];
            
        }else{
        
        CheckBoxViewController *selectVC = [[CheckBoxViewController alloc]init];
        selectVC.titleStr = [NSString stringWithFormat:@"选择%@",model.attribute_name];
        selectVC.attribute_id = model.id;
        selectVC.selectId = [_attribute_list_idDic objectForKey:model.id];
        selectVC.GetAttribeBlock = ^(NSString *name, NSString *nameId, NSString *parentId) {
            [_attribute_list_nameDic setObject:name forKey:model.attribute_name];
            [_attribute_list_idDic setObject:nameId forKey:parentId];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        };
            
        [self.navigationController pushViewController:selectVC animated:YES];
            
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}



@end
