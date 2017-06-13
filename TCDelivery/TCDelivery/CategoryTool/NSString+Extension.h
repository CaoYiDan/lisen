//
//  NSString+Extension.h
//  XCFApp
//
//  Created by callmejoejoe on 16/4/15.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  获取字体最大尺寸
 */
- (CGSize)getSizeWithTextSize:(CGSize)size fontSize:(CGFloat)fontSize;

/*HMAC计算返回二进制后，进行base64加密*/
//+(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
@end
