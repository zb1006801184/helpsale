//
//  HMDataManager.h
//  HelpSale
//
//  Created by CYT on 2017/8/28.
//  Copyright © 2017年 朱标. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDataManager : NSObject


+(void)requestUrl:(NSString *)url
           params:(NSMutableDictionary *)param
           HidHUD:(BOOL)isHidHud
          success:(void (^)(id result))successBlock
          failure:(void (^)(NSError *error))failBlock;


+(void)getImageUrl:(NSArray *)imageArr
          progress:(void (^)(NSDictionary *progress))progressBlock
           success:(void (^)(NSArray *result))successBlock;





@end
