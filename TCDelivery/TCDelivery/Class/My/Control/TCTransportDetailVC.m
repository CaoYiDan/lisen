//
//  TCOrderManagerViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//




#import "TCUnitView.h"
#import "TCOrderModel.h"
#import "TCTransportDetailVC.h"
#import "TCBaseTextView.h"
#import "TCCertificateView.h"
#import "TCBigMapVC.h"
#import "RouteAnnotation.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface TCTransportDetailVC ()<BMKMapViewDelegate>
//存储查询得到的路线点---传给大地图VC。
@property(nonatomic,strong)NSMutableArray*locationArray;

@end

@implementation TCTransportDetailVC
{
    TCUnitView*_orderIdLabel;
    TCUnitView*_orderCreateDate;
    
    TCUnitView*_devier;
    TCUnitView*_weight;
    TCUnitView*_car;
    
    TCUnitView*_deliverDate;
    
    TCUnitView*_orderStart;
    TCUnitView*_orderEnd;
    TCUnitView*_orderEqument;
    
    UIView*_changeBaseView;
    TCBaseTextView*_transportMeasure;
    TCBaseTextView*_transportPrice;
    
    //百度地图
    BMKMapView* _mapView;
    UIButton*_checkMapBtn;
    
    //已完成
    UIButton*_finishOrderBtn;
    //已装货
    UIButton*_startOrderBtn;
    //确认修改
    UIButton*_changeBtn;
    //查看凭证
    UIButton*_checkCertificate;
    
    NSString*_mapTag;//tag标记，Y代表百度鹰眼轨迹，Z代表中交兴路轨迹
    UIButton*_chungHingRoadMap;
    UIButton*_eagelEyeMap;
    
    TCCertificateView*_certificateView;//凭证
    NSString *_certificateHeaderUrl;//请求得到的凭证Url的header
    NSString *_certificateUrl;//请求得到的凭证Url
    
    UIImageView*_imagePrice;
}

