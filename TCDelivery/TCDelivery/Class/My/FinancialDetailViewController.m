//
//  FinancialDetailViewController.m
//  TianMing
//
//  Created by 李智帅 on 2017/5/22.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import "FinancialDetailViewController.h"
#import "TCBaseTextView.h"
#import "TCBaseMenu.h"
//#import "LXPopOverMenu.h"
#import "BDImagePicker.h"
#import "PriceCollectionViewCell.h"
#import "SDCycleScrollView.h"
#define  Space 6
@interface FinancialDetailViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PriceViewCollectionViewDelegate>
{
    
    UICollectionView * _collectionView;
    UIScrollView*baseView;
    UIImageView * _secondIV;
    UIImageView * _imageView1;
    UIImageView * _imageView2;
    UITextView * _remarkTV;
    //车牌号
    
    //行驶证号
    //TCBaseTextView*_driverNumber;
    //司机姓名
    //TCBaseTextView*_driverName;
    //司机电话
    //TCBaseTextView*_phone;
    //车类型
    //TCBaseTextView*_carType;
    //车长度
    //TCBaseMenu*_carLength;
    //载重
    //TCBaseTextView*_carLoad;
    //提交按钮
    UIButton*_applicationCertification;
    //道路运输证
    //TCBaseTextView*_loadNumber;
    
}
@property(nonatomic,strong)NSMutableArray * bannerArray;
@property(nonatomic,strong)NSMutableArray * carArray;
@property(nonatomic,strong)UITextView * remarkTV;
@property(nonatomic,strong)TCBaseTextView*carNumber;
@property(nonatomic,strong)TCBaseTextView*carType;
@property(nonatomic,strong)TCBaseTextView*phone;
@property(nonatomic,strong)TCBaseTextView*driverName;
@property(nonatomic,assign)int selected;
//车辆类型
@property(nonatomic,strong)NSMutableArray*carTypeArr;
@property(nonatomic,copy)NSString * imgStr1;
@property(nonatomic,copy)NSString * imgStr2;
@end

@implementation FinancialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self createNav];
    [self createBanner];
    
    // Do any additional setup after loading the view.
}
-(void)keyboardHide{
    
    [self.phone.textFiled resignFirstResponder];
    [self.driverName.textFiled resignFirstResponder];
    
    if ([self.titleStr isEqualToString:@"ETC卡"]) {
        
        [self.carNumber.textFiled resignFirstResponder];
        [self.carType.textFiled resignFirstResponder];
        
    }if ([self.titleStr isEqualToString:@"车险服务"]) {
        
        [self.remarkTV resignFirstResponder];
        
    }if ([self.titleStr isEqualToString:@"驾乘座位险"]) {
        
        [self.remarkTV resignFirstResponder];
    }
    
}

#pragma mark - createUI
- (void)createUI{

    
    UIScrollView*aBaseView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    baseView = aBaseView;
    baseView.backgroundColor=[UIColor whiteColor];
    baseView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:baseView];
    
    int offsetH = 140;
    SDCycleScrollView * _adScrol = [[SDCycleScrollView alloc]init];
    _adScrol.imageURLStringsGroup = self.bannerArray;
    _adScrol.bannerImageViewContentMode=UIViewContentModeScaleToFill;
    _adScrol.infiniteLoop = YES;
    _adScrol.delegate = self;
    _adScrol.placeholderImage = [UIImage imageNamed:@"1.jpg"];
    //adScrol.dotColor = [UIColor whiteColor];
    _adScrol.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    [baseView addSubview:_adScrol];
    [_adScrol mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        make.top.offset(0);
        make.left.offset(0);
        make.height.offset(SCREEN_W/2.7);
        make.width.offset(SCREEN_W);
        
    }];
    NSMutableArray * mutableArr = [NSMutableArray arrayWithCapacity:0];
    [mutableArr addObject:@"tc1a.jpg"];
    [mutableArr addObject:@"tc1b.jpg"];
    [mutableArr addObject:@"tc2a.jpg"];
    [mutableArr addObject:@"tc2b.jpg"];
    [mutableArr addObject:@"tc3a.jpg"];
    [mutableArr addObject:@"tc3b.jpg"];
    UIImageView * firstIV = [[UIImageView alloc]init];
    //firstIV.layer.borderColor = [UIColor blackColor].CGColor;
    //firstIV.layer.borderWidth = 1;
    [baseView addSubview:firstIV];
    [firstIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(SCREEN_W/2.7+20);
        make.left.offset(10);
        make.height.offset(offsetH);
        make.width.offset(SCREEN_W-20);
        
    }];

    UIImageView * secondIV = [[UIImageView alloc]init];
    //secondIV.layer.borderColor = [UIColor blackColor].CGColor;
    //secondIV.layer.borderWidth = 1;
    [baseView addSubview:secondIV];
    _secondIV = secondIV;
    [secondIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstIV.mas_bottom).offset(20);
        make.left.offset(SCREEN_W/2-70);
        make.height.offset(offsetH);
        make.width.offset(140);
        
    }];

    if ([self.titleStr isEqualToString:@"ETC卡"]) {
        
        firstIV.image = [UIImage imageNamed:mutableArr[0]];
        secondIV.image = [UIImage imageNamed:mutableArr[1]];
        [self createETC];
        
    }else if ([self.titleStr isEqualToString:@"车险服务"]){
        
        firstIV.image = [UIImage imageNamed:mutableArr[2]];
        secondIV.image = [UIImage imageNamed:mutableArr[3]];
        
        [self createCarSevice];
    
    }else {
    
        firstIV.image = [UIImage imageNamed:mutableArr[4]];
        secondIV.image = [UIImage imageNamed:mutableArr[5]];
        [self createCarSeatSevice];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [baseView addGestureRecognizer:tapGestureRecognizer];
    
    
}

