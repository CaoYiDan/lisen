//
//  LGFindVC.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGFindVC.h"
#import "LGAgainSetPWVC.h"
@interface LGFindVC()<UITextFieldDelegate>
{
    UIButton* getpassbutton;
    NSTimer * getpasstimer;
}

@end
@implementation LGFindVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self creatall];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self setupNavigationWithTilteName:@"找回密码"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//创建所有的子控件视图View
-(void)creatall{
    //即第一个输入框的父控件View
    UIView*passwordview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 40)];
    passwordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab= [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab.frame=CGRectMake(15, 0,90, 40);

    passlab.text=self.isChangePhone? @"新手机号":@"注册的手机号";

    [passwordview addSubview:passlab];
    UITextField*textfiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, kWindowW-125, 40)];
    textfiled.placeholder=@"请输入11位手机号";
    //利用键值观察，改变textflied的placeholderLabel.font
    [textfiled setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [passwordview addSubview:textfiled];
    textfiled.font = [UIFont systemFontOfSize:14];
    textfiled.delegate = self;
    self.firstTextFiled=textfiled;
    
    [self.scroview addSubview:passwordview];
    
    //即第二个输入框的父控件View
    UIView*againpasswordview=[[UIView alloc]initWithFrame:CGRectMake(0, 61, kWindowW, 40)];
    againpasswordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab2= [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab2.frame=CGRectMake(15, 0,90, 40);
    passlab2.text=@"请输入验证码";
   
    [againpasswordview addSubview:passlab2];
    UITextField*textfiled2=[[UITextField alloc]initWithFrame:CGRectMake(120, 2, kWindowW-125-95, 40)];
    textfiled2.keyboardType=UIKeyboardTypeNumberPad;
    textfiled2.placeholder=@"请输入验证码";
    [againpasswordview addSubview:textfiled2];
    textfiled.font = [UIFont systemFontOfSize:12];
    
    //利用键值观察，改变textflied的placeholderLabel.font
    textfiled2.font = [UIFont systemFontOfSize:12];
    textfiled2.returnKeyType = UIReturnKeyDone;
    textfiled2.delegate = self;
    self.secondTextFiled=textfiled2;
    
    //获取验证码的按钮
    UIButton*getcodebtn=[UIButton buttonWithBackgroundColor:[UIColor clearColor] title:@"获取验证码" titleLabelFont:  [UIFont systemFontOfSize:12]titleColor:  [UIColor blackColor] target:self action: @selector(getpassword:)clipsToBounds:NO];
    getpassbutton=getcodebtn;
    getcodebtn.frame=CGRectMake(kWindowW-105, 0, 100, 40);
    if([[NSUserDefaults standardUserDefaults] doubleForKey:@"getpasstime"])
    {
        NSDate* date = [NSDate date];
        double timenow = [date timeIntervalSince1970];
        double timepass = [[NSUserDefaults standardUserDefaults] doubleForKey:@"getpasstime"];
        if(timenow< timepass)
        {
            getpasstimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleMaxShowTimer:) userInfo:nil
                                                           repeats:YES];
            [getpasstimer fire];
            getpassbutton.userInteractionEnabled = NO;
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getpasstime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
    
    [againpasswordview addSubview:getcodebtn];
    [self.scroview addSubview:againpasswordview];
    
    //验证码前面的小竖线
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=[UIColor lightGrayColor];
    [againpasswordview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(1, 10));
        make.right.equalTo(getcodebtn.left).offset(2);
        make.top.equalTo(againpasswordview).offset(15);
    }];
    
    
    UIButton*confirmbtn=nil;
    confirmbtn=[UIButton borderButtonWithBackgroundColor:KTCBlueColor title:@"确定" borColour:KTCBlueColor titleLabelFont:Font(16) titleColor:[UIColor whiteColor] target:self action:@selector(confirmClick) clipsToBounds:YES];
        confirmbtn.frame=CGRectMake(10, 147, kWindowW-20, 40);
    [self.scroview addSubview:confirmbtn];
}

