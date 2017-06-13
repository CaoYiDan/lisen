//
//  UILabel+Extension.h
//  XCFApp
//
//  Created by callmejoejoe on 16/4/5.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             numberOfLines:(NSInteger)lines
             textAlignment:(NSTextAlignment)textAlignment;


/**
 *  自己粗略做的一个指示器=。=
 *
 *  @param stats 提示内容
 *  @param view  添加到view上
 */
+ (void)showStats:(NSString *)stats atView:(UIView *)view;

/**
 *  快速设置富文本
 *
 *  @param string 需要设置的字符串
 *  @param range  需要设置的范围（范围文字颜色显示为下厨房橘红色）
 */
- (void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithColour:(UIColor *)colour Double:(BOOL)ifDouble Withrange:(NSRange)range2 WithColour:(UIColor *)colour2;
- (void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithColour:(UIColor*)colour;
- (NSAttributedString *)procesString:(NSString *)str1 withcolour:(UIColor*)firstColour withfont:(NSInteger)font1 with:(NSString *)str2 withcolour:(UIColor*)secondColour withfont:(NSInteger)font2;
+ (void)showNoBgroundViewStats:(NSString *)stats atView:(UIView *)view ;
@end
