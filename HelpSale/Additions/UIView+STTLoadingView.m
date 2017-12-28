//
//  UIView+STTLoadingView.m
//  SZBBS
//
//  Created by 朱标 on 16/8/24.
//  Copyright © 2016年 Seentao Technology CO.,LTD. All rights reserved.
//
#import "UIView+STTLoadingView.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>
static const void *STTHttpRequestHUDKey = @"STTHttpRequestHUDKey";

@interface UIView ()
@property(nonatomic,strong)MBProgressHUD *progressHUD;
@end
@implementation UIView (STTLoadingView)
// 设置 属性的 Getter方法，利用Runtime 来添加这个属性
-(MBProgressHUD *)progressHUD
{
    MBProgressHUD *HUD = objc_getAssociatedObject(self, &STTHttpRequestHUDKey);
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        objc_setAssociatedObject(self, &STTHttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return HUD;
}
// 然后 就是 出现动画 和 隐藏动画了
-(void)showLoadingViewWithMessage:(NSString*)message
{
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    //是提示框背景透明(个人感觉视觉体验更好)
//    self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    self.progressHUD.bezelView.color = [[UIColor clearColor] colorWithAlphaComponent:0];
    
    if (message) {
        self.progressHUD.labelText = message;
    }else
    {
        self.progressHUD.labelText = @"";
    }
    
    [self.progressHUD show:YES];
}

-(void)stopLoadingViewWithMessage:(NSString*)message
{
    if (message.length)
    {
        self.progressHUD.labelText = message;
        [self.progressHUD hide:YES afterDelay:1];
    }
    else
    {
        [self.progressHUD hide:YES];
    }
}

- (void)showLoadingTransparentBackgroundWhitMessage:(NSString *)message {
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    //是提示框背景透明(个人感觉视觉体验更好)
        self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.progressHUD.bezelView.color = [[UIColor clearColor] colorWithAlphaComponent:0];
    
    if (message) {
        self.progressHUD.labelText = message;
    }else
    {
        self.progressHUD.labelText = @"";
    }
    
    [self.progressHUD show:YES];

}

- (void)showLableViewWithMessage:(NSString *)message
{
    [self.progressHUD show:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = message;
//    self.progressHUD.detailsLabelText = message;
    [self.progressHUD hide:YES afterDelay:2];
}

- (void)showLabelNumbelWhithMessage:(NSString *)mssage
{
    [self.progressHUD show:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
//   self.progressHUD.labelText = message;
    self.progressHUD.detailsLabelText = mssage;
    [self.progressHUD hide:YES afterDelay:2];

}

-(void)showLoadingAnimation
{
    UIView * hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    hudView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(-20, -20, 40, 40)];
    
    imageV1.image = [UIImage imageNamed:@"Combined Shape"];
    
    [hudView addSubview:imageV1];
    
    UIImageView *imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(-11.5, - 11.5, 23, 23)];
    
    imageV2.image = [UIImage imageNamed:@"2ddd"];
    
    [hudView addSubview:imageV2];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = HUGE_VALF;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.25 :.1 :.25 :1];
    
    [imageV1.layer addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation1 =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation1.fromValue = [NSNumber numberWithFloat:M_PI *2];
    animation1.toValue =  [NSNumber numberWithFloat:0.f];
    animation1.duration  = 1;
    animation1.autoreverses = NO;
    animation1.fillMode =kCAFillModeForwards;
    animation1.repeatCount = HUGE_VALF;
    animation1.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.42 :0 :.5 :.94];
    
    [imageV2.layer addAnimation:animation1 forKey:nil];
    [self.progressHUD show:YES];
    self.progressHUD.labelText = @"";
    self.progressHUD.backgroundColor = [UIColor clearColor];
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.customView = hudView;

    self.progressHUD.color = [UIColor whiteColor];
    
//    self.progressHUD.color = [self.progressHUD.color colorWithAlphaComponent:0];
}


@end
