//
//  HMDataManager.m
//  HelpSale
//
//  Created by CYT on 2017/8/28.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import "HMDataManager.h"

@implementation HMDataManager

+(void)requestUrl:(NSString *)url
           params:(NSMutableDictionary *)param
           HidHUD:(BOOL)isHidHud
          success:(void (^)(id result))successBlock
          failure:(void (^)(NSError *error))failBlock {
    

    //1.拼接url
    url = [[GlobalUtils urlWithDev] stringByAppendingString:url];
    
    NSLog(@"URL:%@+++++param:%@",url,param);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = 60;
    
    NSDictionary *parameters = @{@"data":param};
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *HMData = [defaults objectForKey:@"HMData"];

    if (HMData) {
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",HMData[@"id"]] forHTTPHeaderField:@"Uid"];
        
        [manager.requestSerializer setValue:HMData[@"token"] forHTTPHeaderField:@"Authorization"];
        
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    if (isHidHud) {

        [hud hideAnimated:NO];
    }
    
    
    //
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *sstt = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",sstt);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        if ([responseObject[@"result"][@"code"] integerValue] == 1) {
            
            [hud hideAnimated:YES];
            
//            successBlock(responseObject[@"result"][@"data"]);
            
        }else {
            
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = responseObject[@"result"][@"error_msg"];
            
            [hud hideAnimated:YES afterDelay:2];
            
        }
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failBlock(error);
        
        NSLog(@"error:%@",error);
        hud.label.text = @"服务器异常";
        
        hud.mode = MBProgressHUDModeText;
        
        [hud hideAnimated:YES afterDelay:2];

    }];
    
}


+(void)getImageUrl:(NSArray *)imageArr
          progress:(void (^)(NSDictionary *progress))progressBlock
           success:(void (^)(NSArray *result))successBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = 60;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *HMData = [defaults objectForKey:@"HMData"];

    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",HMData[@"id"]] forHTTPHeaderField:@"Uid"];
    
    [manager.requestSerializer setValue:HMData[@"token"] forHTTPHeaderField:@"Authorization"];

    [manager POST:[NSString stringWithFormat:@"%@%@",[GlobalUtils urlWithDev],get_qiniu_token_API] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        successBlock(responseObject);
        
        if ([responseObject[@"result"][@"code"] integerValue] == 1) {
            
            NSMutableArray *imageUrlArr = [NSMutableArray array];//图片地址

            for (int i = 0; i < imageArr.count; i++) {
                
                [imageUrlArr addObject:@""];
            }
            
            dispatch_group_t group = dispatch_group_create();

            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:responseObject[@"result"][@"data"][@"qiniu_token"] forKey:@"token"];
            
            [params setObject:HMData[@"id"] forKey:@"x:user_id"];

            for (int i = 0; i < imageArr.count; i++) {
                
                dispatch_group_enter(group);

                [manager POST:@"http://up-z2.qiniu.com" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSData *imgData = UIImageJPEGRepresentation(imageArr[i], 1);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                    [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/png"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    float progress = ((float)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
                    
                    NSDictionary *progressDic = @{[NSString stringWithFormat:@"%d",i]:[NSString stringWithFormat:@"%.2lf",progress]};
                    
                    progressBlock(progressDic);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [imageUrlArr replaceObjectAtIndex:i withObject:responseObject[@"result"][@"data"][@"file_name"]];

                    dispatch_group_leave(group);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"%@",error);
                    
                    dispatch_group_leave(group);

                }];
                
            }

            dispatch_group_notify(group, dispatch_get_main_queue(), ^(){

                successBlock(imageUrlArr);
            });

            
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = responseObject[@"result"][@"error_msg"];
            
            [hud hideAnimated:YES afterDelay:2];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

        hud.label.text = @"服务器异常";
        
        hud.mode = MBProgressHUDModeText;
        
        [hud hideAnimated:YES afterDelay:2];
        
    }];

    
}







@end
