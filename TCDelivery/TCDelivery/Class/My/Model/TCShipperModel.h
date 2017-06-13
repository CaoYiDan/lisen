//
//  TCShipperModel.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/20.
//
//

#import <Foundation/Foundation.h>

@interface TCShipperModel : NSObject


/**
 * 承运方名称
 */

@property (nonatomic, copy) NSString *userName;
/**
 * 发布人姓名
 */

@property (nonatomic, copy) NSString *tenderName;


/**
 * 意向订单生成订单的剩余时间
 */
@property (nonatomic, assign)double countdown;

/**
 * 发布人电话
 */

@property (nonatomic, copy) NSString *tenderTel;
/**
 * 货源ID
 */
@property (nonatomic, copy) NSString *tenderId;

/**
 * 发货方ID
 */
@property (nonatomic, copy) NSString *shipperId;
/**
 * 可运输量
 */
@property (nonatomic, assign)CGFloat offerNum;

/**
 * 竞标单价
 */
@property (nonatomic, assign)double offerPrice;
/**
 * 竞标时间
 */
@property (nonatomic, copy) NSString *bidDateStr;
/**
 * 实际总价
 */
@property (nonatomic, assign)double actualTotalprice;
/**
 * 最终总价
 */
@property (nonatomic, assign)double finalTotalPrice;

/**
 * 需求的货物单位
 */
@property (nonatomic, copy) NSString *sizeUnit;
/**
 *竞标表ID
 */
@property (nonatomic, copy) NSString *bidId;
/**
 *报价量
 */
@property (nonatomic, assign)double goodsWeight;

/**
 *竞标时间
 */
@property (nonatomic, copy) NSString *bidDate;

/**
 *竞标时间
 */
@property (nonatomic, copy) NSString *createDateStr;
/**
 *删除标识
 */
@property (nonatomic, assign) int delFlag;
/**
 *改价标识
 */
@property (nonatomic, copy) NSString *priceChangeFlag;
/**
 *
 */
//报价车辆数量
@property (nonatomic, assign) int carNum;
/**
 *品类
 */
@property (nonatomic, copy) NSString *goodsType;
/**
 *联系人电话(承运方)
 */
@property (nonatomic, copy) NSString *phone;
/**
 * 选定时间
 */
@property (nonatomic, copy) NSString *selectDateStr;
/**
 *卸货省
 */
@property (nonatomic, copy) NSString *receiveProvince;
/**
 *发货时间开始
 */
@property (nonatomic, copy) NSString *startOutDate;
/**
 *体积
 */
@property (nonatomic, assign) double goodsSize;
/**
 *报价单价
 */
@property (nonatomic, assign) double price;
/**
 *报价状态
 */
@property (nonatomic, copy) NSString *bidStatus;
/**
 *承运方ID
 */
@property (nonatomic, copy) NSString *userId;
/**
 *联系人姓名
 */
@property (nonatomic, copy) NSString *headName;

/**
 *发布公司名字
 */
@property (nonatomic, copy) NSString *designatedUserName;

@end
