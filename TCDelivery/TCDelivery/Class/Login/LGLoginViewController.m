//
//  LGLoginViewController.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/16.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGLoginViewController.h"

#import "LGRegistViewController.h"
#import "LGFindVC.h"

@interface LGLoginViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton* getpassbutton;
    NSTimer * getpasstimer;
}
//用户名和用户密码
@property (nonatomic,strong)UITextField *userNameField,*userPassField;

@end

@implementation LGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    [self creattableview];
    [self creatnavigation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBarHidden=YES;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(Thirdlogin)
//                                                 name:NotificationBangding
//                                               object:nil];
    
}

//创建navigation
-(void)creatnavigation{
    self.navigationController.navigationBarHidden=YES;
    UILabel* bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 44)];
    bgLabel.backgroundColor=[UIColor clearColor];
    bgLabel.userInteractionEnabled=YES;
    [self.view addSubview:bgLabel];
    UIButton*back=[UIButton buttonWithType:UIButtonTypeCustom];
    //判断是rootView 还是pushView
    
    //pushView有返回按钮
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    back.frame=CGRectMake(5, 15, 50, 30);
    
    [bgLabel addSubview:back];
    
}

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)creattableview{
    UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tag = 102;
    
    tableview.backgroundColor = LGLighgtBGroundColour235;
    
    UIImageView*imagevie=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 64)];
    UIImageView*imagevie1=[[UIImageView alloc]initWithFrame:CGRectMake((kWindowW-165)/2, 150-104, 165, 44)];
    
    [imagevie addSubview:imagevie1];
    tableview.tableHeaderView=imagevie;
    [self.view addSubview:tableview];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 0.0f;
    switch (indexPath.row) {
        case 0:
            h = 40;
            break;
        case 1:
            h = 40;
            break;
        case 2:
            h = 62;
            break;
        case 3:
            h = 50;
            break;
            
        case 4:
            if (kiPhone4) {
                h=50;
            }else{
            h=100;
            }
            break;
        case 5:
            h=50;
            break;
        default:
            break;
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginViewControllerCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoginViewControllerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:[self createUserNameView]];
            break;
        case 1:
            [cell.contentView addSubview:[self createUserPassView]];
            break;
        case 2:
            [cell.contentView addSubview:[self createLoginButton]];
            cell.contentView.backgroundColor=LGLighgtBGroundColour235;
            break;
        case 3:
            [cell.contentView addSubview:[self createLoginHelpView]];
            cell.contentView.backgroundColor=LGLighgtBGroundColour235;
            break;
        case 4:
            cell.contentView.backgroundColor=LGLighgtBGroundColour235;
            break;
        case 5:
            //是否安装微信校验，没有安装时提示
//            if (![WXApi isWXAppInstalled]) {
//
//            }else{
            
//                [cell.contentView addSubview:[self creatThirdLoginView]];
            //}
            cell.contentView.backgroundColor=LGLighgtBGroundColour235;
            
//             self.userNameField.text=@"15900000000";
//            self.userNameField.text=@"13163193905";
//            self.userPassField.text=@"123456";
//
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

#pragma mark 用户名textfiled
- (UIView *)createUserNameView{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 42)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *userNameView = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 50, 30)];
    userNameView.userInteractionEnabled = YES;
//    userNameView.textColor=LGTitlegrayColour;
    userNameView.text=@"手机号:";
    userNameView.font=[UIFont systemFontOfSize:14];
    [view addSubview:userNameView];
    
    UIView* lineview = [[UIView alloc] initWithFrame:CGRectMake(-10, userNameView.frame.size.height+userNameView.frame.origin.y+3, self.view.frame.size.width+10, 1)];
    lineview.backgroundColor = LGLighgtBGroundColour235;
    [view addSubview:lineview];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, kWindowW-80, 42)];
    self.userNameField.font = [UIFont systemFontOfSize:12];
    self.userNameField.placeholder = @"请输入手机号码";
    self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.userNameField.delegate = self;
    [view addSubview:self.userNameField];
    
    return view;
}

#pragma Mark 密码输入框
- (UIView *)createUserPassView{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 42)];
    view.backgroundColor = [UIColor clearColor];
    UILabel*userNameView = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 50, 30)];
    userNameView.userInteractionEnabled = YES;
    userNameView.text=@"密  码:";
