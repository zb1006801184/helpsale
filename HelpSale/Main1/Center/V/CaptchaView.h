//
//  CaptchaView.h
//  HelpSale
//
//  Created by CYT on 2017/9/4.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptchaView : UIView

@property (nonatomic, retain) NSArray *changeArray; //字符素材数组
@property (nonatomic, retain) NSMutableString *changeString;  //验证码的字符串

@end
