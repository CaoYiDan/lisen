//
//  ROCTabbarController.m
//  Ticketing
//
//  Created by 融合互联-------lisen on 16/11/1.
//  Copyright © 2016年 RHHL. All rights reserved.
//

#import "ROCTabbarController.h"
#import "ROCBaseNavigationController.h"
#import "TCMyViewController.h"
#import "TCHomeViewController.h"
#import "TCFollowViewController.h"
#import "TCDeliveryViewController.h"
#import "TCMyViewController.h"
@implementation ROCTabbarController

+(ROCTabbarController*)sharedTabbar{
    static ROCTabbarController*_shareTabbar=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _shareTabbar=[[self alloc]init];
    });
    return _shareTabbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    // Do any additional setup after loading the view.
    /* 加子控制器*/
    [self createViewControllers];
    /* 添加点击图片和字*/
    [self createTabbar];
    
}

-(void)createViewControllers{
    /* 首页*/
    TCHomeViewController* homeVC =[[TCHomeViewController alloc]init];
    ROCBaseNavigationController * homeNav = [[ROCBaseNavigationController alloc]initWithRootViewController:homeVC];
 
    /* */
    TCDeliveryViewController* categoryVC = [[TCDeliveryViewController alloc]init];
    ROCBaseNavigationController * categoryNav = [[ROCBaseNavigationController alloc]initWithRootViewController:categoryVC];
    
    
    /* 工具*/
    TCFollowViewController * cartVC = [[TCFollowViewController alloc]init];
    ROCBaseNavigationController * cartNav = [[ROCBaseNavigationController alloc]initWithRootViewController:cartVC];
    
    /* 我的*/
    TCMyViewController* mineVC = [[TCMyViewController alloc]init];
    ROCBaseNavigationController* mineNav = [[ROCBaseNavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem.tag=3;
    self.viewControllers = @[homeNav,categoryNav,cartNav,mineNav];
    self.tabBar.tintColor = [UIColor colorWithRed:247/255 green:247/255 blue:247/255 alpha:1];
    self.tabBar.translucent = NO;
    
}

- (void)createTabbar{
    
    NSArray * unselectedArray = @[@"app_home_nav1",@"app_home_nav2",@"app_home_nav3",@"app_home_nav4",];
    
    NSArray * selectedArray = @[@"app_home_nav6",@"app_home_nav5",@"app_home_nav7",@"app_home_nav8",];
    
    NSArray * titleArray = @[@"首页",@"发货",@"跟踪",@"我"];
    
    for (int i = 0; i<self.tabBar.items.count; i++) {
        
        UIImage * unselectedImage = [UIImage imageNamed:unselectedArray[i]];
        
        unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectedImage = [UIImage imageNamed:selectedArray[i]];
        
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem * item = self.tabBar.items[i];
        
        item = [item initWithTitle:titleArray[i] image:unselectedImage selectedImage:selectedImage];
        //tabbar 具体设计
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kRGBColor(42, 73, 137)} forState:UIControlStateSelected];
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        
        //254, 156, 187, 1
    }
}
//
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
     if (viewController.tabBarItem.tag==3){//只要点击了tabbar的”我“tabbaritem,都会回到我的界面
        self.selectedIndex=3;
        TCMyViewController*vc=[[TCMyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
        return YES;
     }
        return YES;
}


@end