#pragma mark - createETC
- (void)createETC{

    //车牌号
    TCBaseTextView*carNumber=[[TCBaseTextView alloc]init];
    [carNumber setText:@"车牌号"];
    self.carNumber=carNumber;
    carNumber.type=2;
    [baseView addSubview:carNumber];
    [carNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_secondIV.mas_bottom).offset(20);
        make.width.offset(SCREEN_W-20);
        make.height.offset(30);
    }];
    
    //司机姓名
    TCBaseTextView*driverName=[[TCBaseTextView alloc]init];
    [driverName setText:@"司机姓名"];
    self.driverName=driverName;
    driverName.type=2;
    [baseView addSubview:driverName];
    [driverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(carNumber.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
    }];
    //司机电话
    TCBaseTextView*phone=[[TCBaseTextView alloc]init];
    [phone setText:@"司机电话"];
    self.phone=phone;
    self.phone.type=2;
    [baseView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(driverName.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
    }];
    
    //车类型
    TCBaseTextView*carType=[[TCBaseTextView alloc]init];
    [baseView addSubview:carType];
    [carType setText:@"车辆类型"];
    self.carType=carType;
    self.carType.type=2;
    [carType mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.top.equalTo(phone.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
        
    }];
    //申请认证
    UIButton*applicationCertification=[[UIButton alloc]init];
    [applicationCertification setTitle:@"提交" forState:UIControlStateNormal];
    _applicationCertification=applicationCertification;
    applicationCertification.layer.cornerRadius=5;
    applicationCertification.backgroundColor = KTCBlueColor;
    [applicationCertification addTarget:self action:@selector(certigication) forControlEvents:UIControlEventTouchUpInside];
    //applicationCertification.backgroundColor=KTCBlueColor;
    [baseView addSubview:applicationCertification];
    [applicationCertification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.mas_offset(CGSizeMake(140, 30));
        make.top.equalTo(_carType.mas_bottom).offset(30);
    }];
    
    baseView.contentSize=CGSizeMake(0, 900);
}


