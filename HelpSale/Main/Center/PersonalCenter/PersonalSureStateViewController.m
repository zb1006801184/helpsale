//
//  PersonalSureStateViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/24.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "PersonalSureStateViewController.h"
#import "PersonalSureStateOneTableViewCell.h"
#import "PersonalSureStateTwoTableViewCell.h"
#import "OneselfSelectTableViewCell.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhoto.h"
#import "SubmitSuccessViewController.h"
#import <UIViewController+MMDrawerController.h>

@interface PersonalSureStateViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIView *selectCityView;

@property (weak, nonatomic) IBOutlet UIPickerView *selectPickerView;

@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (nonatomic,strong)NSArray * provinces;//展示省份
@property (nonatomic,strong)NSArray * cities;//展示城市
@property (nonatomic,strong)NSArray *area ;//展示区域
@property (nonatomic,strong)NSArray *cityDataList;

@property (nonatomic, strong) NSString *addressStr;

@property (nonatomic, strong) UIImage *oneImage;
@property (nonatomic, strong) UIImage *twoImage;
@property (nonatomic, strong) UIImage *threeImage;

@property (nonatomic, copy) NSString *identity_card1;
@property (nonatomic, copy) NSString *identity_card2;
@property (nonatomic, copy) NSString *business_license;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *areas;
@property (nonatomic, copy) NSString *weChat;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation PersonalSureStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"上传认证资料";
    _addressStr = @"请选择区域";
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //views
    [self initViews];
    
    [self loadData];
    
}
- (void)initViews {
    
    _mainTableView.tableHeaderView = _headView;
    
    _mainTableView.tableFooterView = _footView;
    
    [self initDataArray];
}
- (void)initDataArray {
    self.provinces = [NSArray array];
    self.cities = [NSArray array];
    self.area = [NSArray array];
    self.cityDataList = [NSArray array];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    
    self.cityDataList = jsonObject;
    self.provinces = jsonObject;
    self.cities = self.provinces[0][@"city"];
    self.area = self.cities[0][@"area"];
}

#pragma mark - actions
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitClick:(id)sender {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_identity_card1.length < 1) {
        [self.view showLableViewWithMessage:@"请上传身份证图片"];
    }
    if (_identity_card2.length < 1) {
        [self.view showLableViewWithMessage:@"请上传身份证图片"];
    }
    if (_business_license.length < 1) {
        [self.view showLableViewWithMessage:@"请上传营业执照图片"];
    }
    if (_user_name.length < 1) {
        [self.view showLableViewWithMessage:@"请输入用户名"];
    }
    if (_mobile.length < 1) {
        [self.view showLableViewWithMessage:@"请输入联系方式"];
    }
    if (_province.length < 1) {
        [self.view showLableViewWithMessage:@"请选择地址"];
    }
    if (_city.length < 1) {
        [self.view showLableViewWithMessage:@"请选择地址"];
    }
    if (_areas.length < 1) {
        [self.view showLableViewWithMessage:@"请选择地址"];
    }
    if (_weChat.length < 1) {
        [self.view showLableViewWithMessage:@"请填写微信号"];
    }
    if (_addressTextView.text.length > 0) {
        [paramDic setObject:_addressTextView.text forKey:@"address"];
    }
    [paramDic setObject:_identity_card1 forKey:@"identity_card1"];
    [paramDic setObject:_identity_card2 forKey:@"identity_card2"];
    [paramDic setObject:_business_license forKey:@"business_license"];
    [paramDic setObject:_user_name forKey:@"user_name"];
    [paramDic setObject:_mobile forKey:@"mobile"];
    [paramDic setObject:_province forKey:@"province"];
    [paramDic setObject:_city forKey:@"city"];
    [paramDic setObject:_areas forKey:@"area"];
    [paramDic setObject:_weChat forKey:@"weChat"];
    [HMDataManager requestUrl:@"apiv1/Veryfybuyer/change_veryfy_material" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            SubmitSuccessViewController *submitVC = [[SubmitSuccessViewController alloc]init];
            submitVC.fromWhere = @"1";
            [self.navigationController pushViewController:submitVC animated:YES];
        }
    } failure:^(NSError *error) {

        
    }];
}

