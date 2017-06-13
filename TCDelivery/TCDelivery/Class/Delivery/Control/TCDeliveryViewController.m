//
//  TCDeliveryViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//

#import "TCOrderModel.h"
#import "TCLinkModel.h"
#import "TCDeliveryViewController.h"
#import "TCBaseTextView.h"
#import "BDImagePicker.h"
#import "WSDatePickerView.h"
#import "TCOrderListVC.h"
#import "AddressPickView.h"
#import "TCFrequentLinkmanVC.h"
#define  F13   Font(14)
#define  LeftMargin  12
#define  Space 10//竖间距
const CGFloat TextFiledHeight = 35.0;

@interface TCDeliveryViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,TCFrequentLinkmanDelegate>

@property(nonatomic,strong)UILabel*deliveryName;
@property(nonatomic,strong)UILabel*deliveryphone;
@property(nonatomic,strong)UILabel*deliveryAddress;
@property(nonatomic,strong)UIButton*deliveryBtn;

@property(nonatomic,strong)UILabel*getName;
@property(nonatomic,strong)UILabel*getPhone;
@property(nonatomic,strong)UILabel*unLoadDetailAddres;
@property(nonatomic,strong)UIButton*getBtn;

@property(nonatomic,strong)UITextField*weight;
@property(nonatomic,strong)UITextField*volume;
@property(nonatomic,strong)UITextView*descrption;
//@property(nonatomic,strong)UITextField*deliveryData;
//@property(nonatomic,strong)UITextField*beginData;
//@property(nonatomic,strong)UITextField*endData;
@property(nonatomic,strong)TCBaseTextView*deName;
@property(nonatomic,strong)UIScrollView*baseView;
@property(nonatomic,strong)UITextField*goodsName;


//数组，本地的省市文件
@property (nonatomic, strong) NSArray *locData;
//省市选择pickView
@property (nonatomic, strong) UIPickerView *cityPicker;
// 选择器选中的省份
@property (nonatomic, assign) NSInteger provinceIndex;
// 选择器选中的城市
@property (nonatomic, assign) NSInteger cityIndex;

@property(nonatomic,strong)UIView*basePopView;

@property(nonatomic,strong)UIView*base;

@property(nonatomic,strong)NSString*publishType;
//货物类型数组
@property(nonatomic,strong)NSMutableArray*goodsTypeArr;
//车辆长度
@property(nonatomic,strong)NSMutableArray*carLengthArr;
//车辆类型
@property(nonatomic,strong)NSMutableArray*carTypeArr;
//原始单号数组
@property(nonatomic,strong)NSMutableArray*originalOddNumberArr;


/**发货人选中的联系人信息*/
@property(nonatomic,copy)  NSString *deliveryId;
/**收货人选中的联系人信息*/
@property(nonatomic,copy) NSString *receiveId;
/**<##>发货人 还是 收货人*/
@property(nonatomic,assign)LinkType linkType;
//原始单号数组
@property(nonatomic, strong)NSMutableArray *aggrementArr;
@end

@implementation TCDeliveryViewController
{
//    __block UIButton*_loadProvice;
//    __weak UIButton*_loadCity;
//    __weak  UIButton*_loadArea;
    
    NSString*_loadProvice;
    NSString*_loadCity;
    NSString*_loadArea;
    NSString*_loadDetailAddress;
    
    NSString*_unLoadProvice;
    NSString*_unLoadCity;
    NSString*_unLoadArea;
    NSString*_unLoadAddress;
    
    UIButton*_carType;
    UIButton*_carLength;
    UITextField*_carNumber;
    
    UIButton*_deliveryData;
    UIButton*_beginData;
    UIButton*_endData;
    
    UIButton*_goodsType;
    
    NSInteger _indexAddressTag;
    
    UIButton*_publishBtn;
    
    UIView*_logoBaseView;
    UIImageView*_logoImage;
    
    //从相册返回界面时，不需要再次弹出发布类型界面
    BOOL _needPop;
    //每次进入时，需要重新加载车辆类型信息，保持实时更新
    BOOL _needLoadCarMessage;
    //原始单号
    UILabel *_originalOddNumberLabel;
    TCBaseMenu *_originalOddNumer;
    
    AddressPickView * _pickView;
}
#pragma  mark - setter
-(NSMutableArray*)goodsTypeArr{
    if (!_goodsTypeArr) {
        _goodsTypeArr=[NSMutableArray array];
    }
    return _goodsTypeArr;
}
-(NSMutableArray*)aggrementArr{
    if (!_aggrementArr) {
        _aggrementArr=[NSMutableArray array];
    }
    return _aggrementArr;
}
-(NSMutableArray*)carLengthArr{
    if (!_carLengthArr) {
        _carLengthArr=[NSMutableArray array];
    }
    return _carLengthArr;
}

-(NSMutableArray*)carTypeArr{
    if (!_carTypeArr) {
        _carTypeArr=[NSMutableArray array];
    }
    
    return _carTypeArr;
}
//获取原始协议数据
-(NSMutableArray*)originalOddNumberArr{
    if (!_originalOddNumberArr) {
        _originalOddNumberArr=[NSMutableArray array];
    }
    return _originalOddNumberArr;
}
#pragma  mark  - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _needPop=YES;
    //请求一些产品规格数据
    [self locData];
    //创建UI.也没有什么规律可循，只能一个个创建了。
    [self createUI];
    //如果是从我的发布中编辑过来的，则给各个控件赋值
    [self setUpModel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _needLoadCarMessage=YES;
    if (_needPop&&!_model) {
        [UIView animateWithDuration:0.5 animations:^{
            self.basePopView.frame=self.view.bounds;
            _basePopView.backgroundColor=kRGBAColor(1, 1, 1, 0.6);
        }];
    }
    _needPop=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //创建导航栏title
    [self navigationTitle];
}

