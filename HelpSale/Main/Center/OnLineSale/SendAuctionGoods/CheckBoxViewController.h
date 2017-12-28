//
//  CheckBoxViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/31.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxViewController : UIViewController
@property (nonatomic, strong) NSString *attribute_id;
@property(nonatomic, copy) void(^GetAttribeBlock)(NSString *name,NSString *nameId,NSString *parentId);
//已经选中的id
@property (nonatomic, strong) NSString *selectId;
@property (nonatomic, strong) NSString *titleStr;
@end
