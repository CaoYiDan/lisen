//
//  TCFollowViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//
#import "RouteAnnotation.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "TCBigMapVC.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

//引入检索功能所有的头文件

//引入定位功能所有的头文件

//引入计算工具所有的头文件

//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface TCBigMapVC()<BMKMapViewDelegate>

@end

@implementation TCBigMapVC
{
    BMKMapView* _mapView;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"运输监控";
    //     //百度地图的接入，会改变导航栏的背景颜色，在此设置一下
    [self.navigationController.navigationBar setBarTintColor:KMainColor];
    //初始化百度地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    [self.view addSubview:_mapView];
    
    NSInteger size =self.locationArray.count;

       //轨迹点
       CLLocationCoordinate2D*coors=malloc([self.locationArray count]*sizeof(CLLocationCoordinate2D));
        for (int j = 0; j < size; j++) {
            NSDictionary*dict=self.locationArray[j];
            coors[j].latitude=[dict[@"y"] floatValue];
            coors[j].longitude=[dict[@"x"] floatValue];
            
            if (j==0) {
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
            
            if (j==size-1) {
                //大头针
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = coors[j];
                item.title = @"终点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            }        }
        BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:size];
        [_mapView addOverlay:polyline];
    
}

-(void)load{
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
//    _routeSearch.delegate = nil;
}

- (void)dealloc {
//    if (_routeSearch!= nil) {
//        _routeSearch = nil;
//    }
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

@end
