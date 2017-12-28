//
//  NetcaseStyleHeaderView.m
//  SZBBS
//
//  Created by AngusChen on 16/3/9.
//  Copyright © 2016年 Seentao Technology CO.,LTD. All rights reserved.
//

#import "NetcaseStyleHeaderView.h"
#import "UIColor+RGBHelper.h"
//#import "UIViewAdditions.h"
//#import "STTInfoType.h"
#define Width  [UIScreen mainScreen].bounds.size.width


@implementation NetcaseStyleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureView];
    }
    
    return self;
}

- (void)configureView {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
//    self.layer.borderWidth = 1.f;
//    self.layer.borderColor = [UIColor colorIntegerWithRed:238 green:238 blue:238].CGColor;
}

- (void)setTitles:(NSArray *)titles {
    if (_titles != titles) {
        _titles = titles;
        [self layoutTitleLabels];
    }
}

- (void)layoutTitleLabels {
    CGFloat width = 0.f;
    
    for (int i = 0; i < _titles.count; i++) {
        STTScaleTitleLabel *label = [STTScaleTitleLabel new];
        //最大字体
        UIFont *labelFont = [UIFont systemFontOfSize:14.f];
        label.font = labelFont;
        label.text = _titles[i];
        label.backgroundColor = [UIColor clearColor];
        label.defaultColor = [UIColor colorIntegerWithRed:204 green:204 blue:204 alpha:1.f];
        label.highlightColor = [UIColor colorIntegerWithRed:245 green:180 blue:147 alpha:1.f];
        [self addSubview:label];
//        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:labelFont}];
//        label.width = size.width + 20;
        label.width = Width/4;
        label.height = self.height;
        label.left = width;
        width += label.width;
        label.tag = i;
        
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(labelClick:)]];
    }
    
    self.contentSize = CGSizeMake(width, self.height);
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer {

    STTScaleTitleLabel *label = (STTScaleTitleLabel *)recognizer.view;
    
    if (self.didSelectedIndex) {
        self.didSelectedIndex(label.tag);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (STTScaleTitleLabel *label in self.subviews) {
        label.scale = 0.f;
    }
    
    STTScaleTitleLabel *label = self.subviews[selectedIndex];
    label.scale = 1.f;
}


@end

@implementation NetcaseStyleHeaderView (STTInfoType)
//
-(void)GetTitlesArray:(NSArray*)titles
{
    self.titles = titles;
}
@end
