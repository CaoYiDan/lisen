//
//  TCOrderManagerViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//
#import "TCUnitView.h"
#import "TCOrderModel.h"
#import "TCTransportTableViewController.h"
#import "TCOrderDetailViewController.h"

//
//#import "TCBigMapVC.h"
//#import "RouteAnnotation.h"
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//


@interface TCOrderDetailViewController ()
@property(nonatomic,strong)NSArray*locationArray;

@end

@implementation TCOrderDetailViewController
{
    TCUnitView*_orderIdLabel;
    TCUnitView*_createDate;
    
    TCUnitView*_totalWeight;
    TCUnitView*_weight;
    TCUnitView*_unitPrice;
    TCUnitView*_carNumber;
    TCUnitView*_totalPrice;
    TCUnitView*_deliverDate;
    
    TCUnitView*_orderStart;
    TCUnitView*_orderEnd;
    TCUnitView*_orderEqument;
    
    TCUnitView*_orderVolume;
    UILabel*_requirement;
    
    TCUnitView*_totalPriceTitle;
//    //地图
//    BMKMapView* _mapView;
//    BMKRouteSearch*_routeSearch;
//    UIButton*_checkMapBtn;
}
-(NSArray*)locationArray{
    if (!_locationArray) {
        _locationArray=[NSArray array];
    }
    return _locationArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"订单详情";
    
    //布局
    [self createUI];
    //请求数据
    [self loadData];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:KMainColor];

}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//    _routeSearch.delegate = nil;
//}

//- (void)dealloc {
//    if (_routeSearch!= nil) {
//        _routeSearch = nil;
//    }
//    if (_mapView) {
//        _mapView = nil;
//    }
//}

