//
//  AuctionGoodsDetailViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionGoodsDetailViewController : UIViewController

//单选

//多选

//输入框

//属性框
@property (nonatomic, strong)NSMutableDictionary *attribute_list_idDic;
@property (nonatomic, strong)NSMutableDictionary *attribute_list_nameDic;


//分类
@property (nonatomic, copy)NSString *category_name;
@property (nonatomic, copy)NSString *category_id;

@property (nonatomic, copy)NSString *category1_id;

//品牌
@property (nonatomic, copy)NSString *brand_name;
@property (nonatomic, copy)NSString *brand_id;
//系列
@property (nonatomic, copy)NSString *series_name;
@property (nonatomic, copy)NSString *series_id;


//重新选择分类的回调
@property (nonatomic, copy) void(^GetCategoryBlock)(NSString *category_name,NSString *category_id,NSString *brand_name,NSString *brand_id);


@end
