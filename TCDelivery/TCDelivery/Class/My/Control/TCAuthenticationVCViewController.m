
//
//  TCAuthenticationVCViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//

#import "TCAuthenticationVCViewController.h"

#import "TCBaseTextView.h"
#import "AddressPickView.h"
#import "BDImagePicker.h"
#define  Space 10
const CGFloat TextFiledHeight = 35.0;
const CGFloat ImageViewHeight = 50.0;
const CGFloat ImageViewWidth = 100.0;
@interface TCAuthenticationVCViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
//所属地区
@property(nonatomic,strong) NSString*province;//省
@property(nonatomic,strong) NSString*city;//市
@property(nonatomic,strong) NSString*county;//区

@end

@implementation TCAuthenticationVCViewController
{
    //所属地区
    UIButton*_addressBtn;
    //公司名称
    TCBaseTextView*_compentmentName;
    //行业
    TCBaseTextView*_industry;
    //负责人姓名 ,
    TCBaseTextView*_leader;
    //联系电话
    TCBaseTextView*_phone;
    //身份证号码
    TCBaseTextView*_identificationCard;
    //营业执照号码
    TCBaseTextView*_businessLicence;
    //营业执照电子版
    UIImageView*_image1;
    //身份证正面图片
    UIImageView*_image2;
    //身份证背面图片
    UIImageView*_image3;
    //当前上传的imagView
    UIImageView*_chosedImageView;
    
    UIImagePickerController *pickerController;
    NSInteger _index;
    
    //上传得到的网络图片路径
    NSString*_imagePath1;
    NSString*_imagePath2;
    NSString*_imagePath3;
    //选取照片
    UIButton*choseImageBtn1;
    UIButton*choseImageBtn2;
    UIButton*choseImageBtn3;
    //申请认证按钮
    UIButton*_applicationCertification;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.title=@"身份认证";
    //创建UI
    [self createUI];
    
    //请求用户信息数据
    if ([self.userApplyStatus isEqualToString:@"已认证"]) {
        //已认证，请求用户认证的信息
        [self getUserMessage];
        //并且隐藏按钮
       _applicationCertification.hidden=YES;
        choseImageBtn1.hidden=YES;
        choseImageBtn2.hidden=YES;
        choseImageBtn3.hidden=YES;
        //用一个View 覆盖全屏----使所有的编辑都不可编辑
        UIView*coverView=[[UIView alloc]initWithFrame:self.view.bounds];
        coverView.backgroundColor=kRGBAColor(0, 0, 0, 0);
        coverView.userInteractionEnabled=YES;
        [self.view addSubview:coverView];
    }else if ([self.userApplyStatus isEqualToString:@"未通过"]) {
            //已认证，请求用户认证的信息
            [self getUserMessage];
        }
}
  //请求用户信息数据--已认证
