//
//  LGAddresModel.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/6/20.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGAddresModel.h"

@implementation LGAddresModel
/**
 * 添加收货地址
 */
//+ (void)addWithAreaId:(NSString *)areaId
//            telephone:(NSString *)telephone
//               detail:(NSString *)detail
//             fullname:(NSString *)fullname
//             location:(NSString*)location
//noOrYes:(BOOL)noOrYes success:(void (^)(BOOL, NSNumber *, NSString *, LGAddressInfo *, NSArray *))success failure:(void (^)(NSError *))failure
//              
//{
//    NSMutableDictionary *params=nil;
//    if (noOrYes) {
//       params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       areaId,      @"userId",
//                                       telephone,   @"phoneNumber",
//                                       detail,      @"detailAddress",
//                                       fullname,    @"receiver",
//                                       location,      @"location",
//                                       @"DEFAULT", @"defaultAddress",
//                                       nil];
//    
//    }else{
//      params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       areaId,      @"userId",
//                                       telephone,   @"phoneNumber",
//                                       detail,      @"detailAddress",
//                                       fullname,    @"receiver",
//                                       location,      @"location",
//                                       @"NOT_DEFAULT", @"defaultAddress",
//                                       nil];
//
//    }
//    //增加网络地址请求
//
////[[HttpRequest sharedClient]httpRequestPOST:kUrlAddressAdd
////parameters:params progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
////   
////    ToastSuccess(@"添加地址成功");
////} failure:^(NSURLSessionDataTask *task, NSError *error) {
////    NSLog(@"%@",error);
////}];
//    }
///**
// * 更新收货地址
// */
//+ (void)updataWithAreaId:(NSString *)areaId
//                addresId:(NSString*)addresId
//            telephone:(NSString *)telephone
//               detail:(NSString *)detail
//             fullname:(NSString *)fullname
//             location:(NSString*)location
//            defaultAddress:(NSString*)defaultAddress
//              success:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, LGAddressInfo  *address, NSArray *addresses))success
//              failure:(void(^)(NSError *error))failure
//{
////    
////    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
////                                   areaId,      @"userId",
////                                   addresId,   @"addressId",
////                                   telephone,   @"phoneNumber",
////                                   detail,    @"detailAddress",
////                                   fullname,    @"receiver",
////                                   location,     @"location",
////                                   defaultAddress,@"defaultAddress",
////                                   nil];
////    
//    //更改网络地址请求
//    
////    [[HttpRequest sharedClient]httpRequestPOST :kUrlAddressUpdate
////                                   parameters:params progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
////                                       
////                                       ToastSuccess(@"更改地址成功");
////                                       
////                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
////                                       NSLog(@"%@",error);
////                                   }];
//}
//
////获得地址列表
//+ (void)getAddresses:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, NSArray *addresses))success
//             failure:(void(^)(NSError *error))failure
//{
////    NSString *url = [NSString stringWithFormat:@"%@%@",kUrlAddressGetList,[StorageUtil getRoleId]];
////    [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
////        NSLog(@"%@",responseObject);
////        NSArray*addressArr=(NSArray*)responseObject;
////         NSMutableArray*array=[[NSMutableArray alloc]init];
////        if (addressArr.count!=0) {
////           
////            //遍历请求的数据数组，
////            for (NSDictionary*dict in (NSArray*)responseObject) {
////                //将字典转化为模型
////                LGAddressInfo*info=[LGAddressInfo objectWithKeyValues:dict];
////                //将模型加入数组中
////                [array addObject:info];
////            }
////            
////        }else{
////            ToastError(@"请您点击右上角按钮添加");
////        }
////        success(YES,nil,nil,array);
////    } failure:^(NSURLSessionDataTask *task, NSError *error) {
////        failure(error);
////    }];
//}
//
////设置默认地址
//+ (void)setDefaultWithId:(NSString *)addressId
//                 success:(void(^)(BOOL result))success
//                 failure:(void(^)(NSError *error))failure
//{
////    NSString*url=[NSString stringWithFormat:@"%@%@/%@",kUrlAddressSetDefaultWithId,[StorageUtil getRoleId],addressId];
////    
////    [[HttpRequest sharedClient]httpRequestPOST:url
////                                   parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
////                                       success(YES);
////                                       ToastSuccess(@"已将此地址设置成为默认地址");
////                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
////                                       NSLog(@"%@",error);
////                                   }];
////
//}
////获得默认地址
//+ (void)getDefaultWithuserId:(NSString *)userId
//                     success:(void(^)(NSDictionary*dict))success
//                     failure:(void(^)(NSError *error))failure{
////    NSString*url=[NSString stringWithFormat:@"%@%@",kUrlGetDefaultAddrerss,[StorageUtil getRoleId]];
////   [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
////    NSLog(@"默认地址%@",responseObject);
////    success(responseObject);
////} failure:^(NSURLSessionDataTask *task, NSError *error) {
////    failure(error);
////}];
//
//}
@end

