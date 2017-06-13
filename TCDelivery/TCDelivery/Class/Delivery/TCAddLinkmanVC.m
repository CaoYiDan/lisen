//
//  LGEditorAddresViewController.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/31.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "TCAddLinkmanVC.h"
#import "AddressPickView.h"
#import "TCLinkModel.h"
#import "IQKeyboardManager.h"
#define NUMBERS @"0123456789\n"
@interface TCAddLinkmanVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIScrollView*scroview;
//收货人
@property (strong, nonatomic) UITextField *nameField;
//电话
@property (strong, nonatomic) UITextField *phoneField;
//省市
@property (strong, nonatomic)  UITextField *provinceField;
//详细地址
@property (strong, nonatomic)  UITextView *detailAddressField;
//删除地址按钮
@property (strong, nonatomic)  UIButton *delete;
//当前的index，用来代理返回的当前cell
@property (nonatomic, strong) NSIndexPath *indexPath;
//省市选择pickView
@property (nonatomic, strong) UIPickerView *cityPicker;

// 选择器选中的省份
@property (nonatomic, assign) NSInteger provinceIndex;
// 选择器选中的城市
@property (nonatomic, assign) NSInteger cityIndex;
@property(nonatomic,strong)UIButton*deleteBtn;

@property(nonatomic, copy) NSString *provice;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *country;
@end

@implementation TCAddLinkmanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //所有控件杂一个scrollveiw上，以便滑动
    [self creatscroview];
    //创建控件
    [self creatAll];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Naviegation
    [self creatNavigation];
    
}

//创建Navigation
-(void)creatNavigation{
    if (!self.model) {
        self.title=@"新建联系人";
        self.deleteBtn.hidden=YES;
    }else{
        self.title=@"编辑联系人";
        [self assignByModel];
    }
    //保存按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:0];
    button.bounds = CGRectMake(0, 0, 40, 30);
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nameField becomeFirstResponder];
    self.phoneField.delegate=self;
    //发送通知，每当一个textfiled结束编辑，就会给相应的模型属性赋值。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nameFieldEndEditing)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(phoneFieldEndEditing)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detailAddressFieldEndEditing)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.detailAddressField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proviceFieldBeginEditing)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self.provinceField];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;    //让rootView禁止滑动
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)proviceFieldBeginEditing{
    [self.view endEditing:YES];
}
//赋值(编辑模式)
-(void)assignByModel{
    self.nameField.text = self.model.receiveName;
    self.phoneField.text = self.model.receiveTel;
    self.provinceField.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.receiveProvince,self.model.receiveCity,self.model.receiveCounty];
    self.detailAddressField.text = self.model.receiveAddress;
    self.provice = self.model.receiveProvince;
    self.city = self.model.receiveCity;
    self.country = self.model.receiveCounty;
}
-(void)save{
    [self saveandMoren:NO];
}