-(void)getUserMessage{
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[StorageUtil getRoleId] forKey:@"id"];
    [[HttpRequest sharedClient]httpRequestPOST:kUserMessage parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSString*success=responseObject[@"success"];
        if ([success integerValue]==1) {
            //根据已认证的信息，给UI赋值
             [self createValuesWithDictionary:responseObject[@"data"]];
        }
        
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
     }];
}
//根据已认证的信息，给UI赋值
-(void)createValuesWithDictionary:(NSDictionary*)dict{

    [_addressBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",dict[@"province"],dict[@"city"],dict[@"county"]] forState:0];
    self.province=dict[@"province"];
     self.city=dict[@"city"];
     self.county=dict[@"county"];
    _compentmentName.textFiled.text=dict[@"realName"];
    _industry.textFiled.text=dict[@"industry"];
    _leader.textFiled.text=dict[@"headName"];
    _phone.textFiled.text=dict[@"phone"];
    
    _identificationCard.textFiled.text=dict[@"identityCode"];
    _businessLicence.textFiled.text=dict[@"businessLicence"];
    [_image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"imgHeadPath"],dict[@"businessLicenceImage"]]]];
    [_image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"imgHeadPath"],dict[@"identityImageFront"]]]];
    [_image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"imgHeadPath"],dict[@"identityImageBack"]]]];
    
    _imagePath1=dict[@"businessLicenceImage"];
    _imagePath2=dict[@"identityImageFront"];
    _imagePath3=dict[@"identityImageBack"];
}
-(void)noAction{}//不做任何处理
-(void)createUI{
    UILabel*rightItem=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    rightItem.text=[NSString stringWithFormat:@"(%@)",self.userApplyStatus];
    rightItem.font=Font(12);
    rightItem.textColor=[UIColor blackColor];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem=item;
    
    UIScrollView*baseView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    baseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //所属地区
    UIView*baseAdderssView=[[UIView alloc]init];
    [baseView addSubview:baseAdderssView];
    [baseAdderssView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(20);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
    UILabel*addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, TextFiledHeight)];
    addressLabel.font=Font(13);
    addressLabel.text=@"所属地区";
    addressLabel.textAlignment=NSTextAlignmentCenter;
    [baseAdderssView addSubview:addressLabel];
    
    UIButton*addressBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, 0, 160, TextFiledHeight)];
    [addressBtn setTitleColor:[UIColor blackColor] forState:0];
    _addressBtn=addressBtn;
    addressBtn.layer.cornerRadius=5;
    addressBtn.titleLabel.font=Font(12);
    [addressBtn addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchDown];
    addressBtn.layer.borderColor=LGLighgtBGroundColour235.CGColor;
    addressBtn.layer.borderWidth=1;
    [baseAdderssView addSubview:addressBtn];
    
    
    //公司名称
    TCBaseTextView*compentmentName=[[TCBaseTextView alloc]init];
    [compentmentName setText:@"公司名称"];
    _compentmentName=compentmentName;
    compentmentName.type=2;
    [baseView addSubview:compentmentName];
    [compentmentName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(baseAdderssView.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
    //行业
    TCBaseTextView*industry=[[TCBaseTextView alloc]init];
    [industry setText:@"行业"];
    _industry=industry;
    industry.type=2;
    [baseView addSubview:industry];
    [industry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(compentmentName.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
     //负责人姓名
    TCBaseTextView*leader=[[TCBaseTextView alloc]init];
    [leader setText:@"负责人姓名"];
    _leader=leader;
    leader.type=2;
    [baseView addSubview:leader];
    [leader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(industry.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
    
    //联系电话
    TCBaseTextView*phone=[[TCBaseTextView alloc]init];
    [phone setText:@"联系电话"];
    _phone=phone;
    phone.type=2;
    [baseView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.offset(0);
        make.top.equalTo(leader.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
    //省份证号码
    TCBaseTextView*identificationCard=[[TCBaseTextView alloc]init];
    [identificationCard setText:@"身份证号码"];
    identificationCard.type=2;
    _identificationCard=identificationCard;
    identificationCard.textFiled.font=Font(11);
    [baseView addSubview:identificationCard];
    [identificationCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(phone.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
    //营业执照号码
    TCBaseTextView*businessLicence=[[TCBaseTextView alloc]init];
    [businessLicence setText:@"营业执照号码"];
    businessLicence.type=2;
    _businessLicence=businessLicence;
    businessLicence.textFiled.font=Font(11);
    [baseView addSubview:businessLicence];
    [businessLicence mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(identificationCard.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
//    营业执照电子版
    UIView*photoBaseView1=[[UIView alloc]init];
    [baseView addSubview:photoBaseView1];
    UILabel*businessLicenceLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, TextFiledHeight)];
    businessLicenceLabel.font=Font(11);
    businessLicenceLabel.text=@"营业执照电子版";
    [photoBaseView1 addSubview:businessLicenceLabel];
    
    UIImageView*businessLicenceImage=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, ImageViewWidth, ImageViewHeight)];
    _image1=businessLicenceImage;
    businessLicenceImage.tag=11;
    
    businessLicenceImage.layer.borderColor=LGLighgtBGroundColour235.CGColor;
    businessLicenceImage.layer.borderWidth=1;
    [photoBaseView1 addSubview:businessLicenceImage];
    businessLicenceImage.backgroundColor=LGLighgtBGroundColour235;
    
    UIButton*choseBtn1=[[UIButton alloc]initWithFrame:CGRectMake(205, 10, 60, TextFiledHeight)];
    [choseBtn1 addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
    choseBtn1.tag=1;
    choseImageBtn1=choseBtn1;
    choseBtn1.backgroundColor=KTCGreen;
    choseBtn1.titleLabel.font=Font(12);
    [choseBtn1 setTitle:@"选取照片" forState:0];
    [photoBaseView1 addSubview:choseBtn1];
    
    [photoBaseView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.offset(0);
        make.size.offset(CGSizeMake(270, ImageViewHeight));
        make.top.equalTo(businessLicence.bottom).offset(Space+10);
    }];
     //身份证正面照
    UIView*photoBaseView2=[[UIView alloc]init];
    [baseView addSubview:photoBaseView2];
    UILabel*frontIdentificationCard=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, TextFiledHeight)];
    frontIdentificationCard.font=Font(11);
    frontIdentificationCard.text=@"身份证正面照";
    frontIdentificationCard.textAlignment=NSTextAlignmentCenter;
    [photoBaseView2 addSubview:frontIdentificationCard];
    
    UIImageView*frontIdentificationCardImage=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, ImageViewWidth, ImageViewHeight)];
    _image2=frontIdentificationCardImage;
    frontIdentificationCardImage.tag=12;
    frontIdentificationCardImage.layer.borderColor=LGLighgtBGroundColour235.CGColor;
    frontIdentificationCardImage.layer.borderWidth=1;
    [photoBaseView2 addSubview:frontIdentificationCardImage];
   frontIdentificationCardImage.backgroundColor=LGLighgtBGroundColour235;
    
    UIButton*choseBtn2=[[UIButton alloc]initWithFrame:CGRectMake(205, 10, 60, TextFiledHeight)];
    choseImageBtn2=choseBtn2;
    choseBtn2.backgroundColor=KTCGreen;
    [choseBtn2 addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
    choseBtn2.tag=2;
    choseBtn2.titleLabel.font=Font(12);
    [choseBtn2 setTitle:@"选取照片" forState:0];
    [photoBaseView2 addSubview:choseBtn2];
    
    [photoBaseView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.offset(0);
        make.size.offset(CGSizeMake(270, ImageViewHeight));
        make.top.equalTo(photoBaseView1.bottom).offset(Space+10);
    }];
    //身份证背面照
    UIView*photoBaseView3=[[UIView alloc]init];
    [baseView addSubview:photoBaseView3];
    UILabel*oppositeIdentifier=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, TextFiledHeight)];
    oppositeIdentifier.font=Font(11);
    oppositeIdentifier.text=@"身份证背面照";
    oppositeIdentifier.textAlignment=NSTextAlignmentCenter;
    [photoBaseView3 addSubview:oppositeIdentifier];
    
    UIImageView*oppositeIdentifierImage=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, ImageViewWidth, ImageViewHeight)];
    _image3=oppositeIdentifierImage;
    oppositeIdentifierImage.tag=13;
    [photoBaseView3 addSubview:oppositeIdentifierImage];
    oppositeIdentifierImage.backgroundColor=LGLighgtBGroundColour235;
    
    oppositeIdentifierImage.layer.borderColor=LGLighgtBGroundColour235.CGColor;
    oppositeIdentifierImage.layer.borderWidth=1;
    UIButton*choseBtn3=[[UIButton alloc]initWithFrame:CGRectMake(205, 10, 60, TextFiledHeight)];
    choseImageBtn3=choseBtn3;
    choseBtn3.backgroundColor=KTCGreen;
    choseBtn3.titleLabel.font=Font(12);
    [choseBtn3 addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
    choseBtn3.tag=3;
    [choseBtn3 setTitle:@"选取照片" forState:0];
    [photoBaseView3 addSubview:choseBtn3];
    
    [photoBaseView3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.offset(0);
        make.size.offset(CGSizeMake(270, ImageViewHeight));
        make.top.equalTo(photoBaseView2.bottom).offset(Space+10);
    }];
    
    //申请认证
    UIButton*applicationCertification=[[UIButton alloc]init];
    [applicationCertification setTitle:@"申请认证" forState:UIControlStateNormal];
    _applicationCertification=applicationCertification;
    applicationCertification.layer.cornerRadius=5;
    [applicationCertification addTarget:self action:@selector(certigication) forControlEvents:UIControlEventTouchUpInside];
    applicationCertification.backgroundColor=KTCBlueColor;
    [baseView addSubview:applicationCertification];
    [applicationCertification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.offset(CGSizeMake(140, 35));
        make.top.equalTo(photoBaseView3.bottom).offset(30);
    }];
    
    baseView.contentSize=CGSizeMake(0, 700);
}