- (IBAction)sureClick:(id)sender {
    _selectCityView.hidden = YES;
        NSLog(@"选择名称:%@%@%@",self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"name"],self.cities[[self.selectPickerView selectedRowInComponent:1]][@"name"],self.area[[self.selectPickerView selectedRowInComponent:2]][@"name"]);
    _addressStr = [NSString stringWithFormat:@"%@%@%@",self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"name"],self.cities[[self.selectPickerView selectedRowInComponent:1]][@"name"],self.area[[self.selectPickerView selectedRowInComponent:2]][@"name"]];

    _province = self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"id"];
    _city = self.cities[[self.selectPickerView selectedRowInComponent:1]][@"id"];
    _areas = self.area[[self.selectPickerView selectedRowInComponent:2]][@"name"];
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:2];
    [_mainTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)cancleClick:(id)sender {
    _selectCityView.hidden = YES;
}
//选择照片
- (void)selectPhoto:(NSInteger)index :(NSIndexPath *)indexPath {
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 9
    pickerVc.maxCount = 1;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Recoder Select Assets
    //    pickerVc.selectPickers = self.assets;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        NSMutableArray *images = status.mutableCopy;
        UIImageView *imageView = [[UIImageView alloc]init];
        if ([images[0] isKindOfClass:[ZLPhotoAssets class]]) {
            imageView.image = [images[0] originImage];
        }else{
            imageView.image = images[0];
        }
        if (index == 1) {
            _oneImage = imageView.image;
        }else if (index == 2) {
            _twoImage = imageView.image;
        }else if (index == 3) {
            _threeImage = imageView.image;
        }
        
        NSMutableArray *imageAry = [NSMutableArray array];
        [imageAry addObject:imageView.image];
        [HMDataManager getImageUrl:imageAry progress:^(NSDictionary *progress) {
            
        } success:^(NSArray *result) {
            if (index == 1) {
                _identity_card1 = result[0];
            }else if (index == 2) {
                _business_license = result[0];
            }else if (index == 3) {
                _identity_card2 = result[0];
            }
            
        }];
        [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [pickerVc showPickerVc:self];
    

}
- (void)photoOneClick:(UIButton *)button {
    PersonalSureStateOneTableViewCell *cell = (PersonalSureStateOneTableViewCell *)[[button superview] superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    [self selectPhoto:indexPath.section + 1 :indexPath];
}
- (void)photoTwoClick:(UIButton *)button {
    PersonalSureStateOneTableViewCell *cell = (PersonalSureStateOneTableViewCell *)[[button superview] superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    [self selectPhoto:3 :indexPath];
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 4;
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"姓名",@"微信号",@"联系方式",@"所在地区",@"所在街道"];
    if (indexPath.section == 0 || indexPath.section == 1) {
        PersonalSureStateOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSureStateOneTableViewCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalSureStateOneTableViewCell" owner:self options:nil]firstObject];
        }
        
        if (indexPath.section == 1) {
            cell.twoButton.hidden = YES;
            
            [cell.oneButton setImage:[UIImage imageNamed:@"addzz"] forState:UIControlStateNormal];
        }
        [cell.oneButton addTarget:self action:@selector(photoOneClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.twoButton addTarget:self action:@selector(photoTwoClick:) forControlEvents:UIControlEventTouchUpInside];
        if (  indexPath.section == 0 ) {
            if (_oneImage) {
                [cell.oneButton setImage:_oneImage forState:UIControlStateNormal];
            }
            if (_threeImage) {
                [cell.twoButton setImage:_threeImage forState:UIControlStateNormal];
            }
        }
        if (indexPath.section == 1) {
            if (_twoImage) {
                [cell.oneButton setImage:_twoImage forState:UIControlStateNormal];
            }
        }

        return cell;
    }
    
    if (indexPath.section == 2 && indexPath.row == 3) {
        OneselfSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneselfSelectTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OneselfSelectTableViewCell" owner:self options:nil]firstObject];
        }
        cell.titleLabel.text = @"所在地区";
        cell.contenLabel.text = _addressStr;
        return cell;
    }
    
    PersonalSureStateTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSureStateTwoTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalSureStateTwoTableViewCell" owner:self options:nil]firstObject];
    }
    
    cell.titleLabel.text = titles[indexPath.row];
    if (indexPath.row < 3||indexPath.row == 4) {
        cell.inputTextField.placeholder = [NSString stringWithFormat:@"请输入%@",titles[indexPath.row]];
        
    }

    if (_dataDic) {
        
        if (indexPath.row == 0) {
            
            cell.inputTextField.text = _user_name;
        }else if (indexPath.row == 1){
        
            cell.inputTextField.text = _weChat;

        }else if (indexPath.row == 2){
            
            cell.inputTextField.text = _mobile;

        }

    }
    
    cell.inputTextField.tag = indexPath.row + 100;
    
    [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        return 108;
    }
    
    if (indexPath.section == 2 && indexPath.row == 4) {

        return 0;
    }
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
    UILabel *headTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, 200, 12)];
    headTitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    headTitleLabel.font = [UIFont systemFontOfSize:12];
    
    if (section == 0) {
        headTitleLabel.text = @"请上传身份证正反面";
    }else if (section == 1) {
        headTitleLabel.text = @"上传营业执照照片";
    }   else if (section == 2){
        headTitleLabel.text = @"其他信息";
    }
    [view addSubview:headTitleLabel];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 3) {
        _selectCityView.hidden = NO;
        
        for (int i = 0; i < 4; i ++) {
            
            UITextField *textField = [tableView viewWithTag:100 + i];
            
            [textField resignFirstResponder];
        }

        [_addressTextView resignFirstResponder];
                
    }
}