//    userNameView.textColor=LGTitlegrayColour;
    userNameView.font=[UIFont systemFontOfSize:14];
    [view addSubview:userNameView];
    self.userPassField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0   , kWindowW-80    ,42)];
    self.userPassField.font = [UIFont systemFontOfSize:12];
    self.userPassField.delegate = self;
    self.userPassField.secureTextEntry = YES;
    self.userPassField.placeholder = @"请输入密码";
    self.userPassField.returnKeyType = UIReturnKeyDone;
    self.userPassField.delegate = self;
    [view addSubview:self.userPassField];
    return view;
}
#pragma mark 创建登录按钮
- (UIView *)createLoginButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    
    [btn setFrame:CGRectMake(15, 62-38, self.view.frame.size.width-30, 38)];
    [btn setTitle:@"登  录" forState:UIControlStateNormal];
    [btn setBackgroundColor:KTCBlueColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"common_btn_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"common_btn_highlighted"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark 快速注册和忘记密码按钮
- (UIView *)createLoginHelpView{
    
    UIView *helpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 50)];
    UIView* viewhid = [[UIView alloc] initWithFrame:CGRectMake(helpView.frame.size.width/2,(helpView.frame.size.height-10)/2 , 1, 10)];
    viewhid.backgroundColor = LGLighgtBGroundColour235;
    [helpView addSubview:viewhid];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setFrame:CGRectMake(20, (helpView.frame.size.height-12)/2, 100, 35)];
    [registBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registBtn.layer.borderColor=KTCBlueColor.CGColor;
    registBtn.layer.borderWidth=1;
    registBtn.layer.cornerRadius=5;
    [registBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [registBtn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [helpView addSubview:registBtn];
    
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassBtn setFrame:CGRectMake(kWindowW-20- registBtn.frame.size.width, registBtn.frame.origin.y, registBtn.frame.size.width,35)];
    [forgetPassBtn setTitle:@"找回密码？" forState:UIControlStateNormal];
    [forgetPassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetPassBtn.layer.borderColor=KTCBlueColor.CGColor;
    forgetPassBtn.layer.borderWidth=1;
    forgetPassBtn.layer.cornerRadius=5;
    [forgetPassBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [forgetPassBtn addTarget:self action:@selector(gotoForgetPass) forControlEvents:UIControlEventTouchUpInside];
    [helpView addSubview:forgetPassBtn];
    return helpView;
}

#pragma mark 注册
-(void)gotoRegister{
    //将thirdId写为none ,则在这个button下进行的注册不会与微信进行绑定（怕在微信第三方登录之后，再进行注册 起冲突）
    
    LGRegistViewController*vc=[[LGRegistViewController alloc]init];
    vc.view.backgroundColor=[UIColor blackColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//
#pragma mark 忘记密码
-(void)gotoForgetPass{
    LGFindVC*vc=[[LGFindVC alloc]init];
    vc.view.backgroundColor=[UIColor blackColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 登录
- (void)onLogin{

    [self.userNameField resignFirstResponder];
    [self.userPassField resignFirstResponder];
    //设备Id
     NSString*osVrsion=[NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    
    NSString *userName = self.userNameField.text;
    if(userName == nil || userName.length==0)
    {
        [MBProgressHUD showMessage:@"请输入手机号" toView:self.view afterDelty:1.0];
        return;
    }
    
    if (![Common checkTel:self.userNameField.text]) {
        
        [MBProgressHUD showMessage:@"手机号格式不对" toView:self.view afterDelty:1.0];
        return;
    }
    
    NSString *userPass = self.userPassField.text;
    if (userPass == nil || userPass.length == 0) {
        
        [MBProgressHUD showMessage:@"请输入密码" toView:self.view afterDelty:1.0];
        return;
    }
    
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
    
    [dic setObject:self.userNameField.text forKey:@"mobile"];
    [dic setObject:self.userPassField.text forKey:@"password"];
    if (!isEmptyString([StorageUtil getDeviceToken])) {
         [dic setObject:[StorageUtil getDeviceToken] forKey:@"recentDeviceId"];
    }else{//测试用的--避免模拟器不能登录
        [dic setObject:@"12345"forKey:@"recentDeviceId"];
    }
    [dic setObject:@"IOS" forKey:@"recentDeviceType"];
    [dic setObject:@"SHIPPING" forKey:@"userType"];
    NSLog(@"%@",dic);
    [[HttpRequest sharedClient]httpRequestPOST:kUrlLogin parameters:dic progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSLog(@"%@",responseObject);
        NSNumber *success=responseObject[@"success"];
      
        //登录成功
        if ([success integerValue]==1){
            
               //如果是空，则说明是未认证成功账户，
                if (!isNull(responseObject[@"data"][@"role"][@"userType"])&&!isEmptyString(responseObject[@"data"][@"role"][@"userType"])){
                    
                    NSString*userType=responseObject[@"data"][@"role"][@"userType"];
                    if (![userType isEqualToString:@"SHIPPING"]) {
                        ToastError(@"承运端或司机端账号,无法登陆");
                        return ;
                    }
                    //存储手机号
                    [StorageUtil saveUserMobile:self.userNameField.text];
                    //存储用户数据
                    [StorageUtil saveRoleId:responseObject[@"data"][@"id"]];
                    [StorageUtil saveUserStatus:responseObject[@"data"][@"role"][@"status"]];
                    [StorageUtil saveUserSubType:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"role"][@"userSubType"]]];
                    [StorageUtil saveRealName:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"role"][@"realName"]]];
                    [StorageUtil saveHeaderName:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"role"][@"headName"]]];
                    [StorageUtil saveUserName:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"role"][@"userName"]]];
                }else{
                    //存储手机号
                    [StorageUtil saveUserMobile:self.userNameField.text];
                    //存储用户数据
                    [StorageUtil saveRoleId:responseObject[@"data"][@"id"]];
                }
//            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:@"注册成功" message:@"是否立即前往认证界面" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"立即前往", nil];
//            [alter show];
            // 发送通知,给个人中心界面，以此决定好要不要更新tableView
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStatusChange object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }else {
            ToastError(responseObject[@"info"]);
        }
        //失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [MBProgressHUD showMessage:@"登录失败" toView:self.view afterDelty:1.0];
    }];
}

#pragma mark - 销毁时调用,移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==0) {
//        
//    }else{
//    
//    }
//}
#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
