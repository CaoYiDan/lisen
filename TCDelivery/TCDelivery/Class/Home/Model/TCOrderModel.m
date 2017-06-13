//
//  TCOrderModel.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import "TCOrderModel.h"

@implementation TCOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"orderId" : @"id"};
}

@end
