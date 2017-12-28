//
//  OfferBuyView.h
//  HelpSale
//
//  Created by CYT on 2017/8/20.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptchaView.h"

@interface OfferBuyView : UIView<UITextFieldDelegate>

typedef void (^BackBlock)();

typedef void (^TureBlock)();


@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,copy) NSString *goods_id;


@property (nonatomic,copy) BackBlock backBlock;
@property (nonatomic,copy) TureBlock tureBlock;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet CaptchaView *captchaView;

@end
