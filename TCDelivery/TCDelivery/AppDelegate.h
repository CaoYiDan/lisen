//
//  AppDelegate.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//  Copyright © 2017年 RHHL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,copy) NSString* gotopagestring;

@end

