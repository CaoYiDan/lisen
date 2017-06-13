//
//  TCOrderCellLayout.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/28.
//
//

#import <Foundation/Foundation.h>
#import "YYTextLayout.h"
@class  TCOrderModel;
@interface TCOrderCellLayout : NSObject
@property (nonatomic, strong) NSMutableAttributedString *orderIdText; //编号
@property (nonatomic, strong) NSMutableAttributedString *statusText; //状态
@property (nonatomic, strong) NSMutableAttributedString *goodsNameText; //运输的货物
@property (nonatomic, strong) NSMutableAttributedString *weightText; //载重
@property (nonatomic, strong) NSMutableAttributedString *createDateText; //右上角文本
@property (nonatomic, strong) NSMutableAttributedString *distanceText; //起点--终点文本
@property (nonatomic, strong) NSMutableAttributedString *carText; //用车信息文本
@property (nonatomic, strong) NSMutableAttributedString *optionText; //操作按钮文本
/**模型*/
@property(nonatomic,strong)TCOrderModel*model;
/**cell类型*/
@property(nonatomic,assign)SwitchType switchType;

- (instancetype)initWithStatus:(TCOrderModel *)model andSwitchType:(SwitchType)switchType;
@end
