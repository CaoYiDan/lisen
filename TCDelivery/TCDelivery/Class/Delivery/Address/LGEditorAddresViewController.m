//
//  LGEditorAddresViewController.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/31.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGEditorAddresViewController.h"

#import "LGAddressInfo.h"
#import "LGAddresModel.h"

#define NUMBERS @"0123456789\n"
@interface LGEditorAddresViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>
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
//数组，本地的省市文件
@property (nonatomic, strong) NSArray *locData;
// 选择器选中的省份
@property (nonatomic, assign) NSInteger provinceIndex;
// 选择器选中的城市
@property (nonatomic, assign) NSInteger cityIndex;
@property(nonatomic,strong)UIButton*deleteBtn;
@end

@implementation LGEditorAddresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //所有控件杂一个scrollveiw上，以便滑动
    [self creatscroview];
    //创建控件
    [self creatall];
    //初始化模型
    [self  setupaddressInfo];
    //初始化本地省市数组
    [self locData];
}
//初始化模型
-(void)setupaddressInfo{
    if (!_addressInfo) {
        _addressInfo = [[LGAddressInfo alloc] init];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Naviegation
    [self creatNavigation];
    
}
//创建Navigation
-(void)creatNavigation{
    //由isadd判断是添加还是编辑
    if (self.isAdd) {
    self.title=@"收货地址";
    self.deleteBtn.hidden=YES;
    }else{
      self.title=@"编辑收货地址";
        self.addressInfo=self.editaddressInfo;
    }
    //保存按钮
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:@"保存" forState:UIControlStateNormal];
    
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

    //创建pickView
    [self setupCityPicker];
}
-(void)save{
    [self saveandMoren:NO];
}

