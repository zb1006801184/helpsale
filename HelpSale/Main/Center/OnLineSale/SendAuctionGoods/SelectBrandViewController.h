//
//  SelectBrandViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/28.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBrandViewController : UIViewController


//分类名称
@property (nonatomic, copy)NSString *category_name;
//分类ID
@property (nonatomic, copy)NSString *category_id;
//来自上传
@property (nonatomic, copy)NSString *fromSubmit;
//来自哪里
@property (nonatomic, copy)NSString *fromWhere;


@end
