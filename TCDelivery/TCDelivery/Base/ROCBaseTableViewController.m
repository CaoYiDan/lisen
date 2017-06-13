//
//  ROCBaseTableViewController.m
//  Ticketing
//
//  Created by 融合互联-------lisen on 16/11/3.
//  Copyright © 2016年 RHHL. All rights reserved.
//

#import "ROCBaseTableViewController.h"


static NSString * const ROCBaseTicketCellId = @"ROCBaseTicketCell";
@interface ROCBaseTableViewController ()

@end

@implementation ROCBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  初始化表格
     */
    [self setupTable];
}

/**
 *  初始化表格
 */
- (void)setupTable {
    CGFloat const LYHomeCellHeight = 60;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.showsVerticalScrollIndicator=NO;
    //注册单元格
//    [self.tableView registerClass:[ROCBaseTicketCell class] forCellReuseIdentifier:ROCBaseTicketCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = LYHomeCellHeight;
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellNumber;
}

#pragma mark - lazy load
- (NSMutableArray *)items {
    
    if(!_items) {
        
        _items = [NSMutableArray array];
    }
    
    return _items;
}

@end
