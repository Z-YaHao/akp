//
//  AKNetWork.m
//  AKProject
//
//  Created by yahaozhang on 2020/4/12.
//  Copyright © 2020 thsde. All rights reserved.
//

#import "AKNetWork.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@implementation AKNetWork



+(AFHTTPSessionManager *)afmanager{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSUTF8StringEncoding];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
    
    [SVProgressHUD showWithStatus:@"正在请求"];
    return manager;
    
}


+(void)getRequestWithUrl:(NSString *)url parameter:(NSDictionary *)paraDic success:(void(^)(id result))successBlock failure:(void(^)(void))failureBlock{
    
    AFHTTPSessionManager *manager = [self afmanager];
    
    [manager GET:url parameters:paraDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject) {
           
           if (successBlock) {
               
               successBlock(responseObject);
           }
           
           
       }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (failureBlock) {
            
            failureBlock();
        }
    }];
    
    
    
}


+(void)postRequestWithUrl:(NSString *)url parameter:(NSDictionary *)paraDic success:(void(^)(id result))successBlock failure:(void(^)(void))failureBlock{
    
    AFURLSessionManager *manager = [self afmanager];

    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:paraDic error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"%@",error);
            if (failureBlock) {
                
                failureBlock();
            }
        }
        else{
            if (responseObject) {
                
                if (successBlock) {
                    
                    successBlock(responseObject);
                }
                
                
            }
        }
        
    }];
    
    [task resume];
    
}

@end
