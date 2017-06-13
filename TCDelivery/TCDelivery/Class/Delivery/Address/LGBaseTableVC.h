//
//  LGBaseTableVC.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGBaseTableVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *TableView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray*heightArray;
/*
 <##>tableView是分组还是普通的样式
 */
@property(nonatomic,copy)NSString*tableViewStyle;
/*
 <##>是否需要刷新  no 为不需要刷新，其他则需要刷新
 */
@property(nonatomic,copy)NSString*ifNeedRefresh;
@end
