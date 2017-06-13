//
//  Confing.h
//  LetsGo
//
//  Created by 融合互联-------lisen on 16/12/14.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//


//登录状态改变
extern NSString*const NotificationLoginStatusChange;
//分类界面二级界面将要加载--BMG
extern NSString*const NotificationDetailCategoryDataWillLoad;
//分类界面二级界面将要加载----LETS
extern NSString*const NotificationDetailCategoryDataWillLoadLETS;
//分类三级排序点击通知
extern NSString*const NotificationPricePaiXu;
//绑定通知
extern NSString*const NotificationBangding;
//商品详情，网页Html加载完成之后，发送的通知
extern NSString*const NotificationHeightChange;
//选择菜单某项通知------宝马购（即分类大界面）
//extern NSString*const NotificationChooseCategory;
//选择菜单某项通知-----（Lets购专题筛选界面）
extern NSString*const NotificationChooseCategoryLETS;
//购物车数量发生变化
extern NSString*const NotificationCartCountChange;
//改变tabbar的selectedIndex
extern NSString*const NotificationTabbarSelectedIndexChange;





//cell类型，只枚举里出现最多的两大类，其他的个别并未列举
typedef NS_ENUM(NSInteger,ROCCellType)
{
    ROCCellNormalType,//最普通
    ROCCellTextFiledType //有textfiled的
};
//switch类型
typedef NS_ENUM(NSInteger,SwitchType)
{
    SwitchTypeMyPublishList=0,//我的发布列表
    SwitchTypeTransportList,//运单订单列表
    SwitchTypeMyOrderList,//我的订单列表
};
//我的发布类型
typedef NS_ENUM(NSInteger,MyPublishType)
{
    MyPublishTypeAll=0,//全部
    MyPublishTypeWill,//待发布
    MyPublishTypeIng,//报价中
    MyPublishTypeHaveFinished,//已结束
    
};
//运单订单类型
typedef NS_ENUM(NSInteger,TransportType)
{
    TransportTypeAll=0,//全部
    TransportTypeIng,//运输中
    TransportTypeWill,//待运输
    TransportTypeHaveFinished//已完成
};
//订单类型
typedef NS_ENUM(NSInteger,OrderType)
{
    OrderTypeAll=0,//全部
    OrderTypeTransport,//运输中
    OrderTypeWill,//已取消
    OrderTypeFinished,//结束
    OrderTypeCancel//已取消
};
//订单类型
typedef NS_ENUM(NSInteger,LinkType)
{
    LinkTypeDelivery=0,//发货人
    LinkTypeReceive//收货人
};
//申请认证状态
#define    APPLY_STATUS_APPLYING  @"APPLYING"  //待审核
#define    APPLY_STATUS_CONFIRMED  @"CONFIRMED" //通过审核
#define    APPLY_STATUS_UNCONFIRMED  @"UNCONFIRMED" //未通过（未申请）
#define   APPLY_STATUS_UNAVAILABLE  @"UNAVAILABLE" //不可用



