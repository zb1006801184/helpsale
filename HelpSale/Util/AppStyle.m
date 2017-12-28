//
//  AppStyle.m
//  HelpSale
//
//  Created by 朱标 on 2017/8/16.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "AppStyle.h"
#import "UIColor+RGBHelper.h"
@implementation AppStyle

+ (UIColor *)colorForNavBackground {
    
    return [UIColor colorWithHexString:@"#050634"];
    
}

+ (UIColor *)colorForDefault {
    return [UIColor colorWithHexString:@"#C79D65"];
}

+ (UIColor *)colorForCrucial {
    return [UIColor colorWithHexString:@"#FE5B62"];
}

+ (UIColor *)colorForDefaultBackground {
    return [UIColor colorWithHexString:@"#F5F6FA"];
}
@end