#pragma  mark - 创建导航栏title
-(void)navigationTitle{
    if(_model&&[_model.tenderType isEqualToString:@"OPEN"]){
        [self initWithType:@"公开竞标"];
    }else if (_model&& ![_model.tenderType isEqualToString:@"OPEN"]){
        [self initWithType:@"总包"];
    }else{
        self.navigationItem.title=@"发货";
    }
}

- (void)initWithType:(NSString *)type{
    if ([type isEqualToString:@"总包"]) {
        self.navigationItem.title=@"发布需求(总包)";
        self.publishType=@"CONTRACTOR";
        _logoBaseView.hidden=NO;
        _deName.hidden=NO;
        _originalOddNumer.hidden=NO;
        _originalOddNumberLabel.hidden=NO;
        _publishBtn.frame=CGRectMake(kWindowW/2-50, _endData.frameHeight+_endData.originY+85, 100, 30);
    }else{
        self.navigationItem.title=@"发布需求(公开竞标)";
        //改变类型
        self.publishType=@"OPEN";
        //改变界面
        _logoBaseView.hidden=YES;
        _deName.hidden=YES;
        _originalOddNumberLabel.hidden=YES;
        _originalOddNumer.hidden=YES;
        _publishBtn.frame=CGRectMake(kWindowW/2-50, _endData.frameHeight+_endData.originY+20, 100, 30);
    }
}


#pragma  mark 模型赋值给控件
-(void)setUpModel{
    if (_model) {
        //发货人信息
        self.deliveryName.text =_model.outName;
        self.deliveryphone.text = _model.outTel;
        self.deliveryAddress.text = [NSString stringWithFormat:@"%@%@%@%@",_model.outProvince,_model.outCity,_model.outCounty,_model.outAddress];
        _loadProvice = _model.outProvince;
        _loadCity = _model.outCity;
        _loadArea = _model.outCounty;
        _loadDetailAddress = _model.outAddress;
        //卸货 收货人信息
        _getName.text=_model.receiveName;//卸货人
        _getPhone.text=_model.receiveTel;//卸货人电话
        self.unLoadDetailAddres.text = [NSString stringWithFormat:@"%@%@%@%@",_model.receiveProvince,_model.receiveCity,_model.receiveCounty,_model.receiveAddress];
        _unLoadProvice = _model.receiveProvince;
        _unLoadCity = _model.receiveCity;
        _unLoadArea = _model.receiveAddress;
        _unLoadAddress = _model.receiveAddress;
        
        [_goodsType setTitle:_model.goodsType forState:0];//货物类型
        _goodsName.text=_model.goodsName;//货物名称
        _weight.text=[NSString stringWithFormat:@"%.2f",_model.goodsWeight];//重量
        _volume.text=[NSString stringWithFormat:@"%.2f",_model.goodsSize];//体积
        _descrption.text=_model.remarks;//描述
        
        [_carType setTitle:_model.carType forState:0];//车类型
        [_carLength setTitle:[NSString stringWithFormat:@"%.1f",_model.carSize] forState:0];//车长度
        _carNumber.text=[NSString stringWithFormat:@"%d",_model.carNum];//用车数量
        
        [_deliveryData setTitle:_model.outDate forState:0];//发货时间
        [_beginData setTitle:_model.tenderStartTime forState:0];//报价开始时间
        [_endData setTitle:_model.tenderEndTime forState:0];//报价结束时间
        [_originalOddNumer setTitle:_model.ysNum forState:0];//原始协议
        //获取协议号
        [self getReceiverAndAgreementAndIfRefreshReceiver:NO];
        //将发布按钮改名字为保存
        [_publishBtn setTitle:@"保存" forState:0];
    }
}

#pragma  mark 清空已填写的数据
-(void)clear{
    
//        _deliveryName.text=@"";//发货人
//        _deliveryphone.text=@"";//电话
//    
//        _getName.text=@"";//卸货人
//        _getPhone.text=@"";//卸货人电话
    
   
    
  
    
        [_goodsType setTitle:@"" forState:0];//货物类型
        _goodsName.text=@"";//货物名称
        _weight.text=@"";//重量
        _volume.text=@"";//体积
        _descrption.text=@"";//描述
        
        [_carType setTitle:@"类型" forState:0];//车类型
        [_carLength setTitle:@"长度" forState:0];//车长度
        _carNumber.text=@"";//用车数量
        
        [_deliveryData setTitle:@"" forState:0];//发货时间
        [_beginData setTitle:@"" forState:0];//报价开始时间
        [_endData setTitle:@"" forState:0];//报价结束时间
    
     //获取自协议和常用联系人
     [self getReceiverAndAgreementAndIfRefreshReceiver:YES];

}

