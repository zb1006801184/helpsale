//
//  LotsDetailsBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "LotsDetailsBuyViewController.h"
#import "StockCellectionCell.h"
#import "LotsDetailBuyModel.h"
#import "PriceBuyCell.h"
#import "OfferBuyView.h"
#import "PaymentBuyViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ScanViewController.h"
#import "SharedItem.h"


@interface LotsDetailsBuyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UILabel *serisesLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *priceCollectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *myPageContril;

@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *good_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel3;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

//遮罩
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) OfferBuyView *offerBuyView;

@property (nonatomic,assign) NSInteger time;

@property (nonatomic,strong) LotsDetailBuyModel *model;


@end

@implementation LotsDetailsBuyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"StockCellectionCell" bundle:nil] forCellWithReuseIdentifier:@"StockCellectionCell"];
    
    [_priceCollectionView registerNib:[UINib nibWithNibName:@"PriceBuyCell" bundle:nil] forCellWithReuseIdentifier:@"PriceBuyCell"];

    
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //右边
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, 50, 16);
    
    [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"C79D65"] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 96, 44)];
    
    leftLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    leftLabel.textAlignment = NSTextAlignmentLeft;
    
    leftLabel.font = [UIFont systemFontOfSize:18];
    
    leftLabel.text = @"拍品详情";
    
    self.navigationItem.titleView = leftLabel;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self loadData];

}

//加载详情数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    if (_goodsId) {
        
        [params setObject:_goodsId forKey:@"goods_id"];

    }else{
    
        [params setObject:_lotsId forKey:@"id"];
        
    }
    
    [HMDataManager requestUrl:get_goods_detail_API params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {

            _model = [[LotsDetailBuyModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
        }

        [self showData];
        
        [self.tableView reloadData];
        
        [_priceCollectionView reloadData];
        
        [_myCollectionView reloadData];
                
    } failure:nil];

    
}

//显示数据
- (void)showData{
    
    _time = [_model.acution[@"left_seconds"] integerValue];

    if (_time != 0) {
        
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];

        _view1.hidden = NO;
        _view2.hidden = NO;
        _view3.hidden = NO;
        _view4.hidden = NO;
        _view5.hidden = NO;
        _view6.hidden = NO;

    }else{
        
        _timeView.hidden = YES;

        _view1.hidden = YES;
        _view2.hidden = YES;
        _view3.hidden = YES;
        _view4.hidden = YES;
        _view5.hidden = YES;
        _view6.hidden = YES;

    }
    
    _myPageContril.numberOfPages = _model.picture_list.count;

    _good_nameLabel.text = _model.goods_name;
    
    _brandLabel.text = _model.brand_name;
    
    _categoryLabel.text = _model.category_name;
    
    _remarkLabel.text = _model.remark;
    
    _serisesLabel.text = _model.series_name;

    
    NSString *priceStr = [NSString stringWithFormat:@"已有%@人报价  %@人围观",_model.acution[@"offer_count"],_model.acution[@"view"]];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%@",_model.acution[@"offer_count"]]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FE5B62"] range:range];
    
    _priceLabel3.attributedText = string;

    if ([_model.status integerValue] != 1) {
   
        _priceLabel1.text = @"最高出价";
        
        _priceLabel2.textColor = [UIColor colorWithHexString:@"CF9444"];

        _priceLabel2.text = _model.acution[@"now_high_price"];
        
        
    }else{
    
        _priceLabel1.text = @"我的出价";
        
        if ([_model.acution[@"my_price"] integerValue] == 0) {
            
            _priceLabel2.text = @"暂未出价";
        }else{
        
            _priceLabel2.text = [NSString stringWithFormat:@"￥%@",_model.acution[@"my_price"]];
            _priceLabel2.textColor = [UIColor colorWithHexString:@"CF9444"];
        }
    }

    
    for (int i = 0; i < _model.attribute_list.count; i++) {
        
        UILabel *label1 = [self.tableView viewWithTag:i*2 + 100];
        
        UILabel *label2 = [self.tableView viewWithTag:i*2 + 101];

        NSLog(@"%d  %d",i*2 + 100,i*2 + 101);
        
        
        if ([_model.attribute_list[i][@"attribute_type"] isEqualToString:@"text"]) {
            
            label1.text = _model.attribute_list[i][@"attribute_name"];
            
            label2.text = _model.attribute_list[i][@"attribute_value"];
            

        }else {
        
            label1.text = _model.attribute_list[i][@"parent_name"];
            
            label2.text = _model.attribute_list[i][@"attribute_value"];
            
        }

    }
    
    
    if ([_model.status isEqualToString:@"1"]) {

        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"C79D65"];

        if ([_model.acution[@"my_price"] integerValue] == 0) {

            _buttonLabel.text = @"立即出价";
            
        }else{
        
            _buttonLabel.text = @"修改出价";

        }
        
    }else if ([_model.status isEqualToString:@"2"]){
    
        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"CDCDCD"];
        
        _buttonLabel.text = @"等待卖家确认报价";

    }else if ([_model.status isEqualToString:@"3"]){
        
        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"C79D65"];
        
        _buttonLabel.text = @"付款";
        
    }else if ([_model.status isEqualToString:@"4"]){
        
        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"CDCDCD"];
        
        _buttonLabel.text = @"已付款待核实";
        
    }else if ([_model.status isEqualToString:@"5"]){
        
        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"CDCDCD"];
        
        _buttonLabel.text = @"等待发货";
        
    }else if ([_model.status isEqualToString:@"6"]){
        
        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"C79D65"];
        
        _buttonLabel.text = @"确认收货";
        
    }else{
        
        _buttonLabel.backgroundColor = [UIColor colorWithHexString:@"CDCDCD"];
        
        _buttonLabel.text = @"报价结束";
    
    }

    
    if (_isHome) {
        
        _buttonLabel.text = @"已结束";

    }
    
    
}