#pragma  mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"运单详情";
    //布局
    [self createUI];
    //请求运单数据
    [self loadData];
    //请求运单轨迹
    _mapTag=@"Y";//第一此加载时默认为鹰眼轨迹
    [self loadPointData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma  mark - 创建UI
-(void)createUI{
    UIScrollView*baseView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    baseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseView];
    UIView*topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 15)];
    topLine.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:topLine];
    //定单号
    _orderIdLabel=[[TCUnitView alloc]init];
    _orderIdLabel.type=14;
    [baseView addSubview:_orderIdLabel];
    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kiPhone5) {
            make.left.offset(2);
            make.width.offset(kWindowW/2-10);
        }else{
            make.left.offset(10);
        }
        make.height.offset(30);
        make.top.offset(15);
    }];
    //创建时间
    _orderCreateDate=[[TCUnitView alloc]init];
    _orderCreateDate.type=24;
    
    [baseView addSubview:_orderCreateDate];
    [_orderCreateDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWindowW/2);
        make.height.offset(30);
        make.width.offset(kWindowW/2);
        make.top.equalTo(_orderIdLabel).offset(0);
    }];
    
    UIView*line1=[[UIView alloc]init];
    line1.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(_orderIdLabel.bottom).offset(0);
    }];
    //司机
    _devier=[[TCUnitView alloc]init];
    _devier.type=33;
    [baseView addSubview:_devier];
    [_devier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(30);
        make.top.equalTo(line1.bottom).offset(10);
    }];
    
    //    //载重:
    //    TCUnitView*weightTitle=[[TCUnitView alloc]init];
    //    weightTitle.type=15;
    //    [weightTitle setLabelText:@"载重:"];
    //    [baseView addSubview:weightTitle];
    //    [weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset(10);
    //        make.height.offset(30);
    //        make.top.equalTo(_devier.bottom).offset(JianJu);
    //    }];
    //
    //    //吨
    //    _weight=[[TCUnitView alloc]init];
    ////    _weight.type=0;
    //    [baseView addSubview:_weight];
    //    [_weight mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(weightTitle.right).offset(4);
    //        make.height.offset(30);
    //        make.top.equalTo(weightTitle);
    //    }];
    //
    //车牌号
    _car=[[TCUnitView alloc]init];
    _car.type=35;
    [baseView addSubview:_car];
    [_car mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderCreateDate);
        make.height.offset(30);
        make.top.equalTo(_devier);
    }];
    
    //发货时间
    _deliverDate=[[TCUnitView alloc]init];
    _deliverDate.type=37;
    [baseView addSubview:_deliverDate];
    [_deliverDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_devier);
        make.height.offset(30);
        make.top.equalTo(_devier.bottom).offset(JianJu);
    }];
    
    UIView*line11=[[UIView alloc]init];
    line11.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line11];
    [line11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(_deliverDate.bottom).offset(10);
    }];
    
    //起点
    _orderStart=[[TCUnitView alloc]init];
    _orderStart.type=10;
    [baseView addSubview:_orderStart];
    [_orderStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(30);
        make.top.equalTo(line11.bottom).offset(10);
    }];
    //终点
    _orderEnd=[[TCUnitView alloc]init];
    _orderEnd.type=11;
    [baseView addSubview:_orderEnd];
    [_orderEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderStart);
        make.height.offset(30);
        make.top.equalTo(_orderStart.bottom).offset(JianJu);
    }];
    
    //中交兴路轨迹
    UIButton*chungHingRoadMap=[[UIButton alloc]init];
    chungHingRoadMap.tag=12;
    chungHingRoadMap.hidden=YES;
    _chungHingRoadMap=chungHingRoadMap;
    [chungHingRoadMap addTarget:self action:@selector(changeMap:) forControlEvents:UIControlEventTouchUpInside];
    chungHingRoadMap.titleLabel.font=Font(12);
    [chungHingRoadMap setTitleColor:[UIColor whiteColor] forState:0];
    chungHingRoadMap.backgroundColor=kRGBColor(206, 207, 208);
    [chungHingRoadMap setTitle:@"切换到中交兴路轨迹" forState:0];
    [chungHingRoadMap setTitleColor:[UIColor blackColor] forState:0];
    [baseView addSubview:chungHingRoadMap];
    [chungHingRoadMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 30));
        make.top.equalTo(_orderEnd.bottom).offset(10);
    }];
    
    //鹰眼轨迹
    UIButton*eagelEyeMap=[[UIButton alloc]init];
    eagelEyeMap.tag=13;
    //在百度地图路径规划完之前，这个按钮不能点击
    [eagelEyeMap addTarget:self action:@selector(changeMap:) forControlEvents:UIControlEventTouchUpInside];
    _eagelEyeMap=eagelEyeMap;
    eagelEyeMap.titleLabel.font=Font(12);
    eagelEyeMap.backgroundColor=kRGBColor(206, 207, 208);
    [eagelEyeMap setTitleColor:[UIColor whiteColor] forState:0];
    [eagelEyeMap setTitle:@"切换到百度鹰眼轨迹" forState:0];
    [eagelEyeMap setTitleColor:[UIColor blackColor] forState:0];
    [baseView addSubview:eagelEyeMap];
    [eagelEyeMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 30));
        make.top.equalTo(chungHingRoadMap.bottom).offset(3);
    }];
    
    //地图图片
    _mapView=[[BMKMapView alloc]init];
    [baseView addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(eagelEyeMap.bottom).offset(3);
        make.size.offset(CGSizeMake(kWindowW, kWindowW/2));
    }];
    
    UIButton*checkMap=[[UIButton alloc]init];
    _checkMapBtn=checkMap;
    //在百度地图路径规划完之前，这个按钮不能点击
    _checkMapBtn.userInteractionEnabled=NO;
    [checkMap addTarget:self action:@selector(checkMapClick) forControlEvents:UIControlEventTouchUpInside];
    [checkMap setImage:[UIImage imageNamed:@"fh_dd_xq_an9"] forState:0];
    checkMap.titleLabel.font=Font(12);
    checkMap.backgroundColor=LGLighgtBGroundColour235;
    checkMap.layer.cornerRadius=5;
    [checkMap setTitle:@"查看大图" forState:0];
    [checkMap setTitleColor:[UIColor blackColor] forState:0];
    [baseView addSubview:checkMap];
    [checkMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWindowW-120);
        make.size.offset(CGSizeMake(110, 30));
        make.top.equalTo(_mapView.bottom).offset(3);
    }];
    
    //分割线
    UIView*line12=[[UIView alloc]init];
    line12.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line12];
    [line12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 10));
        make.top.equalTo(checkMap.bottom).offset(5);
    }];
    
    //修改界面的背景View
    UIView*changeBaseView=[[UIView alloc]init];
    [baseView addSubview:changeBaseView];
    _changeBaseView=changeBaseView;
    [changeBaseView makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(checkMap.bottom).offset(10);
        make.size.offset(CGSizeMake(kWindowW, 100));
    }];
    
    //修改运输量
    _transportMeasure=[[TCBaseTextView alloc]init];
    [_transportMeasure setText:@"运输量 "];
    [changeBaseView addSubview:_transportMeasure];
    [_transportMeasure makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWindowW/2-100);
        make.size.offset(CGSizeMake(200, 30));
        make.top.offset(10);
    }];
    //吨
    UIImageView*measureImage=[[UIImageView alloc]init];
    [measureImage setImage:[UIImage imageNamed:@"fh_dd_xq_an1"]];
    [changeBaseView addSubview:measureImage];
    [measureImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_transportMeasure.right).offset(5);
        make.top.offset(15);
        make.size.offset(CGSizeMake(20, 20));
    }];
    
    //修改运输价
    _transportPrice=[[TCBaseTextView alloc]init];
    [_transportPrice setText:@"运输价 "];
    [changeBaseView addSubview:_transportPrice];
    [_transportPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWindowW/2-100);
        make.size.offset(CGSizeMake(200, 30));
        make.top.equalTo(_transportMeasure.bottom).offset(5);
    }];
    _changeBaseView.hidden=YES;//先隐藏
    //元
    UIImageView*priceImage=[[UIImageView alloc]init];
    _imagePrice=priceImage;
    [priceImage setImage:[UIImage imageNamed:@"fh_dd_xq_an11"]];
    [changeBaseView addSubview:priceImage];
    [priceImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_transportPrice.right).offset(5);
        make.top.equalTo(_transportPrice.top).offset(5);
        make.size.offset(CGSizeMake(20, 20));
    }];
    //确认修改
    UIButton*changeBtn=[[UIButton alloc]init];
    [changeBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.layer.cornerRadius=5;
    _changeBtn=changeBtn;
    changeBtn .backgroundColor=KTCBlueColor;
    [changeBtn setTitle:@"确认修改" forState:0 ];
    [changeBaseView addSubview:changeBtn];
    changeBtn.titleLabel.font=Font(13);
    [changeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(100, 30));
        make.centerX.offset(0);
        make.top.equalTo(_transportPrice.bottom).offset(10);
    }];
    
    UIView*line13=[[UIView alloc]init];
    line13.backgroundColor=LGLighgtBGroundColour235;
    [changeBaseView addSubview:line13];
    [line13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 10));
        make.top.equalTo(changeBtn.bottom).offset(10);
    }];
    
    //已完成
    UIButton*haveFinishBtn=[[UIButton alloc]init];
    _finishOrderBtn=haveFinishBtn;
    haveFinishBtn.layer.cornerRadius=5;
    haveFinishBtn.tag=2;
    haveFinishBtn.titleLabel.font=Font(13);
    [haveFinishBtn addTarget:self action:@selector(optional:) forControlEvents:UIControlEventTouchUpInside];
    haveFinishBtn.backgroundColor=KTCBlueColor;
    [haveFinishBtn setTitle:@"已完成" forState:0 ];
    [baseView addSubview:haveFinishBtn];
    [haveFinishBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(100, 30));
        make.centerX.offset(0);
        make.top.equalTo(line13.bottom).offset(10);
    }];
    
    //查看凭证
    UIButton*checkCertificate=[[UIButton alloc]init];
    checkCertificate.layer.cornerRadius=5;
    checkCertificate.tag=2;
    _checkCertificate=checkCertificate;
    checkCertificate.titleLabel.font=Font(13);
    [checkCertificate addTarget:self action:@selector(checkCertificate) forControlEvents:UIControlEventTouchUpInside];
    checkCertificate.backgroundColor=KTCBlueColor;
    [checkCertificate setTitle:@"查看凭证" forState:0 ];
    [baseView addSubview:checkCertificate];
    [checkCertificate makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(100, 30));
        make.centerX.offset(kWindowW/2-60);
        make.top.equalTo(line12.bottom).offset(10);
    }];
    //已装货
    UIButton*haveLoadBtn=[[UIButton alloc]init];
    _startOrderBtn=haveLoadBtn;
    [haveLoadBtn addTarget:self action:@selector(optional:) forControlEvents:UIControlEventTouchUpInside];
    haveLoadBtn.tag=1;
    haveLoadBtn.layer.cornerRadius=5;
    haveLoadBtn.titleLabel.font=Font(13);
    haveLoadBtn .backgroundColor=KTCBlueColor;
    [haveLoadBtn setTitle:@"已装货" forState:0 ];
    [baseView addSubview:haveLoadBtn];
    [haveLoadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(100, 30));
        make.centerX.offset(0);
        make.top.equalTo(line13.bottom).offset(10);
    }];
    baseView.contentSize=CGSizeMake(0, 800);
}

