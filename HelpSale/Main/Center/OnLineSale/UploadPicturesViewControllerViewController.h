//
//  UploadPicturesViewControllerViewController.h
//  HelpSale
//
//  Created by CYT on 2017/10/22.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadPicturesViewControllerViewController : BaseViewController



typedef void (^TureBlock)(NSArray *imageArr);

@property (nonatomic,copy) TureBlock TureBlock;


@property (nonatomic,copy)NSString *categate_id;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@end
