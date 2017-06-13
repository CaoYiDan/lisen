//
//  Common.m
//  CaissaPadDemo
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 ecannetwork. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (id)customArray:(NSArray*) _Array ObjectAtIndex:(NSUInteger) _Indxe
{
    if (_Array.count>= _Indxe+1)
    {
        return [_Array objectAtIndex:_Indxe];
    }else
    {
        NSLog(@"\n\n\n\n\n\n\n数组越界其中:\n1、数组总数(count):%lu\n2、当前的索引:%lu\n3、数组内容:%@\n\n\n\n\n",_Array.count,_Indxe,_Array);
        return nil;
    }
}

+(NSString *)getDownloadPath{
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    return documentDir;
//    return [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"Download"];
}

+ (NSArray *) getDownMusicList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [Common getDownloadPath];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *_path = [path stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:_path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
    return fileList;
}

+ (NSString *) formatTime:(int) second
{
    if (second>-1) {
        return [NSString stringWithFormat:@"%02d:%02d",second/60,second%60];
    }
    return nil;
}

//+ (UIButton *) addFunnelEvent:(UIViewController *) _viewController action:(SEL)action
//{
//    int gap = 10;
//    UIImage *img = GETIMAGE(@"funnel_btn");
//    CGRect  rect = CGRectMake(CGRectGetWidth(SCREENFRAME)-img.size.width-gap, CGRectGetHeight(SCREENFRAME)-img.size.height-NAVIGATIONHEIGHT-gap, img.size.width, img.size.height);
//    
//    UIButton *funnelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [funnelBtn addTarget:_viewController action:action forControlEvents:UIControlEventTouchUpInside];
//    funnelBtn.frame = rect;[funnelBtn setBackgroundImage:img forState:UIControlStateNormal];
//    return funnelBtn;
//}
+ (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}


+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

void drawDottedLine(CGContextRef context, CGFloat startX, CGFloat startY,
                    CGFloat endX, CGFloat endY, const CGFloat lengths[],
                    size_t count, CGColorRef color, CGFloat lineWidth) {
    
    CGContextSaveGState(context);
    
    if(color)
        CGContextSetStrokeColorWithColor(context, color);
    if(lineWidth > 0)
        CGContextSetLineWidth(context, lineWidth);
    
    CGContextSetLineDash(context, 0, lengths, count);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

void drawLine(CGContextRef context, CGFloat startX, CGFloat startY,
              CGFloat endX, CGFloat endY, CGColorRef color, CGFloat lineWidth) {
    
    CGContextSaveGState(context);
    
    if(color)
        CGContextSetStrokeColorWithColor(context, color);
    if (lineWidth > 0)
        CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

void drawRectWithRect(CGContextRef context, CGRect rect, CGColorRef strokeColor,
                      CGColorRef fillColor, CGFloat borderWidth,
                      CGPathDrawingMode drawMode) {
    
    CGContextSaveGState(context);
    
    if (drawMode == kCGPathStroke) {
        
        CGContextSetStrokeColorWithColor(context, strokeColor);
        
    } else {
        
        CGContextSetFillColorWithColor(context, fillColor);
        CGContextSetStrokeColorWithColor(context, strokeColor);
        
    }
    
    if (borderWidth > 0)
        CGContextSetLineWidth(context, borderWidth);
    
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, drawMode);
    
    CGContextRestoreGState(context);
    
    
}

+ (NSAttributedString *) getTextContent:(NSString *) content key:(NSString *) contentKey contentColor:(UIColor *)contentColor contentKey:(UIColor *) contentKeyColor textContentFont:(NSInteger) contentFont contentKeyFont:(NSInteger) contentKeyFont
{
    NSRange range = [content rangeOfString:contentKey];
    if (content==nil &&content.length==0) {
        return nil;
    }
    if (range.location != NSNotFound) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
        [str addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0,range.location)];
        [str addAttribute:NSForegroundColorAttributeName value:contentKeyColor range:NSMakeRange(range.location,range.length)];
        [str addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(range.location+range.length,content.length-range.location-range.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentFont] range:NSMakeRange(0,range.location)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentKeyFont] range:NSMakeRange(range.location,range.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentFont] range:NSMakeRange(range.location+range.length,content.length-range.location-range.length)];
        return str;

    }
    return [[NSAttributedString alloc] initWithString:content attributes:@{UITextAttributeFont:[UIFont systemFontOfSize:contentFont],UITextAttributeTextColor:contentColor}];
}

