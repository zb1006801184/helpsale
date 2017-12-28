//
//  PersonalInformationBuyViewController.m
//  HelpSale
//
//  Created by CYT on 2017/9/5.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PersonalInformationBuyViewController.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
#import "ModifyNicknameViewController.h"
#import "EditPhoneBuyViewController.h"
#import "UIViewController+MMDrawerController.h"


@interface PersonalInformationBuyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nick_nameLabel;

@end

@implementation PersonalInformationBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, 16, 15);
    
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 96, 44)];
    
    leftLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    leftLabel.textAlignment = NSTextAlignmentLeft;
    
    leftLabel.font = [UIFont systemFontOfSize:18];
    
    leftLabel.text = @"个人信息";
    
    self.navigationItem.titleView = leftLabel;

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f2fa"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}


- (void)showData{
    
    
    UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];
    
    NSLog(@"---%@",model.nick_name);
    
    _nick_nameLabel.text = model.nick_name;
    
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head_img_url]];
    
    _phoneLabel.text = model.mobile;
    
}

- (void)leftBtnAction{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        // 最多能选9张图片
        
        pickerVc.topShowPhotoPicker = YES;
        
        pickerVc.status = PickerViewShowStatusCameraRoll;
        
        pickerVc.maxCount = 1;
        
        pickerVc.isShowCamera = YES;
        
        [pickerVc showPickerVc:self];
        
        pickerVc.callBack = ^(NSArray *assets){
            
            NSMutableArray *imageArr = [NSMutableArray array];
            
            for (int i = 0; i < assets.count; i++) {
                
                if ([assets[i] isKindOfClass:[ZLPhotoAssets class]]) {
                    
                    ZLPhotoAssets *asset = assets[i];
                    
                    [imageArr addObject:asset.originImage];
                    
                }else{
                    
                    [imageArr addObject:[UIImage rotateImage:assets[i]]];
                    
                }
            }
            
            [HMDataManager getImageUrl:imageArr progress:^(NSDictionary *progress) {
                
                NSLog(@"%@",progress);
                
            } success:^(NSArray *result) {
                
                NSLog(@"%@",result);
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                if (result.count != 0) {
                    
                    [params setObject:result[0] forKey:@"head_img"];
                }


                NSArray *imageArr1 = result;
                
                [HMDataManager requestUrl:change_user_info_API params:params HidHUD:YES success:^(id result) {
                    
                    BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
                    
                    if ([model.code intValue] == 1) {
                     
                        UserDetaiModel *model = [HSUserDetaiModel getUserDetailModelForKey:[HSUserDetaiModel getUserDetailModelKey]];

                        
                        model.head_img_url = [NSString stringWithFormat:@"%@%@",[GlobalUtils urlWithImage],imageArr1[0]];

                        [HSUserDetaiModel setUserDetailModel:model forKey:[HSUserDetaiModel getUserDetailModelKey]];
                        
                        _headImageV.image = imageArr[0];

                    }
                    
                    
                } failure:nil];
                
                
            }];
            
            
        };
        
        
        
    }else if (indexPath.row == 1){
        
        EditPhoneBuyViewController *editPhoneBuyVC = [[EditPhoneBuyViewController alloc]init];

        
        editPhoneBuyVC.typeStr = 1;
        
        [self.navigationController pushViewController:editPhoneBuyVC animated:YES];

        
    }else if (indexPath.row == 2){

        ModifyNicknameViewController *modifyNicknameVC = [[ModifyNicknameViewController alloc]init];
        
        modifyNicknameVC.nickNameStr = _nick_nameLabel.text;
        
        [self.navigationController pushViewController:modifyNicknameVC animated:YES];

    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;

    [self showData];
    
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
