//
//  SaleGoodsDetailViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/17.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SaleGoodsDetailViewController.h"
#import "SaleGoodsTetailOneTableViewCell.h"
#import "SaleGoodsDetailTwoTableViewCell.h"
#import "SaleGoodsDetaiThreeTableViewCell.h"
#import "CategoryModel.h"
#import <UIViewController+MMDrawerController.h>
#import "ScanViewController.h"
#import "SharedItem.h"


@interface SaleGoodsDetailViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) SDCycleScrollView *SDCycleScrollView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (nonatomic, strong) CategoryModel *model;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UILabel *remarkTextField;
@property (nonatomic, strong) NSArray *price_list;

@property (strong, nonatomic) IBOutlet UIButton *colseSaleButton;
@property (strong, nonatomic) IBOutlet UIButton *priceButton;
//距下
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (strong, nonatomic) IBOutlet UIView *trueView;

@property (strong, nonatomic) IBOutlet UIView *showDissatifiedView;


@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIButton *twoButton;



@property (nonatomic, strong) NSString *takeCalss;



@end

@implementation SaleGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //拍品详情
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataList = [NSMutableArray array];
    
    self.showDissatifiedView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.showDissatifiedView.hidden = YES;
    self.firstButton.selected = YES;

    self.showDissatifiedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:self.showDissatifiedView];
    _takeCalss = @"1";

    [self getData];
    //views
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initViews {
    //轮播图
    _SDCycleScrollView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 208) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    _SDCycleScrollView.imageURLStringsGroup = _model.picture_list;
    _SDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _SDCycleScrollView.currentPageDotColor = [AppStyle colorForDefault];
    _mainTableView.tableHeaderView = _SDCycleScrollView;
    //脚视图
    _footView.frame = CGRectMake(0, 0, kScreenWidth, 256);
    _mainTableView.tableFooterView = _footView;
    _remarkTextField.text = _model.remark;
    
    _colseSaleButton.hidden = YES;
    
    _priceButton.hidden = YES;

    _trueView.hidden = YES;

    //已成交
    if ([GlobalUtils isHaveStateWith:_model.status_group state:acution_success]) {
        
        _colseSaleButton.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
        
        _colseSaleButton.hidden = NO;

        [self.view addSubview:_colseSaleButton];

        [_colseSaleButton setTitle:_model.status_format forState:UIControlStateNormal];
        
        return;
    }
    
    //已上拍（出价）
//    if ([GlobalUtils isHaveStateWith:_model.status_group state:acution]) {
//        _priceButton.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
//        _priceButton.hidden = NO;
//
//        [self.view addSubview:_priceButton];
//        return;
//    }
    
    
    if ([_model.status isEqualToString:@"2"]) {
        
        _trueView.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
        
        _trueView.hidden = NO;

        [self.view addSubview:_trueView];
        return;

    }
    //距下
    _tableViewBottom.constant = 0;

}

//对价格不满意
- (IBAction)noPriceAction:(id)sender {
    
    self.showDissatifiedView.hidden = NO;
    
}
//确定出售
- (IBAction)trueAction:(id)sender {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_model.goods_id forKey:@"goods_id"];
    [HMDataManager requestUrl:@"sellerv1/Acution/confirm_price" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getData];
        }
    } failure:^(NSError *error) {
        
    }];

}

//进入下次拍卖
- (void)takeGoodsNet {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_model.goods_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Acution/refuse_price" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//取回商品
- (void)getGoodsNet {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_model.goods_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Goods/recaption" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            [_dataList removeAllObjects];
            [self getData];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//取回商品
- (IBAction)firstClick:(id)sender {
    _firstButton.selected = YES;
    _twoButton.selected = NO;
    _takeCalss = @"1";
}

//进入下次拍卖
- (IBAction)twoClick:(id)sender {
    _takeCalss = @"2";
    _firstButton.selected = NO;
    _twoButton.selected = YES;
    
}

//返回
- (IBAction)hideShowClick:(id)sender {
    _showDissatifiedView.hidden = YES;
}

//确认
- (IBAction)sureShowClick:(id)sender {
    _showDissatifiedView.hidden = YES;
    if ([_takeCalss isEqualToString:@"1"]) {
        [self getGoodsNet];
    }else if ([_takeCalss isEqualToString:@"2"]) {
        [self takeGoodsNet];
    }
    
}




#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareClick:(id)sender {
    
    
    [self WXAction];
    
}

//微信分享
- (void)WXAction{
    
    NSMutableArray *imgArr = [NSMutableArray array];
    
    __block NSInteger item1 = 0;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.removeFromSuperViewOnHide = YES;
    
    
    for (int i = 0 ; i < _model.picture_list.count; i++) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",_model.picture_list[i],@"?imageMogr2/auto-orient/thumbnail/820x820>/blur/1x0/quality/75"];
        
        NSLog(@"%@",urlStr);
        
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"");
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            item1++;
            
            if (error) {
                
            }
            if (image) {
                
                [imgArr addObject:image];
                
            }
            
            if (item1 == _model.picture_list.count) {
                
                [hud hideAnimated:YES];
                
                [self WXpush:imgArr];
                
            }
            
        }];
        
    }
    
    
}


