//
//  HttpRequest.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/6/26.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResponseObject;

typedef void(^ProgressBlock)(NSProgress *downloadProgress);
typedef void(^SucessBlock)(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) ;
typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error) ;


@interface HttpRequest : NSObject

@property (nonatomic,strong)AFHTTPSessionManager *manager;

+ (HttpRequest *)sharedClient;
//取消网络请求
- (void)cancelRequest;
//get请求
- (void)httpRequestGET:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure ;
//post请求
- (void)httpRequestPOST:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure ;
//put请求
//- (void)httpRequestPUT:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure ;
//delete请求
//- (void)httpRequestDELETE:(NSString *)string parameters:(id)parmeters progress:(ProgressBlock)progress sucess:(SucessBlock)sucess failure:(FailureBlock)failure  ;

@end
