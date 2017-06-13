//
//  UIButton+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/6.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (UIButton *)exclusiveButton {
//    UIButton *exclusiveButton = [UIButton buttonWithBackgroundColor:[UIColor orangeColor]
//                                                              title:@"独家"
//                                                     titleLabelFont:[UIFont systemFontOfSize:XCFRecipeCellFontSizeDesc]
//                                                         titleColor:[UIColor redColor].CGColor;
//                                                             target:nil
//                                                             action:nil
//                                                      clipsToBounds:NO];
//    exclusiveButton.enabled = NO;
//    return exclusiveButton;
    return nil;
}



+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor
                                  title:(NSString *)title
                         titleLabelFont:(UIFont *)font
                             titleColor:(UIColor *)titleColor
                                 target:(id)target
                                 action:(SEL)action
                          clipsToBounds:(BOOL)clipsToBounds {
    
    UIButton *button = [[UIButton alloc] init];
    if (clipsToBounds) button.layer.cornerRadius = 5;
//    button.clipsToBounds = clipsToBounds;
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 *  快速创建一个带边框的button
 *
 *  @param backgroundColor button背景颜色
 *  @param title           按钮title文字
 *  @param font            按钮title字体大小
 *  @param titleColor      按钮titleyanse
 *  @param target          target
 *  @param action          action
 *
 *  @return 创建好的button
 */
+ (UIButton *)borderButtonWithBackgroundColor:(UIColor *)backgroundColor
                                  title:(NSString *)title
                         titleLabelFont:(UIFont *)font
                             titleColor:(UIColor *)titleColor
                                 target:(id)target
                                 action:(SEL)action
                          clipsToBounds:(BOOL)clipsToBounds {
    
    UIButton *button = [[UIButton alloc] init];
    if (clipsToBounds) button.layer.cornerRadius = 5;
   
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)borderButtonWithBackgroundColor:(UIColor *)backgroundColor
                                        title:(NSString *)title borColour:(UIColor*)borcolour
                               titleLabelFont:(UIFont *)font
                                   titleColor:(UIColor *)titleColor
                                       target:(id)target
                                       action:(SEL)action
                                clipsToBounds:(BOOL)clipsToBounds{
    UIButton *button = [[UIButton alloc] init];
    if (clipsToBounds) button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = borcolour.CGColor;
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;

}

@end
