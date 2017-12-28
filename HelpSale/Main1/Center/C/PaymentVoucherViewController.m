//
//  PaymentVoucherViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/8.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PaymentVoucherViewController.h"
#import "OnlineFeedbackBuyCell.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"

@interface PaymentVoucherViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,strong) NSMutableArray *imageUrlArr;

@end

@implementation PaymentVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArr = [NSMutableArray array];

    _imageUrlArr = [NSMutableArray array];

    self.titleStr = @"上传支付凭证";
    
    _myCollectionView.delegate = self;
    
    _myCollectionView.dataSource = self;
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"OnlineFeedbackBuyCell" bundle:nil] forCellWithReuseIdentifier:@"OnlineFeedbackBuyCell"];

}

- (IBAction)submitAction:(id)sender {

    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [_params setObject:_imageUrlArr forKey:@"proof"];
    
    [HMDataManager requestUrl:pay_acution_API params:_params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            hud.label.text = @"付款凭证提交成功！";
            
            hud.mode = MBProgressHUDModeText;
            
            [hud hideAnimated:YES afterDelay:2];

            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark --UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imageArr.count + 1;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OnlineFeedbackBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OnlineFeedbackBuyCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        
        cell.delegateButton.hidden = YES;
        
        cell.imageV.image = [UIImage imageNamed:@"addpic"];
        
    }else{
    
        cell.delegateButton.hidden = NO;

        NSLog(@"%@",_imageArr[indexPath.row - 1]);
        
        cell.imageV.image = _imageArr[indexPath.row - 1];
        
    }
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row == 0) {
        
        ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        // 最多能选9张图片

        pickerVc.topShowPhotoPicker = YES;
        
        pickerVc.status = PickerViewShowStatusCameraRoll;
        
        pickerVc.maxCount = 9;
        
        pickerVc.isShowCamera = YES;
        
        [pickerVc showPickerVc:self];
        
        pickerVc.callBack = ^(NSArray *assets){
            
            NSMutableArray *imageArr = [NSMutableArray array];
            
            for (int i = 0; i < assets.count; i++) {
                
                if ([assets[i] isKindOfClass:[ZLPhotoAssets class]]) {
                    
                    ZLPhotoAssets *asset = assets[i];
                    
                    [imageArr addObject:asset.originImage];
                    
                    [_imageArr addObject:asset.originImage];
                    
                }else{
                    
                    [imageArr addObject:[UIImage rotateImage:assets[i]]];
                    
                    [_imageArr addObject:[UIImage rotateImage:assets[i]]];

                }
            }
            
            [HMDataManager getImageUrl:imageArr progress:^(NSDictionary *progress) {
                
                NSLog(@"%@",progress);
                
            } success:^(NSArray *result) {
                
                NSLog(@"%@",result);
                
                if (result.count != 0) {
                    
                    [_imageUrlArr addObjectsFromArray:result];
                    
                    [_myCollectionView reloadData];
                    
                    
                }
                
            }];
        };
        
    }
    
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
