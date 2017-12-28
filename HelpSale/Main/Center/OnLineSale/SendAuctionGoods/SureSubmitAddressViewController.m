//
//  SureSubmitAddressViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/9/1.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "SureSubmitAddressViewController.h"
#import "SubmitSuccessViewController.h"
#import "AdressModel.h"
@interface SureSubmitAddressViewController ()

@property (weak, nonatomic) IBOutlet UIView *selectCityView;
@property (weak, nonatomic) IBOutlet UIPickerView *selectPickerView;
@property (nonatomic,strong)NSArray * provinces;//展示省份
@property (nonatomic,strong)NSArray * cities;//展示城市
@property (nonatomic,strong)NSArray *areas;//展示区域
@property (nonatomic,strong)NSArray *cityDataList;
@property (weak, nonatomic) IBOutlet UILabel *noticeMessageLabel;

@property (nonatomic, copy) NSString *addressStr;


@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UITextView *moreTextView;


@property (nonatomic, strong) NSString *recovery_type;

@property (nonatomic, strong) NSString *is_safe;
@property (nonatomic, strong) NSString *delivery_pay;

@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *province_id;
@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *mobile;

@property (weak, nonatomic) IBOutlet UIButton *expressButton;

@property (weak, nonatomic) IBOutlet UIButton *takeButton;

@property (weak, nonatomic) IBOutlet UIButton *insureButton;

@property (weak, nonatomic) IBOutlet UIButton *toPay;


@end

@implementation SureSubmitAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"信息确认";
    
    [self initDataArray];
    
    [self loadData];
    
}

- (void)initDataArray {
    self.provinces = [NSArray array];
    self.cities = [NSArray array];
    self.areas = [NSArray array];
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
    self.areas = self.cities[0][@"area"];
}


#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)overlookClick:(id)sender {
    [self submitClick];
}
- (IBAction)sureClick:(id)sender {
    [self submitClick];
}
//取回方式
- (IBAction)expressClick:(id)sender {
    _recovery_type = @"1";
    _expressButton.selected = YES;
    _takeButton.selected = NO;
}
- (IBAction)takeClick:(id)sender {
    _recovery_type = @"2";
    _expressButton.selected = NO;
    _takeButton.selected = YES;
}
- (IBAction)insureClick:(id)sender {
    _is_safe = @"1";
    _delivery_pay = @"2";
    _insureButton.selected = YES;
    _toPay.selected = NO;
}
- (IBAction)payClick:(id)sender {
    _is_safe = @"2";
    _delivery_pay = @"1";
    _insureButton.selected = NO;
    _toPay.selected = YES;
}


- (IBAction)cancleClick:(id)sender {
    _selectCityView.hidden = YES;
}

- (IBAction)sureClick1:(id)sender {
    _selectCityView.hidden = YES;
    _addressStr = [NSString stringWithFormat:@"%@%@%@",self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"name"],self.cities[[self.selectPickerView selectedRowInComponent:1]][@"name"],self.areas[[self.selectPickerView selectedRowInComponent:2]][@"name"]];
    _addressLabel.text = _addressStr;
    
    _province = self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"name"];
    _city = self.cities[[self.selectPickerView selectedRowInComponent:1]][@"name"];
    _area = self.areas[[self.selectPickerView selectedRowInComponent:2]][@"name"];
    
    _province_id = self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"id"];
    _city_id = self.cities[[self.selectPickerView selectedRowInComponent:1]][@"id"];
    _area_id = self.areas[[self.selectPickerView selectedRowInComponent:2]][@"id"];
    
}

- (IBAction)selectAddressClick:(id)sender {
    _selectCityView.hidden = NO;
    
    [_nameLabel resignFirstResponder];
    
    [_phoneTextField resignFirstResponder];
    
    [_moreTextView resignFirstResponder];
    
}


#pragma mark - Net 

- (void)submitClick {
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/goodsJson.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    NSArray *goods_list = [NSArray array];
    if (data) {
        id responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的数据（字典）
        goods_list = responseDic;
    }

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (_recovery_type.length > 0) {
        [paramDic setObject:_recovery_type forKey:@"recovery_type"];
    }
    if (_is_safe.length > 0) {
        [paramDic setObject:_is_safe forKey:@"is_safe"];
    }
    if (_delivery_pay.length > 0) {
        [paramDic setObject:_delivery_pay forKey:@"delivery_pay"];
    }
    if (_nameLabel.text.length > 0) {
        [paramDic setObject:_nameLabel.text forKey:@"user_name"];
    }
    if (_province.length > 0) {
        [paramDic setObject:_province forKey:@"province"];
    }
    if (_city.length > 0) {
        [paramDic setObject:_city forKey:@"city"];
    }
    if (_area.length > 0) {
        [paramDic setObject:_area forKey:@"area"];
    }
    if (_province_id.length > 0) {
        [paramDic setObject:_province_id forKey:@"province_id"];
    }
    if (_city_id.length > 0) {
        [paramDic setObject:_city_id forKey:@"city_id"];
    }
    if (_area_id.length > 0) {
        [paramDic setObject:_area_id forKey:@"area_id"];
    }
    if (_address.length > 0) {
        [paramDic setObject:_address forKey:@"address"];
    }

    if (_mobile.length > 0) {
        [paramDic setObject:_mobile forKey:@"mobile"];
    }
    NSMutableDictionary *goods_listDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < goods_list.count ; i++) {
        [goods_listDic setObject:goods_list[i] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    [paramDic setObject:goods_listDic forKey:@"goods_list"];

    
    if (_bank_name.length > 0) {
        [paramDic setObject:_bank_name forKey:@"bank_name"];
    }
    if (_account.length > 0) {
        [paramDic setObject:_account forKey:@"account"];
    }
    if (_account_name.length > 0) {
        [paramDic setObject:_account_name forKey:@"account_name"];
    }

    [HMDataManager requestUrl:@"sellerv1/Goods/add_goods" params:paramDic HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            SubmitSuccessViewController *submitVC = [[SubmitSuccessViewController alloc]init];
            [self.navigationController pushViewController:submitVC animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

//获取默认地址数据
- (void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HMDataManager requestUrl:get_default_address params:params HidHUD:NO success:^(id result) {
        
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        
        if ([model.code intValue] == 1) {
            
            
            if ([result[@"result"][@"data"][@"item"] isKindOfClass:NSDictionary.class]) {
                
                AdressModel *model = [[AdressModel alloc]initWithDic:result[@"result"][@"data"][@"item"]];
                
                _province_id = model.province_id;
                
                _city_id = model.city_id;
                
                _area_id = model.area_id;
                
                _moreTextView.text = model.address;
                
                _nameLabel.text = model.user_name;
                
                _phoneTextField.text = model.mobile;
                
                _addressStr = [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.area];
                _addressLabel.text = _addressStr;
                
                if (_moreTextView.text.length > 0) {
                    _noticeMessageLabel.hidden = YES;
                }else{
                    _noticeMessageLabel.hidden = NO;
                }
                
            }
            
            
        }
        
    } failure:nil];
    
    
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
            rows = self.areas.count;
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
            title = self.areas[row][@"name"];
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

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _noticeMessageLabel.hidden = YES;
    }else{
        _noticeMessageLabel.hidden = NO;
    }
}






@end