#pragma  mark  申请认证点击事件
-(void)certigication{

    @try {
        NSMutableDictionary*dict=[NSMutableDictionary dictionary];
        
        [dict setObject:self.province forKey:@"province"];//省
        [dict setObject:self.city forKey:@"city"];//市
        [dict setObject:self.county forKey:@"county"];//区
        [dict setObject:_compentmentName.textFiled.text forKey:@"realName"];//公司名称
        [dict setObject:_industry.textFiled.text forKey:@"industry"];//行业
        [dict setObject:_phone.textFiled.text forKey:@"phone"];//电话
        [dict setObject:_leader.textFiled.text forKey:@"headName"];//负责人姓名
        [dict setObject:_identificationCard.textFiled.text forKey:@"identityCode"];//省份证号码
        [dict setObject:_businessLicence.textFiled.text forKey:@"businessLicence"];//营业执照号码
    
        [dict setObject:_imagePath1 forKey:@"businessLicenceImage"];//营业执照电子版
        [dict setObject:_imagePath2 forKey:@"identityImageFront"];//省份证正面
        [dict setObject:_imagePath3 forKey:@"identityImageBack"];//省份证背面
        [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];//userID
        
        //认证接口
        [[HttpRequest sharedClient]httpRequestPOST:kApplyShipping parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            NSLog(@"%@",responseObject[@"code"]);
            
            NSString*sucess=responseObject[@"success"];
            if ([sucess intValue]) {
                 ToastSuccess(@"提交成功，等待审核");
//                //将认证状态置为 待审核
                [StorageUtil saveUserStatus:APPLY_STATUS_APPLYING];
//                // 发送通知,给个人中心界面，以此决定好要不要更新tableView
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginStatusChange object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            ToastError(responseObject[@"info"]);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            ToastError(@"糟糕，网络出错了");
        }];

    } @catch (NSException *exception) {
        ToastError(@"请填写完整信息");
    } @finally {
        
    }
}