#pragma  mark - 请求数据
-(void)loadData{
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:self.transportId forKey:@"orderDetailsNum"];
    NSString*url=[NSString stringWithFormat:@"%@%@",kTransportDetail,self.transportId];
    [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSLog(@"%@",responseObject);
        //运单详情数据
        TCOrderModel*model=[TCOrderModel objectWithKeyValues:responseObject[@"data"][@"orderDetailDto"]];
        //赋值数据
        [self createModel:model];
        //得到凭证Url
        _certificateHeaderUrl=responseObject[@"data"][@"orderDetailDto"][@"imageHeadUrl"];
        _certificateUrl=responseObject[@"data"][@"orderDetailDto"][@"imageUrl"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
    }];
}

//请求运单轨迹
-(void)loadPointData{
    if ([_mapTag isEqualToString:@"Y"]) {
    }
    [MBProgressHUD showHUDAddedTo:_mapView animated:YES];
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:self.transportId forKey:@"entityName"];
    [dict setObject:_mapTag forKey:@"tag"];//tag标记，Y代表百度鹰眼轨迹，Z代表中交兴路轨迹
    [[HttpRequest sharedClient]httpRequestPOST:kTransportPoint parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        //运单IDzai
        self.locationArray=responseObject[@"data"];
        //绘制轨迹点
        [self drawPoint];
        [MBProgressHUD hideHUDForView:_mapView animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:_mapView animated:YES];
    }];
}