//+ (NSArray *)createInputViewWithFrame:(CGRect) frame WithTextField:(UITextField *) textField withIconImageName:(NSString *) imageName withPlaceholder:(NSString *) placeholder{
//    UIImageView *userNameView = [[UIImageView alloc] initWithFrame:frame];
//    userNameView.userInteractionEnabled = YES;
//    userNameView.image = [UIImage imageNamed:@"login_field_bg"];
//    
//    if (imageName && imageName.length>0) {
//        UIImage *im = GETIMAGE(imageName);
//        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, im.size.width, im.size.height)];
//        iconImage.image = im;//@"login_name_icon"
//        [userNameView addSubview:iconImage];
//    }
//    
//    UITextField *_textField = [[UITextField alloc] initWithFrame:CGRectMake(imageName.length>0?35:10, 0, CGRectGetWidth(SCREENFRAME)- (imageName.length>0 ?60 : 40), 40)];
//    _textField.placeholder = [placeholder safeString];
//    [userNameView addSubview:_textField];
//    
//    return @[userNameView,_textField];
//}

//+ (NSMutableAttributedString *)setAttributedText:(NSString *)string withRange:(NSRange )range withNormalFont:(UIFont *)normalFont withNormalColor:(UIColor *)normalColor withHighlightedFont:(UIFont *)hightlightedFont withHightlightedColor:(UIColor *)highlightedColor
//{
//    if (string.length>0 && range.location != NSNotFound) {
//        //range计算
//        NSUInteger rangeCount = range.location+range.length;
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//        //设置：前后不同的颜色和字体
//        if (normalColor) {
//            [attributedString addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0, rangeCount)];
//            
//        }else
//        {
//            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(162, 162, 162) range:NSMakeRange(0, rangeCount)];
//        }
//        if (highlightedColor) {
//            [attributedString addAttribute:NSForegroundColorAttributeName value:highlightedColor range:NSMakeRange(rangeCount, attributedString.length-rangeCount)];
//            
//        }else
//        {
//            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(67, 74, 84) range:NSMakeRange(rangeCount, attributedString.length-rangeCount)];
//            
//        }
//        if (normalFont) {
//            [attributedString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, rangeCount)];
//        }else
//        {
//            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, rangeCount)];
//        }
//        if (hightlightedFont) {
//            [attributedString addAttribute:NSFontAttributeName value:hightlightedFont range:NSMakeRange(rangeCount, attributedString.length-rangeCount)];
//        }else
//        {
//            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(rangeCount, attributedString.length-rangeCount)];
//        }
//        return attributedString;
//    }else{
//        return nil;
//    }
//}

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

//+ (UIView *) buildSegmentationViewWithFrame:(CGRect) frame superView:(UIView *) superView
//{
//    UIView *segmentation = [[UIView alloc]initWithFrame:frame];
//    segmentation.backgroundColor = SEGMENTATIONCOLOR;
//    [superView addSubview:segmentation];
//    return segmentation;
//}
//
//转换颜色色值
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//判断手机号是不是有效
+ (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0)
    {
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        return NO;
        
    }
    
    // NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *regex = @"^((14[0-9])|(17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch)
    {
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        
        return NO;
        
    }
    
    else
    {
        
        return YES;
    }
    
}

