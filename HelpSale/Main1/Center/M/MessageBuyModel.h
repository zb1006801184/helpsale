//
//  MessageBuyModel.h
//  HelpSale
//
//  Created by CYT on 2017/9/7.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseModel.h"

@interface MessageBuyModel : BaseModel


@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *from_user_id;
@property (nonatomic, copy) NSString *to_user_id;
@property (nonatomic, copy) NSString *is_all;
@property (nonatomic, copy) NSString *cover_img;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *object_id;
@property (nonatomic, copy) NSString *result_code;
@property (nonatomic, copy) NSString *cover_img_url;
@property (nonatomic, copy) NSString *is_read;


@end
