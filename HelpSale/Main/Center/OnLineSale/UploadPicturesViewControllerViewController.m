//
//  UploadPicturesViewControllerViewController.m
//  HelpSale
//
//  Created by CYT on 2017/10/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "UploadPicturesViewControllerViewController.h"
#import "OnlineFeedbackBuyCell.h"
#import "TakepictureViewController.h"
#import "ScanViewController.h"
#import "SampleCell.h"
#import "ZLPhoto.h"

@interface UploadPicturesViewControllerViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    UIView *headView;
    
}


@property (nonatomic,strong) UICollectionView *myCollectionview;

@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,strong) NSMutableArray *dataArr;


@property (nonatomic,strong) NSMutableDictionary *imageDataDic;



@end

@implementation UploadPicturesViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleStr = @"上传图片";
    
    _imageArr  = [NSMutableArray array];
    
    _dataArr = [NSMutableArray array];
    
    _imageDataDic = [NSMutableDictionary dictionary];
    
//    _myCollectionView.delegate = self;
//    
//    _myCollectionView.dataSource = self;
//    
//    [_myCollectionView registerNib:[UINib nibWithNibName:@"OnlineFeedbackBuyCell" bundle:nil] forCellWithReuseIdentifier:@"OnlineFeedbackBuyCell"];
//    
//    NSArray *imageArr = @[@"腕表",@"箱包",@"首饰",@"其他"];
//    
//    titleArr1 = @[@"正面",@"反面",@"侧面",@"使用痕迹",@"划痕或瑕疵",@"附件"];
//    
//    titleArr2 = @[@"正面",@"反面",@"底面",@"边角",@"五金细节",@"附件"];
//
//    titleArr3 = @[@"正面",@"反面",@"侧面",@"刻印及编号",@"磨损及细节",@"附件"];
//
//    titleArr4 = @[@"正面",@"反面",@"平铺展示",@"标签及编号",@"磨损及细节",@"附件"];
//
//
//    for (int i = 0; i < 6; i++) {
//        
//        UIButton *button = [self.view viewWithTag:100+i];
//        
//        button.layer.masksToBounds = YES;
//        
//        button.layer.borderWidth = 2;
//
//        if (i == 0) {
//            
//            
//            button.layer.borderColor = [UIColor colorWithHexString:@"C79D65"].CGColor;
//            
//        }else{
//            
//            button.layer.borderColor = [UIColor clearColor].CGColor;
//        
//        }
//        
//        UILabel *label = [self.view viewWithTag:200+i];
//
//        if ([_categate_id isEqualToString:@"1"]) {
//            
//            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imageArr[0],i+1]] forState:UIControlStateNormal];
//            
//            label.text = titleArr1[i];
//            
//        }else if ([_categate_id isEqualToString:@"2"]){
//            
//            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imageArr[1],i+1]] forState:UIControlStateNormal];
//            
//            label.text = titleArr2[i];
//            
//        }else if ([_categate_id isEqualToString:@"4"]){
//            
//            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imageArr[2],i+1]] forState:UIControlStateNormal];
//            
//            label.text = titleArr3[i];
//            
//        }else if ([_categate_id isEqualToString:@"31"]){
//            
//            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imageArr[3],i+1]] forState:UIControlStateNormal];
//            
//            label.text = titleArr4[i];
//            
//        }
//
//    }
    
    //右边
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 50, 16);
    
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    [self creatUI];
    
    [self getDataList];

}


