//
//  UserDetaiModel.m
//  HM
//
//  Created by Air on 2017/2/13.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import "UserDetaiModel.h"

@implementation UserDetaiModel
-(id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {

        [RMMapper populateObject:self fromDictionary:dic];
    }
    return self;
}


@end