#pragma  mark 请求数据
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:self.orderNum forKey:@"orderNum"];
    [dict setObject:@"1" forKey:@"pageNumber"];
    [dict setObject:@"1" forKey:@"pageSize"];
    
    [[HttpRequest sharedClient]httpRequestPOST:kOrderList parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
        NSLog(@"%@",responseObject);
        TCOrderModel*model1=[[TCOrderModel alloc]init];
        model1=[TCOrderModel objectWithKeyValues:responseObject[@"data"][@"list"][0]];
        [self createModel:model1];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        ToastError(@"网络错误");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

//模型赋值
-(void)createModel:(TCOrderModel*)model{
    //订单号
    [_orderIdLabel setLabelText:[NSString stringWithFormat:@"订单号: %@",model.orderNum]];
    //创建时间
    [_createDate setLabelText:model.createDateStr];
    //发货地址
    [_orderStart setLabelText:[NSString stringWithFormat:@"%@ %@ %@ %@",model.outProvince,model.outCity,model.outCounty,model.outAddress]];
    //卸货地址
    [_orderEnd setLabelText:[NSString stringWithFormat:@"%@ %@ %@ %@",model.receiveProvince,model.receiveCity,model.receiveCounty,model.receiveAddress]];
    //车辆数
    [_carNumber setLabelText:[NSString stringWithFormat:@"%.0d",model.carNum]];
    //总价格
    if(!isNull(model.shipingTotalprice)&&!isEmptyString(model.shipingTotalprice)){
        [_totalPrice setLabelText:[NSString stringWithFormat:@"%@",model.shipingTotalprice]];
    }
    //发货时间
    [_deliverDate setLabelText:[NSString stringWithFormat:@"发货时间:%@",model.deliverTimeStr]];
    //吨
    if ([model.sizeUnit isEqualToString:@"吨"]) {
        _weight.type=0;
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f",model.shipingNum]];
        
    }else{
        //单位不是吨
        _weight.type=4;
        
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f %@",model.shipingNum,model.sizeUnit]];
    }
    //单价
    [_unitPrice setLabelText:[NSString stringWithFormat:@"%.2f 元/吨",model.shipingPrice]];
    //总包模式下隐藏所有关于价格的控件
    NSLog(@"%@",model.tenderType);
    if ([model.tenderType isEqualToString:@"CONTRACTOR"]) {
        _requirement.text=model.remarks;
        _unitPrice.hidden=YES;
        _totalPrice.hidden=YES;
        _totalPriceTitle.hidden=YES;
    }
}
-(void)createUI{
    UIScrollView*baseView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    baseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIView*topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 10)];
    topLine.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:topLine];
    //定单号
    _orderIdLabel=[[TCUnitView alloc]init];
    _orderIdLabel.type=14;
    [baseView addSubview:_orderIdLabel];
    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(30);
        make.width.offset(kWindowW/2-15);
        make.top.offset(10);
    }];
    //创建时间
    _createDate=[[TCUnitView alloc]init];
    _createDate.type=12;
    [baseView addSubview:_createDate];
    
    [_createDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWindowW/2);
        make.size.offset(CGSizeMake(kWindowW/2-3, 30));
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

    //总报价量:
    TCUnitView*weightTitle=[[TCUnitView alloc]init];
    weightTitle.type=21;
    [weightTitle setLabelText:@"总报价量:"];
    [baseView addSubview:weightTitle];
    [weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderIdLabel);
        make.height.offset(30);
        make.top.equalTo(line1.bottom).offset(10);
    }];
    //吨
    _weight=[[TCUnitView alloc]init];
    [baseView addSubview:_weight];
    [_weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weightTitle.right).offset(4);
        make.height.offset(30);
        make.top.equalTo(weightTitle);
    }];
    
    //车辆数量
    TCUnitView*carTitle=[[TCUnitView alloc]init];
     carTitle.type=35;
    [carTitle setLabelText:@"车辆数量:"];
    [baseView addSubview:carTitle];
    [carTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderIdLabel);
        make.height.offset(30);
        make.top.equalTo(_weight.bottom).offset(JianJu);
    }];

    //辆
    _carNumber=[[TCUnitView alloc]init];
    _carNumber.type=2;
    [baseView addSubview:_carNumber];
    [_carNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carTitle.right).offset(4);
        make.height.offset(30);
        make.top.equalTo(carTitle);
    }];
    //元
    _totalPrice=[[TCUnitView alloc]init];
    _totalPrice.type=3;
    [baseView addSubview:_totalPrice];
    [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWindowW-90);
        make.size.offset(CGSizeMake(85, 30));
        make.top.equalTo(_carNumber);
    }];
    //合计费用
    TCUnitView*totalPriceTitle=[[TCUnitView alloc]init];
    totalPriceTitle.type=36;
    _totalPriceTitle=totalPriceTitle;
    [totalPriceTitle setLabelText:@"合计:"];
    [baseView addSubview:totalPriceTitle];
    [totalPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_totalPrice.left).offset(0);
        make.height.offset(30);
        make.top.equalTo(_carNumber);
    }];
    //单
    _unitPrice=[[TCUnitView alloc]init];
    _unitPrice.type=34;
    [baseView addSubview:_unitPrice];
    [_unitPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalPriceTitle);
        make.height.offset(30);
        make.top.equalTo(_weight);
    }];
    
    UIView*line11=[[UIView alloc]init];
    line11.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line11];
    [line11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(_carNumber.bottom).offset(10);
    }];

    //起点
    _orderStart=[[TCUnitView alloc]init];
    _orderStart.type=10;
    [baseView addSubview:_orderStart];
    [_orderStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderIdLabel);
        make.height.offset(30);
        make.top.equalTo(line11.bottom).offset(2);
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
    
    //发货时间
    _deliverDate=[[TCUnitView alloc]init];
    _deliverDate.type=37;
    [baseView addSubview:_deliverDate];
    [_deliverDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderStart);
        make.height.offset(30);
        make.top.equalTo(_orderEnd.bottom).offset(JianJu);
    }];
    //分割线
    UIView*line3=[[UIView alloc]init];
    line3.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(_deliverDate.bottom).offset(0);
    }];
    //要求
    UILabel*requirement=[[UILabel alloc]init];
    requirement.numberOfLines=0;
    _requirement=requirement;
    requirement.font=Font(12);
    
    [baseView addSubview:requirement];
    [requirement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(line3.bottom).offset(10);
        make.width.offset(kWindowW-20);
    }];
    
    UIView*line111=[[UIView alloc]init];
    line111.backgroundColor=LGLighgtBGroundColour235;
    [baseView addSubview:line111];
    [line111 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(requirement.bottom).offset(10);
    }];
    
    