#pragma  mark 弹出的发布类型选择框
-(UIView*)basePopView{
    if (_basePopView==nil) {
        _basePopView=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWindowW, kWindowH)];
        _basePopView.backgroundColor=kRGBAColor(1, 1, 1, 0);
        [self.view addSubview:_basePopView];

        UIView*popView=[[UIView alloc]initWithFrame:CGRectMake(kWindowW/2-100, kWindowH/2-50, 200, 90)];
        popView.backgroundColor=[UIColor whiteColor];
        [_basePopView addSubview:popView];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, popView.frameWidth, 30)];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=LGLighgtBGroundColour235;
        label.text=@"发货";
        [popView addSubview:label];
        
        UIButton*openBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 45, 70, 30)];
        openBtn.tag=1;
        openBtn.backgroundColor=KTCGreen;
        [openBtn addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        openBtn.titleLabel.font=Font(12);
        [openBtn setTitle:@"公开竞标" forState:0];
        [popView addSubview:openBtn];
        
        UIButton*openBtn2=[[UIButton alloc]initWithFrame:CGRectMake(110, 45, 70, 30)];
        openBtn2.tag=2;
        openBtn2.titleLabel.font=Font(12);
        openBtn2.backgroundColor=[UIColor orangeColor];
        [openBtn2 addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        [openBtn2 setTitle:@"总包" forState:0];
        [popView addSubview:openBtn2];
    }
    return _basePopView;
}

#pragma  mark 选择发货类型
-(void)type:(UIButton*)btn{
    if (![[StorageUtil getUserSubType] isEqualToString:@"OPEN"]&&![[StorageUtil getUserSubType] isEqualToString:@"CONTRACTOR"]) {
        ToastError(@"您认证未通过，还不能发布");
        return;
    }
    if (btn.tag==2 &&![[StorageUtil getUserSubType] isEqualToString:@"CONTRACTOR"]) {
        ToastError(@"您现在还不能发布总包模式");
        return;
    }
    //退去选择发货类型界面
    [UIView animateWithDuration:0.5 animations:^{
        self.basePopView.frame=CGRectMake(0, kWindowH, kWindowW, kWindowH);
        _basePopView.backgroundColor=kRGBAColor(1, 1, 1, 0);
    }];
    //清空已填写的数据
    [self clear];
    if (btn.tag==1) {
        [self initWithType:@"公开竞标"];
    }else{
        [self initWithType:@"总包"];
    }
}

#pragma  mark 加载网络车辆类型数据----.txt
-(void)loadCar:(UIButton*)btn{
    if (self.goodsTypeArr.count!=0&&!_needLoadCarMessage) {
        NSMutableArray*dataArr=[NSMutableArray array];
        if (btn.tag==190) {//货物类型
            dataArr=self.goodsTypeArr;
        }else if (btn.tag==191){//车类型
            dataArr=self.carTypeArr;
        }else if (btn.tag==192){//长度
            dataArr=self.carLengthArr;
        }
        //如果为0，直接返回
        if (dataArr.count==0) {
            return;
        }
        
        [LXPopOverMenu showPopOverMenu:btn withMenuCellNameArray:dataArr imageNameArray:nil menuDirection:PopOverMenuDownDirection doneBlock:^(NSString* selectString) {
            if (btn.tag==192) {
                [btn setTitle:[NSString stringWithFormat:@"%@",selectString] forState:UIControlStateNormal];
            }else{
                [btn setTitle:selectString forState:UIControlStateNormal];}
        } dismissBlock:^{
            
        }];
    }else{
        
        //异步请求，不然，如果遇到没有网络，或者网络不好，会阻塞线程，造成短时间卡死的现象
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //获取数据
            NSString *path = [NSString stringWithFormat:@"%@/v1/combo.json",kUrlBase];
            path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            NSURL *url = [NSURL URLWithString:path];
            NSString*str=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            //字符串转字典
            NSDictionary*dict=[self dictionaryWithJsonString:str];
            self.goodsTypeArr=dict[@"goodsType"];
            self.carLengthArr=dict[@"carLength"];
            self.carTypeArr=dict[@"carType"];
            
            __block  NSMutableArray*dataArr=[NSMutableArray array];
            
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //此VC没有退出时，则不用多次加载，
                _needLoadCarMessage=NO;
                if (btn.tag==190) {//货物类型
                    dataArr=self.goodsTypeArr;
                }else if (btn.tag==191){//车类型
                    dataArr=self.carTypeArr;
                }else if (btn.tag==192){//长度
                    dataArr=self.carLengthArr;
                }
                
                if (dataArr.count==0) {
                    ToastError(@"获取数据有误");
                    return;
                }
                NSLog(@"%@",dataArr);
                [LXPopOverMenu showPopOverMenu:btn withMenuCellNameArray:dataArr imageNameArray:nil menuDirection:PopOverMenuDownDirection doneBlock:^(NSString* selectString) {
                    if (btn.tag==192) {
                        [btn setTitle:[NSString stringWithFormat:@"%@",selectString] forState:UIControlStateNormal];
                    }else{
                        [btn setTitle:selectString forState:UIControlStateNormal];}
                } dismissBlock:^{
                    
                }];
            });
        });

    }
}

