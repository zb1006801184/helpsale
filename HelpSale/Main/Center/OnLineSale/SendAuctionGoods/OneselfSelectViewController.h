//
//  OneselfSelectViewController.h
//  HelpSale
//
//  Created by 朱标 on 2017/8/31.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneselfSelectViewController : UIViewController
@property (nonatomic, copy) NSString *parent_name;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) void(^GetNameBlock)(NSString *name,NSString *nameid,NSString *parentId);
@end
