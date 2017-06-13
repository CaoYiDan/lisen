//
//  UILabel+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/5.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             numberOfLines:(NSInteger)lines
             textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = lines;
    label.textAlignment = textAlignment;
    return label;
}


//+ (void)showStats:(NSString *)stats atView:(UIView *)view {
//    CGSize sizea=[stats getSizeWithTextSize:CGSizeMake(180, MAXFLOAT) fontSize:12];
//    UIView*view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 120+sizea.height)];
//    view2 .center=view.center;
//    view2.backgroundColor=kRGBAColor(0, 0, 0, 0.8);
//    [view addSubview:view2];
//    UIImageView*imag=[[UIImageView alloc]initWithFrame:CGRectMake(70,30, 61, 61)];
//    
//    [imag setImage:[UIImage imageNamed:@"zj_gou"]];
//    [view2 addSubview:imag];
//    UILabel *message = [[UILabel alloc] init];
//    message.layer.cornerRadius = 10;
//    message.clipsToBounds = YES;
//    
//    message.numberOfLines = 0;
//    message.font = [UIFont systemFontOfSize:15];
//    message.textColor = [UIColor whiteColor];
//    message.textAlignment = NSTextAlignmentCenter;
//    message.alpha = 1;
//    
//    message.text = stats;
//    
//    
//    [view2 addSubview:message];
//    [message mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imag.bottom).offset(16);
//        make.width.offset(180);
//        make.centerX.equalTo(view2);
//        
//    }];
//    [UIView animateWithDuration:1.5 animations:^{
//        view2.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//            view2.alpha = 0;
//        } completion:^(BOOL finished) {
//            [view2 removeFromSuperview];
//            
//        }];
//    }];
//}
//+ (void)showNoBgroundViewStats:(NSString *)stats atView:(UIView *)view {
//    CGSize sizea=[stats getSizeWithTextSize:CGSizeMake(180, MAXFLOAT) fontSize:12];
//    UIView*view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 120+sizea.height)];
//    view2 .center=view.center;
//    view2.backgroundColor=kRGBAColor(0, 0, 0, 0.8);
//    [view addSubview:view2];
//    UIImageView*imag=[[UIImageView alloc]initWithFrame:CGRectMake(70,30, 61, 61)];
//    
//    [imag setImage:[UIImage imageNamed:@"zj_gou"]];
//    [view2 addSubview:imag];
//    UILabel *message = [[UILabel alloc] init];
//    message.layer.cornerRadius = 10;
//    message.clipsToBounds = YES;
//   
//    message.numberOfLines = 0;
//    message.font = [UIFont systemFontOfSize:15];
//    message.textColor = [UIColor whiteColor];
//    message.textAlignment = NSTextAlignmentCenter;
//    message.alpha = 1;
//    
//    message.text = stats;
//    
//    [view2 addSubview:message];
//   [message mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.top.equalTo(imag.bottom).offset(16);
//       make.width.offset(180);
//            make.centerX.equalTo(view2);
//
//   }];
//    [UIView animateWithDuration:1.5 animations:^{
//        view2.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//            view2.alpha = 0;
//        } completion:^(BOOL finished) {
//            [view2 removeFromSuperview];
//            
//        }];
//    }];
//}

-(void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithColour:(UIColor *)colour{
    NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrsString addAttribute:NSForegroundColorAttributeName value:colour range:range];
    self.attributedText = attrsString;
}
- (void)setAttributeTextWithString:(NSString *)string range:(NSRange)range WithColour:(UIColor *)colour Double:(BOOL)ifDouble Withrange:(NSRange)range2 WithColour:(UIColor *)colour2{
    NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrsString addAttribute:NSForegroundColorAttributeName value:colour range:range];
    if (ifDouble==YES) {
        
        [attrsString addAttribute:NSForegroundColorAttributeName value:colour2 range:range2];
    }
    self.attributedText = attrsString;
}
- (NSAttributedString *)procesString:(NSString *)str1 withcolour:(UIColor*)firstColour withfont:(NSInteger)font1 with:(NSString *)str2 withcolour:(UIColor*)secondColour withfont:(NSInteger)font2
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", str1, str2]];
    [str addAttribute:NSForegroundColorAttributeName value:firstColour range:NSMakeRange(0,str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value: secondColour range:NSMakeRange(str1.length + 1, str2.length)];
    
    [str addAttribute:NSFontAttributeName value:Font(font1) range:NSMakeRange(0, str1.length)];
    [str addAttribute:NSFontAttributeName value:Font(font2) range:NSMakeRange(str1.length+1, str2.length)];
    
    return str;
}


@end