#pragma  mark  将字符串转成字典
-(id )dictionaryWithJsonString:(NSString *)jsonString {
    NSLog(@"%@",jsonString);
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

#pragma  mark - 创建UI
-(void)createUI{
    //baseView
    UIScrollView*baseView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    self.baseView=baseView;
    baseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseView];

    //分割线
    UIView*topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 10)];
    topLine.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:topLine];
    
    //发货人信息图片
    UIImageView*deliveryImage=[[UIImageView alloc]initWithFrame:CGRectMake(LeftMargin, 12, 20, 20)];
    [deliveryImage setImage:[UIImage imageNamed:@"ydxq_an3"]];
    [baseView addSubview:deliveryImage];
    
    //发货人信息标题
    UILabel*deliveryTitle=[UILabel labelWithFont:F13 textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    deliveryTitle.text=@"发货人信息";
    [baseView addSubview:deliveryTitle];
    deliveryTitle.frame=CGRectMake(LeftMargin+30, 10, kWindowW, 25);
    
    UIView*line3=[[UIView alloc]initWithFrame:CGRectMake(0,35, kWindowW, 2)];
    line3.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line3];
    
    //发货人姓名
    UILabel*nameLabel=[[UILabel alloc]init];
    nameLabel.font=[UIFont systemFontOfSize:14];
    [baseView addSubview:nameLabel];
    self.deliveryName=nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(37+10);
        make.left.offset(10);
        make.width.offset(120);
        make.height.offset(20);
    }];
    //发货人手机号码
    UILabel*telLab=[[UILabel alloc]init];
    [baseView addSubview:telLab];
    self.deliveryphone=telLab;
    telLab.font=[UIFont systemFontOfSize:14];
    [telLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.top).offset(0);
        make.left.equalTo(nameLabel.right).offset(20);
        make.size.offset(CGSizeMake(150,20));
    }];

    //发货人地址
    UILabel*Addreslab=[[UILabel alloc]init];
    [baseView addSubview:Addreslab];
    Addreslab.font=Font(13);
    Addreslab.numberOfLines=2;
    self.deliveryAddress=Addreslab;
    [Addreslab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.bottom).offset(2);
        make.left.equalTo(nameLabel);
        make.size.offset(CGSizeMake(kWindowW-20, 50));
    }];
    
    UIButton *deviceryTap = [[UIButton alloc]init];
    [deviceryTap addTarget:self action:@selector(deviceryTap) forControlEvents:UIControlEventTouchDown];
     [deviceryTap setTitleColor:[UIColor blackColor] forState:0];
    self.deliveryBtn = deviceryTap;
    deviceryTap.backgroundColor = [UIColor  clearColor];
    [baseView addSubview:deviceryTap];
    [deviceryTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(line3);
        make.width.offset(kWindowW);
        make.bottom.equalTo(Addreslab).offset(10);
    }];
    
    
     CGFloat menuWidth=(kWindowW-LeftMargin-95)/3;
    //分割线
    UIView*middleLine=[[UIView alloc]init];
    middleLine.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.offset(0);
    make.size.offset(CGSizeMake(kWindowW, 10));
    make.top.equalTo(Addreslab.bottom).offset(0);
    }];
    //收货人信息图片
    UIImageView*getImage=[[UIImageView alloc]init];
    [getImage setImage:[UIImage imageNamed:@"ydxq_an4"]];
    [baseView addSubview:getImage];
    [getImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(20, 20));
        make.left.offset(LeftMargin);
        make.top.equalTo(middleLine.bottom).offset(3.5);
    }];
    //收货人信息
    UILabel*getTitle=[UILabel labelWithFont:F13 textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentLeft];
    getTitle.text=@"收货人信息";
    [baseView addSubview:getTitle];
    [getTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(getImage.right).offset(LeftMargin);
        make.top.equalTo(getImage).offset(0);
        make.size.offset(CGSizeMake(150, 25));
    }];
    UIView*line4=[[UIView alloc]init];
    line4.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(getTitle.bottom).offset(0);
        make.left.offset(0);
    }];

    //收货人姓名
    self.getName=[[UILabel alloc]init];
    self.getName.font=[UIFont systemFontOfSize:14];
    [baseView addSubview:self.getName];
    
    [self.getName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line4).offset(10);
        make.left.offset(10);
        make.width.offset(120);
        make.height.offset(20);
    }];
    //收货人手机号码
    self.getPhone=[[UILabel alloc]init];
    [baseView addSubview:self.getPhone];
    self.getPhone.font=[UIFont systemFontOfSize:14];
    [self.getPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getName.top).offset(0);
        make.left.equalTo(self.getName.right).offset(20);
        make.size.offset(CGSizeMake(150,20));
    }];
    
    //收货人地址
    UILabel*getAddres=[[UILabel alloc]init];
    [baseView addSubview:getAddres];
    getAddres.font=Font(13);
    getAddres.numberOfLines=2;
    self.unLoadDetailAddres=getAddres;
    [getAddres mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_getName.bottom).offset(2);
        make.left.equalTo(_getName);
        make.size.offset(CGSizeMake(kWindowW-20, 50));
    }];
    
    UIButton *getTap = [[UIButton alloc]init];
    self.getBtn = getTap;
    [getTap setTitleColor:[UIColor blackColor] forState:0];
    [getTap addTarget:self action:@selector(getTap) forControlEvents:UIControlEventTouchDown];
    getTap.backgroundColor = [UIColor  clearColor];
    [baseView addSubview:getTap];
    [getTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(line4.bottom);
        make.width.offset(kWindowW);
        make.bottom.equalTo(getAddres).offset(10);
    }];
    
    //分割线
    UIView*bottomLine=[[UIView alloc]init];
    bottomLine.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 10));
        make.top.equalTo(getAddres.bottom).offset(0);
    }];
    
    //收货人信息图片
    UIImageView*goodsImage=[[UIImageView alloc]init];
    [goodsImage setImage:[UIImage imageNamed:@"ydxq_an5"]];
    [baseView addSubview:goodsImage];
    [goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(20, 20));
        make.left.offset(LeftMargin);
        make.top.equalTo(bottomLine.bottom).offset(2);
    }];
    
    //货物信息
    UILabel*goodsLabel=[[UILabel alloc]init];
    goodsLabel.text=@"货物信息";
    goodsLabel.font=F13;
    [baseView addSubview:goodsLabel];
    [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImage.right).offset(LeftMargin);
        make.size.offset(CGSizeMake(70, 25));
        make.top.equalTo(bottomLine.bottom).offset(0);
    }];
    //分割线
    UIView*line6=[[UIView alloc]init];
    line6.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(goodsLabel.bottom).offset(0);
    }];

    //货物品类
    UILabel*goodsTypeLabel=[[UILabel alloc]init];
    goodsTypeLabel.text=@"货物类型:";
    goodsTypeLabel.font=F13;
    [baseView addSubview:goodsTypeLabel];
    [goodsTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.size.offset(CGSizeMake(70, TextFiledHeight));
        make.top.equalTo(goodsLabel.bottom).offset(Space);
    }];
    
    //货物类型
    TCBaseMenu*equipment=[[TCBaseMenu alloc]init];
    [baseView addSubview:equipment];
    _goodsType=equipment;
    [equipment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    equipment.tag=190;
    [equipment addTarget:self action:@selector(loadCar:) forControlEvents:UIControlEventTouchUpInside];
    [equipment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsTypeLabel.right).offset(10);
        make.size.offset(CGSizeMake(kWindowW-112, TextFiledHeight));
        make.top.equalTo(goodsTypeLabel.top);
    }];
    //品名
    TCBaseTextView*goodsName=[[TCBaseTextView alloc]init];
    [goodsName setText:@"品名:"];
    goodsName.type=3;
    _goodsName=goodsName.textFiled;
    goodsName.textFiled.delegate=self;
    [baseView addSubview:goodsName];
    [goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsTypeLabel);
        make.top.equalTo(goodsTypeLabel.bottom).offset(Space);
        make.size.offset(CGSizeMake(kWindowW-32, TextFiledHeight));
    }];

    //重量
    TCBaseTextView*weight=[[TCBaseTextView alloc]init];
    [weight setText:@"重量:"];
    self.weight=weight.textFiled;
    weight.textFiled.delegate=self;
    weight.type=3;
    [baseView addSubview:weight];
    [weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.top.equalTo(goodsName.bottom).offset(Space);
        make.size.offset(CGSizeMake(kWindowW-62, TextFiledHeight));
    }];
    UILabel*dun=[[UILabel alloc]init];
    dun.text=@"吨";
    [baseView addSubview:dun];
    [dun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weight.right).offset(3);
        make.size.offset(CGSizeMake(30,TextFiledHeight));
        make.top.equalTo(weight);
    }];
    //体积
    TCBaseTextView*volume=[[TCBaseTextView alloc]init];
    [volume setText:@"体积:"];
    self.volume=volume.textFiled;
    volume.textFiled.delegate=self;
    volume.type=3;
    [baseView addSubview:volume];
    [volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.top.equalTo(weight.bottom).offset(Space);
        make.size.offset(CGSizeMake(kWindowW-62, TextFiledHeight));
    }];
    UILabel*fang=[[UILabel alloc]init];
    fang.text=@"方";
    [baseView addSubview:fang];
    [fang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(volume.right).offset(3);
        make.size.offset(CGSizeMake(70, TextFiledHeight));
        make.top.equalTo(volume);
    }];
    //描述
    UILabel*description=[[UILabel alloc]init];
    description.text=@"描述:";
    description.font=F13;
    description.textAlignment=NSTextAlignmentCenter;
    [baseView addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.size.offset(CGSizeMake(70, TextFiledHeight));
        make.top.equalTo(volume.bottom).offset(Space);
    }];
    UITextView*textView=[[UITextView alloc]init];
    textView.layer.borderColor=[UIColor grayColor].CGColor;
    textView.layer.borderWidth=0.6;
    self.descrption=textView;
    [baseView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(description.right).offset(10);
        make.size.offset(CGSizeMake(kWindowW-112,100));
        make.top.equalTo(description.top);
    }];
    
    //车辆需求
    UILabel*needCar=[[UILabel alloc]init];
    needCar.text=@"车辆需求:";
    needCar.font=F13;
    [baseView addSubview:needCar];
    [needCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.size.offset(CGSizeMake(70, TextFiledHeight));
        make.top.equalTo(textView.bottom).offset(Space);
    }];
     
    //运货车的类型
    TCBaseMenu*carType=[[TCBaseMenu alloc]init];
    [baseView addSubview:carType];
    _carType=carType;
    [carType setTitle:@"类型" forState:UIControlStateNormal];
    [carType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    carType.tag=191;
    [carType addTarget:self action:@selector(loadCar:) forControlEvents:UIControlEventTouchUpInside];
    [carType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(needCar.right).offset(0);
        make.size.offset(CGSizeMake(menuWidth, TextFiledHeight));
        make.top.equalTo(needCar.top);
    }];
    
    //长度
    TCBaseMenu*carLength=[[TCBaseMenu alloc]init];
    [baseView addSubview:carLength];
    _carLength=carLength;
    [carLength setTitle:@"长度" forState:UIControlStateNormal];
    [carLength setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    carLength.tag=192;
    [carLength addTarget:self action:@selector(loadCar:) forControlEvents:UIControlEventTouchUpInside];
    [carLength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carType.right).offset(5);
        make.size.offset(CGSizeMake(menuWidth, TextFiledHeight));
        make.top.equalTo(needCar.top);
    }];
    
    //数量
   UITextField*carNumber=[[UITextField alloc]init];
    [baseView addSubview:carNumber];
    _carNumber=carNumber;
    carNumber.layer.cornerRadius=5;
    carNumber.layer.borderColor=[UIColor blackColor].CGColor;
    carNumber.layer.borderWidth=0.5;
    carNumber.textAlignment=NSTextAlignmentCenter;
    carNumber.placeholder=@" 数量";
    [carNumber setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    carNumber.font=Font(12);
    carNumber.tintColor=[UIColor blackColor];
    [carNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carLength.right).offset(5);
        make.size.offset(CGSizeMake(menuWidth-10, TextFiledHeight));
        make.top.equalTo(carLength.top);
    }];
    UILabel*liang=[[UILabel alloc]init];
    liang.text=@"辆";
    liang.font=Font(12);
    [baseView addSubview:liang];
    [liang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carNumber.right).offset(3);
        make.size.offset(CGSizeMake(30, TextFiledHeight));
        make.top.equalTo(carNumber);
    }];

    //发货日期
    UILabel*deliveryDa=[[UILabel alloc]init];
    deliveryDa.text=@"发货日期:";
    deliveryDa.font=F13;
    [baseView addSubview:deliveryDa];
    [deliveryDa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.size.offset(CGSizeMake(70, TextFiledHeight));
        make.top.equalTo(needCar.bottom).offset(Space);
    }];

    TCBaseMenu*deliveryData=[[TCBaseMenu alloc]init];
    [baseView addSubview:deliveryData];
    _deliveryData=deliveryData;
    deliveryData.tag=100;
    [deliveryData setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deliveryData addTarget:self action:@selector(setupCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:deliveryData];
    [deliveryData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deliveryDa.right).offset(5);
        make.top.equalTo(needCar.bottom).offset(Space);
        make.size.offset(CGSizeMake(kWindowW-100, TextFiledHeight));
    }];

    //报价开始时间
    UILabel*beginDa=[[UILabel alloc]init];
    beginDa.text=@"报价开始时间:";
    beginDa.font=F13;
    beginDa.adjustsFontSizeToFitWidth=YES;
    [baseView addSubview:beginDa];
    [beginDa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7);
        make.size.offset(CGSizeMake(75, TextFiledHeight));
        make.top.equalTo(deliveryDa.bottom).offset(Space);
    }];
    
    TCBaseMenu*beginData=[[TCBaseMenu alloc]init];
    [baseView addSubview:beginData];
    _beginData=beginData;
    beginDa.tag=101;
    [beginData setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [beginData addTarget:self action:@selector(setupCalendar:) forControlEvents:UIControlEventTouchUpInside];

    [baseView addSubview:beginData];
    [beginData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginDa.right).offset(5);
        make.top.equalTo(deliveryData.bottom).offset(Space);
        make.size.offset(CGSizeMake(kWindowW-100, TextFiledHeight));
    }];
    //报价结束时间
    UILabel*endDa=[[UILabel alloc]init];
    endDa.text=@"报价截止时间:";
    endDa.font=F13;
    endDa.adjustsFontSizeToFitWidth=YES;
    [baseView addSubview:endDa];
    [endDa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7);
        make.size.offset(CGSizeMake(75, TextFiledHeight));
        make.top.equalTo(beginDa.bottom).offset(Space);
    }];
    
    TCBaseMenu*endData=[[TCBaseMenu alloc]init];
    [baseView addSubview:endData];
    _endData=endData;
    endDa.tag=102;
    
    [endData setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [endData addTarget:self action:@selector(setupCalendar:) forControlEvents:UIControlEventTouchUpInside];
    
    [baseView addSubview:endData];
    [endData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endDa.right).offset(5);
        make.top.equalTo(beginData.bottom).offset(Space);
        make.size.offset(CGSizeMake(kWindowW-100, TextFiledHeight));
    }];
    
    
    UIView*base=[[UIView alloc]init];
    _base=base;
    [baseView addSubview:base];
    [base mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(endData.bottom).offset(10);
        make.size.offset(CGSizeMake(kWindowW, 100));
    }];
    
    
    UIView*line7=[[UIView alloc]init];
    line7.backgroundColor=LGLighgtBGroundColour235;
    [base addSubview:line7];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.left.offset(0);
        make.top.offset(0);
    }];
    
