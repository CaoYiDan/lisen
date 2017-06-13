//
//  LGAgainSetPWVC.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGAgainSetPWVC.h"
@interface LGAgainSetPWVC ()<UITextFieldDelegate>
{
    UIButton* getpassbutton;
    NSTimer * getpasstimer;
}

@end
@implementation LGAgainSetPWVC
-(void)viewDidLoad{
    [super viewDidLoad];
    [self creatall];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationWithTilteName:@"重新设置密码"];
}

-(void)creatall{
    UIView*passwordview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 40)];
    passwordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab= [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab.frame=CGRectMake(15, 0,90, 40);
    passlab.text=@"新密码设置";
    [passwordview addSubview:passlab];
    UITextField*textfiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 2, kWindowW-125, 40)];
    textfiled.placeholder=@"请输入新的密码";
    [passwordview addSubview:textfiled];
    //利用键值观察，改变textflied的placeholderLabel.font
    [textfiled setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    textfiled.delegate = self;
    self.firstTextFiled=textfiled;
    self.firstTextFiled.secureTextEntry = YES;
    [self.scroview addSubview:passwordview];
    UIView*againpasswordview=[[UIView alloc]initWithFrame:CGRectMake(0, 61, kWindowW, 40)];
    againpasswordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab2= [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab2.frame=CGRectMake(15, 0,90, 40);
    passlab2.text=@"再次输入密码";

    [againpasswordview addSubview:passlab2];
    UITextField*textfiled2=[[UITextField alloc]initWithFrame:CGRectMake(120, 2, kWindowW-125, 40)];
    textfiled2.placeholder=@"请输入刚才设置的密码";
    //利用键值观察，改变textflied的placeholderLabel.font
    [textfiled2 setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    [againpasswordview addSubview:textfiled2];
    
    textfiled2.returnKeyType = UIReturnKeyDone;
    textfiled2.delegate = self;
      textfiled2.secureTextEntry = YES;
    self.secondTextFiled=textfiled2;
    
    [self.scroview addSubview:againpasswordview];
    UILabel*tip=[UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:[UIColor grayColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    tip.frame=CGRectMake(15, 112, 250, 20);
    tip.text=@"密码由6—20位英文字母,数字或符号组成";
    [self.scroview addSubview:tip];
    UIButton*confirmbtn=[UIButton borderButtonWithBackgroundColor:KTCBlueColor title:@"确定" titleLabelFont: [UIFont systemFontOfSize:16] titleColor: [UIColor whiteColor] target:self action:@selector(confirm) clipsToBounds:YES];
    confirmbtn.frame=CGRectMake(10, 147, kWindowW-20, 40);
    [self.scroview addSubview:confirmbtn];
}

-(void)getpassword:(UIButton*)button
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{   [super viewWillDisappear: animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)confirm{
    
    if (IsNilString(self.firstTextFiled.text) || IsNilString(self.secondTextFiled.text)) {
        [MBProgressHUD showMessage:@"密码不能为空" toView:self.view afterDelty:1.0];
        return;
    }
    if (![self.firstTextFiled.text isEqualToString:self.secondTextFiled.text]) {
        [MBProgressHUD showMessage:@"两次密码不一致" toView:self.view afterDelty:1.0];
        return;
    }
    if (self.secondTextFiled.text.length<6) {
        [MBProgressHUD showMessage:@"密码长度不得小于6" toView:self.view afterDelty:1.0];
        return;
    }
    
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
    //密码
    [dic setObject:self.firstTextFiled.text forKey: @"newPassword"];
    [dic setObject:self.secondTextFiled.text forKey: @"repeatPassword"];
    [dic setObject:@"123456" forKey:@"sms"];
    [dic setObject:[StorageUtil getRoleId] forKey:@"memberId"];
    WeakSelf;
    //提交新的密码到服务器
    [[HttpRequest sharedClient]httpRequestPOST:KResetPassword parameters:dic progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
     [MBProgressHUD showMessage:@"修改成功，请重新登录" toView:window afterDelty:1.5];
        [UIView animateWithDuration:1.5 animations:^{
            
        } completion:^(BOOL finished) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
         [MBProgressHUD showError:@"更换密码失败"];
    }];
    
}

@end
