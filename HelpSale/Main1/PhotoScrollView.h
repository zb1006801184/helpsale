//
//  PhotoScrollView.h
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIScrollView<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIImageView *photoImageView;
}

@property(nonatomic,copy)NSString *imageUrl;

@property (nonatomic,strong) UIImage *image;


@property (nonatomic,strong) UIImage *thumbnailImage;
@end