//    TCBaseTextView*deName=[[TCBaseTextView alloc]init];
//    [deName setText:@"发货方名称:"];
//    self.deName=deName;
//    deName.textFiled.delegate=self;
//    deName.type=1;
//    [base addSubview:deName];
//    [deName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(LeftMargin);
//        make.top.equalTo(line7.bottom).offset(Space);
//        make.size.offset(CGSizeMake(240, 30));
//    }];
    
    //原始单号Label
    UILabel *originalOddNumberLabel=[[UILabel alloc]init];
    originalOddNumberLabel.text=@"协议号:";
    originalOddNumberLabel.font=F13;
    _originalOddNumberLabel=originalOddNumberLabel;
    [baseView addSubview:originalOddNumberLabel];
    [originalOddNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LeftMargin);
        make.size.offset(CGSizeMake(70, TextFiledHeight));
         make.top.equalTo(line7.bottom).offset(Space);
    }];
    
    //原始单号
    TCBaseMenu*originalOddNumber=[[TCBaseMenu alloc]init];
    [baseView addSubview:originalOddNumber];
    _originalOddNumer=originalOddNumber;
    [originalOddNumber setTitle:@"请选择原始单号" forState:UIControlStateNormal];
    [originalOddNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    originalOddNumber.tag=2001;
    [originalOddNumber addTarget:self action:@selector(choseOriginalOddNumber:) forControlEvents:UIControlEventTouchUpInside];
    [originalOddNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originalOddNumberLabel.right).offset(5);
        make.top.equalTo(line7.bottom).offset(Space);
        make.size.offset(CGSizeMake(240, TextFiledHeight));
    }];
    

    //立即发布
    UIButton*publishBtn=[[UIButton alloc]init];
    _publishBtn=publishBtn;
    publishBtn.layer.cornerRadius=5;
    [publishBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font=Font(14);
    publishBtn.backgroundColor=KTCBlueColor;
    [publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:publishBtn];
   
    baseView.contentSize=CGSizeMake(0,1100);
}

