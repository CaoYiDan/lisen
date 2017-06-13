//
//  NSString+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/15.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "NSString+Extension.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSString (Extension)

- (CGSize)getSizeWithTextSize:(CGSize)size fontSize:(CGFloat)fontSize {
    CGSize resultSize = [self boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}
                                           context:nil].size;
    return resultSize;
}
//
////HMAC计算返回二进制后，进行base64加密
//+(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
//{
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
//    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
//
//    NSData*data = [GTMBase64 encodeData:HMACData];
//    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",base64String);
//    return base64String;
//}
//
@end
