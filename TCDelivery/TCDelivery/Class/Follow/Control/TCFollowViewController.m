//
//  TCFollowViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//
#import "RouteAnnotation.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "TCFollowViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface TCFollowViewController ()<BMKMapViewDelegate>
@property(nonatomic,strong)NSArray*locationArr;
@end

@implementation TCFollowViewController
{
    BMKMapView* _mapView;
    NSString*_mapTag;//Y代表百度鹰眼轨迹，Z代表中交兴路轨迹
    
//    BMKRouteSearch*_routeSearch;
}
-(NSArray*)locationArr{
    if (!_locationArr) {
        _locationArr=[NSArray array];
    }
    return _locationArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"运输监控";
   
     //初始化百度地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64-49)];
    [self.view addSubview:_mapView];
//    [MBProgressHUD showHUDAddedTo:_mapView animated:YES];
    
    _mapTag=@"Z";
    //鹰眼轨迹
    UIButton*eagelEyeMap=[[UIButton alloc]init];
    eagelEyeMap.tag=13;
    //在百度地图路径规划完之前，这个按钮不能点击
    [eagelEyeMap addTarget:self action:@selector(changeMap:) forControlEvents:UIControlEventTouchUpInside];
    
    eagelEyeMap.titleLabel.font=Font(12);
    eagelEyeMap.backgroundColor=kRGBColor(206, 207, 208);
    [eagelEyeMap setTitleColor:[UIColor whiteColor] forState:0];
    [eagelEyeMap setTitle:@"切换到百度鹰眼轨迹" forState:0];
    [eagelEyeMap setTitleColor:[UIColor blackColor] forState:0];
    [self.view addSubview:eagelEyeMap];
    [eagelEyeMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 30));
        make.bottom.offset(-50);
    }];

    //中交兴路轨迹
    UIButton*chungHingRoadMap=[[UIButton alloc]init];
    chungHingRoadMap.tag=12;
    [chungHingRoadMap addTarget:self action:@selector(changeMap:) forControlEvents:UIControlEventTouchUpInside];
    chungHingRoadMap.titleLabel.font=Font(12);
    [chungHingRoadMap setTitleColor:[UIColor whiteColor] forState:0];
    chungHingRoadMap.backgroundColor=kRGBColor(206, 207, 208);
    [chungHingRoadMap setTitle:@"切换到中交兴路轨迹" forState:0];
    [chungHingRoadMap setTitleColor:[UIColor blackColor] forState:0];
    [self.view addSubview:chungHingRoadMap];
    [chungHingRoadMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 30));
        make.bottom.equalTo(eagelEyeMap.top).offset(-3);
    }];
}

-(void)loadAllPoint{
    [MBProgressHUD showHUDAddedTo:_mapView animated:YES];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
//    也是Z是中交兴路，Y是百度鹰眼
    [dict setObject:_mapTag forKey:@"tag"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    //"SHIPPING"; //发货公司
    [dict setObject:@"SHIPPING" forKey:@"userType"];
    [[HttpRequest sharedClient]httpRequestPOST:kALLTransportPoint parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
        NSLog(@"%@",responseObject);
        self.locationArr=responseObject[@"data"];
        //划线
        [self drawPoint];
         [MBProgressHUD hideHUDForView:_mapView animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            ToastError(@"请求超时");
            [MBProgressHUD hideHUDForView:_mapView animated:YES];
        }];
}

-(void)drawPoint{
    
    for (NSDictionary*dic in self.locationArr) {
        
        NSArray * allkeys = [dic allKeys];
      
        //    // 添加折线覆盖物
      
        NSArray*allPointArr=dic[allkeys[0]];
        
        CLLocationCoordinate2D*coors=malloc([allPointArr count]*sizeof(CLLocationCoordinate2D));
        for (int i=0; i<allPointArr.count; i++) {
           
            NSDictionary*di=allPointArr[i];

            coors[i].latitude=[di[@"y"] floatValue];
            coors[i].longitude=[di[@"x"] floatValue];
            
            if (i==0) {
                CLLocationCoordinate2D coor;
                coor.latitude=[di[@"y"] floatValue];
                coor.longitude=[di[@"x"] floatValue];
                //将地图的中心设置为起点
                BMKMapStatus*status=[[BMKMapStatus alloc]init];
                status.targetGeoPt=coor;
                [_mapView setMapStatus:status];
                
                //大头针----运单号
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate =coor;
                item.title = [NSString stringWithFormat:@"订单编号:%@",allkeys[0]];
                item.type = 3;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
        }
        if (allPointArr.count!=0) {
            BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:allPointArr.count];
            [_mapView addOverlay:polyline];
        }
    }
    [MBProgressHUD hideHUDForView:_mapView animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    //地图比例
    [_mapView setZoomLevel:10];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //请求数据
    [self loadAllPoint];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //百度地图的接入，会改变导航栏的背景颜色，在此设置一下
    [self.navigationController.navigationBar setBarTintColor:KMainColor];
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
// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}

-(void)changeMap:(UIButton*)btn{
    if (btn.tag==12) {
        _mapTag=@"Z";
    }else if (btn.tag==13){
        _mapTag=@"Y";
    }
    //清除已划线轨迹
    [_mapView removeOverlays:_mapView.overlays];
    //重新请求数据
    [self loadAllPoint];
}

@end
