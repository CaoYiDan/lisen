//
//  LGAddressInfo.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/27.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//
typedef NS_ENUM(NSInteger, XCFAddressInfoCellState) {
    LGAddressInfoCellStateNone,
    LGAddressInfoCellStateSelected
};

#import <Foundation/Foundation.h>

@interface LGAddressInfo : NSObject
//是否是默认地址状态
@property (nonatomic, assign) XCFAddressInfoCellState state;
//姓名
@property (nonatomic, copy) NSString *receiver;
//电话
@property (nonatomic, copy) NSString *phoneNumber;
//手机
@property (nonatomic, copy) NSString *telNumber;
//邮箱
@property (nonatomic, copy) NSString *receiverEmail;
//省市
@property (nonatomic, copy) NSString *location;
//详细地址
@property (nonatomic, copy) NSString *detailAddress;
//地址id
@property(nonatomic,assign)NSInteger addressId;
//用户id
@property(nonatomic,assign)NSInteger roleId;
//是否为默认状态
@property (nonatomic, copy) NSString *defaultAddress;
@end
