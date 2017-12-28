//
//  SelectChildAttributesViewController.h
//  HelpSale
//
//  Created by CYT on 2017/10/18.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectChildAttributesViewController : BaseViewController

typedef void (^BackBlock)(NSString *category_name,NSString *category_id);

@property (nonatomic,copy) BackBlock backBlock;



//分类名称
//@property (nonatomic, copy)NSString *category_name;
//分类ID
@property (nonatomic, copy)NSString *category_id;

//来自哪里
@property (nonatomic, copy)NSString *fromWhere;



@end