#pragma mark - 存储
- (void)saveandMoren:(BOOL)ifMORen{
    [self.view endEditing:YES];
//    self.addressInfo.state = LGAddressInfoCellStateSelected;
    if (self.nameField.text.length <= 0) {
        
        ToastError(@"收货人姓名不能为空");
        return;
    }
    
    if (self.phoneField.text.length==0) {
        ToastError(@"请您填写手机号码");
        return;
    }
    
    BOOL isTel=[Common checkTel:self.phoneField.text];
    if (!isTel) {
        ToastError(@"手机号码格式不对");
        return;
    }
    
    if (self.provinceField.text <= 0) {
        ToastError(@"请选择地址的省市");
        //return;
        return;
    }
    if (self.detailAddressField.text.length==0) {
        ToastError(@"请您填写详细的收货地址");
        return;
    }
//    1559938954848845609
    if (!self.model) {
        // 添加联系人
        NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
        [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
        [dict setObject:self.nameField.text forKey:@"receiveName"];
        [dict setObject:self.phoneField.text forKey:@"receiveTel"];
        [dict setObject:self.provice forKey:@"receiveProvince"];
        [dict setObject:self.city forKey:@"receiveCity"];
        [dict setObject:self.country forKey:@"receiveCounty"];
        [dict setObject:self.detailAddressField.text forKey:@"receiveAddress"];
        [dict setObject:@(self.linkType) forKey:@"categoryFlag"];
        [[HttpRequest sharedClient]httpRequestPOST:kReceiverSave parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            if ([responseObject[@"code"] integerValue]==200) {
                ToastSuccess(@"添加成功");
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else  {
        // 编辑联系人
        NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
        [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
        [dict setObject:self.model.receiverId forKey:@"receiverId"];
        [dict setObject:self.nameField.text forKey:@"receiveName"];
        [dict setObject:self.phoneField.text forKey:@"receiveTel"];
        [dict setObject:self.provice forKey:@"receiveProvince"];
        [dict setObject:self.city forKey:@"receiveCity"];
        [dict setObject:self.country forKey:@"receiveCounty"];
        [dict setObject:self.detailAddressField.text forKey:@"receiveAddress"];
        [[HttpRequest sharedClient]httpRequestPOST:kReceiverModifi parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            if ([responseObject[@"code"] integerValue]==200)  {
                 ToastSuccess(@"编辑成功");
            }
           
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark - 关闭键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.provinceField resignFirstResponder];
    [self.detailAddressField resignFirstResponder];
}

#pragma mark textfiled退出键盘时，将当前所编辑的内容传给模型
- (void)nameFieldEndEditing {
//    self.addressInfo.receiver=self.nameField.text;
}

- (void)phoneFieldEndEditing {
//    self.addressInfo.phoneNumber=self.phoneField.text;
}

- (void)detailAddressFieldEndEditing {
//    self.addressInfo.detailAddress=self.detailAddressField.text;
}

- (void)done {
    
}
//
//- (void)setAddressInfo:(LGAddressInfo *)addressInfo {
//    _addressInfo = addressInfo;
//    self.nameField.text = addressInfo.receiver;
//    self.phoneField.text = addressInfo.phoneNumber;
//    self.provinceField.text = addressInfo.location;
//    self.detailAddressField.text = addressInfo.detailAddress;
//}

-(void)setupCityPicker{
    
    AddressPickView *pickView = [[AddressPickView alloc]initWithType:2];
    WeakSelf;
    pickView.block = ^(NSString *province,NSString *city,NSString *district){
        weakSelf.provinceField.text=[NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        weakSelf.provice = province;
        weakSelf.city = city;
        weakSelf.country = district;
        [weakSelf.detailAddressField becomeFirstResponder];
    };
    self.provinceField.inputView = pickView;
}

-(void)click{
    
}
-(void)creatAll{
    
    UIView*passwordview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 40)];
    passwordview.backgroundColor=[UIColor whiteColor];
    //收货人
    UILabel*passlab= [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab.frame=CGRectMake(15, 0,70, 40);
    passlab.font=Font(12);
    passlab.text=@"收货人";
    [passwordview addSubview:passlab];
    UITextField*textfiled=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kWindowW-125, 40)];
    textfiled.placeholder=@"请输入姓名";
    
    self.nameField=textfiled;
    [passwordview addSubview:textfiled];
    textfiled.font = [UIFont systemFontOfSize:14];
    textfiled.returnKeyType = UIReturnKeyDone;
    textfiled.delegate = self;
    [self.scroview addSubview:passwordview];
    UIView*againpasswordview=[[UIView alloc]initWithFrame:CGRectMake(0, 61, kWindowW, 40)];
    againpasswordview.backgroundColor=[UIColor whiteColor];
    UILabel*passlab2= [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    passlab2.frame=CGRectMake(15, 0,70, 40);
    passlab2.font=Font(12);
    passlab2.text=@"手机号码";
    [againpasswordview addSubview:passlab2];
    [self.scroview addSubview:againpasswordview];
    UITextField*textfiled2=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kWindowW-125, 40)];
    textfiled2.placeholder=@"请输入收货人的手机号码";
    [againpasswordview addSubview:textfiled2];
    textfiled2.font = [UIFont systemFontOfSize:14];
    textfiled2.returnKeyType = UIReturnKeyDone;
    textfiled2.delegate = self;
    self.phoneField=textfiled2;
    [self.scroview addSubview:againpasswordview];
    UIView*passwordview3=[[UIView alloc]initWithFrame:CGRectMake(0, 102, kWindowW, 40)];
    passwordview3.backgroundColor=[UIColor whiteColor];
    //所在省市
    UILabel*passlab3= [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    passlab3.frame=CGRectMake(15,0,70, 40);
    passlab3.text=@"所在地区";
    passlab3.font=Font(12);
    [passwordview3 addSubview:passlab3];
    
    UITextField*textfiled3=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kWindowW-125, 40)];
    textfiled3.placeholder=@"请选择您的所在地区";
    self.provinceField=textfiled3;
    [passwordview3 addSubview:textfiled3];
    textfiled3.font = [UIFont systemFontOfSize:14];
    textfiled3.returnKeyType = UIReturnKeyDone;
    textfiled3.delegate = self;
    [self.scroview addSubview:passwordview3];
    
    UIView*againpasswordview4=[[UIView alloc]initWithFrame:CGRectMake(0, 143, kWindowW, 60)];
    againpasswordview4.backgroundColor=[UIColor whiteColor];
    //详细地址
    UILabel*passlab4= [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    passlab4.frame=CGRectMake(15, 0,70, 30);
    passlab4.text=@"详细地址";
    passlab4.font=Font(12);
    [againpasswordview4 addSubview:passlab4];
    //由于详细地址字数比较多，多以是textView
    UITextView*textView4=[[UITextView alloc]initWithFrame:CGRectMake(100, 0, kWindowW-125, 60)];
    [againpasswordview4 addSubview:textView4];
    
    textView4.font = [UIFont systemFontOfSize:14];
    textView4.returnKeyType = UIReturnKeyDone;
    textView4.delegate=self;
    self.detailAddressField=textView4;
    [self.scroview addSubview:againpasswordview4];
    
    UIButton*confirmbtn=[[UIButton alloc]init];
    confirmbtn.frame=CGRectMake(0, kWindowH-60-50-64, kWindowW, 40);
    confirmbtn.backgroundColor=[UIColor whiteColor];
    
    //删除地址
    UIButton*deleteaBtn=[UIButton borderButtonWithBackgroundColor:[UIColor orangeColor] title:@"删除联系人" titleLabelFont:Font(13) titleColor:[UIColor whiteColor] target:self action: @selector(delete1) clipsToBounds:YES];
    deleteaBtn.frame=CGRectMake(85, 5, kWindowW-170, 30);
    self.deleteBtn=confirmbtn;
    [confirmbtn addSubview:deleteaBtn];
    [self.scroview addSubview:confirmbtn];
    
    UIView*vi=[[UIView alloc]initWithFrame:CGRectMake(0, kWindowH-60-64, kWindowW, 50)];
    vi.backgroundColor=[UIColor whiteColor];
    [self.scroview addSubview:vi];
    //设置为默认地址
    UIButton*button=[UIButton borderButtonWithBackgroundColor:[UIColor redColor] title:@"设置为默认联系人" borColour:[UIColor redColor] titleLabelFont: [UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] target:self action:@selector(acquiesClick)  clipsToBounds:YES];
    button.frame=CGRectMake(85, 12, kWindowW-170, 30);
    [vi addSubview:button];
    if (!self.model) {
        confirmbtn.hidden=YES;
        vi.hidden=YES;
    }else{
        confirmbtn.hidden=NO;
        vi.hidden=NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    // [aTextfield resignFirstResponder];//关闭键盘
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 默认  按钮点击事件
-(void)acquiesClick{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:self.model.receiverId forKey:@"receiverId"];
    [[HttpRequest sharedClient] httpRequestPOST:kReceiverDefault parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        if ([responseObject[@"code"] integerValue]==200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark 删除
-(void)delete1{
    WeakSelf;
    //删除地址网络请求
    NSString *url = [NSString stringWithFormat:@"%@%@",kReceiverDelete,self.model.receiverId];
        [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            if ([responseObject[@"code"] integerValue]==200) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
}

-(void)deleteclick{
}

-(void)set{
}

#pragma mark 创建scrollView
-(void)creatscroview{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIScrollView*scroview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
    scroview.backgroundColor=LGLighgtBGroundColour235;
    scroview.contentSize=CGSizeMake(kWindowW, kWindowH+100);
    [self.view addSubview:scroview];
    self.scroview=scroview;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    if(textField == self.phoneField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            ToastError(@"请输入数字");
            return NO;
        }
    }
    //其他的类型不需要检测，直接写入
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.provinceField) {
        [self setupCityPicker];
//        //控制整个功能是否启用。

    }else{
        
    }
}

@end
