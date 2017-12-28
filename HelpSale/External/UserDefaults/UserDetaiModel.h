//
//  UserDetaiModel.h
//  HM
//
//  Created by Air on 2017/2/13.
//  Copyright © 2017年 zhubiao. All rights reserved.
//

#import "BaseModel.h"

@interface UserDetaiModel : BaseModel

@property (nonatomic, retain) NSString * password;//密码
@property (nonatomic, retain) NSString * iphoneNumber;//手机号
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, retain) NSString * nick_name;//昵称
@property (nonatomic, retain) NSString * openid;//微信openid
@property (nonatomic, retain) NSString * unionid;//微信unionid
@property (nonatomic, retain) NSString * head_img;//头像
@property (nonatomic, retain) NSString * head_img_url;//头像
@property (nonatomic, retain) NSString * parent_id;//邀请人id
@property (nonatomic, retain) NSString * add_time;//用户注册时间
@property (nonatomic, strong) NSString * sex; //性别
@property (nonatomic, strong) NSString * integral_total; //积分总额
@property (nonatomic, strong) NSString * integral_left; //积分余额
@property (nonatomic, strong) NSString * used_code; //激活时所用的邀请码
@property (nonatomic, strong) NSString * country; //激活时所用的邀请码
@property (nonatomic, strong) NSString * token; //
@property (nonatomic, strong) NSString * province; //
@property (nonatomic, strong) NSString * city; //
@property (nonatomic, strong) NSString * area; //
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString *is_buyer_veryfy;

@property (nonatomic, assign) int  id;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString * userid;
@property (nonatomic, strong) NSString * user_number;

@property (nonatomic, strong) NSString * privence;
@property (nonatomic, assign)  int level;
@property (nonatomic, strong) NSString *huanxin_userid;
@property (nonatomic, strong) NSString *huanxin_username;
@property (nonatomic, strong) NSString *my_friends_number;
@property (nonatomic, strong) NSString *my_goods_users_number;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) int is_complete;
@property (nonatomic, assign) int if_my_friend;

@property (nonatomic, assign) int my_friends_variable;
@property (nonatomic, assign) int my_friends_left;
@property (nonatomic, assign) int my_question_answer_number;


@end
