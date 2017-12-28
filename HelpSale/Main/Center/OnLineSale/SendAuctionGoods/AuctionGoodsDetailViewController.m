//
//  AuctionGoodsDetailViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AuctionGoodsDetailViewController.h"
#import "PhotoCollectionViewCell.h"
#import "OneselfSelectTableViewCell.h"
#import "CategoryModel.h"
#import "InputOneTableViewCell.h"
#import "OneselfSelectViewController.h"
#import "CheckBoxViewController.h"
#import "SelectClassifyViewController.h"
#import "SureSubmitViewController.h"
#import "SelectBrandViewController.h"
#import "CenterTextuerViewController.h"
#import "SelectSeriesViewController.h"
#import "SelectChildAttributesViewController.h"
#import "UploadPicturesViewControllerViewController.h"


@interface AuctionGoodsDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CGFloat _itemWH;
    CGFloat _margin;

}
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectTitleImage;

@property (nonatomic, strong) NSMutableArray *lineThingsAry;

@property (nonatomic, strong) NSMutableDictionary *photo;

@property (nonatomic, strong) NSMutableArray *photoAry;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (strong, nonatomic) IBOutlet UIView *mainFootView;



@end

@implementation AuctionGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.title = @"拍品信息填写";
    _selectTitleImage = [NSMutableArray array];
    _photo = [NSMutableDictionary dictionary];
//    NSArray *lines = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    _lineThingsAry = [NSMutableArray array];
    
    for (int i = 0 ; i < 100; i++) {
        
        [_lineThingsAry addObject:@"0"];
    }
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataList = [NSMutableArray array];
    _attribute_list_idDic = [NSMutableDictionary dictionary];
    _attribute_list_nameDic = [NSMutableDictionary dictionary];
    _photoAry = [NSMutableArray array];
    [self getClassNet];
    //views
    [self initViews];
}
//views
- (void)initViews {
    _mainTableView.tableFooterView = _mainFootView;
    [self configCollectionView];
}

- (void)configCollectionView {

//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, 140)];
//    
//    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
//    
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 31)];
//    
//    topView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//    
//    [headerView addSubview:topView];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(10, 5.5, 56, 20);
//    label.text = @"商品编号";
//    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
//    [topView addSubview:label];
//    
//    UILabel *label1 = [[UILabel alloc] init];
//    label1.frame = CGRectMake(80, 5.5, 143.5, 20);
//    label1.text = @"897897921378638612";
//    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    label1.textColor = [UIColor colorWithRed:199/255.0 green:157/255.0 blue:101/255.0 alpha:1/1.0];
//    [topView addSubview:label1];
//
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _margin = 4;
    _itemWH = (kScreenWidth - 2 * _margin - 4) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 100) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
//    [headerView addSubview:_collectionView];
    
    _mainTableView.tableHeaderView = _collectionView;
    for (NSInteger i = 0; i < 100 ; i++) {
        
        NSString * stringID = [NSString stringWithFormat:@"PhotoCollectionViewCell%ld",i];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:stringID];
        
    }
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)againSendClick:(id)sender {
    
    if (_photoAry.count == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = @"还未上传图片";
        
        [hud hideAnimated:YES afterDelay:2];

        return;
    }
    
    
    [self saveGoods];
    
    SelectClassifyViewController *selectClassifyVC = [[SelectClassifyViewController alloc]init];
    
    [self.navigationController pushViewController:selectClassifyVC animated:YES];
}
- (IBAction)atOnceClick:(id)sender {
//    NSLog(@"%@",_photoAry);
//    NSLog(@"%@",_attribute_list_idDic);
//    
    if (_photoAry.count == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = @"还未上传图片";
        
        [hud hideAnimated:YES afterDelay:2];
        
        return;
    }

    [self saveGoods];
    
    SureSubmitViewController *submitVC = [[SureSubmitViewController alloc]init];
    
    [self.navigationController pushViewController:submitVC animated:YES];
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
    if (_photoAry.count > 0) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < _photoAry.count; i ++ ) {
            
            [dic setObject:_photoAry[i] forKey:[NSString stringWithFormat:@"%d",i]];
            
        }

        
        [goodDics setObject:dic forKey:@"picture_list"];
    }
    
    if (_category1_id) {
        
        [goodDics setObject:_category1_id forKey:@"category_id"];

    }else{
    
        [goodDics setObject:_category_id forKey:@"category_id"];

    }
    
    [goodDics setObject:_brand_id forKey:@"brand_id"];
    
    if (_series_id) {
        
        [goodDics setObject:_series_id forKey:@"series_id"];
        
    }
    
    
    [goodDics setObject:_remarkTextView.text forKey:@"remark"];

    
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


