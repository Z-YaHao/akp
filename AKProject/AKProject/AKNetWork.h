//
//  AKNetWork.h
//  AKProject
//
//  Created by yahaozhang on 2020/4/12.
//  Copyright © 2020 thsde. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKNetWork : NSObject



+(void)getRequestWithUrl:(NSString *)url parameter:(NSDictionary *)paraDic success:(void(^)(id result))successBlock failure:(void(^)(void))failureBlock;

+(void)postRequestWithUrl:(NSString *)url parameter:(NSDictionary *)paraDic success:(void(^)(id result))successBlock failure:(void(^)(void))failureBlock;
@end

NS_ASSUME_NONNULL_END
