//
//  Constants.h
//  BaseProject
//
//  Created by Rovee on 15/10/21.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma  mark 测试接口

//正式
//#define kUrlBase        @"http://www.tiancheng100y.com/tcwl-api-server"
//#define ImageBase       @"http://www.tiancheng100y.com/tcwl-image-server/"

//测试 114
#define kUrlBase        @"http://47.93.116.114:8080/tcwl-api-server"

#define ImageBase       @"http://47.93.116.114:8080/tcwl-image-server/"

//上传图片
#define kPostPhoto    ImageBase@"v1/image/upload"
//首页接口
#define kHomeUrl    kUrlBase@"/v1/demandAggregate/homePage"
//我的订单
#define kOrderList    kUrlBase@"/v1/orderRest/selectOrder"
//查询原始单号和默认联系人
#define kSelectSonAgreement   kUrlBase@"/v1/receiver/receiverAndAgreement/"
//18首页轮播 get
#define HomeBanner kUrlBase@"/v1/advert/content/list/"
//金融服务
#define FinancialService kUrlBase@"/v1/insurance/create"
//联系人列表
#define kReceiverList   kUrlBase@"/v1/receiver/list"
//保存联系人
#define kReceiverSave   kUrlBase@"/v1/receiver/save"
//编辑修改联系人
#define kReceiverModifi  kUrlBase@"/v1/receiver/modify"
//删除联系人
#define kReceiverDelete  kUrlBase@"/v1/receiver/delete/"
//设置默认联系人
#define kReceiverDefault  kUrlBase@"/v1/receiver/defaultSddr"
//上传用户头像
#define kUpdateHeadImage   kUrlBase@"/v1/user/updateHeadImage"
//用户信息
#define kUserMessage    kUrlBase@"/v1/user/role"
//我的发布详情
#define kPublishDetail    kUrlBase@"/v1/demand/findById"
//我的发布----承运方报价接口
#define kPublishShipper    kUrlBase@"/v1/bid/find"
//身份认证
#define kApplyShipping    kUrlBase@"/v1/user/apply/shipping"
//我的发布
#define kPublishList    kUrlBase@"/v1/demand/find"
//选择报价生成意向订单接口
#define KBidSelect    kUrlBase@"/v1/bid/select"
//最终选定生成订单接口
#define KCreateOrder    kUrlBase@"/v1/orderRest/addOrder"
//取消意向订单
#define KCancelIntention    kUrlBase@"/v1/bid/delete"
//运单接口
#define kTransportList    kUrlBase@"/v1/orderRest/selectOrderDetails"
//运单详情
#define kTransportDetail    kUrlBase@"/v1/demandAggregate/selectOrderDetails/"

//请求运单轨迹接口
#define kTransportPoint    kUrlBase@"/v1/location/EntityPointsByTag"

//所有运单的轨迹点
#define kALLTransportPoint    kUrlBase@"/v1/location/AllEntityPointsByTag"
//修改运单状态 ----已完成和已装货
#define kStartOrOverOrderDetail    kUrlBase@"/v1/orderRest/startOrOverOrderDetail"
//修改运单的价格、数量接口
#define kUpdateOrderDetailNumOrPrice    kUrlBase@"/v1/orderRest/updateOrderDetailNumOrPrice"

//图片上传接口
#define kImageUpload    kUrlBase@"/v1/image/uploadForApp"

//发布需求
#define kAddDemand    kUrlBase@"/v1/demand/add"
//编辑修改发布需求
#define kDemandModify    kUrlBase@"/v1/demand/modify"
//立即发布
#define kPublicDemanNow    kUrlBase@"/v1/demand/publicDemanNow"

//登录地址
#define kUrlLogin     kUrlBase@"/v1/user/login"
//退出登录
#define kUrlEquit     kUrlBase@"/v1/user/logout"
//获取验证码url
#define kUrlSmsGetCode     kUrlBase@"/v1/msg/sms/sendMsg"
//查对验证码地址
#define kUrlSmsCheckCode   kUrlBase@"/v1/msg/sms/checkCode"
//密码确认接口
#define kUrlRegister       kUrlBase@"/v1/user/register"
//重置密码
#define KResetPassword       kUrlBase@"/v1/user/resetPassword"

#pragma  mark 用户信息 

#define kStorageUserId          @"userId"
#define kStorageUserMobile      @"userMobile"
#define kStorageUserName        @"userName"
#define kStorageHeaderName      @"headerName"
#define kStorageUserRealName    @"realName"
#define kStorageUserType        @"userType"
#define kStorageUserSubType     @"userSubType"
#define kStorageUserStatus      @"userStatus"
#define kStorageDeviceToken      @"deviceToken"
//wekself 防止死循环
#define WeakSelf __weak typeof(self) weakSelf = self;

#pragma mark - ios版本判断
#define kIOS5_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )

#define kIOS6_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

#define kIOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define kIOS8_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kIOS9_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define kIOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#pragma mark - 设备类型
#define kiPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#pragma mark - 屏幕相关
#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

#define SCREEN_H ([UIScreen mainScreen].bounds.size.height-64)
#define  JianJu 4
#define  LGLighgtBGroundColour235 kRGBColor(240, 240, 240)
//判断string是否为空 nil 或者 @""；
#define IsNilString(__String) (__String==nil || [__String isEqualToString:@""] || [[__String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])

#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])

#define isEmptyString(x)      (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
//提示语 Toast 错误
#define ToastError(msg)    [MBProgressHUD showError:msg];
//提示语 Toast  成功
#define ToastSuccess(msg)    [MBProgressHUD showSuccess:msg];

#pragma mark - 颜色

#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define kRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define Color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]

#define kCOLOR_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define Font(x) [UIFont systemFontOfSize:x+1]

#define FontBold(x) [UIFont fontWithName:@"Helvetica-Bold" size:x+1]

//全局颜色
//#define  KMainColor kRGBColor(42, 73, 137)
#define  KMainColor kRGBColor(250, 250, 250)
#define  KNavigationColor kRGBColor(255, 255, 255)
#define KTCBlueColor kRGBColor(42, 73, 137)
#define  KTCGreen kRGBColor(106, 191, 99)
//主界面的背景颜色
#define  KGrayColor kRGBColor(238, 238, 239)

// Storyboard通过名字获取
#define kStoryboard(StoryboardName)     [UIStoryboard storyboardWithName:StoryboardName bundle:nil]

#endif /* Constants_h */
