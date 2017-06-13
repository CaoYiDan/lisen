//
//  LGRegistViewController.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/16.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGRegistViewController : UIViewController
/*
 手机textfiled
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
/*
 验证码textfiled
 */
@property (weak, nonatomic) IBOutlet UITextField *codeField;
/*
 <##>验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
/*
 <##>下一步按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *Nextbtn;
/*
 全体基于父控件scrollview
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scroview;
/*
 <##>返回按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *back;

@end
