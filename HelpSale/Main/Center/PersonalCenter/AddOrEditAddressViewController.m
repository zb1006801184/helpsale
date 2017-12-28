//
//  AddOrEditAddressViewController.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AddOrEditAddressViewController.h"
#import <UIViewController+MMDrawerController.h>


@interface AddOrEditAddressViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *selectCityView;
@property (weak, nonatomic) IBOutlet UIPickerView *selectPickerView;
@property (nonatomic,strong)NSArray * provinces;//展示省份
@property (nonatomic,strong)NSArray * cities;//展示城市
@property (nonatomic,strong)NSArray *area ;//展示区域
@property (nonatomic,strong)NSArray *cityDataList;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UILabel *noticeMessageLabel;

@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *areas;

@end

@implementation AddOrEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //views
    
    if (_model1) {
        
        _province = _model1.province_id;
        
        _city = _model1.city_id;
        
        _areas = _model1.area_id;
        
        _addressTextView.text = _model1.address;
        
        _userNameTextField.text = _model1.user_name;
        
        _phoneTextField.text = _model1.mobile;
        
        _addressStr = [NSString stringWithFormat:@"%@%@%@",_model1.province,_model1.city,_model1.area];
        _areaLabel.text = _addressStr;
        
        if (_addressTextView.text.length > 0) {
            _noticeMessageLabel.hidden = YES;
        }else{
            _noticeMessageLabel.hidden = NO;
        }
        
    }
    
    
    self.title = @"新增地址";
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
#pragma mark - Net
- (void)getDataNet {

    if (_isAddress) {
        
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:_province forKey:@"province_id"];
        [paramDic setObject:_city forKey:@"city_id"];
        [paramDic setObject:_areas forKey:@"area_id"];
        [paramDic setObject:_addressTextView.text forKey:@"address"];
        [paramDic setObject:_phoneTextField.text forKey:@"mobile"];
        [paramDic setObject:_userNameTextField.text forKey:@"user_name"];
        
        NSString *url = @"";
        
        if (_model1) {
            
            [paramDic setObject:_model1.id forKey:@"id"];

            url = edit_address_API;

        }else{
        
            url = add_address_API;

        }

        [HMDataManager requestUrl:url params:paramDic HidHUD:NO success:^(id result) {
            BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
            if ([model.code integerValue] == 1) {
                if (self.updateAddressBlock) {
                    self.updateAddressBlock();
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            
        }];

    }else{

        
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:_province forKey:@"province_id"];
    [paramDic setObject:_city forKey:@"city_id"];
    [paramDic setObject:_areas forKey:@"area_id"];
    [paramDic setObject:_addressStr forKey:@"address"];
    [paramDic setObject:_phoneTextField.text forKey:@"mobile"];
    [paramDic setObject:_userNameTextField.text forKey:@"user_name"];
    [paramDic setObject:_model.id forKey:@"id"];
    [HMDataManager requestUrl:@"sellerv1/Order/edit_order" params:paramDic HidHUD:NO success:^(id result) {
        BaseModel *model = [[BaseModel alloc]initWithDic:result[@"result"]];
        if ([model.code integerValue] == 1) {
            if (self.updateAddressBlock) {
                self.updateAddressBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
        
    }
}
#pragma mark - actions

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)preserveClick:(id)sender {
    [self getDataNet];
}
- (IBAction)cancleClick:(id)sender {
    _selectCityView.hidden = YES;
}
- (IBAction)sureClick:(id)sender {
    _selectCityView.hidden = YES;
    _addressStr = [NSString stringWithFormat:@"%@%@%@",self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"name"],self.cities[[self.selectPickerView selectedRowInComponent:1]][@"name"],self.area[[self.selectPickerView selectedRowInComponent:2]][@"name"]];
    _areaLabel.text = _addressStr;
    _province = self.provinces[[self.selectPickerView selectedRowInComponent:0]][@"id"];
    _city = self.cities[[self.selectPickerView selectedRowInComponent:1]][@"id"];
    _areas = self.area[[self.selectPickerView selectedRowInComponent:2]][@"id"];

}


- (IBAction)selectAddressClick:(id)sender {
    _selectCityView.hidden = NO;
    
    [_userNameTextField resignFirstResponder];
    
    [_phoneTextField resignFirstResponder];

    [_addressTextView resignFirstResponder];
    
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


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;

    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _noticeMessageLabel.hidden = YES;
    }else{
        _noticeMessageLabel.hidden = NO;
    }
}

@end
