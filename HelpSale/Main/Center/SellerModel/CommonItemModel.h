//
//  CommonItemModel.h
//  ZYSideSlipFilter
//
//  Created by lzy on 16/10/16.
//  Copyright © 2016年 zhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonItemModel : BaseModel
@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *itemName;
@property (copy, nonatomic) NSString *category_name;
@property (copy, nonatomic) NSString *brand_name_title;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *brand_name;
@property (copy, nonatomic) NSString *parent_name;
@property (copy, nonatomic) NSString *brand_name_alpha;
@property (copy, nonatomic) NSString *logo;
@property (nonatomic, strong) NSString *cateId;

@property (nonatomic, strong) NSString *isSend;
@property (nonatomic, assign) int category_id;

@property (assign, nonatomic) int id;

@property (assign, nonatomic) BOOL selected;

@property (nonatomic, assign) BOOL isRemoveSelect;

@property (nonatomic, assign) BOOL typeBool;
@end
