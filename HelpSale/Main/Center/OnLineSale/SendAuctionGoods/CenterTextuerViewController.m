//
//  CenterTextuerViewController.m
//  HM
//
//  Created by Air on 2017/5/23.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import "CenterTextuerViewController.h"
#import "CenterThreeSeletCollectionViewCell.h"
#import "CommonItemModel.h"
//#import "getGoodsByIdModel.h"
#import "CategoryModel.h"
@interface CenterTextuerViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataDics;
@property (nonatomic, strong) NSArray *TitleArry;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSArray *selectAry;

@end

@implementation CenterTextuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"选择材质";
    
    [self initRightBtn];
    _dataList = [NSMutableArray array];
    _dataDics = [NSMutableArray array];

    //
    UICollectionViewFlowLayout *FL = [[UICollectionViewFlowLayout alloc] init];
    FL.scrollDirection = UICollectionViewScrollDirectionVertical;
    FL.minimumLineSpacing = 1;
    FL.minimumInteritemSpacing = 1;
    [self.myCollectionView setCollectionViewLayout:FL];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"CenterThreeSeletCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CenterThreeSeletCollectionViewCell"];
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    [self getData];
    _selectId = [NSString stringWithFormat:@"%@",_selectId];
    if (_selectId.length > 0) {
        _selectAry = [_selectId componentsSeparatedByString:@","];
    }
}

-(void)initRightBtn
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 16)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithHexString:@"F6B08D"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barBtn;
}
-(void)rightBtnClick
{
    
    //处理选择好了的数据
    NSString *name = @"";
    NSString *nameId = @"";
    for (CategoryModel *model in _dataList) {
        if (model.isSelect) {
            name = [NSString stringWithFormat:@"%@,%@",name,model.attribute_name];
            nameId = [NSString stringWithFormat:@"%@,%@",nameId,model.id];
            _parentId = model.parent_id;
        }
    }

    CategoryModel *model = _dataList[0];
    _parentId = model.parent_id;
    
    if (name.length > 0) {
        name = [name substringFromIndex:1];
        nameId = [nameId substringFromIndex:1];
        if (self.GetAttribeTextureBlock) {
            self.GetAttribeTextureBlock(name,nameId,_parentId);
        }
    }else{
        if (self.GetAttribeTextureBlock) {
            self.GetAttribeTextureBlock(@"",@"",_parentId);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];

//    //处理选择好了的数据
//    NSString *name = @"";
//    NSString *nameId = @"";
//    for (NSArray *ary in _dataDics) {
//        for (CategoryModel *model in ary) {
//            if (model.isSelect) {
//                name = [NSString stringWithFormat:@"%@,%@",name,model.attribute_name];
//                nameId = [NSString stringWithFormat:@"%@,%@",nameId,model.id];
//                _parentId = model.parent_id;
//            }
//        }
//    }
//    
//    CategoryModel *model = _dataDics[0][0];
//    
//    _parentId = model.parent_id;
//    
//    if (name.length > 0) {
//        name = [name substringFromIndex:1];
//        nameId = [nameId substringFromIndex:1];
//        if (self.GetAttribeTextureBlock) {
//            self.GetAttribeTextureBlock(name,nameId,_parentId);
//        }
//    }else{
//        if (self.GetAttribeTextureBlock) {
//            self.GetAttribeTextureBlock(@"",@"",_parentId);
//        }
//    }
//    
//    [self.navigationController popViewControllerAnimated:YES];
//
}

#pragma mark collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //
    CGFloat width = (kScreenWidth - 2) / 2;
    
    return CGSizeMake(width, 120);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CenterThreeSeletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CenterThreeSeletCollectionViewCell" forIndexPath:indexPath];
    if (_dataList.count < 1) {
        return cell;
    }
    CategoryModel *model = _dataList[indexPath.row];
    cell.TitleLabel.text = model.attribute_name;
    [cell.TitleImage sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@""]];
    cell.selectImage.hidden = !model.isSelect;
    
