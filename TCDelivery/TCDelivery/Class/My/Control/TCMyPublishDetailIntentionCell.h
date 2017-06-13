//
//  TCMyPublishDetailIntentionCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import "TCBaseTableViewCell.h"
@class  TCShipperModel;
//代理模式
@protocol   TCMyPublishDetailIntentionCellDelegate <NSObject>
@optional
-(void)TCMyPublishDetailIntentionCellCtreateOrder:(NSInteger)row andOption:(NSString*)option;
@end

@interface TCMyPublishDetailIntentionCell : TCBaseTableViewCell
/**代理传值---确认 和取消生成订单*/
@property(nonatomic,weak)id <TCMyPublishDetailIntentionCellDelegate> delegate;
/**模型*/
@property(nonatomic,strong)TCShipperModel*shipperModel;
/**<#title#>*/
@property(nonatomic,assign)NSInteger  index;

@end
