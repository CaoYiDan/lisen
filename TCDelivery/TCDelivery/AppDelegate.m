//
//  AppDelegate.m
//  Ticketing
//
//  Created by 融合互联-------lisen on 16/11/1.
//  Copyright © 2016年 RHHL. All rights reserved.
//
//友盟推送
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "ROCTabbarController.h"
#import "TCMyPublishDetailVC.h"
#import "TCTransportDetailVC.h"
#import "TCTransportDetailVC.h"
#import "TCAuthenticationVCViewController.h"
#import "TCOrderDetailViewController.h"
//发货方--APPID
#define STOREAPPID @"1216099452"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.backgroundColor=KMainColor;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    /* 初始化tabbar */
    ROCTabbarController*tabbar=[[ROCTabbarController alloc]init];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    //初始化键盘弹出的第三方库
    [self setIQKeyboardManager];
    //百度地图的引入
    _mapManager = [[BMKMapManager alloc]init];
    [_mapManager start:@"R0YjGleYizPbe3RUdheLD5udt2W7ZdZP"  generalDelegate:nil];
    //友盟推送初始化
    [self setUMessageWith:launchOptions];
    //一句代码实现检测更新
    [self hsUpdateApp];
    return YES;
}

//友盟推送初始化
-(void)setUMessageWith:(NSDictionary *)launchOptions{
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"58d1e0fcaed1795604000b13" launchOptions:launchOptions];
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。或者1.4.0的文档
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
}
//初始化键盘弹出的第三方库
-(void)setIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //控制整个功能是否启用。
    manager.enable = YES;
    //控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    //控制键盘上的工具条文字颜色是否用户自定义。  注意这个颜色是指textfile的tintcolor
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //中间位置是否显示占位文字
    manager.shouldShowTextFieldPlaceholder = NO;
    //设置占位文字的字体
    manager.placeholderFont = [UIFont boldSystemFontOfSize:17];
    //控制是否显示键盘上的工具条。
    manager.enableAutoToolbar = YES;
}

/***  天朝专用检测app更新*/

-(void)hsUpdateApp
{
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        //2先获取当前工程项目版本号
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        //3从网络获取appStore版本号
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",STOREAPPID]]] returningResponse:nil error:nil];
        if (response == nil) {
            
            return;
        }
        
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            
            return;
        }
        NSArray *array = appInfoDic[@"results"];
        NSDictionary *dic = [array lastObject];
        NSString *appStoreVersion = dic[@"version"];
        
        //4当前版本号小于商店版本号,就更新
        if([currentVersion floatValue]<[appStoreVersion floatValue])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                [alert show];
            });
        }else{
            //不做任何处理
        }
    });
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //5实现跳转到应用商店进行更新
    if(buttonIndex==1)
    {
        //6此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/lets-gou/id%@?l=zh&ls=1&mt=8", STOREAPPID]];
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:url];
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        self.gotopagestring = [userInfo objectForKey:@"channel"];
        if(self.window.rootViewController){
            [self gotopageviewcontrollerWithUserInfo:userInfo];
        }
        else{
            
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self stringWithDeviceToken:deviceToken];
}

-(NSString *)stringWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString2 = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    
                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    //储存deviceToken
    [StorageUtil saveDeviceToken:deviceTokenString2];
    return deviceTokenString2;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

//接受远程推送，跳转到指定界面
-(void)gotopageviewcontrollerWithUserInfo:(NSDictionary*)userInfo{
    if (isEmptyString([StorageUtil getRoleId])) {//用户退出登录，则不做处理
        return;
    }
    UITabBarController* tabbar = (UITabBarController*)self.window.rootViewController;
    if(self.gotopagestring)
    {
        if ([self.gotopagestring isEqualToString:@"ROLE_AUTH"]) {//新用户引导角色认证
            self.gotopagestring = nil;
            TCAuthenticationVCViewController *controller = [[TCAuthenticationVCViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"AUTH_SUCCESS"]) {//审核通过--查看认证详细界面
            self.gotopagestring = nil;
            TCAuthenticationVCViewController *controller = [[TCAuthenticationVCViewController alloc]init];
            controller.userApplyStatus=@"已认证";
            controller.hidesBottomBarWhenPushed = YES;
             [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"AUTH_FAIL"]) {//审核未通过--查看认证详细界面
            self.gotopagestring = nil;
            TCAuthenticationVCViewController *controller = [[TCAuthenticationVCViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.userApplyStatus=@"未通过";
             [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"OFFER"]) {//承运方报价
            self.gotopagestring = nil;
            TCMyPublishDetailVC *controller = [[TCMyPublishDetailVC alloc]init];
            controller.tenderId=userInfo[@"tenderId"];
            controller.hidesBottomBarWhenPushed = YES;
            [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"UPDATE_OFFER"]) {//承运方修改报价--报价页面
            self.gotopagestring = nil;
            TCMyPublishDetailVC *controller = [[TCMyPublishDetailVC alloc]init];
            controller.tenderId=userInfo[@"tenderId"];
            controller.hidesBottomBarWhenPushed = YES;
             [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"MEAD_ORDER"]){//订单生成---订单详细界面
            self.gotopagestring = nil;
            TCOrderDetailViewController *controller = [[TCOrderDetailViewController alloc]init];
            /**订单编号*/
            controller.orderNum=userInfo[@"OrderNum"];
            /**订单Id*/
            controller.orderId=userInfo[@"OrderId"];
            controller.hidesBottomBarWhenPushed = YES;
             [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"UPDATE_ORDER"]) {//订单状态发生变化---订单详细界面
            self.gotopagestring = nil;
            TCOrderDetailViewController *controller = [[TCOrderDetailViewController alloc]init];
            /**订单编号*/
            controller.orderNum=userInfo[@"OrderNum"];
            /**订单Id*/
            controller.orderId=userInfo[@"OrderId"];
            controller.hidesBottomBarWhenPushed = YES;
             [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
        }else if ([self.gotopagestring isEqualToString:@"UPDATE_WAYBILL"]) {//运单状态发生变化---运单详情界面
            self.gotopagestring = nil;
            TCTransportDetailVC *controller = [[TCTransportDetailVC alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            /**运单编号*/
            controller.transportId=userInfo[@"OrderDetailNum"];
            /**运单Id*/
            controller.transportId2=userInfo[@"OrderDetailId"];
            controller.tenderType=userInfo[@"OrderTenderType"];
            [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
            
            
        }

    }
}
@end