#pragma mark - pcikerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows = self.provinces.count;
            break;
        case 1:
            rows = self.cities.count;
            break;
        case 2:
            rows = self.area.count;
            break;
        default:
            break;
    }
    return rows;
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.provinces[row][@"name"];
            break;
        case 1:
            title = self.cities[row][@"name"];
            break;
        case 2:
            title = self.area[row][@"name"];
            break;
        default:
            break;
    }
    return title;
}

//选中时回调的委托方法，在此方法中实现省份和城市间的联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0://选中省份表盘时，根据row的值改变城市数组，刷新城市数组，实现联动
            self.cities = self.provinces[row][@"city"];
            self.area = self.cities[0][@"area"];
            [self.selectPickerView reloadComponent:1];
            [self.selectPickerView reloadComponent:2];
            break;
        case 1:
            self.area = self.cities[row][@"area"];
            [self.selectPickerView reloadComponent:2];
            break;
        case 2:
        default:
            break;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger row = textField.tag - 100;
    if (row == 0) {
        //姓名
        _user_name = textField.text;
        
    }else if (row == 1) {
        //微信号
        _weChat = textField.text;
    }else if (row == 2) {
        //联系方式
        _mobile = textField.text;
    }else if (row == 4) {
        //所在街道
        _areas = textField.text;
    }
    
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _noticeLabel.hidden = YES;
    }else{
        _noticeLabel.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
}

////获取认证资料
- (void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_veryfy_material params:params HidHUD:YES success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            _dataDic = result[@"result"][@"data"];
            
            if (_dataDic) {
                
                
                _identity_card1 = _dataDic[@"identity_card1"];
                
                _identity_card2 = _dataDic[@"identity_card2"];
                
                _business_license = _dataDic[@"business_license"];
                
                _user_name = _dataDic[@"user_name"];
                
                _mobile = _dataDic[@"mobile"];
                
                _province = _dataDic[@"province"];
                
                _city = _dataDic[@"city"];
                
                _areas = _dataDic[@"area"];
                
                _weChat = _dataDic[@"weChat"];
                
                _addressStr = [NSString stringWithFormat:@"%@%@%@",_dataDic[@"province_name"],_dataDic[@"city_name"],_dataDic[@"area_name"]];
                
                
                _addressTextView.text = _dataDic[@"address"];
                
                [_mainTableView reloadData];
                
                
                NSArray *urlStr = @[_dataDic[@"identity_card1_url"],_dataDic[@"identity_card2_url"],_dataDic[@"business_license_url"]];
                
                
                for (int i = 0; i < 3; i++) {
                    
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlStr[i]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        NSLog(@"");
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                        
                        if (image) {
                            
                            if (i == 0) {
                                
                                _oneImage = image;
                                
                            }else if (i == 1){
                                
                                _threeImage = image;
                                
                            }else if (i == 2){
                                
                                _twoImage = image;
                                
                            }
                            
                            [_mainTableView reloadData];
                            
                        }
                        
                    }];
                    
                    
            }
            }
            
            
        }
        
    } failure:nil];
    
}



@end