//判断邮箱是否有效
+(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

//身份证号码是否合法
+ (BOOL)validateIDCardNumber:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}
//判断字符串是否含有特殊字符
+(BOOL)validateName:(NSString *)nameStr
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet
                                       
                                       characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    NSRange userNameRange = [nameStr rangeOfCharacterFromSet:nameCharacters];
    
    if (userNameRange.location != NSNotFound)
    {
        
        NSLog(@"包含特殊字符");
        return YES;
        
    }
    else
    {
        return NO;
    }
}

+(NSString *)intervalSinceNow: (NSString *) theDate
{
    NSTimeInterval late = [theDate floatValue];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=late-now;
    
    //
    //    if (cha/3600<1) {
    //        timeString = [NSString stringWithFormat:@"%f", cha/60];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"剩余开奖时间 %@分钟", timeString];
    //
    //    }
    //    if (cha/3600>1&&cha/86400<1) {
    //        timeString = [NSString stringWithFormat:@"%f", cha/3600];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"剩余开奖时间 %@小时", timeString];
    //    }
    //    if (cha/86400>1)
    //    {
    //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"剩余开奖时间 %@天", timeString];
    //
    //    }
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    NSTimeInterval leftHour= cha-86400*[timeString integerValue];
    timeString=[NSString stringWithFormat:@"剩余开奖时间: %@天", timeString];
    
    NSString*hourString = [NSString stringWithFormat:@"%f", leftHour/3600];
    CGFloat  hour=[hourString floatValue];
  
    hourString=[NSString stringWithFormat:@"%.0f小时", hour];
   
    timeString=[NSString stringWithFormat:@"%@%@",timeString,hourString];
    return timeString;
}

+(void)checkVersion:(void(^)(NSString*isCurrentVersion))block

{
    
    //appid  1151766675
//    
//    AFHTTPSessionManager*manager =[AFHTTPSessionManager manager];
//    
//    NSString*urlString =[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1151766675"];
//    [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //最新版本
//        NSArray*arr=responseObject[@"results"];
//        
//        if (arr.count==0) {
//            
//        }else{
//            NSString*version =responseObject[@"results"][0][@"version"];
//            
//            //当前版本
//            
//            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//            
//            // 当前应用软件版本  比如：1.0.1
//            
//            NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//            
//            NSLog(@"当前应用软件版本:%@",appCurVersion);
//            
//            if([appCurVersion isEqualToString:version]){
//                
//                //是最新版本
//                
//                block(@"1");
//                
//            }else{
//                
//                //不是最新版本,回调最新版本号过去
//                
//                block(version);
//                
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
    
}
+(void)postDeviceTokenAndUserId{
//    NSString*dToken=@"";
//    dToken = [[[[[StorageUtil getdeviceToken] description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                     
//                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
//                                    
//                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSString*appVersion=[NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//    NSString*ownerId=[StorageUtil getRoleId];
//
//    NSString*osVrsion=[NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
//    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
//    if (dToken==nil) {
//        
//    }else{
//        [dict setObject:dToken     forKey:@"deviceToken"];
//    }
//    
//    [dict setObject:appVersion forKey:@"appVersion"];
//    
//    if (ownerId==nil||ownerId.length==0||[ownerId isEqualToString:@"none"]) {
//        
//    }else{
//        
//        [dict setObject:ownerId    forKey:@"ownerId"];
//    }
//    [dict setObject:@"LETSGO"  forKey:@"appCode"];
//    [dict setObject:@"iOS"     forKey:@"osType"];
//    [dict setObject:osVrsion   forKey:@"osVersion"];
//    [dict setObject:@"DEFAULT" forKey:@"groupCode"];
//    [dict setObject:@"NORMAL"  forKey:@"status"];
//    [dict setObject:@""        forKey:@"deviceCode"];
//    NSLog(@"%@",dict);
//    [[HttpRequest sharedClient]httpRequestPOST:kDeviceToken parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
//        NSLog(@"%@",responseObject);
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];

}
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        NSLog(@"%d,%d",w,h);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}


@end
