//
//  ScanCell.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "ScanCell.h"
@implementation ScanCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        
        [self creatScorllView];
        
        self.backgroundColor = [UIColor blackColor];
        
    }
    
    return self;
    
}

-(void)setImageURL:(NSString *)imageURL{
    
    _imageURL=imageURL;
    
//    3.把一个图片数据传到_scrollView中
    
    _scrollView.imageUrl=_imageURL;

}

- (void)setImage:(UIImage *)image{

    _image = image;

    _scrollView.image = _image;
}

-(void)creatScorllView{
    
    _scrollView=[[PhotoScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width-40, self.height)];
    
    [self.contentView addSubview:_scrollView];

    
}

@end
