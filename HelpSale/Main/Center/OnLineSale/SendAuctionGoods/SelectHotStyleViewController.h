//
//  SelectHotStyleViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/25.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHotStyleViewController : UIViewController
@property (nonatomic, copy)NSString *titleStr;
//来自哪里
@property (nonatomic, copy)NSString *fromWhere;
//来自上传
@property (nonatomic, copy)NSString *fromSubmit;

//分类名称
@property (nonatomic, copy)NSString *category_name;
//分类ID
@property (nonatomic, copy)NSString *category_id;
//品牌名称
@property (nonatomic, copy)NSString *brand_name;
//品牌ID
@property (nonatomic, copy)NSString *brand_id;


@end
