//
//  StorageUtil.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/30.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "StorageUtil.h"

@implementation StorageUtil
//用户ID
+ (void)saveRoleId:(NSString *)roleId
{
    [self saveObject:roleId forKey:kStorageUserId];
}
+ (NSString *)getRoleId
{
    return [self getObjectByKey:kStorageUserId];
}
//用户手机号码
+ (void)saveUserMobile:(NSString *)userMobile
{
    [self saveObject:userMobile forKey:kStorageUserMobile];
}
+ (NSString *)getUserMobile
{
    return [self getObjectByKey:kStorageUserMobile];
}
//userType
+ (void)saveUserType:(NSString *)userType
{
    [self saveObject:userType forKey:kStorageUserType];
}
+ (NSString *)getUser
{
    return [self getObjectByKey:kStorageUserType];
}
//userSubType
+ (void)saveUserSubType:(NSString *)userSubType
{
    [self saveObject:userSubType forKey:kStorageUserSubType];
}
+ (NSString *)getUserSubType
{
    return [self getObjectByKey:kStorageUserSubType];
}
//用户的header姓名
+ (void)saveHeaderName:(NSString *)headerName{
    [self saveObject:headerName forKey:kStorageHeaderName];
}
+ (NSString *)getHeaderName{
    return [self getObjectByKey:kStorageHeaderName];
}

//用户的user姓名
+ (void)saveUserName:(NSString *)userName{
  [self saveObject:userName forKey:kStorageUserName];
}
+ (NSString *)getUserName{
  return [self getObjectByKey:kStorageUserName];
}
//realName
+ (void)saveRealName:(NSString *)realName
{
    [self saveObject:realName forKey:kStorageUserRealName];
}
+ (NSString *)getRealName
{
    return [self getObjectByKey:kStorageUserRealName];
}
//用户认证状态
//    APPLY_STATUS_APPLYING = "APPLYING";   //待审核
//    APPLY_STATUS_CONFIRMED = "CONFIRMED"; //通过审核
//    APPLY_STATUS_UNCONFIRMED = "UNCONFIRMED"; //未通过（未申请）
//    APPLY_STATUS_UNAVAILABLE = "UNAVAILABLE"; //不可用
+ (void)saveUserStatus:(NSString *)userStatus
{
    [self saveObject:userStatus forKey:kStorageUserStatus];
}
+ (NSString *)getUserStatus
{
    return [self getObjectByKey:kStorageUserStatus];
}
//手机的deviceToken
+ (void)saveDeviceToken:(NSString *)deviceToken{
      [self saveObject:deviceToken forKey:kStorageDeviceToken];
}
+ (NSString *)getDeviceToken{
    return [self getObjectByKey:kStorageDeviceToken];
}


//公用的保存和获取本地数据的方法
+ (void)saveObject:(NSObject *)obj forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];//把数据持久化到standardUserDefaults数据库
}
+ (NSString *)getObjectByKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *obj = [defaults objectForKey:key];
    
    if (!obj) return nil;
    
    return obj;
}

@end
