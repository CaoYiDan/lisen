//
//  ServerViewController.m
//  TianMing
//
//  Created by 李智帅 on 17/3/29.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import "ServerViewController.h"
#import "LGPassWordVC.h"
@interface ServerViewController ()
@property (nonatomic,strong) UITextField * numberTF;
@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroview.backgroundColor=[UIColor whiteColor];
    [self createNav];
    [self createUI];
    // Do any additional setup after loading the view.
}

#pragma mark -createUI
- (void)createUI{

    UILabel * serveLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 64+20, kWindowW-60, 30)];
    serveLab.text=@"请输入您的服务专员手机号";
    serveLab.font=Font(15);
    serveLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:serveLab];
    
    UIView * lineView1 = [[UIView alloc]init];
    
    lineView1.frame = CGRectMake(0, 60,kWindowW, 1);
    [self.view addSubview:lineView1];
    
    UILabel * numberLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 70+44, kWindowW-60, 30)];
    numberLab.text=@"+86";
    numberLab.font=Font(15);
    numberLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:numberLab];
    
    self.numberTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 70+44, kWindowW - 90, 30)];
    self.numberTF.borderStyle=UITextBorderStyleRoundedRect;
    self.numberTF.textAlignment = NSTextAlignmentCenter;
    self.numberTF.placeholder = @"请输入服务专员手机号";
    self.numberTF.textColor = [UIColor blackColor];
    self.numberTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.numberTF];
    
    UIView * lineView2 = [[UIView alloc]init];
    
    lineView2.frame = CGRectMake(0,110+44,kWindowW, 1);
    [self.view addSubview:lineView2];
    
    UIButton * jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpBtn.frame = CGRectMake(kWindowW/2-100, 140+44, 80, 30);
    [jumpBtn setBackgroundImage:[UIImage imageNamed:@"blue_an1"] forState:UIControlStateNormal];
    [jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [jumpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jumpBtn.tag=11;
    jumpBtn.layer.borderColor=[UIColor orangeColor].CGColor;
    jumpBtn.layer.borderWidth=1.0f;
    jumpBtn.layer.cornerRadius=5;
    jumpBtn.titleLabel.font=Font(12);
    [jumpBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(kWindowW/2+20, 140+44, 80, 30);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
    nextBtn.tag=12;
    nextBtn.titleLabel.font=Font(12);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5;
    nextBtn.backgroundColor=KTCBlueColor;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextBtn];
    
    
}

- (void)nextBtnClick:(UIButton*)btn{

    if (btn.tag==11) {//跳过
        LGPassWordVC * psVC = [[LGPassWordVC alloc]init];
        psVC.phoneNumber=self.phoneNumber;
        [self.navigationController pushViewController:psVC animated:YES];
    }else{//下一步
        if ([self checkTel:self.numberTF.text]) {
            LGPassWordVC * psVC = [[LGPassWordVC alloc]init];
            psVC.severStr = self.numberTF.text;
            psVC.phoneNumber=self.phoneNumber;
            [self.navigationController pushViewController:psVC animated:YES];
        }else{
            ToastError(@"您输入的号码有误，请重新输入");
        }
    }
    
}

//判断手机号是不是有效
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0)
    {
        ToastError(@"手机号不能为空");
        
        return NO;
        
    }
    
    // NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *regex = @"^((14[0-9])|(17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch)
    {
        
        //                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //
        //                [alert show];
        ToastError(@"您输入的手机号码有误请重新输入");
        
        
        return NO;
        
    }
    
    else
    {
        
        return YES;
    }
    
}

#pragma mark - createNav
- (void)createNav{
    
    [self setupNavigationWithTilteName:@"服务专员"];
}

- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
