//
//  LGLoginBaseVC.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGLoginBaseVC : UIViewController
/*
 <##>标题
 */
@property(nonatomic,copy)NSString*titleName;
/*scrollView*/
@property(nonatomic,strong)UIScrollView*scroview;
@property(nonatomic,strong)UITextField*firstTextFiled;
@property(nonatomic,strong)UITextField*secondTextFiled;
//将上层的手机号传过来
@property(nonatomic,copy)NSString*phoneNumber;
-(void)setupNavigationWithTilteName:(NSString*)titleName;

@end
