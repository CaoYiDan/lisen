//
//  LGAddressInfo.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/27.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGAddressInfo.h"

@implementation LGAddressInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_state          forKey:@"state"];
    [aCoder encodeObject:_receiver            forKey:@"name"];
    [aCoder encodeObject:_telNumber           forKey:@"phone"];
    [aCoder encodeObject:_location        forKey:@"province"];
    [aCoder encodeObject:_detailAddress   forKey:@"detailAddress"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.state           = [decoder decodeIntegerForKey:@"state"];
        self.detailAddress   = [decoder decodeObjectForKey:@"detailAddress"];
    }
    return self;
}

@end