- (void)getDataList {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:_categate_id forKey:@"category_id"];
    
    [HMDataManager requestUrl:camera_image params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            NSArray *list = result[@"result"][@"data"];
            for (NSDictionary *dic in list) {
                [_dataArr addObject:dic];
            }

           int index =  (_dataArr.count - 1)/3 + 1;
  
            [self creatUI:index];
            
//            [_myCollectionview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)creatUI :(NSInteger)index{

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];

    scrollView.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    [self.view addSubview:scrollView];

    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120 * index + 36)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    [scrollView addSubview:headView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(12, 14, 48, 12);
    label.text = @"示例图片";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    
    [headView addSubview:label];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
//    layout.minimumLineSpacing=10;
//    
//    layout.minimumInteritemSpacing = 10;
    
    
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    
    _myCollectionview =  [[UICollectionView alloc]initWithFrame:CGRectMake(0, 36, kScreenWidth, 120 * index) collectionViewLayout:layout];
    
    _myCollectionview.delegate = self;

    _myCollectionview.dataSource = self;
    
    _myCollectionview.backgroundColor = [UIColor clearColor];
    
    [headView addSubview:_myCollectionview];
    
    [_myCollectionview registerNib:[UINib nibWithNibName:@"SampleCell" bundle:nil] forCellWithReuseIdentifier:@"SampleCell"];

    CGFloat bottom  = 0;
    
    for (int i = 0; i < _dataArr.count; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(13, 6 + (114 * i) + headView.bottom, 200, 12);
        label.text = _dataArr[i][@"text"];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        
        [scrollView addSubview:label];
        
        
        UICollectionViewFlowLayout *layout1=[[UICollectionViewFlowLayout alloc]init];
        
        layout1.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        
        layout1.minimumLineSpacing=8;
        //
        //    layout.minimumInteritemSpacing = 10;
        
        
        layout1.sectionInset = UIEdgeInsetsMake(6, 12, 6, 0);

        
        UICollectionView *collectionV =  [[UICollectionView alloc]initWithFrame:CGRectMake(0,  24 + (114 * i) + headView.bottom, kScreenWidth, 90) collectionViewLayout:layout1];
        
        collectionV.delegate = self;
        
        collectionV.dataSource = self;
        
        collectionV.backgroundColor = [UIColor whiteColor];
        
        collectionV.tag = 100 + i;
        
        [scrollView addSubview:collectionV];
        
        [collectionV registerNib:[UINib nibWithNibName:@"OnlineFeedbackBuyCell" bundle:nil] forCellWithReuseIdentifier:@"OnlineFeedbackBuyCell"];

        if (i == _dataArr.count - 1) {
            
            scrollView.contentSize = CGSizeMake(kScreenWidth, collectionV.bottom + 37  +44);
            
            bottom = collectionV.bottom + 37  +44;
            
        }
        
    }

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, bottom - 44, kScreenWidth, 44);
    
    button.backgroundColor = [UIColor colorWithHexString:@"C79D65"];
    
    [button setTitle:@"完成上传" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [button addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:button];
}