#pragma mark - createCarSevice车险服务 10 20 tag
- (void)createCarSevice{
    
    
    
    [self.carArray addObject:@"机动车辆损失险"];
    [self.carArray addObject:@"第三者责任险"];
    [self.carArray addObject:@"车上人员责任险"];
    [self.carArray addObject:@"发动机特别损失险"];
    [self.carArray addObject:@"发动机涉水损失险"];
    [self.carArray addObject:@"玻璃单独破碎险"];
    [self.carArray addObject:@"车身划痕损失险"];
    [self.carArray addObject:@"不计免赔率特约险"];
    [self.carArray addObject:@"交强险"];
    [self.carArray addObject:@"盗抢险"];
    
    //司机姓名
    TCBaseTextView*driverName=[[TCBaseTextView alloc]init];
    [driverName setText:@"姓名"];
    self.driverName=driverName;
    driverName.type=2;
    [baseView addSubview:driverName];
    [driverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_secondIV.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
    }];
    //司机电话
    TCBaseTextView*phone=[[TCBaseTextView alloc]init];
    [phone setText:@"电话"];
    self.phone=phone;
    self.phone.type=2;
    [baseView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(driverName.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
    }];
    
    UILabel * driverCodeLab = [[UILabel alloc]init];
    driverCodeLab.text = @"行驶证";
    driverCodeLab.font = [UIFont systemFontOfSize:13];
    driverCodeLab.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:driverCodeLab];
    [driverCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(phone.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    
    UIButton * driverCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    driverCodeBtn.backgroundColor = KTCBlueColor;
    driverCodeBtn.tag = 10;
    [driverCodeBtn setTitle:@"浏览" forState:UIControlStateNormal];
    [driverCodeBtn addTarget:self action:@selector(driverCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:driverCodeBtn];
    [driverCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(phone.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCodeLab.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(60, 25));
        
    }];
    
    UIImageView * imageView1 = [[UIImageView alloc]init];
    _imageView1 = imageView1;
    imageView1.layer.borderColor = [UIColor blackColor].CGColor;
    imageView1.layer.borderWidth = 0.5;
    [baseView addSubview: imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(driverCodeBtn.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCodeLab.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(200,140));
        
    }];
    
    UIView * firstLine = [[UIView alloc]init];
    firstLine.backgroundColor = KMainColor;
    [baseView addSubview:firstLine];
    
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView1.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_W,1));
        
    }];
    
    UILabel * driverCode = [[UILabel alloc]init];
    driverCode.text = @"身份证";
    driverCode.font = [UIFont systemFontOfSize:13];
    driverCode.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:driverCode];
    [driverCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstLine.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    
    UIButton * driverCodeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    driverCodeBtn2.backgroundColor = KTCBlueColor;
    driverCodeBtn2.tag = 20;
    [driverCodeBtn2 setTitle:@"浏览" forState:UIControlStateNormal];
    [driverCodeBtn2 addTarget:self action:@selector(driverCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:driverCodeBtn2];
    [driverCodeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstLine.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCode.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(60, 25));
        
    }];
    
    UIImageView * imageView2 = [[UIImageView alloc]init];
    imageView2.layer.borderColor = [UIColor blackColor].CGColor;
    imageView2.layer.borderWidth = 0.5;
    _imageView2 = imageView2;
    [baseView addSubview: imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(driverCodeBtn2.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCode.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(200,140));
        
    }];
    
    UIView * firstLine2 = [[UIView alloc]init];
    firstLine2.backgroundColor = KMainColor;
    [baseView addSubview:firstLine2];
    
    [firstLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView2.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_W,1));
        
    }];
    
    UILabel * insuranceLab = [[UILabel alloc]init];
    insuranceLab.text = @"保险种类:";
    insuranceLab.font = [UIFont systemFontOfSize:13];
    insuranceLab.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:insuranceLab];
    [insuranceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstLine2.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 3;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [baseView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(insuranceLab.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(50);
        make.size.mas_offset(CGSizeMake(SCREEN_W-60,120));
        
    }];
    _collectionView.layer.borderColor = [UIColor blackColor].CGColor;
    _collectionView.layer.borderWidth = 1;
    _collectionView.layer.cornerRadius = 5;
    _collectionView.layer.masksToBounds = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //[_collectionView addSubview:_hud];
    
    
    UIButton * selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn setImage:[UIImage imageNamed:@"cyf_bjxq_an2-1"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"cyf_bjxq_an2"] forState:UIControlStateSelected];
    [selectedBtn setTitle:@"是否必须本地保险公司" forState:UIControlStateNormal];
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:selectedBtn];
    
    [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_collectionView.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(50);
        make.size.mas_offset(CGSizeMake(160,20));
        
    }];
    
    [_collectionView registerClass:[PriceCollectionViewCell class] forCellWithReuseIdentifier:@"carCell"];
    _collectionView.backgroundColor =[UIColor whiteColor];
    
    
    UILabel * remarkLab = [[UILabel alloc]init];
    remarkLab.text = @"备注:";
    remarkLab.font = [UIFont systemFontOfSize:13];
    remarkLab.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:remarkLab];
    [remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(selectedBtn.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    UITextView * textView  = [[UITextView alloc]init];
    self.remarkTV = textView;
    textView.layer.masksToBounds=YES;
    textView.layer.cornerRadius=5;
    textView.layer.borderWidth=1;
    textView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    //textView.frame = CGRectMake(10, 60, kWindowW-20, 150);
    textView.font = [UIFont systemFontOfSize:13];
    [baseView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(remarkLab.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(50);
        make.size.mas_offset(CGSizeMake(SCREEN_W-60, 120));
        
    }];
    
    
    //申请认证
    UIButton*applicationCertification=[[UIButton alloc]init];
    [applicationCertification setTitle:@"提交" forState:UIControlStateNormal];
    _applicationCertification=applicationCertification;
    applicationCertification.layer.cornerRadius=5;
    applicationCertification.backgroundColor = KTCBlueColor;
    [applicationCertification addTarget:self action:@selector(certigication) forControlEvents:UIControlEventTouchUpInside];
    //applicationCertification.backgroundColor=KTCBlueColor;
    [baseView addSubview:applicationCertification];
    [applicationCertification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.mas_offset(CGSizeMake(140, 30));
        make.top.equalTo(textView.mas_bottom).offset(30);
    }];

    baseView.contentSize = CGSizeMake(SCREEN_W,1700);
}