- (void)WXpush:(NSArray*)imageArr{
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = _model.goods_name;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",imageArr);
    
    for (int i = 0; i < imageArr.count; i++) {
        
        UIImage *imagerang = imageArr[i];
        
        NSString *path_sandox = NSHomeDirectory();
        
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
        
        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
        
        NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
        
        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在吊起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
        
        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
        
        [array addObject:item];

    }
    
    NSLog(@"%@",array);
    
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:array
                                                                                        applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypeAirDrop];
    
    [self presentViewController:activityViewController animated:TRUE completion:nil];
    
}


- (IBAction)priceClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请先申请成为买家才能出价!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - Net
- (void)getData {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_good_id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Goods/get_goods_detail" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            _model = [[CategoryModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
            _model.price = result[@"result"][@"data"][@"item"][@"acution"][@"price"];
            _model.status_group =result[@"result"][@"data"][@"item"][@"acution"][@"status_group"];
            _price_list = result[@"result"][@"data"][@"item"][@"acution"][@"price_list"];
            for (NSDictionary *dic in _model.attribute_list) {
                CategoryModel *model = [[CategoryModel alloc]initWithDic:dic];
                [_dataList addObject:model];
            }
            [self initViews];
            [_mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"%ld",(long)index);
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    
    scanVC.imageURLArr = _model.picture_list;
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
    
    scanVC.currentIndexPath = path;
    
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([GlobalUtils isHaveStateWith:_model.status_group state:acution_deal]) {
            return 2;
        }
        return 1;
    }
    return _dataList.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //出价完成
        if ([GlobalUtils isHaveStateWith:_model.status_group state:acution_deal] && indexPath.row == 1) {
            SaleGoodsDetaiThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleGoodsDetaiThreeTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"SaleGoodsDetaiThreeTableViewCell" owner:self options:nil]firstObject];
            }
            cell.dataList = _price_list;
            return cell;
        }

        //出价未完成
        SaleGoodsTetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleGoodsTetailOneTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SaleGoodsTetailOneTableViewCell" owner:self options:nil]firstObject];
        }
        cell.titleLabel.text = _model.goods_name;
        
        cell.quetoLabel.text = _model.acution[@"offer_count"];
        
        cell.viewLabel.text = [NSString stringWithFormat:@"%@人围观",_model.acution[@"view"]];
        cell.priceLabel.text = _model.price;
        
        if ([_model.status isEqualToString:@"10"]) {
            
            cell.view1.hidden = YES;
            cell.view2.hidden = YES;
            cell.view3.hidden = YES;
            cell.priceLabel.hidden = YES;
            cell.viewLabel.hidden = YES;
            cell.quetoLabel.hidden = YES;

            cell.priceNameLabel.hidden = YES;
            
        }else{
            
            cell.view1.hidden = NO;
            cell.view2.hidden = NO;
            cell.view3.hidden = NO;
            cell.priceLabel.hidden = NO;
            cell.viewLabel.hidden = NO;
            cell.quetoLabel.hidden = NO;
            cell.priceNameLabel.hidden = NO;
        
        }
        
        return cell;
    }
    
    
    SaleGoodsDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleGoodsDetailTwoTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SaleGoodsDetailTwoTableViewCell" owner:self options:nil]firstObject];
    }
//    if (_dataList.count < 1) {
//        return cell;
//    }
    
    if (indexPath.row == 0) {
        
        cell.titleLabel.text = @"分类";
        cell.contentLabel.text = _model.category_name;

        
    }else if (indexPath.row == 1){
    
        cell.titleLabel.text = @"品牌";
        cell.contentLabel.text = _model.brand_name;
        
    }else{
    
        CategoryModel *model = _dataList[indexPath.row -2];
        
        if ([model.attribute_type isEqualToString:@"text"]) {
            
            cell.titleLabel.text = model.attribute_name;
            cell.contentLabel.text = model.attribute_value;
        }else {
            cell.titleLabel.text = model.parent_name;
            cell.contentLabel.text = model.attribute_value;
            
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {

            return 92;
        }
        
        if ([_model.status isEqualToString:@"10"]) {
            
            return 48;
            
        }else{
            
            return 110;
        }

    }
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return view;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