//    [cell.isSelectBtn addTarget:self action:@selector(isSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//点击单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *model = _dataList[indexPath.row];
    model.isSelect = !model.isSelect;
    _dataList[indexPath.row] = model;
    [_myCollectionView reloadData];
}
//请求数据
-(void)getData
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:_attribute_id forKey:@"attribute_id"];
    NSMutableDictionary *allRequestDic = [NSMutableDictionary dictionary];
    [allRequestDic setObject:requestDic forKey:@"data"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];

    [paramDic setObject:_attribute_id forKey:@"id"];

    NSString *url = @"";
    
    if (_isHot) {
        
        url = @"apiv1/Attribute/get_child_attribute";

    }else{
    
        url = @"apiv1/Attribute/get_attribute_by_initial";


    }

    [HMDataManager requestUrl:url params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            
                if (_isHot) {
                    
                    for (NSDictionary *dic in result[@"result"][@"data"][@"list"]) {
                        CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                        //对比已经选中的id
                        for (NSString *str in _selectAry) {
                            if ([[NSString stringWithFormat:@"%@",model.id] isEqualToString:str]) {
                                model.isSelect = YES;
                            }
                        }
                        
                        [_dataList addObject:model];
                    }
                    
                }else{

                _dataDic = result[@"result"][@"data"][@"list"];
                    
                    if (_dataDic.count > 0 ) {


                _TitleArry = [_dataDic allKeys];
                //排序一遍数据
                NSArray *TitleArry = [_TitleArry sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    if ([obj1 intValue] > [obj2 intValue]) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedAscending;
                    }
                    
                }];
                _TitleArry = TitleArry;
                
                //处理数据
                for (NSString *key in _TitleArry) {
                    NSArray *item = _dataDic[key];
                    //                NSMutableArray *modelsTwo = [NSMutableArray array];
                    for (NSDictionary *dic in item) {
                        CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                        //对比已经选中的id
                        for (NSString *str in _selectAry) {
                            if ([[NSString stringWithFormat:@"%@",model.id] isEqualToString:str]) {
                                model.isSelect = YES;
                            }
                        }
                        
                        [_dataList addObject:model];
                        
                    }
                }
                    
                }
                
            }
            //处理数据
//            for (NSString *key in _TitleArry) {
//                
//                NSArray *item = _dataDic[key];
//                NSMutableArray *modelsTwo = [NSMutableArray array];
//                for (NSDictionary *dic in item) {
//                    CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
//                    //对比已经选中的id
//                    for (NSString *str in _selectAry) {
//                        if ([[NSString stringWithFormat:@"%@",model.id] isEqualToString:str]) {
//                            model.isSelect = YES;
//                        }
//                    }
//                    
//                    [modelsTwo addObject:model];
//                }
//                [_dataDics addObject:modelsTwo];
//            }
            
            [_myCollectionView reloadData];
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    

    
    
//    [[HMNetManager  shareManager]sendRequestWithDic:allRequestDic opt:OPT_POST shortURL:@"Attribute/getAttributeByGroup" setSuccessBlock:^(NSDictionary *responseDic){
//        BaseModel *model = [[BaseModel alloc]initWithDic:responseDic];
//        if ([model.status integerValue] == 200) {
//            _dataDic = responseDic[@"data"][@"list"];
//            _TitleArry = [_dataDic allKeys];
//            //排序一遍数据
//            NSArray *TitleArry = [_TitleArry sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                if ([obj1 intValue] > [obj2 intValue]) {
//                    return NSOrderedDescending;
//                } else {
//                    return NSOrderedAscending;
//                }
//
//            }];
//            _TitleArry = TitleArry;
//            //处理数据
//            for (NSString *key in _TitleArry) {
//                NSArray *item = _dataDic[key];
//                NSMutableArray *modelsTwo = [NSMutableArray array];
//                for (NSDictionary *dic in item) {
//                    getGoodsByIdModel *model = [[getGoodsByIdModel alloc]initWithDic:dic];
//                    //对比已经选中的id
//                    for (NSString *str in _selectAry) {
//                        if ([[NSString stringWithFormat:@"%@",model.id] isEqualToString:str]) {
//                            model.isSelect = YES;
//                        }
//                    }
//                    
//                    [_dataList addObject:model];
//
//                }
//            }
//            
//            
//            [_myCollectionView reloadData];
//        }else{
//            [self.view showLableViewWithMessage:model.msg];
//        }
//    } setFailBlock:^(id obj) {
//        
//    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

@end