- (void)rightBtnAction{

    for (NSString *key in _imageDataDic.allKeys) {
        
        NSArray * imageArr = _imageDataDic[key];
        
        [_imageArr addObjectsFromArray:imageArr];
        
    }

    if (_imageArr.count > 0) {
        
        _TureBlock(_imageArr);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

- (IBAction)takeAPicker:(id)sender {
    
    
//    TakepictureViewController *uploadPicturesVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"TakepictureViewController"];
//    
////    uploadPicturesVC.labelText = [_describeLabel.text substringFromIndex:5];
//    
//    uploadPicturesVC.backBlock = ^(UIImage *image) {
//        
//        [_imageArr addObject:image];
//        
//        [_myCollectionview reloadData];
//
//    };
//    
//    [self.navigationController pushViewController:uploadPicturesVC animated:YES];
//

}

#pragma mark --UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == _myCollectionview) {
        
        return _dataArr.count;

    }
    
    NSArray *array = _imageDataDic[[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];
    
    return array.count + 1;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _myCollectionview) {
        
        SampleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
        
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"image"]]];
        
        cell.titleLabel.text = _dataArr[indexPath.row][@"text"];
        
        return cell;

    }
    
    OnlineFeedbackBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OnlineFeedbackBuyCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.delegateButton.hidden = YES;
        
        cell.imageV.image = [UIImage imageNamed:@"addpic"];
        
    }else{
    
        
        NSArray *array = _imageDataDic[[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];

        cell.delegateButton.hidden = NO;
        
        cell.imageV.image = array[indexPath.row - 1];
        
        [cell.delegateButton addTarget:self action:@selector(delegateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.delegateButton.tag = 1000 * (collectionView.tag - 100) + indexPath.row - 1;
        
    }
    
    return cell;
    
}

- (void)delegateAction:(UIButton*)bt{
    
    NSInteger index =  bt.tag/1000;
    
    NSInteger index1 =  bt.tag%1000;
    
    UICollectionView *collectionView = [self.view viewWithTag:index + 100];
    
    NSArray *array = _imageDataDic[[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];
    
    NSMutableArray *imageArr = [NSMutableArray arrayWithArray:array];
    
    [imageArr removeObjectAtIndex:index1];
    
    [_imageDataDic setObject:[imageArr copy] forKey:[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];

    [collectionView reloadData];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_myCollectionview != collectionView) {
        
        if (indexPath.row == 0) {
            

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"选择相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                
                ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
                // MaxCount, Default = 9
                pickerVc.maxCount = 100;
                // Jump AssetsVc
                pickerVc.status = PickerViewShowStatusCameraRoll;
                // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
                pickerVc.photoStatus = PickerPhotoStatusPhotos;
                // Recoder Select Assets
                //    pickerVc.selectPickers = self.assets;
                // Desc Show Photos, And Suppor Camera
                pickerVc.topShowPhotoPicker = YES;
                pickerVc.isShowCamera = NO;
                // CallBack
                pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
                    NSMutableArray *images = status.mutableCopy;

                    for (ZLPhotoAssets *asset in images) {
                        
                        
                        NSArray *array = _imageDataDic[[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];
                        
                        NSMutableArray *imageArr = [NSMutableArray arrayWithArray:array];
                        
                        [imageArr addObject:asset.originImage];
                        
                        [_imageDataDic setObject:[imageArr copy] forKey:[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];


                        [collectionView reloadData];

                    }
                    
                };
                [pickerVc showPickerVc:self];
                
                
            }];
            
            
            UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                TakepictureViewController *uploadPicturesVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"TakepictureViewController"];
                
                uploadPicturesVC.labelText = _dataArr[collectionView.tag - 100][@"text"];
                
                uploadPicturesVC.backBlock = ^(UIImage *image) {
                    
                    NSArray *array = _imageDataDic[[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];
                    
                    NSMutableArray *imageArr = [NSMutableArray arrayWithArray:array];
                    
                    
                    [imageArr addObject:image];
                    
                    [_imageDataDic setObject:[imageArr copy] forKey:[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];
                    
                    [collectionView reloadData];
                    
                };
                
                [self.navigationController pushViewController:uploadPicturesVC animated:YES];
                
                
            }];
            
            [alertController addAction:cancelAction];
            
            [alertController addAction:archiveAction];
            
            [alertController addAction:deleteAction];


            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
          
        }else{
            
            NSArray *array = _imageDataDic[[NSString stringWithFormat:@"%ld",collectionView.tag - 100]];

        
            ScanViewController *scanVC = [[ScanViewController alloc]init];
            
            scanVC.imageArr = array;
            
            NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:0];
            
            scanVC.currentIndexPath = path;
            
            [self.navigationController pushViewController:scanVC animated:YES];
            
        }

    }else{
    
        ScanViewController *scanVC = [[ScanViewController alloc]init];
        
        NSMutableArray *imageUrlArr = [NSMutableArray array];
        
        for (NSDictionary *dic in _dataArr) {
            
            [imageUrlArr addObject:dic[@"image"]];
            
        }
        
        scanVC.imageURLArr = imageUrlArr;
        
        NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.item  inSection:0];
        
        scanVC.currentIndexPath = path;
        
        [self.navigationController pushViewController:scanVC animated:YES];
        
    
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_myCollectionview == collectionView) {
        return CGSizeMake((kScreenWidth - 40)/3 , (kScreenWidth - 40)/3 );

    }
    
    return CGSizeMake(82,82);

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