#pragma  mark 绘制路线
-(void)drawPoint{
  
     CLLocationCoordinate2D*coors=malloc([self.locationArray count]*sizeof(CLLocationCoordinate2D));
    for (int i=0; i<self.locationArray.count; i++) {
        NSDictionary*dict=self.locationArray[i];
        coors[i].latitude=[dict[@"y"] floatValue];
        coors[i].longitude=[dict[@"x"] floatValue];
        
        if (i==0) {
            //将地图的中心设置为起点
            BMKMapStatus*status=[[BMKMapStatus alloc]init];
            status.targetGeoPt=coors[0];
            [_mapView setMapStatus:status];
            
            //大头针
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = coors[0];
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
    }
        _checkMapBtn.userInteractionEnabled=YES;
        BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:self.locationArray.count];
        [_mapView addOverlay:polyline];
}
#pragma  mark - 数据赋值
-(void)createModel:(TCOrderModel*)model{
//    是否有中交兴路地图（0没有 1有）
    if([model.iszjxl integerValue]==0){
        //隐藏掉中交兴路按钮，并且将鹰眼按钮上移
        _chungHingRoadMap.hidden=YES;
        [_eagelEyeMap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chungHingRoadMap.bottom).offset(-30);
        }];
    }else{
        _chungHingRoadMap.hidden=NO;
    }
    //运单ID
    [_orderIdLabel setLabelText:[NSString stringWithFormat:@"订单号: %@",model.orderDetailsNum]];
    //创建时间
    [_orderCreateDate setLabelText:model.createDateStr];
    //司机
    [_devier setLabelText:[NSString stringWithFormat:@"司机:%@",model.driverName]];
