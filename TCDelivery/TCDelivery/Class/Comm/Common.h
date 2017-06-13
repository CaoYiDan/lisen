//
//  Common.h
//  CaissaPadDemo
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 ecannetwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Common : NSObject
/*将秒数转换为当前时间*/
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;

+ (id)customArray:(NSArray*) _Array ObjectAtIndex:(NSUInteger) _Indxe;

/*
 * 得到路径
 */
+(NSString *)getDownloadPath;

+ (NSArray *) getDownMusicList;

+ (NSString *) formatTime:(int) second;

/*
 * 初始化筛选按钮
 */
//+ (UIButton *) addFunnelEvent:(UIViewController *) _viewController action:(SEL)action;

/*绘制虚线*/
void drawDottedLine(CGContextRef context, CGFloat startX, CGFloat startY,
                    CGFloat endX, CGFloat endY, const CGFloat lengths[],
                    size_t count, CGColorRef color, CGFloat lineWidth);

/*绘制矩形*/
void drawRectWithRect(CGContextRef context, CGRect rect, CGColorRef strokeColor,
                      CGColorRef fillColor, CGFloat borderWidth, CGPathDrawingMode drawMode);

/*绘制直线*/
void drawLine(CGContextRef context, CGFloat startX, CGFloat startY,
              CGFloat endX, CGFloat endY, CGColorRef color, CGFloat lineWidth);


/*UIColor转UIImage*/
+ (UIImage*) createImageWithColor: (UIColor*) color;

/*
 * 字体换色
 */
+ (NSAttributedString *) getTextContent:(NSString *) content key:(NSString *) contentKey contentColor:(UIColor *)contentColor contentKey:(UIColor *) contentKeyColor textContentFont:(NSInteger) contentFont contentKeyFont:(NSInteger) contentKeyFont;

/*
 *AttributedText NSRange
 */
//+ (NSMutableAttributedString *)setAttributedText:(NSString *)string withRange:(NSRange )range withNormalFont:(UIFont *)normalFont withNormalColor:(UIColor *)normalColor withHighlightedFont:(UIFont *)hightlightedFont withHightlightedColor:(UIColor *)highlightedColor;


/*
 * 创建输入框
 */
#define CUSTOMINPUTFRAME CGRectMake(35, 0, CGRectGetWidth(SCREENFRAME)-80, 40)
//+ (NSArray *)createInputViewWithFrame:(CGRect) frame WithTextField:(UITextField *) textField withIconImageName:(NSString *) imageName withPlaceholder:(NSString *) placeholder;
/*
 * 计算文字高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

/*
 * 分割线
 */
//+ (UIView *) buildSegmentationViewWithFrame:(CGRect) frame superView:(UIView *) superView;


//转换颜色色值
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;


//判断手机号是不是有效
+(BOOL)checkTel:(NSString *)str;

//判断邮箱是否有效

+(BOOL)isValidateEmail:(NSString *)email;

//是否输入表情
+(BOOL)isContainsEmoji:(NSString *)string;


//身份证号码是否合法
+ (BOOL)validateIDCardNumber:(NSString *)identityCard;

//判断字符串是否含有特殊字符
+(BOOL)validateName:(NSString *)nameStr;
//剩余时间的计算问题
+(NSString *)intervalSinceNow: (NSString *) theDate;
//检查版本号
+(void)checkVersion:(void(^)(NSString*isCurrentVersion))block;
//上传deviceToken和userId
+(void)postDeviceTokenAndUserId;
//判定字符串是否为空
+ (BOOL) isBlankString:(NSString *)string;
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request;
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request;
@end