#pragma mark - selectedBtnClick:
- (void)selectedBtnClick:(UIButton *)btn{

    btn.selected = !btn.selected;
    self.selected = btn.selected;
    
}
#pragma mark - createCarSeatSevice驾乘座位险
- (void)createCarSeatSevice{
    
    //司机姓名
    TCBaseTextView*driverName=[[TCBaseTextView alloc]init];
    [driverName setText:@"姓名"];
    self.driverName=driverName;
    driverName.type=2;
    [baseView addSubview:driverName];
    [driverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_secondIV.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
    }];
    //司机电话
    TCBaseTextView*phone=[[TCBaseTextView alloc]init];
    [phone setText:@"电话"];
    self.phone=phone;
    self.phone.type=2;
    [baseView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(driverName.mas_bottom).offset(Space);
        make.size.mas_offset(CGSizeMake(kWindowW-20, 30));
    }];
    
    UILabel * driverCodeLab = [[UILabel alloc]init];
    driverCodeLab.text = @"行驶证";
    driverCodeLab.font = [UIFont systemFontOfSize:13];
    driverCodeLab.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:driverCodeLab];
    [driverCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(phone.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    
    UIButton * driverCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    driverCodeBtn.backgroundColor = KTCBlueColor;
    driverCodeBtn.tag = 10;
    [driverCodeBtn setTitle:@"浏览" forState:UIControlStateNormal];
    [driverCodeBtn addTarget:self action:@selector(driverCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:driverCodeBtn];
    [driverCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(phone.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCodeLab.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(60, 25));
        
    }];
    
    UIImageView * imageView1 = [[UIImageView alloc]init];
    _imageView1 = imageView1;
    imageView1.layer.borderColor = [UIColor blackColor].CGColor;
    imageView1.layer.borderWidth = 0.5;
    [baseView addSubview: imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(driverCodeBtn.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCodeLab.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(200,140));
        
    }];
    
    UIView * firstLine = [[UIView alloc]init];
    firstLine.backgroundColor = KMainColor;
    [baseView addSubview:firstLine];
    
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView1.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_W,1));
        
    }];
    
    UILabel * driverCode = [[UILabel alloc]init];
    driverCode.text = @"身份证";
    driverCode.font = [UIFont systemFontOfSize:13];
    driverCode.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:driverCode];
    [driverCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstLine.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    
    UIButton * driverCodeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    driverCodeBtn2.backgroundColor = KTCBlueColor;
    driverCodeBtn2.tag = 20;
    [driverCodeBtn2 setTitle:@"浏览" forState:UIControlStateNormal];
    [driverCodeBtn2 addTarget:self action:@selector(driverCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:driverCodeBtn2];
    [driverCodeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstLine.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCode.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(60, 25));
        
    }];
    
    UIImageView * imageView2 = [[UIImageView alloc]init];
    imageView2.layer.borderColor = [UIColor blackColor].CGColor;
    imageView2.layer.borderWidth = 0.5;
    _imageView2 = imageView2;
    [baseView addSubview: imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(driverCodeBtn2.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.equalTo(driverCode.mas_right).offset(Space);
        make.size.mas_offset(CGSizeMake(200,140));
        
    }];
    
    UIView * firstLine2 = [[UIView alloc]init];
    firstLine2.backgroundColor = KMainColor;
    [baseView addSubview:firstLine2];
    
    [firstLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView2.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_W,1));
        
    }];
    
    UILabel * remarkLab = [[UILabel alloc]init];
    remarkLab.text = @"备注:";
    remarkLab.font = [UIFont systemFontOfSize:13];
    remarkLab.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:remarkLab];
    [remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(firstLine2.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(10);
        make.size.mas_offset(CGSizeMake(70, 30));
        
    }];
    UITextView * textView  = [[UITextView alloc]init];
    self.remarkTV = textView;
    textView.layer.masksToBounds=YES;
    textView.layer.cornerRadius=5;
    textView.layer.borderWidth=1;
    textView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    //textView.frame = CGRectMake(10, 60, kWindowW-20, 150);
    textView.font = [UIFont systemFontOfSize:13];
    [baseView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(remarkLab.mas_bottom).offset(Space);
        //make.left.equalTo(phone.mas_left);
        make.left.offset(50);
        make.size.mas_offset(CGSizeMake(SCREEN_W-60, 120));
        
    }];
    
    
    //申请认证
    UIButton*applicationCertification=[[UIButton alloc]init];
    [applicationCertification setTitle:@"提交" forState:UIControlStateNormal];
    _applicationCertification=applicationCertification;
    applicationCertification.layer.cornerRadius=5;
    applicationCertification.backgroundColor = KTCBlueColor;
    [applicationCertification addTarget:self action:@selector(certigication) forControlEvents:UIControlEventTouchUpInside];
    //applicationCertification.backgroundColor=KTCBlueColor;
    [baseView addSubview:applicationCertification];
    [applicationCertification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.mas_offset(CGSizeMake(140, 30));
        make.top.equalTo(textView.mas_bottom).offset(30);
    }];
    
    baseView.contentSize = CGSizeMake(SCREEN_W,1500);
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.carArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * carCell = @"carCell";
    PriceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:carCell forIndexPath:indexPath];
    cell.delegate=self;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.carArray) {
        
        NSString * str =  self.carArray[indexPath.row];
        [cell refreshInsuranceStr:str];
    }
    
    return cell;
}
#pragma  mark 自定义cell点击触发的代理---其实就是根据cell的整体选择状态改变全选按钮的选择状态
-(void)collectionCellClick{
   
    //遍历collectionView
    for (UIView*childView in _collectionView.subviews) {
        if ([childView isKindOfClass:[PriceCollectionViewCell class]]) {
            
            PriceCollectionViewCell*cell=(PriceCollectionViewCell*)childView;
            //只要有一个cell是未选中的，则全选就是未选中状态
            if (cell.selectBtn.isSelected==NO) {
                
            }
        }
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_W-80)/2,20);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1,1,1,1);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}


