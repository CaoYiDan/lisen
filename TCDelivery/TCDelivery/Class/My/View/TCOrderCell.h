//
//  TCOrderCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//

#import <UIKit/UIKit.h>
@class  TCOrderModel;
@interface TCOrderCell : UITableViewCell
/**<#Name#>*/
@property(nonatomic,strong)TCOrderModel*orderModel;
/***/
@property(nonatomic,assign)SwitchType  switchType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
