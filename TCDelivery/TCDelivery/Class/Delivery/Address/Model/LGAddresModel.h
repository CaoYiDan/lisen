//
//  LGAddresModel.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/6/20.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAddressInfo.h"
@interface LGAddresModel : NSObject
//===== 与服务器交互的方法 =====//
//
///**
// * 添加收货地址
// */
//+ (void)addWithAreaId:(NSString *)areaId
//            telephone:(NSString *)telephone
//               detail:(NSString *)detail
//             fullname:(NSString *)fullname
//             location:(NSString*)location
//              noOrYes:(BOOL)noOrYes
//              success:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, LGAddressInfo *address, NSArray *addresses))success
//              failure:(void(^)(NSError *error))failure;
///**
// * 更新收货地址
// */
//+ (void)updataWithAreaId:(NSString *)areaId
//            addresId:(NSString*)addresId
//            telephone:(NSString *)telephone
//               detail:(NSString *)detail
//             fullname:(NSString *)fullname
//             location:(NSString*)location
//          defaultAddress:(NSString*)defaultAddress
//              success:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, LGAddressInfo *address, NSArray *addresses))success
//              failure:(void(^)(NSError *error))failure;
////获得地址列表
//+ (void)getAddresses:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, NSArray *addresses))success
//             failure:(void(^)(NSError *error))failure;
//
////设置默认地址
//+ (void)setDefaultWithId:(NSString *)addressId
//                 success:(void(^)(BOOL result))success
//                 failure:(void(^)(NSError *error))failure;
//
////获得默认地址
//+ (void)getDefaultWithuserId:(NSString *)userId
//                 success:(void(^)(NSDictionary*dict))success
//                 failure:(void(^)(NSError *error))failure;

@end
