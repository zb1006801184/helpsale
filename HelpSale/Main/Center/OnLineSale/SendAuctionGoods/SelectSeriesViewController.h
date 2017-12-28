//
//  SelectSeriesViewController.h
//  HelpSale
//
//  Created by CYT on 2017/10/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectSeriesViewController : BaseViewController

//分类名称
@property (nonatomic, copy)NSString *category_name;
//分类ID
@property (nonatomic, copy)NSString *category_id;

//来自哪里
@property (nonatomic, copy)NSString *fromWhere;

@property (nonatomic, copy)NSString *fromSubmit;

//品牌名称
@property (nonatomic, copy)NSString *brand_name;
//品牌ID
@property (nonatomic, copy)NSString *brand_id;





@end
