//
//  HttpRequest.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/6/26.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "HttpRequest.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
//#include "base64.h"
@implementation HttpRequest

+ (HttpRequest *)sharedClient{
    static HttpRequest *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
        
    });
    
    return _sharedClient;
}

-(AFHTTPSessionManager*)manager{
    static AFHTTPSessionManager *_managera = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _managera = [AFHTTPSessionManager manager];
        
    });
    
    return _managera;
}

//取消网络请求
- (void) cancelRequest
{
    [self.manager.operationQueue cancelAllOperations ];
}

//GET请求
-(void)httpRequestGET:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure  {
   
    [self.manager.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Accept"];
    
     [self.manager.requestSerializer setValue:@"192.168.1.177"  forHTTPHeaderField:@"Host"];
    
    [self.manager.requestSerializer setValue:@"a553929c2453449bab1e705aa9762328"  forHTTPHeaderField:@"token"];

    self.manager.requestSerializer.timeoutInterval=10;
    [self.manager GET:string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress!= nil) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        sucess(task,responseObject,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(task,error);
    }];
}

//POST请求
- (void)httpRequestPOST:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure    {
   ;
//    NSString*str=[NSString hmac:[self GetMonthFormData] withKey:@"letsgo123"];
    
//    [self.manager.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
//    [self.manager.requestSerializer setValue:@"application/json"  forHTTPHeaderField:@"Accept"];
//    
//    [self.manager.requestSerializer setValue:@"192.168.1.177"  forHTTPHeaderField:@"Host"];
    
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
   self.manager.requestSerializer.timeoutInterval=20;
    
         [self.manager POST:string parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
             if (progress!= nil) {
                 progress(downloadProgress);
             }
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            sucess(task,responseObject,responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

             failure(task,error);
         }];
     }
     @end
