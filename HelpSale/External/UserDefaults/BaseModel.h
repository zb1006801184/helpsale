//
//  BaseModel.h
//  HM
//
//  Created by Air on 2017/2/13.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import "Jastor.h"
#import "RMMapper.h"
@interface BaseModel : Jastor
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * error_msg;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *error_no;
@property (nonatomic, copy) NSString *code;


-(id)initWithDic:(NSDictionary *)dic;


@end