#pragma mark - Net
- (void)getClassNet {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_category_id forKey:@"category_id"];
    [HMDataManager requestUrl:@"apiv1/Attribute/get_top_attribute_by_category" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            NSArray *list = result[@"result"][@"data"][@"list"];
            for (NSDictionary *dic in list) {
                CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
        [_mainTableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDataNet1:(NSString*) parent_id  index:(NSInteger)index{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:parent_id forKey:@"id"];
    [HMDataManager requestUrl:@"apiv1/Attribute/get_child_attribute" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code intValue] == 1) {
            NSArray *list = result[@"result"][@"data"][@"list"];
            
            for (int i = 0; i < list.count; i++) {
                
                CategoryModel *model = [[CategoryModel alloc]initWithDic:list[i]];

                [_dataList insertObject:model atIndex:index + i + 1];
                
            }

//            for (NSDictionary *dic in list) {
//                CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
//                [_dataList addObject:model];
//            }
            [_mainTableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        
    }];
}

//- (void) insertObjects:(NSArray *)additions atIndexes:(NSIndexSet *)indexes
//
//{
//    
//    
//    NSUInteger currentIndex = [indexes firstIndex];
//    
//    
//    NSUInteger i, count = [indexes count];
//    
//    
//    
//    for (i = 0; i < count; i++)
//        
//        
//    {
//        
//        
//        
//        [self insertObject:[additions objectAtIndex:i] atIndex:currentIndex];
//        
//        
//        currentIndex = [indexes indexGreaterThanIndex:currentIndex];
//        
//        
//    }
//    
//}





- (void)getImageUrlWith:(NSArray *)imageUrl {
    
    [HMDataManager getImageUrl:imageUrl progress:^(NSDictionary *progress) {
        NSLog(@"%@",progress);
        NSString *index = [progress allKeys][0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue]  inSection:0];
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_lineThingsAry[[index integerValue]] floatValue] < 1.0) {
                cell.loadingView.progress = [progress[index] floatValue];
                [cell.loadingView setProgress:[progress[index] floatValue] animated:YES];
                _lineThingsAry[[index integerValue]] = progress[index];
            }
        });
        
    } success:^(NSArray *result) {
        NSLog(@"%@",result);
        NSMutableArray *photoAry = [NSMutableArray array];
        for (int i = 0; i < result.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:result[i] forKey:@"image"];
            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"sort"];
            [photoAry addObject:dic];
        }
        _photoAry = photoAry;
    }];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectTitleImage.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * stringID = [NSString stringWithFormat:@"PhotoCollectionViewCell%ld",indexPath.row];
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringID forIndexPath:indexPath];
    cell.deleteBtn.hidden = NO;
    cell.loadingView.hidden = YES;
    cell.loadingView.progress = [_lineThingsAry[indexPath.row] floatValue];
    if (indexPath.row == _selectTitleImage.count) {
        cell.TitleImage.image = [UIImage imageNamed:@"addpic"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.loadingView.hidden = NO;
        cell.TitleImage.image = _selectTitleImage[indexPath.row];

//        if ([_selectTitleImage[indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
//            cell.TitleImage.image = [_selectTitleImage[indexPath.row] originImage];
//        }else{
//            cell.TitleImage.image = _selectTitleImage[indexPath.row];
//        }
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建选择图片控制器
    if (indexPath.row == _selectTitleImage.count) {
        

//        UploadPicturesViewControllerViewController *uploadPicturesVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadPicturesViewControllerViewController"];
        
        UploadPicturesViewControllerViewController *uploadPicturesVC = [[UploadPicturesViewControllerViewController alloc]init];
        
        uploadPicturesVC.categate_id = _category_id;
        
        uploadPicturesVC.TureBlock = ^(NSArray *imageArr) {
//            
//            if (self.selectTitleImage.count + imageArr.count > 9) {
//                [self.view showLableViewWithMessage:@"图片不能超过九张"];
//                return ;
//            }
            
            [self.selectTitleImage  addObjectsFromArray:imageArr];

            NSMutableArray *photoAry = [NSMutableArray array];
            
            
//            NSLog(@"%@",_selectTitleImage);
            
            for (int i = 0; i < _selectTitleImage.count; i++) {

                UIImageView *imageView = [[UIImageView alloc]init];
                
                imageView.image = _selectTitleImage[i];
                
                [photoAry addObject:_selectTitleImage[i]];

            }
            
            [self getImageUrlWith:photoAry];
            [self.collectionView reloadData];
        };

        
        [self.navigationController pushViewController:uploadPicturesVC animated:YES];

        
//
//        ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
//        // MaxCount, Default = 9
//        pickerVc.maxCount = 9;
//        // Jump AssetsVc
//        pickerVc.status = PickerViewShowStatusCameraRoll;
//        // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
//        pickerVc.photoStatus = PickerPhotoStatusPhotos;
//        // Recoder Select Assets
//        //    pickerVc.selectPickers = self.assets;
//        // Desc Show Photos, And Suppor Camera
//        pickerVc.topShowPhotoPicker = YES;
//        pickerVc.isShowCamera = YES;
//        // CallBack
//        pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
//            NSMutableArray *images = status.mutableCopy;
//            if (self.selectTitleImage.count + images.count > 9) {
//                [self.view showLableViewWithMessage:@"图片不能超过九张"];
//                return ;
//            }
//            [self.selectTitleImage  addObjectsFromArray:status.copy];
//            NSMutableArray *photoAry = [NSMutableArray array];
//            for (int i = 0; i < _selectTitleImage.count; i++) {
//                UIImageView *imageView = [[UIImageView alloc]init];
//                if ([_selectTitleImage[i] isKindOfClass:[ZLPhotoAssets class]]) {
//                    imageView.image = [_selectTitleImage[i] originImage];
//                }else{
//                    imageView.image = _selectTitleImage[i];
//                }
//                [photoAry addObject:imageView.image];
//                //NSData *imageData = UIImagePNGRepresentation(imageView.image);
//                NSData *imageData = UIImageJPEGRepresentation(imageView.image, 1.0);
////                [self ChangeNet:imageData :[NSString stringWithFormat:@"%d",i]];
//            }
//            [self getImageUrlWith:photoAry];
//            [self.collectionView reloadData];
//        };
//        [pickerVc showPickerVc:self];
//
    }else{
//        ShowImageViewController *showVC = [[ShowImageViewController alloc]init];
//        UIImageView *imageView = [[UIImageView alloc]init];
//        
//        if ([_selectTitleImage[indexPath.row] isKindOfClass:[ZLPhotoAssets class]]) {
//            imageView.image = [_selectTitleImage[indexPath.row] originImage];
//        }else{
//            imageView.image = _selectTitleImage[indexPath.row] ;
//        }
//        showVC.image = imageView.image;
//        [self presentViewController:showVC animated:YES completion:nil];
    }
    
    
}
-(void)deleteBtnClick:(UIButton *)button
{
    _lineThingsAry[_selectTitleImage.count - 1] = @"0";
    [_selectTitleImage removeObjectAtIndex:button.tag];
    [_photo removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)button.tag]];
    if (_selectTitleImage.count == 0) {
        [_photo removeAllObjects];
    }
    [_collectionView reloadData];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        if (_series_id) {
            
            return 3;
        }

        return 2;
    }
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        OneselfSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneselfSelectTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OneselfSelectTableViewCell" owner:self options:nil]firstObject];
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"商品类别:";
            
            cell.contenLabel.text = _category_name;

