//
//  TCOrderTableViewCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/28.
//
//

#import <UIKit/UIKit.h>
#import "TCOrderCellLayout.h"
@protocol TCOrderTableViewCellDelegate
//代理-----处理底部的操作按钮
-(void)TCOrderTableViewCellOptionType:(NSString*)optionType atIndexPathRow:(NSInteger)row;
@end

@interface TCOrderTableViewCell : UITableViewCell
/**代理*/
@property(nonatomic,weak)id  delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**<#Name#>*/
@property(nonatomic,strong)TCOrderCellLayout*layout;

-(void)setLayout:(TCOrderCellLayout*)layout andIndexpathRow:(NSInteger)row;
@end
