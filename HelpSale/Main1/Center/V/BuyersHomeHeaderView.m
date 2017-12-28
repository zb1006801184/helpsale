//
//  BuyersHomeHeaderView.m
//  HelpSale
//
//  Created by CYT on 2017/8/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BuyersHomeHeaderView.h"
#import "CategoryBuyViewController.h"
#import "UIView+Controller.h"
#import "UIButton+WebCache.h"




@implementation BuyersHomeHeaderView



- (void)setCategoryArr:(NSArray *)categoryArr {

    _categoryArr = categoryArr;
    
    for (int i = 0; i < _categoryArr.count; i++) {
        
        CategoryBuyModel *model = _categoryArr[i];
        
        UIButton *button = [self viewWithTag:100 + i];
        
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal];
        
    }

}

- (void)setTime:(NSInteger)time{

    _time = time;
    
    if (_time != 0) {

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
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



- (IBAction)phoneAction:(id)sender {
    
    NSString *allString = [NSString stringWithFormat:@"tel:400-7755-059"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    
}

- (IBAction)selectCategoryAction:(UIButton *)sender {
        
    
    CategoryBuyViewController *categoryBuyVC = [[CategoryBuyViewController alloc]init];
    
    categoryBuyVC.model = _categoryArr[sender.tag - 100];
    
    [self.viewController.navigationController pushViewController:categoryBuyVC animated:YES];
    
}
@end