#pragma  mark  - 选择日历
- (void)setupCalendar:(UIButton*)btn {
    [self.view endEditing:YES];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        [btn setTitle:date forState:UIControlStateNormal];
    }];
    datepicker.datePickerStyle = DateStyleShowYearMonthDayHourMinute;
    [datepicker show];
}

#pragma  mark 选择原始单号
- (void)choseOriginalOddNumber:(UIButton *)btn{
            if (self.aggrementArr.count==0) {
            ToastError(@"您暂无可用单号");
            return ;
        }
        [LXPopOverMenu showPopOverMenu:btn withMenuCellNameArray:self.aggrementArr imageNameArray:nil menuDirection:PopOverMenuDownDirection doneBlock:^(NSString* selectString) {
            
        [btn setTitle:[NSString stringWithFormat:@"%@",selectString] forState:UIControlStateNormal];
        } dismissBlock:^{ }];
}

#pragma  mark - 获取自协议和常用联系人 refresh是否刷新联系人
- (void)getReceiverAndAgreementAndIfRefreshReceiver:(BOOL)refresh{
    self.receiveId= @"1";
    self.deliveryId =@"1";//先初始化一个数值，以免没有默认时，传nil.
    NSString *url =[NSString stringWithFormat:@"%@%@",kSelectSonAgreement,[StorageUtil getRoleId]];
    [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        if (refresh) {
            //发货人信息
            TCLinkModel *deliveryModel = [TCLinkModel objectWithKeyValues:responseObject[@"data"][@"out"]];
            [self assignDeliveryByModel:deliveryModel];
            
            //收货人信息
            TCLinkModel *receiverModel = [TCLinkModel objectWithKeyValues:responseObject[@"data"][@"receive"]];
            [self assignReceiverByModel:receiverModel];
        }
       
        //原始单号
        NSMutableArray *arr=[NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"][@"agreement"]) {
                NSString *isDelFlag = dict[@"delFlag"];
                if ([isDelFlag integerValue]== 1){
                    //0 表示被禁用
                }else{
                    [arr addObject: dict[@"ysNum"]];
                }
        }
        self.aggrementArr = arr;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma  mark 常用联系人
-(void)deviceryTap{
    TCFrequentLinkmanVC *vc = [[TCFrequentLinkmanVC alloc]init];
    self.linkType = LinkTypeDelivery;
    vc.deliveryId = self.deliveryId;
    vc.delegate=self;
    _needPop = NO;
    vc.linkType = LinkTypeDelivery;
   [self.navigationController pushViewController:vc animated:YES];
}

-(void)getTap{
    TCFrequentLinkmanVC *vc = [[TCFrequentLinkmanVC alloc]init];
    vc.delegate=self;
    _needPop = NO;
    self.linkType = LinkTypeReceive;
    vc.receiveId = self.receiveId;
    vc.linkType = LinkTypeReceive;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark  联系人代理回调
- (void)frequentLinkmanDidSelectRowAtIndexPath:(NSIndexPath *)indexPath withObject:(TCLinkModel *)model{
    if (self.linkType == LinkTypeDelivery) {
        [self assignDeliveryByModel:model];
    }else{
        [self assignReceiverByModel:model];
    }
}
-(void)assignDeliveryByModel:(TCLinkModel *)model{
    if (isEmptyString(model.receiveName)) {
        self.deliveryName.text =@"";
        self.deliveryphone.text = @"";
        self.deliveryAddress.text = @"";
        _loadProvice = @"";
        _loadCity = @"";
        _loadArea = @"";
        _loadDetailAddress = @"";
        self.deliveryBtn.titleLabel.font=Font(14);
        [self.deliveryBtn setTitle:@"点击选取联系人" forState:0];
        return;
    }
    [self.deliveryBtn setTitle:@"" forState:0];
    self.deliveryId = model.receiverId;
    self.deliveryName.text = model.receiveName;
    self.deliveryphone.text = model.receiveTel;
    self.deliveryAddress.text = [NSString stringWithFormat:@"%@%@%@%@",model.receiveProvince,model.receiveCity,model.receiveCounty,model.receiveAddress];
    _loadProvice = model.receiveProvince;
    _loadCity = model.receiveCity;
    _loadArea = model.receiveCounty;
    _loadDetailAddress = model.receiveAddress;
}
-(void)assignReceiverByModel:(TCLinkModel *)model{
    if (isEmptyString(model.receiveName)) {
        self.getName.text = @"";
        self.getPhone.text = @"";
        self.unLoadDetailAddres.text = @"";
        _unLoadProvice = @"";
        _unLoadCity = @"";
        _unLoadArea = @"";
        _unLoadAddress = @"";
         self.getBtn.titleLabel.font=Font(14);
         [self.getBtn setTitle:@"点击选取联系人" forState:0];
        return;
    }
    [self.getBtn setTitle:@"" forState:0];
    self.receiveId = model.receiverId;
    self.getName.text = model.receiveName;
    self.getPhone.text = model.receiveTel;
    self.unLoadDetailAddres.text = [NSString stringWithFormat:@"%@%@%@%@",model.receiveProvince,model.receiveCity,model.receiveCounty,model.receiveAddress];
    _unLoadProvice = model.receiveProvince;
    _unLoadCity = model.receiveCity;
    _unLoadArea = model.receiveCounty;
    _unLoadAddress = model.receiveAddress;
}

#pragma  mark 立即发布
-(void)publish{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([_carLength.titleLabel.text isEqualToString:@"长度"]) {
        ToastError(@"请选择车辆长度");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    if ([_carType.titleLabel.text isEqualToString:@"类型"]) {
        ToastError(@"请选择车辆类型");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    if (isEmptyString(_loadProvice)) {
        ToastError(@"请选择发货人地址");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    if (isEmptyString(_loadProvice)) {
        ToastError(@"请选择收货人地址");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
#warning   /** @try @catch @finish 防止一些信息不填写，导致崩溃--*/
    @try {
    
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
        
/**1.发货信息参数*/
        
        //发货人名字
        [dict setObject:_deliveryName.text forKey:@"outName"];
        //发货人电话
        [dict setObject:_deliveryphone.text forKey:@"outTel"];
        //装货市Province
        [dict setObject:_loadProvice forKey:@"outProvince"];
        //装货城市City
        [dict setObject:_loadCity forKey:@"outCity"];
        //装货County
        [dict setObject:_loadArea forKey:@"outCounty"];
        //装货详细地址
        [dict setObject:_loadDetailAddress forKey:@"outAddress"];
        //发货日期
        [dict setObject:_deliveryData.titleLabel.text forKey:@"outDate"];
        
/**2.卸货信息参数*/
        
        //卸货人姓名
        [dict setObject:_getName.text forKey:@"receiveName"];
        //卸货人电话
        [dict setObject:_getPhone.text forKey:@"receiveTel"];
        //卸货市Province
        [dict setObject:_unLoadProvice forKey:@"receiveProvince"];
        //卸货City
        [dict setObject:_unLoadCity forKey:@"receiveCity"];
         //卸货county
        [dict setObject:_unLoadArea forKey:@"receiveCounty"];
        //卸货详细地址
        [dict setObject:_unLoadAddress forKey:@"receiveAddress"];
        
///**3.货物信息参数*/
        
        //货物名称
        [dict setObject:_goodsName.text forKey:@"goodsName"];
        //货物类型
        [dict setObject:_goodsType.titleLabel.text forKey:@"goodsType"];
        //车数量
        [dict setObject:_carNumber.text forKey:@"carNum"];
        //长度
        [dict setObject:_carLength.titleLabel.text forKey:@"carSize"];
        
        //车类型
        [dict setObject:_carType.titleLabel.text forKey:@"carType"];
        if (!isEmptyString(_volume.text)) {
            //体积
            [dict setObject:_volume.text forKey:@"goodsSize"];
        }
        //体积单位
        [dict setObject:@"方" forKey:@"sizeUnit"];
        // 重量单位
        [dict setObject:@"吨" forKey:@"weightUnit"];
        //重量
        [dict setObject:_weight.text forKey:@"goodsWeight"];
        //描述
        [dict setObject:_descrption.text forKey:@"remarks"];
        //报价截止日期
        [dict setObject:_endData.titleLabel.text forKey:@"tenderEndTime"];
        //报价开始时间
        [dict setObject:_beginData.titleLabel.text forKey:@"tenderStartTime"];
        //需求模式:竞争模式:OPEN /总包模式CONTRACTOR,
        [dict setObject:self.publishType forKey:@"tenderType"];
#warning   /** ---公开竞争模式---*/
        if ([self.publishType isEqualToString:@"OPEN"]) {
           
        }else{
#warning   /** ---总包模式---*/
            if (![_originalOddNumer.titleLabel.text isEqualToString:@"请选择原始单号"]){
            [dict setObject: _originalOddNumer.titleLabel.text forKey:@"ysNum"];
            }
        }
        NSString*url=nil;
#warning   /** ---编辑模式---*/
        if (_model) {
            //tenderId
            [dict setObject:_model.tenderId forKey:@"tenderId"];
            //userID
            [dict setObject:[StorageUtil getRoleId] forKey:@"updateBy"];
            url=kDemandModify;
        }else{
#warning   /** ---发布模式---*/
        //UserId---在编辑的上传中没有userId
        [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
            //userID
            [dict setObject:[StorageUtil getRoleId] forKey:@"createBy"];
        url=kAddDemand;
        }
        NSLog(@"%@",dict);
        [[HttpRequest sharedClient]httpRequestPOST:url parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            NSLog(@"%@",responseObject);
            NSString*ifSuccess=responseObject[@"success"];
            
            if ([ifSuccess integerValue]==0){//失败
                if(!isNull(responseObject[@"info"])){
                    ToastError(responseObject[@"info"]);
                }else{
                    ToastError(@"发布失败了,请重试");
                    }
            }else{//成功
                
                if (_model) {//如果是编辑，则pop到最根部
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    ToastSuccess(@"编辑成功");
                    return ;
                }
                ToastSuccess(@"发布成功");
                //清空数据
                [self clear];
                //跳转到我的发布界面
                TCOrderListVC*vc=[[TCOrderListVC alloc]init];
                vc.switchType=SwitchTypeMyPublishList;
                vc.firstSelectedBtn=1;
                [self.navigationController pushViewController:vc animated:YES];
            }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            ToastError(@"糟糕，网络出错了");
        }];
    }
    @catch (NSException *exception) {
        ToastError(@"请填写完整信息");
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    @finally {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }

}


@end
