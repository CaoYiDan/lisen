//
//  ROCBaseTableViewController.h
//  Ticketing
//
//  Created by 融合互联-------lisen on 16/11/3.
//  Copyright © 2016年 RHHL. All rights reserved.
//

#import "BaseViewController.h"

@interface ROCBaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
/**
 *  item数组
 */
@property (nonatomic, strong) NSMutableArray *items;
//tableview
@property(nonatomic,strong)UITableView*tableView;
/** 返回的cell有多少行*/
@property(nonatomic,assign)NSInteger  cellNumber;

@end