//            cell.contenLabel.text = _category_name;
        }else if (indexPath.row == 1) {
            cell.titleLabel.text = @"品牌";
            cell.contenLabel.text = _brand_name;
        }else if (indexPath.row == 2) {
            cell.titleLabel.text = @"系列";
            cell.contenLabel.text = _series_name;
        }
        return cell;
    }
    CategoryModel *model = _dataList[indexPath.row];
    //单选
    if ([model.attribute_type isEqualToString:@"radio"]) {
        OneselfSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneselfSelectTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OneselfSelectTableViewCell" owner:self options:nil]firstObject];
        }
        cell.titleLabel.text = model.attribute_name;
        cell.contenLabel.text = [NSString stringWithFormat:@"请选择%@",model.attribute_name];
        
        cell.contenLabel.textColor = [UIColor colorWithHexString:@"d9d9d9"];
        
        if (_attribute_list_nameDic[model.attribute_name]) {
            cell.contenLabel.text = _attribute_list_nameDic[model.attribute_name];
            
            cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];

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
        
        cell.contenLabel.textColor = [UIColor colorWithHexString:@"d9d9d9"];
        
        if (_attribute_list_nameDic[model.attribute_name]) {
            cell.contenLabel.text = _attribute_list_nameDic[model.attribute_name];
            cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];
            
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 24;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 10, 24)];
        label.text = @"完整的商品信息有助于我们准确估价，请您认真填写";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"999999"];
        [view addSubview:label];
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryModel *model = _dataList[indexPath.row];
    //重新选择类别
    if (indexPath.section == 0 && indexPath.row == 0) {
//        SelectClassifyViewController *classVC = [[SelectClassifyViewController alloc]init];
//        classVC.whereFrom = @"1";
//        __weak typeof(self)weakSelf = self;
//        self.GetCategoryBlock = ^(NSString *category_name, NSString *category_id, NSString *brand_name, NSString *brand_id) {
//            weakSelf.category_name = category_name;
//            weakSelf.category_id = category_id;
//            weakSelf.brand_name = brand_name;
//            weakSelf.brand_id = brand_id;
//            
//            [weakSelf.mainTableView reloadData];
//        };
//        [self.navigationController pushViewController:classVC animated:YES];
        
        SelectChildAttributesViewController *classifyVC = [[SelectChildAttributesViewController alloc]init];
        
        classifyVC.category_id = _category_id;
        
        __weak typeof(self)weakSelf = self;

        classifyVC.backBlock = ^(NSString *category_name, NSString *category_id) {
          
            weakSelf.category1_id = category_id;
            
            weakSelf.category_name = category_name;
            
            [weakSelf.mainTableView reloadData];

        };
        

        [self.navigationController pushViewController:classifyVC animated:YES];

        return;
    }
    //重新选择品牌
    if (indexPath.section == 0 && indexPath.row == 1) {
//        SelectBrandViewController *selectBrandVC = [[SelectBrandViewController alloc]init];
//        selectBrandVC.fromSubmit = @"1";
//        selectBrandVC.category_id = _category_id;
//        selectBrandVC.category_id = _category_name;
//        __weak typeof(self)weakSelf = self;
//        self.GetCategoryBlock = ^(NSString *category_name, NSString *category_id, NSString *brand_name, NSString *brand_id) {
//            weakSelf.brand_name = brand_name;
//            weakSelf.brand_id = brand_id;
//            [weakSelf.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
//        };
//        [self.navigationController pushViewController:selectBrandVC animated:YES];
        
        
        SelectBrandViewController *brandVC = [[SelectBrandViewController alloc]init];
        brandVC.category_name = _category_name;
        brandVC.category_id = _category_id;
//        brandVC.fromWhere = _fromWhere;
        [self.navigationController pushViewController:brandVC animated:YES];

        return;
    }
    

    //重新选择系列
    if (indexPath.section == 0 && indexPath.row == 2) {
        SelectSeriesViewController *selectBrandVC = [[SelectSeriesViewController alloc]init];
        selectBrandVC.fromSubmit = @"1";
        selectBrandVC.category_id = _category_id;
        selectBrandVC.category_id = _category_name;
        selectBrandVC.brand_id = _brand_id;
        selectBrandVC.brand_name = _brand_name;
        
//        __weak typeof(self)weakSelf = self;
//        self.GetCategoryBlock = ^(NSString *category_name, NSString *category_id, NSString *brand_name, NSString *brand_id) {
//            weakSelf.brand_name = brand_name;
//            weakSelf.brand_id = brand_id;
//            [weakSelf.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
//        };
        [self.navigationController pushViewController:selectBrandVC animated:YES];
        return;
    }

    
    //单选
    if ([model.attribute_type isEqualToString:@"radio"]) {
        OneselfSelectViewController *selectVC = [[OneselfSelectViewController alloc]init];
        selectVC.parent_id = model.id;
        selectVC.parent_name = model.attribute_name;
        selectVC.GetNameBlock = ^(NSString *name, NSString *nameid, NSString *parentId) {
            [_attribute_list_nameDic setObject:name forKey:model.attribute_name];
            [_attribute_list_idDic setObject:nameid forKey:parentId];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
            
            NSLog(@"%@",nameid);
            
            [self getDataNet1:nameid index:indexPath.row];
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }
    if ([model.attribute_type isEqualToString:@"checkbox"]) {
        
        if ([model.child_has_logo isEqualToString:@"1"]) {
            
            CenterTextuerViewController *textureVC = [[CenterTextuerViewController alloc]init];
            
            textureVC.titleStr = [NSString stringWithFormat:@"选择%@",model.attribute_name];

            textureVC.attribute_id = model.id;
            textureVC.selectId = [_attribute_list_idDic objectForKey:[NSString stringWithFormat:@"%@",model.id]];
            
            textureVC.GetAttribeTextureBlock = ^(NSString *name,NSString *nameId,NSString *parentId){
                
                [_attribute_list_nameDic setObject:name forKey:model.attribute_name];
                [_attribute_list_idDic setObject:nameId forKey:[NSString stringWithFormat:@"%@",parentId]];
                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];

                [self getDataNet1:nameId index:indexPath.row];

            };
            
            [self.navigationController pushViewController:textureVC animated:YES];

        }else{
        

        CheckBoxViewController *selectVC = [[CheckBoxViewController alloc]init];
        selectVC.titleStr = [NSString stringWithFormat:@"选择%@",model.attribute_name];
        selectVC.attribute_id = model.id;
        selectVC.selectId = [_attribute_list_idDic objectForKey:[NSString stringWithFormat:@"%@",model.id]];
        selectVC.GetAttribeBlock = ^(NSString *name, NSString *nameId, NSString *parentId) {
            [_attribute_list_nameDic setObject:name forKey:model.attribute_name];
            [_attribute_list_idDic setObject:nameId forKey:[NSString stringWithFormat:@"%@",parentId]];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
            
            [self getDataNet1:nameId index:indexPath.row];

        };
        [self.navigationController pushViewController:selectVC animated:YES];
            
        }
    }

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


@end
