//
//  TCOrderModel.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import <Foundation/Foundation.h>

@interface TCOrderModel : NSObject
@property (nonatomic, assign) BOOL successful;
/**
 * 发布需求的描述ƒ
 */
@property (nonatomic, copy) NSString *remarks;
/**
 * 装货地址（省）
 */
@property (nonatomic, copy) NSString *outProvince;
/**
 *是否有中交兴路地图（0没有 1有）
 */
@property (nonatomic, copy) NSString *iszjxl;
/**
 * 主键id
 */
@property (nonatomic, copy) NSString *orderId;
/**
 * 发布人姓名
 */
@property (nonatomic, copy) NSString *tenderName;

/**
 * 删除状态
 */
@property (nonatomic, assign) int delFlag;
/**
 * 填单添加途径
 */
@property (nonatomic, copy) NSString *addType;
/**
 * 创建时间字符串表示法(用于从model里面取出)
 */
@property (nonatomic, copy) NSString *createDateStr;
/**
 *
 */
@property (nonatomic, copy) NSString *createBy;
/**
 *原始协议
 */
@property (nonatomic, copy) NSString *ysNum;
///**
// * 创建人
// */
//@property (nonatomic, copy) NSString *createBy;

/**
 * 发布公司名字
 */
@property (nonatomic, copy) NSString *tenderComName;
/**
 * 商品类别名称
 */
@property (nonatomic, copy) NSString *goodsType;

/**
 * 报价总价
 */
@property (nonatomic, assign) int offerTotalprice;
/**
 * 装货地址（市）
 */
@property (nonatomic, copy) NSString *outCity;
/**
 * 意向数量
 */
@property (nonatomic, assign) int intentionNum;

/**
 * 订单编号
 */
@property (nonatomic, copy) NSString *orderNum;
/**
 * 发布人电话
 */
@property (nonatomic, copy) NSString *tenderTel;

/**
 * 承运方主键
 */
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) int pageNumber;
/**
 * 报价单价
 */
@property (nonatomic, assign) double offerPrice;
/**
 * 报价单价
 */
@property (nonatomic, assign) double shipingPrice;


/**
 * 支付状态(显示用)
 */
@property (nonatomic, copy) NSString *payStatus;
/**
 * 意向总价
 */
@property (nonatomic, assign) int intentionPrice;
/**
 * 需求模式
 */
@property (nonatomic, copy) NSString *tenderType;
/**
 * 运输所用车辆数量
 */
@property (nonatomic, assign) int carNum;
/**
 * 运输所用车辆的长度
 */
@property (nonatomic, assign) double carSize;
/**
 * 运输所用车辆的长度2(  后台起的名字太混淆)
 */
@property (nonatomic, copy) NSString* carWeight;

/**
 * 运输所用车辆类型
 */
@property (nonatomic, copy)NSString* carType;
/**
 * 实际总价
 */
@property (nonatomic, assign) double actualTotalprice;
/**
 * shippingTotalPrice
 */
@property (nonatomic,copy) NSString* shipingTotalprice;
//吨
@property (nonatomic,assign) double shipingNum;

/**
 * 最终总价
 */
@property (nonatomic, assign) double finalTotalPrice;


@property (nonatomic, copy) NSString *outCounty;
/**
 * 装货地址（详细地址）
 */
@property (nonatomic, copy) NSString *outAddress;
//
@property (nonatomic, assign) int intentionTotalprice;

/**
 * 实际数量
 */
@property (nonatomic, assign) double actualNum;

/**
 * 体积量
 */
@property (nonatomic, assign) double goodsSize;


@property (nonatomic, copy) NSString *createDate;
/**
 * 报价数量
 */
@property (nonatomic, assign) double offerNum;
/**
 * 发货方主键
 */
@property (nonatomic, copy) NSString *shipperId;
/**
 * 需求的货物单位
 */
@property (nonatomic, copy) NSString *sizeUnit;
/**
 * 订单开始时间（暂时不用，用创建时间代替）
 */
@property (nonatomic, copy) NSString *startTime;
/**
 * 实际单价
 */
@property (nonatomic, assign) int actualPrice;
/**
 * 收货人电话
 */
@property (nonatomic, copy) NSString *receiveTel;
/**
 * 收货人姓名
 */
@property (nonatomic, copy) NSString *receiveName;

/**
 * 承运方名称（公司/个人）
 */
@property (nonatomic, copy) NSString *userName;

/**
 * 承运方公司
 */
@property (nonatomic, copy) NSString *cyfName;

@property (nonatomic, assign) int pageSize;

/**
 * 卸货地址（省）
 */
@property (nonatomic, copy) NSString *receiveProvince;
/**
 * 卸货地址（市）
 */
@property (nonatomic, copy) NSString *receiveCity;

/**
 * 卸货地址（区县）
 */
@property (nonatomic, copy) NSString *receiveCounty;
/**
 * 卸货地址（详细地址）
 */
@property (nonatomic, copy) NSString *receiveAddress;
/**
 * 发布需求的货物名称
 */
@property (nonatomic, copy) NSString *goodsName;
/**
 * 开票总价
 */
@property (nonatomic, assign) int billTotalprice;
/**
 * 订单状态(用于显示)
 */
@property (nonatomic, copy) NSString *orderTransStatus;
/**
 * 运单状态(用于显示)
 */
@property (nonatomic, copy) NSString *transStatus;

/**
 * 需求的货物数量
 */

@property (nonatomic, assign) double tenderWeight;
/**
 * 需求的货物数量---单位
 */

@property (nonatomic, copy)NSString*weightUnit;

/**
 * 体积单位
 */
@property (nonatomic, copy) NSString *goodUnit;


//___________________________*********运单的属性**********_________________________
/**
 * 运单的ID
 */
@property (nonatomic, copy) NSString*orderDetailsNum;
/**
 * 运单司机
 */
@property (nonatomic, copy) NSString *driverName;
/**
 * 运单车牌号
 */
@property (nonatomic, copy) NSString *carCode;

/**
 * 时间
 */
@property (nonatomic, copy) NSString *outDate;

/**
 * 发货时间
 */
@property (nonatomic, copy) NSString *deliverTimeStr;


//___________________________*********我的发布的属性**********_________________________
/**
 * 我的发布的ID
 */
@property (nonatomic, copy) NSString*tenderId;
/**
 * 我的发布状态
 */
@property (nonatomic, copy) NSString *statusFlag;
/**
 * 我的发布报价截止时间
 */
@property (nonatomic, copy) NSString *tenderEndTime;
/**
 * 我的发布开始报价时间
 */
@property (nonatomic, copy) NSString *tenderStartTime;
/**
 * 我的发布的货物数量
 */

@property (nonatomic, assign) double goodsWeight;
/**
 * 我的发布发货人
 */
@property (nonatomic, copy) NSString *outName;
/**
 * 我的发布发货人电话
 */
@property (nonatomic, copy) NSString *outTel;
/**
 * 发布联系人姓名
 */
@property (nonatomic, copy) NSString *headName;
@end