-(void)getpassword:(UIButton*)button
{
    [self.firstTextFiled resignFirstResponder];
    [self.secondTextFiled resignFirstResponder];
    NSString *mobile = self.firstTextFiled.text;
    
    if (mobile.length == 0 || ![Common checkTel:self.firstTextFiled.text]) {
        ToastError(@"请填写正确的手机号码");
        return;
    }
//        //查看手机号是否已经注册过
//        NSString*url=[NSString stringWithFormat:@"%@%@",kUrlValidateMobile,mobile];
//        [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
//            //用NsNumber接收BOOL类型的值
//            NSNumber* isValitatephone=responseObject[@"successful"];
//            //注册过，则发送验证码
//            if ([isValitatephone integerValue]==0) {
                //验证时间开始运行
                NSDate* date = [NSDate date];
                [[NSUserDefaults standardUserDefaults] setDouble:([date timeIntervalSince1970]+60) forKey:@"getpasstime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                getpassbutton.userInteractionEnabled = NO;
                getpasstimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleMaxShowTimer:) userInfo:nil
                                        repeats:YES];
                [getpasstimer fire];
                
                //获取验证码的手机号码
                NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
                [dic setObject:mobile forKey: @"toMobile"];

                //调用后台----发送验证码
                [[HttpRequest sharedClient]httpRequestPOST:kUrlSmsGetCode parameters:dic progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
                    
                     [MBProgressHUD showMessage:@"已将验证码发送到您的手机" toView:self.view afterDelty:1.5];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    ToastError(@"发送验证码失败");
                    [getpassbutton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    getpassbutton.userInteractionEnabled = YES;
                    [getpasstimer  invalidate];
                    getpasstimer = nil;
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getpasstime"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }];
                
//            }else{
//                
//                ToastError(@"该手机还没有被注册过,欢迎您注册新账号");
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
    
}


-(void)handleMaxShowTimer:(NSTimer*)timer
{
    NSDate* date = [NSDate date];
    double timenow = [date timeIntervalSince1970];
    double timepass = [[NSUserDefaults standardUserDefaults] doubleForKey:@"getpasstime"];
    if(timenow < timepass)
    {
        int temp = timepass-timenow;
        [getpassbutton setTitle:[NSString stringWithFormat:@"%ds后重新获取",temp] forState:UIControlStateNormal];
    }
    else
    {
        [getpassbutton setTitle:@"获取验证码" forState:UIControlStateNormal];
        getpassbutton.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getpasstime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
# pragma  mark 确认按钮 点击
-(void)confirmClick{
    
    NSString *mobile = self.firstTextFiled.text;
            if (mobile.length == 0|| ![Common checkTel:mobile]) {
        
                ToastError(@"请输入正确手机号码");
        return;    }
    
    NSString *code = self.secondTextFiled.text;
    if (code.length == 0 ) {
        
        ToastError(@"请输入验证码");
        return;
    }
    WeakSelf;
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
    //获取验证码的手机号码
    [dic setObject:mobile forKey: @"toMobile"];
    //验证码
    [dic setObject:code forKey: @"code"];
    [[HttpRequest sharedClient]httpRequestPOST:kUrlSmsCheckCode parameters:dic progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        
        NSString*ifSuccess=responseObject[@"success"];
        
        if ([ifSuccess integerValue]==0){//验证失败
            ToastError(responseObject[@"info"]);
        }
        else{
            //Toast(@"验证成功");
            LGAgainSetPWVC*vc=[[LGAgainSetPWVC alloc]init];
            vc.view.backgroundColor=[UIColor blackColor];
            //将手机号码传给vc
            vc.phoneNumber=self.firstTextFiled.text;
            [weakSelf.navigationController pushViewController:vc animated:YES];

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"验证码错误");
    }];
}

@end