#pragma  mark 所属地区
-(void)addressClick:(UIButton*)btn{
    WeakSelf;
    AddressPickView*pickView = [AddressPickView shareInstance];
    [self.view addSubview:pickView];
    
    pickView.block = ^(NSString *province,NSString *city,NSString *district){
        [btn setTitle:[NSString stringWithFormat:@"%@ %@ %@",province,city,district] forState:0];
        weakSelf.province=province;
        weakSelf.city=city;
        weakSelf.county=district;
    };
}
#pragma  mark 调取相册
-(void)photo{
    WeakSelf;
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {

            UIImageView*photoImage=[weakSelf.view viewWithTag:_index+10];
            [photoImage setImage:image];
            //上传图片---获取图片网络地址
            [weakSelf upDateHeadIcon:image];
    }];
}
#pragma  mark 上传图片
- (void)upDateHeadIcon:(UIImage *)photo{
    if (isNull(photo)) {
        return;
    }
    //菊花显示
    [MBProgressHUD showHUDAddedTo:_chosedImageView animated:YES];
    //申请提交按钮不可点击
    _applicationCertification.userInteractionEnabled=NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];

    NSData * imageData = UIImageJPEGRepresentation(photo,0.5);
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"text"];
    [imageData writeToFile:fullPath atomically:NO];
   
    NSMutableDictionary * dictT = [[NSMutableDictionary alloc]init];
    [dictT setObject:imageData forKey:@"image"];
    
    [manager POST:kPostPhoto parameters:dictT constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"text.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //将二进制转为字符串
        NSString *result2 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        //字符串转字典
        NSDictionary*dict=[self dictionaryWithJsonString:result2];
        NSLog(@"%@",dict);
        if (_index==1) {
            _imagePath1=dict[@"image"];
            NSLog(@"%@",_imagePath1);
        }else if (_index==2){
            _imagePath2=dict[@"image"];
        }else if (_index==3){
            _imagePath3=dict[@"image"];
        }
        [MBProgressHUD hideHUDForView:_chosedImageView animated:YES];
        //申请提交按钮可点击
        _applicationCertification.userInteractionEnabled=YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ToastError(@"上传失败");
        [MBProgressHUD hideHUDForView:_chosedImageView animated:YES];
        _applicationCertification.userInteractionEnabled=YES;
    }];
}

#pragma  mark  将字符串转成字典
-(id )dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        return nil;
    }
    
    return dic;
}

-(void)chose:(UIButton*)btn{
    
    _index=btn.tag;
    if (_index==1) {
        _chosedImageView=_image1;
    }else if (_index==2){
        _chosedImageView=_image2;
    }else if (_index==3){
        _chosedImageView=_image3;
    }
    
    [self photo];
}


@end