#pragma mark - 存储
- (void)saveandMoren:(BOOL)ifMORen{
    [self.view endEditing:YES];
    self.addressInfo.state = LGAddressInfoCellStateSelected;
    if (self.addressInfo.receiver.length <= 0) {
        
        ToastError(@"收货人姓名不能为空");
        return;
    }
    
    if (self.addressInfo.phoneNumber.length==0) {
        ToastError(@"请您填写手机号码");
        return;
    }
    
    BOOL isTel=[Common checkTel:self.addressInfo.phoneNumber];
    if (!isTel) {
        ToastError(@"手机号码格式不对");
        return;
    }
    
    if (self.addressInfo.location.length <= 0) {
        ToastError(@"请选择地址的省市");
        //return;
        return;
    }
    if (self.addressInfo.detailAddress.length==0) {
        ToastError(@"请您填写详细的收货地址");
        return;
    }

    if ([self.title isEqualToString:@"收货地址"]) {
    // 添加收货地址
//    [LGAddresModel addWithAreaId:[StorageUtil getRoleId] telephone:self.addressInfo.phoneNumber detail:self.addressInfo.detailAddress fullname:self.addressInfo.receiver location:self.addressInfo.location noOrYes:ifMORen success:^(BOOL result, NSNumber *resultCode, NSString *message, LGAddressInfo *address, NSArray *addresses) {
//            
//        } failure:^(NSError *error) {
//            
//        }];
//
    } else if ([self.title isEqualToString:@"编辑收货地址"]) {
        NSLog(@"%@",self.addressInfo.defaultAddress);
        //更新收货地址
        NSString*AddressId=[NSString stringWithFormat:@"%ld",(long)self.editaddressInfo.addressId];
//        [LGAddresModel updataWithAreaId:[StorageUtil getRoleId] addresId:AddressId telephone:self.addressInfo.phoneNumber detail:self.addressInfo.detailAddress fullname:self.addressInfo.receiver   location:self.addressInfo.location
//                                 defaultAddress:self.addressInfo.defaultAddress success:^(BOOL result, NSNumber *resultCode, NSString *message, LGAddressInfo *address, NSArray *addresses) {
//         
//        } failure:^(NSError *error) {
//           
//        }];
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
    self.addressInfo.receiver=self.nameField.text;
}

- (void)phoneFieldEndEditing {
    self.addressInfo.phoneNumber=self.phoneField.text;
}

- (void)detailAddressFieldEndEditing {
    self.addressInfo.detailAddress=self.detailAddressField.text;
}

- (void)done {
   
}
//
- (void)setAddressInfo:(LGAddressInfo *)addressInfo {
    _addressInfo = addressInfo;
    self.nameField.text = addressInfo.receiver;
    self.phoneField.text = addressInfo.phoneNumber;
    self.provinceField.text = addressInfo.location;
    self.detailAddressField.text = addressInfo.detailAddress;
}

-(void)setupCityPicker{
    
//    _cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kWindowH-150, kWindowW, 150)];
//    _cityPicker.delegate = self;
//    _cityPicker.dataSource = self;
//    _cityPicker.backgroundColor = LGLighgtBGroundColour;
//    self.provinceField.inputView = _cityPicker;
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 44)];
//    UIButton*confirm=[UIButton buttonWithBackgroundColor:LGDarkRedColur title:@"请您选择您所在的地区" titleLabelFont:Font(14) titleColor:[UIColor whiteColor] target:self action:@selector(click) clipsToBounds:YES];
////    toolbar.backgroundColor = LGBaseColour;
//    confirm.frame=CGRectMake(40, 7, kWindowW-80, 30);
//    [toolbar addSubview:confirm];
//
//    self.provinceField.inputAccessoryView = toolbar;
    
}
-(void)click{

}
-(void)creatall{
    
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
    UIView*againpasswordview4=[[UIView alloc]initWithFrame:CGRectMake(0, 143, kWindowW, 40)];
    againpasswordview4.backgroundColor=[UIColor whiteColor];
    //详细地址
    UILabel*passlab4= [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    
    passlab4.frame=CGRectMake(15, 0,70, 40);
    passlab4.text=@"详细地址";
    passlab4.font=Font(12);
    [againpasswordview4 addSubview:passlab4];
    //由于详细地址字数比较多，多以是textView
    UITextView*textView4=[[UITextView alloc]initWithFrame:CGRectMake(100, 0, kWindowW-125, 40)];
    [againpasswordview4 addSubview:textView4];

    textView4.font = [UIFont systemFontOfSize:14];
    textView4.returnKeyType = UIReturnKeyDone;
    textView4.delegate=self;
    self.detailAddressField=textView4;

    [self.scroview addSubview:againpasswordview4];
    
    UIButton*confirmbtn=[[UIButton alloc]init];
    confirmbtn.frame=CGRectMake(0, 147+50, kWindowW, 40);
    confirmbtn.backgroundColor=[UIColor whiteColor];
    
    //删除地址
    UIButton*deleteaBtn=[UIButton borderButtonWithBackgroundColor:[UIColor whiteColor] title:@"删除地址" titleLabelFont:Font(13) titleColor:[UIColor redColor] target:self action: @selector(delete1) clipsToBounds:YES];
   
    deleteaBtn.frame=CGRectMake(85, 5, kWindowW-170, 30);
    self.deleteBtn=confirmbtn;
        [confirmbtn addSubview:deleteaBtn];
        [self.scroview addSubview:confirmbtn];
   
    UIView*vi=[[UIView alloc]initWithFrame:CGRectMake(0, 147+100, kWindowW, 50)];
    vi.backgroundColor=[UIColor whiteColor];
    [self.scroview addSubview:vi];
    
    //设置为默认地址
    UIButton*button=[UIButton borderButtonWithBackgroundColor:[UIColor redColor] title:@"设置为默认地址" borColour:[UIColor redColor] titleLabelFont: [UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] target:self action:@selector(acquiesClick)  clipsToBounds:YES];
    button.frame=CGRectMake(85, 12, kWindowW-170, 30);
    [vi addSubview:button];
    if (self.isAdd) {
        
    }else{
//编辑地址，将上个viewConrolView传过来的模型给各个textfiled赋值
        self.nameField.text=self.editaddressInfo.receiver;
        self.detailAddressField.text=self.editaddressInfo.detailAddress;
        self.provinceField.text=self.editaddressInfo.location;
        self.phoneField.text=self.editaddressInfo.phoneNumber;
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
    if ([self.title isEqualToString:@"收货地址"]) {
        [self saveandMoren:YES];
        return;
    }
    
//    [self saveandMoren:YES];
    NSString*adddresId=[NSString stringWithFormat:@"%ld",(long)self.addressInfo.addressId];
    WeakSelf;
//    [LGAddresModel setDefaultWithId:adddresId success:^(BOOL result) {
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    } failure:^(NSError *error) {
//        ToastError(@"亲,好像出了点小错误");
//    }];

}

#pragma mark 删除
-(void)delete1{
    WeakSelf;
    NSString*addresId=[NSString stringWithFormat:@"%ld",(long)self.editaddressInfo.addressId];

//删除地址网络请求
    NSMutableDictionary*dict=[[NSMutableDictionary
                               alloc]init];
    [dict setObject:addresId forKey:@"addressId"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    [dict setObject:self.addressInfo.defaultAddress forKey:@"defaultAddress"];

//    [[HttpRequest sharedClient]httpRequestPOST:kUrlAddressDelete
//      parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
//    [weakSelf.navigationController popViewControllerAnimated:YES];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//    ToastError(@"亲,好像出了点小错误");
//  }];

}
-(void)deleteclick{

}

-(void)set{

    
}

#pragma mark 创建scrollView
-(void)creatscroview{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIScrollView*scroview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kWindowW, kWindowH)];
    scroview.backgroundColor=[UIColor redColor];
    scroview.contentSize=CGSizeMake(kWindowW, kWindowH+100);
    [self.view addSubview:scroview];
    self.scroview=scroview;
}


//移除通知
-(void)dealloc{
  
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
//            [alert release];
            return NO;
        }
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}
@end