//计算时间
- (void)ComputationTimeAction:(NSInteger)time{
    
    _hoursLabel.text = [NSString stringWithFormat:@"%ld",time/60/60];
    
    _minutesLabel.text = [NSString stringWithFormat:@"%ld",time/60%60];
    
    _secondsLabel.text = [NSString stringWithFormat:@"%ld",time%60];
    
}

- (void)timeAction:(NSTimer*)timer{
    
    _time--;
    
    if (_time == 0) {
        [timer invalidate];
        timer = nil;
        
    }else{
        
        [self ComputationTimeAction:_time];
        
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    
    if (scrollView == _myCollectionView) {
        
        //更新UIPageControl的当前页
        [_myPageContril setCurrentPage:offset.x / kScreenWidth];
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 208;
    }else if (indexPath.row == 1){
    
        CGRect rect = [_model.goods_name boundingRectWithSize:CGSizeMake(kScreenWidth - 24, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        return rect.size.height + 16;
        
    }else if (indexPath.row == 2){
    
        return 61;
        
    }else if (indexPath.row == 3){
    
        if ([_model.acution[@"status"] integerValue] != 1) {

            return 92;
        }
    }else if (indexPath.row == 4){
    
        if ([_model.acution[@"status"] integerValue] == 1) {

            return 8;
        }
        
    }else if (indexPath.row == 5){
        
        return 40;
        
    }else if (indexPath.row == 6){
        
            return 40;
            
    }else if (indexPath.row == 7){
        
        if (_model.series_id) {
            
            if ([_model.series_id integerValue] != 0) {
                
                return 40;

            }
            
        }
        
        return 0;
        
        
    }else if (indexPath.row == 8){
        

        if (_model.attribute_list.count > 0) {
            
            return 40;
            
        }

    }else if (indexPath.row == 9){
        
        if (_model.attribute_list.count > 1) {
            
            return 40;
            
        }

    }else if (indexPath.row == 10){
        if (_model.attribute_list.count > 2) {
            
            return 40;
            
        }

    }else if (indexPath.row == 11){
        if (_model.attribute_list.count > 3) {
            
            return 40;
            
        }

    }else if (indexPath.row == 12){
        if (_model.attribute_list.count > 4) {
            
            return 40;
            
        }

    }else if (indexPath.row == 13){
        if (_model.attribute_list.count > 5) {
            
            return 40;
            
        }

    }else if (indexPath.row == 14){
        if (_model.attribute_list.count > 6) {
            
            return 40;
            
        }

    }else if (indexPath.row == 15){
        if (_model.attribute_list.count > 7) {
            
            return 40;
        }

    }else if (indexPath.row == 16){
        if (_model.attribute_list.count > 8) {
    
            return 40;
        
        }

    }else if (indexPath.row == 17){
        if (_model.attribute_list.count > 9) {
            
            return 40;
        }
        
    }else if (indexPath.row == 18){
        if (_model.attribute_list.count > 10) {
            
            return 40;
        }
        
    }else if (indexPath.row == 19){
        if (_model.attribute_list.count > 11) {
            
            return 40;
        }
        
    }else if (indexPath.row == 20){
        if (_model.attribute_list.count > 12) {
            
            return 40;
        }
        
    }else if (indexPath.row == 21){
        if (_model.attribute_list.count > 13) {
            
            return 40;
        }
        
    }else if (indexPath.row == 22){
        if (_model.attribute_list.count > 14) {
            
            return 40;
        }
        
    }else if (indexPath.row == 23){
        if (_model.attribute_list.count > 15) {
            
            return 40;
        }
        
    }else if (indexPath.row == 24){
        if (_model.attribute_list.count > 15) {
            
            return 40;
        }
        
    }else if (indexPath.row == 25){
        if (_model.attribute_list.count > 16) {
            
            return 40;
        }
        
    }else if (indexPath.row == 26){
        if (_model.attribute_list.count > 17) {
            
            return 40;
        }
        
    }else if (indexPath.row == 27){
        if (_model.attribute_list.count > 18) {
            
            return 40;
        }
        
    }else if (indexPath.row == 28){
    
        return 8;
    
    }else if (indexPath.row == 29){
        
        CGRect rect = [_model.remark boundingRectWithSize:CGSizeMake(kScreenWidth - 24, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        return rect.size.height + 61;
    }else if (indexPath.row == 31){
    
        return 16;
    
    }else if (indexPath.row == 32){
        
        return 44;
        
    }

    return 0;
}


#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == _myCollectionView) {

        return _model.picture_list.count;

    }else if (collectionView == _priceCollectionView){
    
        NSArray *priceArr = _model.acution[@"price_list"];
        
        return priceArr.count;
    }
    
    
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _myCollectionView) {
    
        StockCellectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StockCellectionCell" forIndexPath:indexPath];
        cell.url = _model.picture_list[indexPath.row];
        
        return cell;
        
    }else{
        
        NSArray *priceArr = _model.acution[@"price_list"];

        PriceBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceBuyCell" forIndexPath:indexPath];
        
        cell.dic = priceArr[indexPath.row];
        
        return cell;
    }
    
    return nil;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];

    scanVC.imageURLArr = _model.picture_list;
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.item inSection:0];

    scanVC.currentIndexPath = path;
    
    [self.navigationController pushViewController:scanVC animated:YES];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 32) {
        
        if ([_model.status isEqualToString:@"1"]) {

            _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            _bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
            [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
            
            _offerBuyView = [[[NSBundle mainBundle]loadNibNamed:@"OfferBuyView" owner:self options:nil] lastObject];
            
            _offerBuyView.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 260);
            
            _offerBuyView.goods_id = _model.acution[@"good_id"];
            
            
            if ([_model.acution[@"my_price"] integerValue] == 0) {
                
                _offerBuyView.isEdit = NO;
                
            }else{
                
                _offerBuyView.isEdit = YES;
                
            }

            
            LRWeakSelf(self);
            
            _offerBuyView.backBlock = ^{
                
                [weakself hideOfferView];
            };
            
            _offerBuyView.tureBlock = ^{
                
                [weakself hideOfferView];
                
                [weakself.timer invalidate];
                
                weakself.timer = nil;
                
                [weakself loadData];
            };
            
            [[UIApplication sharedApplication].keyWindow addSubview:_offerBuyView];

            
        }else if ([_model.status isEqualToString:@"3"]){
        
            PaymentBuyViewController *paymentBuyVC = [[UIStoryboard storyboardWithName:@"Buyers" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentBuyViewController"];
            
            paymentBuyVC.acution_id = _model.acution[@"id"];
            
            paymentBuyVC.pay_money = _model.acution[@"now_high_price"];
            
            [self.navigationController pushViewController:paymentBuyVC animated:YES];

        }else if ([_model.status isEqualToString:@"6"]){
        
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:_model.id forKey:@"acution_id"];
            
            [HMDataManager requestUrl:confirm_express_API params:params HidHUD:NO success:^(id result) {
                
                BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
                
                if ([model.code intValue] == 1) {
                    
                    [self.timer invalidate];
                    
                    self.timer = nil;
                    
                    [self loadData];
                    
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        
        }
        
       
    }

}

- (void)hideOfferView{

    [_bgView removeFromSuperview];
    
    [_offerBuyView removeFromSuperview];
    
    _bgView = nil;
    
    _offerBuyView = nil;

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _priceCollectionView) {
        
        return CGSizeMake(86, 56);

    }
    
    return CGSizeMake(kScreenWidth, 208);

}

- (void)rightBtnAction{
    
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



//返回按钮
- (void)leftBtnAction{

    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
}


@end