//    if ([model.sizeUnit isEqualToString:@"吨"]) {
//        _weight.type=0;
//      [_weight setLabelText:[NSString stringWithFormat:@"%.1f",model.actualNum]];
//    }else{
//    //载重
//        _weight.type=4;
//   
//    [_weight setLabelText:[NSString stringWithFormat:@"%.1f %@",model.actualNum,model.sizeUnit]];
//    }
    //车牌号
    [_car setLabelText:model.carCode];
    
    //起点
    [_orderStart setLabelText:[NSString stringWithFormat:@"%@ %@ %@ %@",model.outProvince,model.outCity,model.outCounty,model.outAddress]];
    //终点
    [_orderEnd setLabelText:[NSString stringWithFormat:@"%@ %@ %@ %@",model.receiveProvince,model.receiveCity,model.receiveCounty,model.receiveAddress]];
    //发货时间
    [_deliverDate setLabelText:[NSString stringWithFormat:@"发货时间:%@",model.deliverTimeStr]];
    //只有在 待运输 时，才能开始发货，在待（未）运输 和 运输中 修改运输数据    在开始运输后，才显示 已完成 按钮。
    if ([model.transStatus isEqualToString:@"未运输"]||[model.transStatus isEqualToString:@"待运输"]) {
        _changeBaseView.hidden=NO;
        _finishOrderBtn.hidden=YES;
        _checkCertificate.hidden=YES;
    }else if([model.transStatus isEqualToString:@"已完成"]){
        _changeBaseView.hidden=YES;
        _startOrderBtn.hidden=YES;
        _finishOrderBtn.hidden=YES;
        //公开竞争模式下，显示 查看凭证按钮，总包模式下部显示。
        if([self.tenderType isEqualToString:@"OPEN"]){
            _checkCertificate.hidden=NO;
        }else{
           _checkCertificate.hidden=YES;
        }
    }else if([model.transStatus isEqualToString:@"已取消"]){
        _changeBaseView.hidden=YES;
        _startOrderBtn.hidden=YES;
        _finishOrderBtn.hidden=YES;
        _checkCertificate.hidden=YES;
    }else if([model.transStatus isEqualToString:@"运输中"]){
        _startOrderBtn.hidden=YES;
        _checkCertificate.hidden=YES;
        _changeBaseView.hidden=NO;
    }
    //运输量赋值
    _transportMeasure.textFiled.text=[NSString stringWithFormat:@"%.2f",model.actualNum];
    //运输价赋值
    _transportPrice.textFiled.text=[NSString stringWithFormat:@"%.2f",model.actualTotalprice];
    //总包模式下隐藏所有关于价格的控件
    if ([self.tenderType isEqualToString:@"CONTRACTOR"]) {
        _transportPrice.hidden=YES;
        [_changeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_transportPrice.bottom).offset(-25);
        }];
        _imagePrice.hidden=YES;
    }
}

#pragma  mark - 按钮操作
#pragma  mark 已装货 已完成
-(void)optional:(UIButton*)btn{
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:self.transportId2 forKey:@"id"];
    //操作标志(开始运单--"1",结束运单----"2") ,
    if(btn.tag==1){
        [dict setObject:@"1" forKey:@"opMark"];
    }else{
        [dict setObject:@"2" forKey:@"opMark"];
    }
    [dict setObject:[StorageUtil getRoleId] forKey:@"updateBy"];
    NSLog(@"%@",dict);
    [[HttpRequest sharedClient]httpRequestPOST:kStartOrOverOrderDetail parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSString*isSuccess=responseObject[@"success"];
        
        if ([isSuccess integerValue]==1){
            ToastSuccess(@"修改成功,请刷新数据");
        }else{
            ToastError(@" 操作失败，请稍后重试!");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络不太好，修改失败了");
    }];
}
#pragma  mark  //修改报价和运输量
-(void)change{
    if ([_transportPrice.textFiled.text integerValue]==0||[_transportMeasure.textFiled.text integerValue]==0) {
        ToastError(@"请填写正确信息");
        return;
    }
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:_transportMeasure.textFiled.text forKey:@"num"];
    [dict setObject:_transportPrice.textFiled.text forKey:@"totalPrice"];
    [dict setObject:self.transportId2 forKey:@"id"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"updateBy"];
    NSLog(@"%@",dict);
    [[HttpRequest sharedClient]httpRequestPOST:kUpdateOrderDetailNumOrPrice parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSLog(@"%@",responseObject);
        NSString*isSuccess=responseObject[@"success"];
        if ([isSuccess integerValue]==1){
            ToastSuccess(@"修改成功");
        }else{
            ToastError(@"糟糕，出错了");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络不太好，修改失败了");
    }];
}
#pragma  mark 查看凭证
-(void)checkCertificate{
    _certificateView=[[TCCertificateView alloc]initWithFrame:self.view.bounds CertificateImagePath:_certificateUrl imageHeaderUrl:_certificateHeaderUrl];
    [self.view addSubview:_certificateView];
}
#pragma  mark 查看路线（查看大地图）
-(void)checkMapClick{
    TCBigMapVC*mapVC=[[TCBigMapVC alloc]init];
    mapVC.locationArray=self.locationArray;
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma  mark 切换地图
-(void)changeMap:(UIButton*)btn{
    if (btn.tag==12) {
        _mapTag=@"Y";
    }else if (btn.tag==13){
        _mapTag=@"Z";
    }
    //清除已划线轨迹
    [_mapView removeOverlays:_mapView.overlays];
    //重新请求数据
    [self loadPointData];
}
#pragma  mark  - 地图轨迹代理
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}
#pragma  mark - setter
-(NSMutableArray*)locationArray{
    if (!_locationArray) {
        _locationArray=[NSMutableArray array];
    }
    return _locationArray;
}

@end