#pragma mark - 图片选择点击
#pragma mark - driverCodeBtn浏览btn
- (void)driverCodeBtn:(UIButton *)btn{

    __weak typeof(self) weakSelf = self;
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {
            if (btn.tag==10) {
                
                [_imageView1 setImage:image];
                
            }else if (btn.tag==20){
                
                _imageView2.image=image;
                
            }
            NSLog(@"%@",image);
            
            [weakSelf upDateHeadIcon:image btnTag:btn.tag];
            
        }
    }];
    
}



#pragma  mark 上传图片
- (void)upDateHeadIcon:(UIImage *)photo btnTag:(NSInteger )tag{
    
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
        //NSData * data = responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        NSLog(@"dic%@",dic);
        NSLog(@"responseObject%@",responseObject);
        NSString * result = dic[@"image"];
        if (tag==10) {
            
            self.imgStr1 = result;
            
        }else if (tag==20){
            
            self.imgStr2 = result;
            
        }
        NSLog(@"result%@",result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error%@",error);
    }];
}


#pragma mark - 提交
-(void)certigication{
    
    @try {
        NSMutableDictionary*dict=[NSMutableDictionary dictionary];
        if ([self.titleStr isEqualToString:@"ETC卡"]) {
            
            [dict setObject:self.carNumber.textFiled.text forKey:@"remarks"];
            [dict setObject:self.driverName.textFiled.text forKey:@"name"];
            [dict setObject:self.phone.textFiled.text forKey:@"phone"];
            [dict setObject:@"ETC" forKey:@"type"];
            [dict setObject:self.carType.textFiled.text forKey:@"categories"];

        }else if ([self.titleStr isEqualToString:@"车险服务"]){
        
            //NSMutableArray*selectedArr=[NSMutableArray array];
            NSMutableString * str = [[NSMutableString alloc]init];
            for (UIView*childView in _collectionView.subviews) {
                if ([childView isKindOfClass:[PriceCollectionViewCell class]]) {
                    
                    PriceCollectionViewCell*cell=(PriceCollectionViewCell*)childView;
                    if (cell.selectBtn.selected==YES) {
                        str = (NSMutableString *)[NSString stringWithFormat:@"%@,%@",cell.selectBtn.titleLabel.text,str];
                        
                    }
                }
            }
            NSLog(@"%@",str);
            [dict setObject:self.driverName.textFiled.text forKey:@"name"];
            [dict setObject:self.phone.textFiled.text forKey:@"phone"];
            [dict setObject:str forKey:@"categories"];
            [dict setObject:self.remarkTV.text forKey:@"remarks"];
            if (self.imgStr2.length !=0) {
                [dict setObject:self.imgStr2 forKey:@"identityCard"];
            }
            if (self.imgStr1.length !=0) {
                [dict setObject:self.imgStr1 forKey:@"drivingLicensePhoto"];
            }
            [dict setObject:@(self.selected) forKey:@"isLocal"];
            [dict setObject:@"车险" forKey:@"type"];
            
        }else {
        
            [dict setObject:self.driverName.textFiled.text forKey:@"name"];
            [dict setObject:self.phone.textFiled.text forKey:@"phone"];
            [dict setObject:self.remarkTV.text forKey:@"remarks"];
            if (self.imgStr2.length !=0) {
                [dict setObject:self.imgStr2 forKey:@"identityCard"];
            }
            if (self.imgStr1.length !=0) {
                [dict setObject:self.imgStr1 forKey:@"drivingLicensePhoto"];
            }
            
            [dict setObject:@"驾乘座位险" forKey:@"type"];
            
        }
                NSLog(@"%@",dict);
        //提交接口
        [[HttpRequest sharedClient]httpRequestPOST:FinancialService parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            NSLog(@"%@",responseObject);
            NSString*sucess=responseObject[@"success"];
            if ([sucess intValue]) {
                ToastSuccess(@"提交成功");
                [self backClick];
                
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

#pragma mark - 轮播图
- (void)createBanner{
    
    NSString * one = @"1559103217846906832";
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HomeBanner,one]);
    [[HttpRequest sharedClient]httpRequestGET:[NSString stringWithFormat:@"%@%@",HomeBanner,one] parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        
        NSLog(@"首页轮播图%@",responseObject);
        NSMutableArray * dataArr = responseObject[@"data"];
        for (NSDictionary * tempDic in dataArr) {
            
            NSString * bannerStr = [NSString stringWithFormat:@"%@%@",tempDic[@"imgHeadPath"],tempDic[@"imgUrl"]];
            NSLog(@"bannerStr%@",bannerStr);
            
            [self.bannerArray addObject:bannerStr];
            NSLog(@"self.bannerArray%@",self.bannerArray);
        }
        if (self.bannerArray.count !=0) {
            [self createUI];
            //[self createRefresh];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - lazyLoad
//轮播图数据源
-(NSMutableArray*)bannerArray{
    if (_bannerArray==nil) {
        _bannerArray=[NSMutableArray array];
    }
    return _bannerArray;
}

//车牌号数组
-(NSMutableArray*)carArray{
    if (!_carArray) {
        _carArray=[NSMutableArray array];
        //        _carArray=@[@"123",@"2212",@"122",@"4321"];
    }
    return _carArray;
}


#pragma mark - createNav
- (void)createNav{
    self.title = self.titleStr;
//    self.titleLabel.text = self.titleStr;
//    self.titleLabel.textColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
//    [self.leftButton setImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
//    [self.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - backClick
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
