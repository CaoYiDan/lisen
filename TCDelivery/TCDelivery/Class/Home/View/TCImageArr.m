//
//  TCImageArr.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/23.
//
//

#import "TCImageArr.h"

@implementation TCImageArr
+(NSArray*)shareWithLeftImageArr{
    static NSArray*_leftImageArr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
  //起(10) 终 车头 发布(13) 号 重 司机 发货时间(17）发 收 电话(20) 总(21) 卸(22) 装 订单创建时间(24) 述  体积(26) 量(27) 报(28)      价(29) 意(30) ¥  元(32) 联系人  单(34） 车   S(36) 时间(橘色)(37)  无图片(38) 时间--绿色(39)
        _leftImageArr=@[@"fh_dd_xq_an2",@"fh_dd_xq_an2-1",@"app_home_nav16",@"app_home_nav9",@"fh_dd_xq_an111",@"ydlb_an2",@"ydlb_an4",@"fh_dd_xq_an7",@"ydxq_an3",@"ydxq_an4",@"fh_an1",@"fh_dd_xq_an17",@"cyfbj_an3",@"cyfbj_an4",@"cyf_in_an3",@"fh_fbxq_ybj_an18",@"fh_fbxq_ybj_an19",@"fh_fbxq_ybj_an21",@"fh_fbxq_ybj_an15",@"fh_fbxq_ybj_an6",@"fh_fbxq_ybj_an10",@"fh_fbxq_ybj_an5",@"fh_fbxq_ybj_an1",@"fh_fbxq_ybj_an3",@"fh_dd_xq_an16",@"fh_dd_xq_an15",@"fh_dd_xq_an14",@"fh_dd_xq_an13",@"",@"cyf_in_an3"];
    });
    return _leftImageArr;

}

+(NSArray*)shareWithRightImageArr{
    static NSArray*_rightImageArr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     
        //吨 米 辆 元(3)  无图片(4）
 _rightImageArr=@[@"fh_dd_xq_an1",@"app_home_nav17",@"fh_dd_xq_an12",@"fh_fbxq_ybj_an1",@"",@"",@"",@"",@""];
        
    });
    return _rightImageArr;
    
}

@end
