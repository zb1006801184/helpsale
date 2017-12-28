//
//  CenterTextuerViewController.h
//  HM
//
//  Created by Air on 2017/5/23.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CenterTextuerViewController : BaseViewController
@property (nonatomic, strong) NSString *attribute_id;
@property(nonatomic, copy) void(^GetAttribeTextureBlock)(NSString *name,NSString *nameId,NSString *parentId);
//已经选中的id
@property (nonatomic, strong) NSString *selectId;

@property (nonatomic, assign) BOOL isHot;


@end
