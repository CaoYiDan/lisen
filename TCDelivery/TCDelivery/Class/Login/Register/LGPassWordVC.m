//
//  LGPassWordVC.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGPassWordVC.h"

@implementation LGPassWordVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationWithTilteName:@"密码设置"];
     //创建UI
     [self creatall];
}

-(void)creatall{
    
    UIView*passwordview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 40)];
    passwordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab= [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab.frame=CGRectMake(15, 0,100, 40);
    passlab.text=@"登录密码设置";
    passlab.adjustsFontSizeToFitWidth=YES;
    passlab.font=Font(14);
    [passwordview addSubview:passlab];
    UITextField*textfiled=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, kWindowW-125, 40)];
    textfiled.placeholder=@"请输入密码";
    [passwordview addSubview:textfiled];
    textfiled.font = [UIFont systemFontOfSize:12];
    textfiled.returnKeyType = UIReturnKeyDone;

    self.firstTextFiled=textfiled;
    self.firstTextFiled.secureTextEntry = YES;
    [self.scroview addSubview:passwordview];
    UIView*againpasswordview=[[UIView alloc]initWithFrame:CGRectMake(0, 61, kWindowW, 40)];
    againpasswordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab2= [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab2.frame=CGRectMake(15, 0,100, 40);
    passlab2.adjustsFontSizeToFitWidth=YES;
    passlab2.text=@"再次输入密码";
    passlab2.font=Font(14);
    [againpasswordview addSubview:passlab2];
    UITextField*textfiled2=[[UITextField alloc]initWithFrame:CGRectMake(120, 0, kWindowW-125, 40)];
    textfiled2.placeholder=@"请输入刚才输入的密码";
    [againpasswordview addSubview:textfiled2];
    textfiled2.font = [UIFont systemFontOfSize:12];
    textfiled2.returnKeyType = UIReturnKeyDone;
    self.secondTextFiled=textfiled2;
    self.secondTextFiled.secureTextEntry = YES;
    [self.scroview addSubview:againpasswordview];
    UILabel*tip=[UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:[UIColor grayColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    tip.frame=CGRectMake(15, 112, 250, 20);
    tip.text=@"密码由6—20位英文字母,数字或符号组成";
    [self.scroview addSubview:tip];
    UIButton*confirmbtn=[UIButton borderButtonWithBackgroundColor:KTCBlueColor title:@"确定" titleLabelFont: [UIFont systemFontOfSize:16] titleColor: [UIColor whiteColor] target:self action:@selector(confirm) clipsToBounds:YES];
    confirmbtn.frame=CGRectMake(10, 147, kWindowW-20, 40);
    [self.scroview addSubview:confirmbtn];
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
    //手机号
    [dic setObject:self.phoneNumber forKey:@"mobile"];
    //密码
    [dic setObject:self.firstTextFiled.text forKey: @"password"];
    //再次输入密码
    [dic setObject:self.secondTextFiled.text forKey:@"repeatPassword"];
    //iOS
    [dic setObject:@"IOS" forKey:@"recentDeviceType"];
    if (!isEmptyString([StorageUtil getDeviceToken])) {
        [dic setObject:[StorageUtil getDeviceToken] forKey:@"recentDeviceId"];
    }else{//测试用的--避免模拟器不能登录
        [dic setObject:@"12345"forKey:@"recentDeviceId"];
    }
    if (!isNull(self.severStr)) {//服务专号
        [dic setValue:self.severStr forKey:@"commissioner"];
    }
    [dic setObject:@"1234" forKey:@"sms"];
    [[HttpRequest sharedClient]httpRequestPOST:kUrlRegister parameters:dic progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSLog(@"%@",responseObject);
//        {
//            success : 1,
//            data : {
//                userId : 1572254897094833481,
//                mobile : 18202574952,
//                userName : 18202574952,
//                updateTime : <null>,
//                delFlag : <null>,
//                recentDeviceId : 1234,
//                recentDeviceType : IOS,
//                email : <null>,
//                createTime : 1487900983000
//            },
//            info : <null>,
//            code : 200
//        }
        
        NSString*ifSuccess=responseObject[@"success"];
        
        if ([ifSuccess integerValue]==0){//验证失败
            ToastError(responseObject[@"info"]);
        }
        else{
            //存储用户信息
            [StorageUtil saveRoleId:responseObject[@"data"][@"userId"]];
            [StorageUtil saveUserMobile:responseObject[@"data"][@"mobile"]];
            [StorageUtil saveUserName:responseObject[@"data"][@"userName"]];
            // 发送通知,给个人中心界面，以此决定好要不要更新tableView
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStatusChange object:nil];
        //注册成功
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
        
    }];
}
@end
