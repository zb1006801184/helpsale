//
//  STTScaleTitleLabel.m
//  SZBBS
//
//  Created by AngusChen on 16/2/22.
//  Copyright © 2016年 Seentao Technology CO.,LTD. All rights reserved.
//

#import "STTScaleTitleLabel.h"

@implementation STTScaleTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self defaultConfigs];
    }
    
    return self;
}

- (void)defaultConfigs {
    self.textAlignment = NSTextAlignmentCenter;
    self.scale = 0.0f;
    self.defaultColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
    self.highlightColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1.f];
}

- (void)setScale:(CGFloat)scale animated:(BOOL)animated{
    _scale = scale;
    NSTimeInterval duration = 0;

    if (animated) {
        duration = .3;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:_scale];
                         CGFloat minScale = 0.8;
                         CGFloat trueScale = minScale + (1-minScale)*scale;
                         self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
                     }];
    
    
}

- (void)setDefaultColor:(UIColor *)defaultColor {
    if (_defaultColor != defaultColor) {
        _defaultColor = defaultColor;
        self.textColor = _defaultColor;
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    const CGFloat *defaultComponents = CGColorGetComponents(self.defaultColor.CGColor);
    const CGFloat *highlightComponents = CGColorGetComponents(self.highlightColor.CGColor);
    
    NSInteger numComponents = CGColorGetNumberOfComponents(self.defaultColor.CGColor);
    
    if (numComponents == 4) {
        self.textColor = [UIColor colorWithRed:(defaultComponents[0] + (highlightComponents[0] - defaultComponents[0]) * scale)
                                         green:(defaultComponents[1] + (highlightComponents[1] - defaultComponents[1]) * scale)
                                          blue:(defaultComponents[2] + (highlightComponents[2] - defaultComponents[2]) * scale)
                                         alpha:(CGColorGetAlpha(self.defaultColor.CGColor) + (CGColorGetAlpha(self.highlightColor.CGColor)- CGColorGetAlpha(self.defaultColor.CGColor)) * scale)];
    }
    //字体最小 TODO(以后滑动改变字体改最小体)
    CGFloat minScale = 1;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
