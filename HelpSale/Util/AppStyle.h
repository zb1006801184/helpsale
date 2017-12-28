//
//  AppStyle.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 定义项目的主题颜色
 */
@interface AppStyle : NSObject

//导航栏颜色
+ (UIColor *)colorForNavBackground;
//主色 价格、按钮等
+ (UIColor *)colorForDefault;
//部分关键字颜色 提醒消息等
+ (UIColor *)colorForCrucial;
//大部分页面背景色
+ (UIColor *)colorForDefaultBackground;

@end
