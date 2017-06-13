//
//  TCTransportListCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/9.
//
//

#import <UIKit/UIKit.h>
@class  TCOrderModel;
@interface TCTransportListCell : UITableViewCell
/**<#Name#>*/
@property(nonatomic,strong)TCOrderModel*orderModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
