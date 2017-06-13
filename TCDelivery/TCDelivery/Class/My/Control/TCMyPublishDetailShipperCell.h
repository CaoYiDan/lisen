//
//  TCMyPublishDetailShipperCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import "TCBaseTableViewCell.h"
@class TCShipperModel;
@interface TCMyPublishDetailShipperCell : TCBaseTableViewCell
/**<##>选定的字样*/
@property(nonatomic,strong) UILabel*chose;
-(void)setModel:(TCShipperModel*)shiperModel andIndex:(NSInteger)index;
@end