//    //地图图片
//    _mapView=[[BMKMapView alloc]init];
//    [baseView addSubview:_mapView];
//    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(0);
//        make.top.equalTo(requirement.bottom).offset(10);
//        make.size.offset(CGSizeMake(kWindowW, kWindowW/2));
//    }];
//    
//    UIButton*checkMap=[[UIButton alloc]init];
//    _checkMapBtn=checkMap;
//    //在百度地图路径规划完之前，这个按钮不能点击
//    _checkMapBtn.userInteractionEnabled=NO;
//    [checkMap addTarget:self action:@selector(checkMapClick) forControlEvents:UIControlEventTouchUpInside];
//    [checkMap setImage:[UIImage imageNamed:@"fh_dd_xq_an9"] forState:0];
//    checkMap.titleLabel.font=Font(12);
//    checkMap.backgroundColor=LGLighgtBGroundColour235;
//    checkMap.layer.cornerRadius=5;
//    [checkMap setTitle:@"查看路线" forState:0];
//    [checkMap setTitleColor:[UIColor blackColor] forState:0];
//    [baseView addSubview:checkMap];
//    [checkMap mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(kWindowW-120);
//        make.size.offset(CGSizeMake(110, 30));
//        make.top.equalTo(_mapView.bottom).offset(3);
//    }];
   // 查看运单
    UIButton*check=[[UIButton alloc]initWithFrame:CGRectMake(kWindowW/2-50, kWindowH-50, 100, 30)];
    check.layer.cornerRadius=5;
    [check setTitle:@"查看运单" forState:0];
    check.titleLabel.font=Font(13);
    [check addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:check];
    check.backgroundColor=KTCBlueColor;
    
    baseView.contentSize=CGSizeMake(0,600);
    
    baseView.bounces=NO;
}
//-(void)loacationMapWithStart:(NSString*)startCity startName:(NSString*)startName andEndCity:(NSString*)endCity endName:(NSString*)endName{
//    [MBProgressHUD showHUDAddedTo:_mapView animated:YES];
//
//    //初始化检索对象
//    _routeSearch=[[BMKRouteSearch alloc] init];
//    //设置delegate，用于接收检索结果
//    _routeSearch.delegate=self;
//    //构造公共交通路线规划检索信息类
//    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    
//    start.name = startName;
//    start.cityName = startCity;
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.name = endName;
//    end.cityName = endCity;
//    
//    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
//    drivingRouteSearchOption.from = start;
//    drivingRouteSearchOption.to = end;
//    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
//    BOOL flag2 = [_routeSearch drivingSearch:drivingRouteSearchOption];
//    if(flag2)
//    {
//        NSLog(@"car检索发送成功");
//    }
//    else
//    {
//        NSLog(@"car检索发送失败");
//    }
//}
//
//-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
//    NSLog(@"驾车查询--- error:%d", (int)error);
//    
//    [MBProgressHUD hideHUDForView:_mapView animated:YES];
//    if (error == BMK_SEARCH_NO_ERROR) {
//        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
//        // 计算路线方案中的路段数目
//        NSInteger size = [plan.steps count];
//        
//        //将返回的路线存储起来
//        self.locationArray=plan.steps;
//        //轨迹点
//       
//        CLLocationCoordinate2D*coors=malloc([self.locationArray count]*sizeof(CLLocationCoordinate2D));
//            for (int j = 0; j < size; j++) {
//                
//                BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
//                coors[j].latitude = transitStep.entrace.location.latitude;
//                coors[j].longitude = transitStep.entrace.location.longitude;
//                
//                if (j==0) {
//                    //将地图的中心设置为起点
//                    BMKMapStatus*status=[[BMKMapStatus alloc]init];
//                    status.targetGeoPt=transitStep.entrace.location;
//                    [_mapView setMapStatus:status];
//                }
//            }
//            BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:size];
//            [_mapView addOverlay:polyline];
//            //在百度地图路径规划完之后，这个按钮才能点击
//            _checkMapBtn.userInteractionEnabled=YES;
//
//        
//    }else{
//        [MBProgressHUD showError:@"路径规划失败" toView:_mapView];
//    }
//}
//
//// Override
//- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
//    if ([overlay isKindOfClass:[BMKPolyline class]]){
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
//        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
//        polylineView.lineWidth = 2.0;
//        return polylineView;
//    }
//    return nil;
//}
//#pragma  mark 查看路线（查看大地图）
//-(void)checkMapClick{
//    TCBigMapVC*mapVC=[[TCBigMapVC alloc]init];
//    mapVC.locationArray=self.locationArray;
//    [self.navigationController pushViewController:mapVC animated:YES];
//}

#pragma  mark  查看运单
-(void)check{
    TCTransportTableViewController*vc=[[TCTransportTableViewController alloc]init];
    vc.orderNum=self.orderNum;
    vc.orderId=self.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
