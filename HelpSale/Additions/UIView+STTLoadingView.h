//
//  UIView+STTLoadingView.h
//  SZBBS
//
//  Created by 朱标 on 16/8/24.
//  Copyright © 2016年 Seentao Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STTLoadingView)
//用MBProgressHUD 实现的加载提示框的分类
/**
 * message 可以 为 空
 */
-(void)showLoadingViewWithMessage:(NSString*)message;

/**
 * message 为空，会 马上 消失
 message 不为空，会 先显示 文字，延迟 消失
 */
-(void)stopLoadingViewWithMessage:(NSString*)message;

/*
 * 显示提示信息（无加载提示框，只显示提示信息）
 */
- (void)showLableViewWithMessage:(NSString *)message;


//自定义动画
-(void)showLoadingAnimation;

//显示提示信息(多行)
- (void)showLabelNumbelWhithMessage:(NSString *)mssage;

//透明加载
- (void)showLoadingTransparentBackgroundWhitMessage:(NSString *)message;

@end
