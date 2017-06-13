//
//  TCLinkModel.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/5/4.
//
//

#import <Foundation/Foundation.h>

@interface TCLinkModel : NSObject
/**<##>联系人ID*/
@property(nonatomic,copy)NSString *receiverId;
/**<##>省*/
@property(nonatomic,copy)NSString *receiveProvince;
/**<##>市*/
@property(nonatomic,copy)NSString *receiveCity;
/**<##>区县*/
@property(nonatomic,copy)NSString *receiveCounty;
/**<##>详细地址*/
@property(nonatomic,copy)NSString *receiveAddress;
/**<##>联系人姓名*/
@property(nonatomic,copy)NSString *receiveName;
/**<##>电话*/
@property(nonatomic,copy)NSString *receiveTel;
/**<##>是否为默认 0：否 1：是*/
@property(nonatomic,assign)NSInteger defaultFlag;

@end
